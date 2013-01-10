<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!--------

File:      ReqVersion2.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Medical Research Council

---------->
<html>
    <head>
       <link rel="stylesheet" type="text/css" href="application.css" />    
<script type="text/javascript" src="http://spike.la.asu.edu/NeuroMLValidator/public/javascripts/jquery-1.7.1.min.js"></script>
  <script type="text/javascript" src="http://spike.la.asu.edu/NeuroMLValidator/public/javascripts/jquery.dropotron-1.0.js"></script>
<script type="text/javascript">
var j = jQuery.noConflict();
      j(function() {
          j('#menu > ul').dropotron({
              mode: 'fade',
              globalOffsetY: 11,
              offsetY: -15
          });
      });
  </script>
        <title>Requirements for version 2.0 of NeuroML</title>
        <%GeneralUtils.setCurrentPageRef("v2");%>
    </head>
    <body>
 
    <div id="wrapper">
        <%@ include file="header.jsp" %>
        <div class="overflowcontent">
      <h1>List of requirements/suggestions for NeuroML Version 2.0</h1>
        
        

        <br/>
        <table id="highlighted" align="center" >
            <tr>
                <td>The following represents an <u>incomplete list</u> of the changes needed to the structure of the language for version 2.0. Many of the changes listed below
                    were designed to get a more consistent naming of elements in NeuroML and have been incorporated since v1.7.1. More details of the overall structural changes
                    for v2.0 will be available in the minutes of the 2010 NeuroML Development Workshop.<br/> See the <a href="../roadmap.php">Roadmap</a> for more details.</td>
            </tr>
        </table>

        <br/>
        <br/>
        
        <table  frame="border" rules="all"  cellpadding="8">
            
        <tr class="footer2"  ><td colspan="2"> <b>General</b></td></tr>
        <tr> <td>
        
        <p>More consistent choice of attributes (<b>&lt;aa bb="XXX"/&gt;</b>) or text elements (<b>&lt;aa&gt; &lt;bb&gt;XXX&lt;/bb&gt;&lt;/aa&gt;</b>) for data:  </p>
         
        <p>- Attributes should be used by default, unless the extra information about the element has multi parts, in which case a sub element (mainly with attributes) should be used</p>
        <p>- Text elements should be used when the contents are expected to be a long string, e.g. comment, url, paper title, et.</p>
        </td><td ><font color="green"><b>Generally incorporated</b></font></td></tr>
        
        
        <tr> <td>
        <p>More consistent naming of elements. As underscores are used in NetworkML and ChannelML (<b>synapse_props</b>, <b>current_voltage_relation</b>, etc.) this form should be used in MorphML etc. too.</p>
        </td><td><font color="green"><b>Generally incorporated</b></font></td></tr>
    
        <tr> <td>
        <p>Change namespace identifiers to <b>http://neuroml.org/metadata</b> from <b>http://morphml.org/metadata/schema</b>, etc. </p>
        </td><td><font color="red"><b>Wait until v2.0, as all existing files will be invalidated</b></font></td></tr>
        
        
      <tr class="footer2"  ><td colspan="2"> <b>Metadata</b></td></tr><tr> <td>
        
        <p>Make <b>meta:property</b> tag/value pair attributes: <b>&lt;meta:property tag="???" value="???"/&gt;</b> </p>
        
    </td><td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H</b></sup></b></font>
</td></tr>
      <tr class="footer2"  ><td colspan="2"> <b>MorphML</b></td></tr>
        <tr> <td>
        <p>Restrict the number of possibilities for specifying parent of <b>segment</b>/<b>cable</b>, etc. to a standardised form. Make <b>parent</b> attribute of <b>segment</b> required.</p>
            </td><td><font color="green"><b>Updated, but no restriction yet <sup><b>E&nbsp;nC</b></sup></b></font>
</td></tr><tr> <td>
        <p>Make changes necessary for variability in cell structure within network (i.e. differences between cells in a population/cell group), which will be mainly dealt with in NetworkML (see below).</p>
        </td><td><font color="red"><b>Not incorporated yet</b></font>
</td></tr>


        <tr> 
            <td>
                <p>Change <b>fractAlongParent</b> to <b>fract_along_parent</b> for consistent naming of attributes in NetworkML and ChannelML</p>
            </td>
            <td>
                <font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;nC</b></sup></b></font>
            </td>
        </tr>


        <tr>
            <td>
                <p>Change <b>lengthUnits</b> to <b>length_units</b> for consistent naming of attributes</p>
            </td>
            <td>
                <font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;nC</b></sup></b></font>
            </td>
        </tr>

        <tr>
            <td>
                <p>Use <b>micrometer</b> instead of <b>micron</b> as option for <b>length_units</b></p>
            </td>
            <td>
                <font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;nC</b></sup></b></font>
            </td>
        </tr>
        
        <tr> 
            <td>
                <p>Change <b>cellBody</b>, <b>freePoints</b>, <b>propertyDetails</b>, <b>groupDetails</b> to <b>cell_body</b>, etc. for consistent naming of elements and attributes</p>
            </td>
            <td>
                <font color="red"><b>Not incorporated yet</b></font>
            </td>
        </tr>
        
        
        
      <tr class="footer2"  ><td colspan="2"> <b>Biophysics</b></td></tr>
                
                
        
        
        <tr> 
        <td>
        <p>Change attribute <b>passiveConductance</b> to <b>passive_conductance</b> to be consistent with naming in NetworkML and ChannelML</p>
        </td>
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;nC</b></sup></b></font></td>
        </tr>
        
        <tr> <td>
        <p>Change <b>specificCapacitance</b>, etc. to <b>spec_capacitance</b>,  <b>spec_axial_resistance</b>,  <b>init_memb_potential</b>, <b>ion_properties</b> 
        to match new naming convention</p>
        </td><td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;nC</b></sup></b></font>
        </td></tr>
        
        <tr> 
        <td>
        <p>Name of group in <b>&lt;group&gt;</b> element to become an attribute (related to next point)</p>
        </td>
        
        <td><font color="red"><b>Not incorporated yet</b></font></td>
        
        </tr>
        
        
        <tr> <td>
        
        <p>Reorganise mechanism/parameter/group structure. Probably to</p><p> <b>&lt;mechanism&gt; &lt;group&gt; &lt;parameters...&gt; &lt;/group&gt; &lt;group&gt; &lt;parameters...&gt; &lt;/group&gt; &lt;/mechanism&gt;</b></p>
        <p> A possible alternative would be to remove the nesting and have lists of</p><p> <b>&lt;mechanismtype name="???"  parameter="???" value="???" group="???"&gt;</b></p>
        <p> The <b>mechanismtype</b> could be replaced by <b>channel_mechanism</b>, <b>spec_capacitance</b>, etc.</p>
        </td>
        <td><font color="red"><b>Not incorporated yet (Priority)</b></font></td>
        </tr>
        
        
        <tr class="footer2"  ><td colspan="2"> <b>ChannelML</b></td></tr>
        <tr> <td>
        <p>Remove optional <b>expr</b> attribute in <b>parameterised_hh</b>, as the form of expression is wholly determined 
        by the <b>type="linoid"</b>, etc.</p>
        </td>
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;N&nbsp;G</b></sup></b></font></td>
        
        </tr>
        
        
        <tr> <td>
      <p>Restructure channels to use <b>&lt;linoid A="1" k="0.1" d="-40"/></b> (or 
      <b>&lt;... expr_form="linoid" A="1" Vslope="10" V0="-40"/></b>)     etc. for standard parameterised rate expressions</p>
        </td>
        <td><font color="green"><b>Part of changed made in ChannelML in v1.7.3, but old form still valid<sup>**&nbsp;E&nbsp;H&nbsp;N&nbsp;G&nbsp;nC</sup></b></font></td>
        
        </tr>
        
        
        
        <tr> <td>
      <p>Change form of conditional generic expression from v &lt; -0.060 ? 5.0 : 5 * (exp (-50 * (v - (-0.060)))), etc. to a nested set of equations</p>
        </td>
        
        <td><font color="red"><b>Not incorporated yet</b></font></td>
        
        </tr><tr> <td>
        <p>A more general framework for dealing with ions, etc. allowing any chemical/species to interact with a channel/synapse (first step to SBML support)</p>
        </td>
        
        <td><font color="red"><b>Not incorporated yet</b></font></td>
        
        </tr>
        
        <tr> <td>
        <p>Have <b>source</b> (i.e. not <b>src</b>) and <b>target</b> as attributes of <b>transition</b></p>
        </td>
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;N&nbsp;G</b></sup></b></font></td>
        
        </tr>
        
        <tr> <td>
        <p>Make <b>resting_conc</b>, <b>decay_constant</b> and <b>ceiling</b> attributes of <b>decaying_pool_model</b> in CaPool, 
        <b>shell_thickness</b> an attribute of <b>pool_volume_info</b>, <b>name</b> an attribute of <b>ion_species</b></p>
        </td>
        
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;N&nbsp;G</b></sup></b></font></td>
        
        </tr>
      <tr class="footer2"  ><td colspan="2"> <b>Level 3/NetworkML</b></td></tr>
        <tr> <td>
        <p>Remove <b>net:potentialSynapticLocation</b> from <b>biophysics</b> element in Level 3 cell (and rename to <b>net:potential_syn_loc</b>), 
        make a subelement of <b>connectivity</b> under <b>cell</b>, as some cells may specify connectivity without detailed biophysics. 
        Rearrange attributes.</p>
        </td>
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;nC</b></sup></b></font></td>
        
        </tr>
        
        <tr> <td>
        
        <p>Make specification of <b>size</b> attribute in <b>&lt;instances&gt;</b> element required. Will help memory allocation when parsing large 
        network files.</p>
        </td>
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;X&nbsp;nC</b></sup></b></font></td>
        
        </tr>
        
        <tr> <td>
        
        <p>Make name of attribute of <b>target</b> for electrical input <b>population</b> instead of <b>cell_group</b></p>
        </td>
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H</b></sup></b></font></td>
        
        </tr>
        
        
        
        <tr> <td>
        
        <p>Move <b>cell_type</b> to be attribute of <b>population</b></p>
        </td>
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;X&nbsp;nC</b></sup></b></font></td>
        
        </tr><tr> <td>
        
        <p>Restructure <b>synapse_props</b> element with <b>synapse_type</b> as an attribute and 
        <b>delays</b> etc. as attributes of this element as opposed to <b>default_values</b>.</p> 
        </td>

        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;X&nbsp;nC</b></sup></b></font></td>

        </tr>
        <tr> <td>
        <p>Move <b>source</b> and <b>target</b> to be attributes of <b>projection</b></p>
        </td>
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;X&nbsp;nC</b></sup></b></font></td>
        
        </tr>
        <tr> <td>
        <p>Make <b>pre cell_id</b>, <b>segment_id</b> etc. attributes of connection, which should speed up reading in of long net conn files, 
        especially when using SAX. (Note: NetworkML plaintext file with 100,000 synapses went from 32MB to 25MB with change).</p>
        </td>
        
        <td><font color="green"><b>Updated<sup><b>**&nbsp;E&nbsp;H&nbsp;X&nbsp;nC</b></sup></b></font></td>
        
        </tr>
        <tr> <td>
        <p>Allow specification of uniquely identified synapse locations on cells (without reference to net conn), not just possible synapse locations.</p>
        
        </td>
        
        <td><font color="red"><b>Not incorporated yet</b></font></td>
        
        </tr>
        <tr> <td>
        <p>Allow <u>variability of structure of cells</u> within populations. A prototype can be specified in a 
        MorphML doc, and each instance will list the changes from the original. Initially this will allow, for example,
        networks of cells of inhomogenous soma radii, or fluctuations in channel densities, etc. but should be extensible 
        to allow any morphological or biophysical changes of the cells in the network.</p>
        </td>
        
        <td><font color="red"><b>Not incorporated yet</b></font></td>
        
        </tr>
        </table>
       
        
        <p>&nbsp;</p>
         <p><b><sup>**</sup></b> = Updated in current specifications. Note: old form will still be valid until v2.0</p>
        <p><b><sup>E</sup></b> = Updated examples to reflect preferred format</p>
        <p><b><sup>H</sup></b> = HTML mappings work with both formats </p>
        <p><b><sup>N</sup></b> = NEURON ChannelML mappings work with both formats </p>
        <p><b><sup>G</sup></b> = GENESIS ChannelML mappings work with both formats </p>
        <p><b><sup>X</sup></b> = X3D mappings for NetworkML work with both formats </p>
        <p><b><sup>nC</sup></b> = Updated neuroConstruct NetworkML/cell import for both formats, exports new form </p>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
<%@ include file="footer.jsp" %>
</div></div>
        
</div></div>
    </body>
</html>
