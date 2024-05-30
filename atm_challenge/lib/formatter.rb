class Formatter
  @@nominal_to_ptbr = {
    10 => :'notasDez',
    20 => :'notasVinte',
    50 => :'notasCinquenta',
    100 => :'notasCem',
  }

  # Format Atm state for output
  def self.format_for_output(atm)
	return { caixa: {} } if atm.state.empty?

    translate_bills = proc { |nominal| @@nominal_to_ptbr[nominal] }

    {
      caixa: {
        :'caixaDisponivel' => atm.available?,
        notas: atm.bills.transform_keys(&translate_bills)
      }
    }
  end
end
