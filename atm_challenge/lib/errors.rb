# frozen_string_literal: true

class ClientError < StandardError
  def initialize(msg)
    @status = 400
    super(msg)
  end

  attr_accessor :status
end

class ServerError < StandardError
  def initialize(msg)
    @status = 500
    super(msg)
  end

  attr_accessor :status
end

class AtmInUseError < ClientError
  def initialize(msg = 'caixa-em-uso')
    super(msg)
  end
end

class AtmNotIntialized < ServerError
  def initialize(msg = 'caixa-inexistente')
    super(msg)
  end
end

class AtmNotAvailable < ClientError
  def initialize(msg = 'caixa-indisponivel')
    super(msg)
  end
end

class AtmNotEnoughCash < ServerError
  def initialize(msg = 'valor-indisponivel')
    super(msg)
  end
end

class AtmDuplicatedWithdrawal < ClientError
  def initialize(msg = 'saque-duplicado')
    super(msg)
  end
end

class BadRequest < ClientError
  def initialize(msg = 'bad-request')
    super(msg)
  end
end

class UnexpectedInput < BadRequest; end
