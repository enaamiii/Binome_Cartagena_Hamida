  --Example instantiation for system 'mon_SOPC'
  mon_SOPC_inst : mon_SOPC
    port map(
      out_port_from_the_led => out_port_from_the_led,
      clk_0 => clk_0,
      in_port_to_the_bouton => in_port_to_the_bouton,
      reset_n => reset_n
    );


