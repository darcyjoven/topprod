DATABASE ds
 
GLOBALS "../../config/top.global"
main
define l_sql STRING
define l_hrcda01  like hrcda_file.hrcda01
define l_hrcda02  like hrcda_file.hrcda02
define l_hrcd03,l_hrcd05   like hrcd_file.hrcd03
   let l_sql = " select hrcda01,hrcda02 from hrcd_file,hrcda_file  where hrcd08 = 'Y' and hrcda02 = hrcd10 and (hrcda06 is null or hrcda08 is null) " 
   prepare hrcda_q from l_sql
   declare hrcda_s cursor for hrcda_q
   foreach hrcda_s into l_hrcda01,l_hrcda02
      select hrcd03,hrcd05 into l_hrcd03,l_hrcd05 from hrcd_file 
       where hrcd10 =  l_hrcda02
      update hrcda_file set hrcda06 = l_hrcd03,hrcda08 =  l_hrcd05,hrcda09 = l_hrcd05 - l_hrcd03 
       where hrcda01 = l_hrcda01 and hrcda02 = l_hrcda02
   end foreach 
end main