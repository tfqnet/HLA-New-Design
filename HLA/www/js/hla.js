function setPage(){
	$('#rptVersion').html('Win MP (Trad) Version 6.7 (Agency) - Last Updated 03 Oct 2012 - E&amp;OE-');

        db.transaction(function(transaction) {
            transaction.executeSql('select count(*) as pCount from SI_Temp_Pages', [], function(transaction, result) {
                if (result != null && result.rows != null) {
                    var row = result.rows.item(0); 
                    $('.totalPages').html(row.pCount);
                }
            },errorHandler);
        },errorHandler,nullHandler);

	var sPath = window.location.pathname;
	var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);

        db.transaction(function(transaction) {
            transaction.executeSql("Select PageNum from SI_Temp_Pages where htmlName = '" + sPage + "'", [], function(transaction, result) {
                if (result != null && result.rows != null) {
                    var row = result.rows.item(0); 
                    $('.currentPage').html(row.PageNum);
                }
            },errorHandler);
        },errorHandler,nullHandler);
    
    db.transaction(function(transaction) {
                   transaction.executeSql("Select AgentLoginID,AgentCode from Agent_profile LIMIT 1", [], function(transaction, result) {
                                          if (result != null && result.rows != null) {
                                          var row = result.rows.item(0); 
                                          $('#agentName').html(row.AgentLoginID);
                                          $('#agentCode').html(row.AgentCode);
                                          }
                                          },errorHandler);
                   },errorHandler,nullHandler);
}

function setPageDesc(page){
	$('#rptVersion').html('Win MP (Trad) Version 6.7 (Agency) - Last Updated 03 Oct 2012 - E&amp;OE-');

        db.transaction(function(transaction) {
            transaction.executeSql('select count(*) as pCount from SI_Temp_Pages', [], function(transaction, result) {
                if (result != null && result.rows != null) {
                    var row = result.rows.item(0); 
                    $('.totalPages').html(row.pCount);
                }
            },errorHandler);
        },errorHandler,nullHandler);

	//var sPath = window.location.pathname;
	//var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
	sPage = page

        db.transaction(function(transaction) {
            transaction.executeSql("Select PageNum from SI_Temp_Pages where htmlName = '" + sPage + "'", [], function(transaction, result) {
                if (result != null && result.rows != null) {
                    var row = result.rows.item(0); 
                    $('.currentPage').html(row.PageNum);
                }
            },errorHandler);
        },errorHandler,nullHandler);
    
    db.transaction(function(transaction) {
                   transaction.executeSql("Select AgentLoginID,AgentCode from Agent_profile LIMIT 1", [], function(transaction, result) {
                                          if (result != null && result.rows != null) {
                                          var row = result.rows.item(0); 
                                          $('#agentName').html(row.AgentLoginID);
                                          $('#agentCode').html(row.AgentCode);
                                          }
                                          },errorHandler);
                   },errorHandler,nullHandler);
}

function writeInvestmentScenarios(){
	$('#investmentScenarios').html('<table id="table-notes"><tr><td width="50%" valign="top">&nbsp;</td><td width="50%" valign="top">The Illustration show the possible level of benefits you may expect on two investment scenarios :<br/><i>Illustrasi ini menunjukkan jangkaan tahap faedah berdasarkan dua senario pelaburan :</i><br/>1. Scenario A (Sce. A) = Assumes the participating fund earns 6.50% every year<br/>&nbsp;&nbsp;&nbsp;&nbsp;<i>Senario A (Sce. A) = Anggapan dana penyertaan memperolehi 6.50% setiap tahun</i><br/>2. Scenario B (Sce. B) = Assumes the participating fund earns 4.50% every year<br/>&nbsp;&nbsp;&nbsp;&nbsp;<i>Senario B (Sce. B) = Anggapan dana penyertaan memperolehi 4.50% setiap tahun</i><br/><br/><div style="width:600px;height:30px;border:2px solid black;padding: 5px 0px 0px 5px">Guaranteed = Minimum you will receive regardless of the Company investment.<br/><i>Terjamin = Minimum yang akan anda perolehi tanpa bergantung kepada pencapaian pelaburan syarikat.</i></div></td></tr></table>');
}

function writeInvestmentScenariosRight(){
	$('#investmentScenariosRight').html('The Illustration show the possible level of benefits you may expect on two investment scenarios :<br/><i>Illustrasi ini menunjukkan jangkaan tahap faedah berdasarkan dua senario pelaburan :</i><br/>1. Scenario A (Sce. A) = Assumes the participating fund earns 6.50% every year<br/>&nbsp;&nbsp;&nbsp;&nbsp;<i>Senario A (Sce. A) = Anggapan dana penyertaan memperolehi 6.50% setiap tahun</i><br/>2. Scenario B (Sce. B) = Assumes the participating fund earns 4.50% every year<br/>&nbsp;&nbsp;&nbsp;&nbsp;<i>Senario B (Sce. B) = Anggapan dana penyertaan memperolehi 4.50% setiap tahun</i><br/><br/><div style="width:480px;height:30px;border:2px solid black;padding: 5px 0px 0px 5px">Guaranteed = Minimum you will receive regardless of the Company investment.<br/><i>Terjamin = Minimum yang akan anda perolehi tanpa bergantung kepada pencapaian pelaburan syarikat.</i></div>');
}

function formatCurrency(num) {
	num = num.toString().replace(/\$|\,/g, '');
    if (isNaN(num)) num = "0";
    sign = (num == (num = Math.abs(num)));
    num = Math.floor(num * 100 + 0.50000000001);
    cents = num % 100;
    num = Math.floor(num / 100).toString();
    if (cents < 10) cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
    	num = num.substring(0, num.length - (4 * i + 3)) + ',' + num.substring(num.length - (4 * i + 3));
    return (((sign) ? '' : '-') + '' + num + '.' + cents);
        //document.write (((sign) ? '' : '-') + '' + num + '.' + cents);
}

	function gup(name)
	{
    	name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
    	var regexS = "[\\?&]"+name+"=([^&#]*)";
    	var regex = new RegExp( regexS );
    	var results = regex.exec( window.location.href );
    	if( results == null )
        	return "";
    	else
        	return results[1];
	}