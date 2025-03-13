DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

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
       l_yy          LIKE  type_file.chr10,
       l_month       LIKE  type_file.chr10,
       l_ogb03      LIKE ogb_file.ogb03
       
  IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
  LET g_success='Y' 
   LET l_yy=YEAR(g_today)
   LET l_month=MONTH(g_today)
   UPDATE sma_file SET sma51=l_yy,sma52=l_month     #'2017' ,sma52='1' 
 #  IF g_success='Y' THEN
 #     COMMIT WORK
 #  ELSE
 #     ROLLBACK WORK
 #  END IF 
END MAIN
