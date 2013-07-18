jQuery(document).ready(function(){
  //alert('loaded jquery');
  jQuery(".0").show();
  jQuery('.load-more').on('click',function(){
     //alert("button clicked");
      var myClass=jQuery(this).attr("class");
      n=myClass.split(" ");
      $("."+n[1]).hide();
      $("."+(parseInt(n[1])+1)).show();
          //jQuery('.load-more').text('No :-<');
  });
});
