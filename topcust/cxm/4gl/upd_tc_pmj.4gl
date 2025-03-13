DATABASE ds

MAIN
DEFINE g_oga RECORD LIKE oga_file.*,
       g_ogb RECORD LIKE ogb_file.*,
   #    l_oga40      LIKE oga_file.oga40,
   #    l_oga40t     LIKE oga_file.oga40t,
  #     l_ogb88,l_ogb88t LIKE ogb_file.ogb88,
       l_cnt        LIKE type_file.num5,
       t_azi04      LIKE azi_file.azi04,
       t_azi03      LIKE azi_file.azi03,
       g_gec07      LIKE gec_File.gec07,
       g_gec05      LIKE gec_file.gec05,
       l_ogb    RECORD LIKE ogb_file.*,
       g_success    LIKE type_file.chr1,
       l_ogb03      LIKE ogb_file.ogb03
       
  IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
  BEGIN WORK
  LET g_success='Y' 
  DECLARE sel_ogb_cur1 CURSOR FOR
  SELECT oga_file.oga011,ogb_file.* FROM  oga_file,ogb_file WHERE  oga01=ogb01 AND oga09='2' 
#  AND ogaconf!='X'  
  AND oga011 IS NOT NULL 
  FOREACH sel_ogb_cur1 INTO g_oga.oga011,g_ogb.*    #出货单&出通单号抓取
    DECLARE sel_ogb3_cur CURSOR FOR 
    SELECT ogb03   FROM ogb_file,oga_file WHERE ogb01=oga01
    AND oga09=1 AND ogb01=g_oga.oga011 AND ogb04=g_ogb.ogb04
    AND ogb31=g_ogb.ogb31 AND ogb32=g_ogb.ogb32 
    OPEN sel_ogb3_cur
    FETCH sel_ogb3_cur INTO l_ogb03 
    CLOSE sel_ogb3_cur 
    IF NOT cl_null(l_ogb03) >0 THEN 
       UPDATE ogb_file SET ogbud10=l_ogb03 WHERE ogb01=g_ogb.ogb01
       AND ogb03=g_ogb.ogb03 
       IF STATUS OR sqlca.sqlerrd[3]=0 THEN
          CALL cl_err('upd ogb err',status,1)
          LET g_success='N'
       END IF  
    END IF 
    

   END FOREACH     
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF 
END MAIN
