class Admin::PagamentoNotificacoesController < ApplicationController
	def notificacoes
		transaction = PagSeguro::Transaction.find_by_notification_code(params[:notificationCode])
    	if transaction.errors.empty?
    		@certificado_pedido = CertificadoPedido.find(transaction.reference)
    		@certificado_pedido.forma_pagamento = CertificadoPedido.forma_pagamento_by_type(transaction.payment_method.type_id)
    		@certificado_pedido.transacao = transaction.code
    		status = CertificadoPedido.status_pagamento_by_code(transaction.status.id).to_sym
            logger.debug "STATUS TRANSACTION #{status}"
    		status_pagamento_atual = @certificado_pedido.status
    		if status == :pago && status != status_pagamento_atual # add saldo
    			@admin_user = @certificado_pedido.admin_user
    			@admin_user.add_saldo @certificado_pedido.valor_total
    			@admin_user.save
    		elsif ((status == :contestado || status == :em_disputa || status == :devolvido) && status != status_pagamento_atual) # remove saldo
    			@admin_user = @certificado_pedido.admin_user
    			@admin_user.remove_saldo @certificado_pedido.valor_total
    			@admin_user.save
    		else
    		end
    		@certificado_pedido.status = status
            logger.debug "STATUS CERTIFICADO #{@certificado_pedido.status}"
    		@certificado_pedido.save
    	end
    	render nothing: true, status: 200 
	end
end