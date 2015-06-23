within Annex60.Experimental.Pipe.BaseClasses;
model TempDelaySD "Temperature delay using spatialDistribution operator"
  extends Annex60.Fluid.Interfaces.PartialTwoPortTransport;

  parameter Real initialPoints[:](each min=0, each max=1) = {0.0, 1.0}
    "Initial points for spatialDistribution";
  parameter Modelica.SIunits.Temperature initialValuesH[:] = {Medium.h_default,
                                                              Medium.h_default}
    "Inital enthalpy values for spatialDistribution";

  Modelica.SIunits.Length x(start=0)
    "Spatial coordiante for spatialDistribution operator";
  Modelica.SIunits.Velocity v "Flow velocity of medium in pipe in m/s";

  parameter Modelica.SIunits.Diameter D = 0.1 "Pipe diameter in m";
  parameter Modelica.SIunits.Length L = 100 "Pipe length in m";
  Modelica.SIunits.Area A "Cross-sectional area of pipe in m*m";

protected
  parameter Modelica.SIunits.Enthalpy h_default=Medium.specificEnthalpy(sta_default)
    "Density, used to compute flow velocity";
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
equation
  dp = 0;
  A = Modelica.Constants.pi * (D/2)^2;

  der(x) = v;
  v = V_flow / A;

  (port_a.h_outflow,
   port_b.h_outflow) = spatialDistribution(inStream(port_a.h_outflow),
                                           inStream(port_b.h_outflow),
                                           x/L,
                                           v>=0,
                                           initialPoints,
                                           initialValuesH);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-72,-28}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-80,80},{80,-60}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-40},{-60,-40},{-60,20},{80,20}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-80,-40},{4,-40},{8,-38},{16,16},{20,20},{80,20}},
          color={255,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-80,60},{-80,-60},{80,-60}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled})}),
    Documentation(revisions="<html>
<ul>
<li>
June 23, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>A simple model to account for the effect of the temperature delay for a fluid flow throurgh a pipe. It uses the spatialDistribution operator to delay changes in input enthalpy depending on the flow velocity.</p>
</html>"));
end TempDelaySD;
