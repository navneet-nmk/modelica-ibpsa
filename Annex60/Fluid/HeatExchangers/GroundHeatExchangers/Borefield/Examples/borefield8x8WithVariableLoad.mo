within Annex60.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples;
model borefield8x8WithVariableLoad
  "Model of a borefield in a 8x8 boreholes with variable load."

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Data.BorefieldData.SandStone_Bentonite_c8x8_h110_b5_d600_T283
    bfData
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Integer lenSim=3600*24*366 "length of the simulation";
  parameter Modelica.SIunits.Temperature T_start = bfData.gen.T_start;

  MultipleBoreHolesUTube borFie(
    lenSim=lenSim,
    redeclare package Medium = Medium,
    bfData=bfData) "borefield"
    annotation (Placement(transformation(extent={{-20,-60},{20,-20}})));
  Modelica.Blocks.Sources.Step load(height=1, startTime=36000)
    "load for the borefield"
    annotation (Placement(transformation(extent={{14,0},{28,14}})));

  Annex60.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    T_start=bfData.gen.T_start,
    m_flow_nominal=bfData.m_flow_nominal,
    m_flow(start=bfData.m_flow_nominal),
    Q_flow_nominal=bfData.gen.q_ste*bfData.gen.nbBh*bfData.gen.hBor,
    p_start=100000)
    annotation (Placement(transformation(extent={{30,40},{10,20}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-60,58},{-40,78}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    T_start=bfData.gen.T_start)
    annotation (Placement(transformation(extent={{38,-50},{58,-30}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{42,-4},{56,10}})));
  Modelica.Blocks.Sources.Pulse pulse(period=7200, offset=-0.25)
    annotation (Placement(transformation(extent={{14,-22},{28,-8}})));
  Movers.FlowControlled_m_flow               pum(
    redeclare package Medium = Medium,
    dynamicBalance=false,
    m_flow_nominal=bfData.m_flow_nominal,
    T_start=T_start,
    addPowerToMedium=false,
    filteredSpeed=false)
    annotation (Placement(transformation(extent={{-6,40},{-26,20}})));
  Modelica.Blocks.Sources.Constant mFlo1(
                                        k=bfData.m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,-8},{-38,4}})));
equation
  connect(hea.port_a, senTem.port_b) annotation (Line(
      points={{30,30},{70,30},{70,-40},{58,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_a, borFie.port_b) annotation (Line(
      points={{38,-40},{20,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(load.y, product.u1) annotation (Line(
      points={{28.7,7},{33.95,7},{33.95,7.2},{40.6,7.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, product.u2) annotation (Line(
      points={{28.7,-15},{36,-15},{36,-1.2},{40.6,-1.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, hea.u) annotation (Line(
      points={{56.7,3},{64,3},{64,24},{32,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFlo1.y, pum.m_flow_in) annotation (Line(
      points={{-37.4,-2},{-15.8,-2},{-15.8,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-6,30},{10,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, borFie.port_a) annotation (Line(points={{-26,30},{-44,30},
          {-60,30},{-60,-40},{-20,-40}}, color={0,127,255}));
  connect(pum.port_b, boundary.ports[1])
    annotation (Line(points={{-26,30},{-26,68},{-40,68}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end borefield8x8WithVariableLoad;
