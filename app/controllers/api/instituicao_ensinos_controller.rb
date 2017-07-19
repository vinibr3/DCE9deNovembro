class Api::InstituicaoEnsinosController < Api::AuthenticateBase
	def index
		param = I18n.transliterate(params[:searchstr].mb_chars.upcase)
		@instituicoes = InstituicaoEnsino.order(:nome).where("unaccent(upper(nome)) ILIKE ?", "%#{param}%").limit(10)
		render json: @instituicoes 
	end
end