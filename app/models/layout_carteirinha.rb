class LayoutCarteirinha < ActiveRecord::Base
	has_many :carteirinhas
	belongs_to :entidade

	url_path = "/admin/:class/:id/:attachment/:style/:filename"

	has_attached_file :verso, :styles => {:original => {}}, :path => "#{url_path}"
	has_attached_file :anverso, :styles => {:original => {}}, :path => "#{url_path}"
	has_attached_file :verso_alternativo, :styles => {:original => {}}, :path => "#{url_path}"

	FILES_NAME_PERMIT = [/png\Z/, /jpe?g\Z/]
	FILES_CONTENT_TYPE = ['image/jpeg', 'image/png']

	validates_attachment_size :verso, :less_than=> 2.megabytes
	validates_attachment_file_name :verso, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :verso, :content_type => FILES_CONTENT_TYPE
	validates_attachment_size :anverso, :less_than=> 2.megabytes
	validates_attachment_file_name :anverso, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :anverso, :content_type => FILES_CONTENT_TYPE
	validates_attachment_size :verso_alternativo, :less_than=> 2.megabytes
	validates_attachment_file_name :verso_alternativo, :matches => FILES_NAME_PERMIT
	validates_attachment_content_type :verso_alternativo, :content_type => FILES_CONTENT_TYPE

	validates_numericality_of :nome_posx, :nome_posy, :instituicao_ensino_posx, :instituicao_ensino_posy,
	                          :curso_posx, :curso_posy, :codigo_uso_posx, :codigo_uso_posy, 
	                          :data_nascimento_posx, :data_nascimento_posy, :rg_posx, :rg_posy, 
	                          :qr_code_posx, :qr_code_posy, :matricula_posx, :matricula_posy, 
 	                          :anverso_width, :anverso_height, :anverso_resolution_x, :anverso_resolution_y
	                                                 
	validates_numericality_of :escolaridade_posy, :escolaridade_posx, :cpf_posy, :cpf_posx, 
							  :nao_depois_posy, :nao_depois_posx, :tamanho_fonte, allow_blank: true

	validates_presence_of :nome_posx, :nome_posy, :instituicao_ensino_posx, :instituicao_ensino_posy,
	                      :curso_posx, :curso_posy, :matricula_posx, :matricula_posy,
	                      :data_nascimento_posx, :data_nascimento_posy, :rg_posx, :rg_posy, 
	                      :codigo_uso_posx, :codigo_uso_posy, :foto_posx, :foto_posy, :foto_width, 
	                      :foto_height, :qr_code_posx, :qr_code_posy, :qr_code_width, :qr_code_height 
	                      
	validates_presence_of :anverso, :entidade, :tamanho_fonte   

	enum font_box: [:caixabaixa, :caixaalta, :titularizado]
 	enum impressao_transparente: {"Não"=>"0", "Sim"=>"1"}                    
 
 	before_validation :set_anverso_configurations                        

	def entidade_nome
		self.entidade.nome if self.entidade
	end

	def font_weight_type
		index = self.font_weight
		magick_type = Magick::NormalWeight
		case index
		when '2' 
			magick_type = Magick::BoldWeight
		when '3' 
			magick_type = Magick::BolderWeight
		when '4' 
			magick_type = Magick::LighterWeight
		else
			magick_type = Magick::NormalWeight # 0 ou 1
		end
		return magick_type
	end

	def font_style_type
		index = self.font_style
		magick_type = Magick::NormalStyle
		case index
		when '2' 
			magick_type = Magick::ItalicStyle
		when '3' 
			magick_type = Magick::ObliqueStyle
		else 
			magick_type = Magick::NormalStyle # 1 ou 4
		end
		return magick_type
	end

	private 
 		def set_anverso_configurations
 			if self.anverso.dirty?
                path = self.anverso.queued_for_write[:original].path
 
                img = Magick::Image.read(path).first
                self.anverso_resolution_x = img.x_resolution
                self.anverso_resolution_y = img.y_resolution
                self.anverso_width = img.columns
                self.anverso_height = img.rows
            end
		end

end