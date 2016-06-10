ActiveAdmin.register LayoutCarteirinha do
	menu if: proc{current_admin_user.super_admin?}, priority: 5
	
	permit_params :anverso, :verso, :nome_posx, :nome_posy, :instituicao_ensino_posx, :instituicao_ensino_posy,
	              :escolaridade_posx, :escolaridade_posy, :curso_posx, :curso_posy,
	              :data_nascimento_posx, :data_nascimento_posy, :rg_posx, :rg_posy,
	              :cpf_posx, :cpf_posy, :codigo_uso_posx, :codigo_uso_posy, 
	              :nao_depois_posx, :nao_depois_posy, :qr_code_posx, :qr_code_posy,
	              :qr_code_width, :qr_code_height, :foto_posx, :foto_posy,
	              :foto_width, :foto_height

	filter :anverso_file_name
	filter :verso_file_name

	index do
		selectable_column
    	id_column
    	column :anverso_file_name
    	column :verso_file_name
    	actions
	end

	show do
		panel "Verso" do 
			attributes_table_for layout_carteirinha do
				row :anverso do 
					a layout_carteirinha.anverso_file_name, class: "show-popup-link", href: layout_carteirinha.anverso.url
				end
			end
		end
		panel "Posições de Informações" do
			columns do
				column do
					attributes_table_for layout_carteirinha do
						row :nome_posx
						row :instituicao_ensino_posx
						row :escolaridade_posx
						row :curso_posx
						row :data_nascimento_posx
						row :rg_posx
						row :cpf_posx
						row :codigo_uso_posx
						row :nao_depois_posx
						row :qr_code_posx
						row :qr_code_width
						row :foto_posx
						row :foto_width
					end
				end
				column do
					attributes_table_for layout_carteirinha do
						row :nome_posy
						row :instituicao_ensino_posy
						row :escolaridade_posy
						row :curso_posy
						row :data_nascimento_posy
						row :rg_posy
						row :cpf_posy
						row :codigo_uso_posy
						row :nao_depois_posy
						row :qr_code_posy
						row :qr_code_height
						row :foto_posy
						row :foto_height
					end
				end
			end
		end
		panel "Verso" do 
			attributes_table_for layout_carteirinha do
				row :verso do 
					a layout_carteirinha.verso_file_name, class: "show-popup-link", href: layout_carteirinha.verso.url
				end
			end
		end
		render inline: "<script type='text/javascript'>$('.show-popup-link').magnificPopup({type: 'image'});</script>"
	end

	form :html => { :enctype => "multipart/form-data"}  do |f| 
		f.semantic_errors *f.object.errors.keys
		f.inputs "Layout", multipart: true do 
			f.input :anverso, label: "Frente", :hint => "Imagem Atual: #{f.object.anverso_file_name}"
			f.input :verso, label: "Verso", :hint => "Imagem Atual: #{f.object.verso_file_name}"
		end
		panel "Informações" do
			attributes_table_for layout_carteirinha do
				row "Nome" do 
					td f.input :nome_posx, label:"Posição X  "
					td f.input :nome_posy, label:"Posição Y  "
				end
				row "Instituição de Ensino" do 
					td f.input :instituicao_ensino_posx, label:"Posição X  "
					td f.input :instituicao_ensino_posy, label:"Posição Y  "
				end
				row "Escolaridade" do 
					td f.input :escolaridade_posx, label:"Posição X  "
					td f.input :escolaridade_posy, label:"Posição Y  "
				end
				row "Curso" do 
					td f.input :curso_posx, label:"Posição X  "
					td f.input :curso_posy, label:"Posição Y  "
				end
				row "Data Nascimento" do 
					td f.input :data_nascimento_posx, label:"Posição X  "
					td f.input :data_nascimento_posy, label:"Posição Y  "
				end
				row "RG" do 
					td f.input :rg_posx, label:"Posição X  "
					td f.input :rg_posy, label:"Posição Y  "
				end
				row "CPF" do 
					td f.input :cpf_posx, label:"Posição X  "
					td f.input :cpf_posy, label:"Posição Y  "
				end
				row "Código de Uso" do 
					td f.input :codigo_uso_posx, label:"Posição X  "
					td f.input :codigo_uso_posy, label:"Posição Y  "
				end
				row "Não Depois" do 
					td f.input :nao_depois_posx, label:"Posição X  "
					td f.input :nao_depois_posy, label:"Posição Y  "
				end
				row "Qr-Code Posição" do 
					td f.input :qr_code_posx, label:"Posição X  "
					td f.input :qr_code_posy, label:"Posição Y  "
				end
				row "Qr-Code Dimensões" do 
					td f.input :qr_code_width, label:"Largura  "
					td f.input :qr_code_height, label:"Comprimento  "
				end
				row "Foto Posição" do 
					td f.input :foto_posx, label:"Posição X  "
					td f.input :foto_posy, label:"Posição Y  "
				end
				row "Foto Dimensões" do 
					td f.input :foto_width, label:"Largura  "
					td f.input :foto_height, label:"Comprimento  "
				end
			end
		end
		f.actions
	end

end