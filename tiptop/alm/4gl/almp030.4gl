# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: almp030.4gl
# Descriptions...: 日結作業
# Date & Author..: NO.FUN-870010 08/09/27 By lilingyu 
# Modify.........: No.FUN-960134 09/07/23 By shiwuying 市場移植
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore 
# Modify.........: No:FUN-A90040 10/10/24 By shenyang  日結的資料來源, 改為 ogb_file(出貨單身檔) 
#                                                       及 ohb_file(銷退單身檔), 來產生日結檔資料, 供計算相關招商費用時使用.
# Modify.........: No:FUN-AA0057 10/12/16 By shenyang  修改bug
# Modify.........: No:TQC-B10165 11/01/14 By shiwuying 日结修改
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-BA0105 11/10/31 By pauline 加上背景作業功能
# Modify.........: No.FUN-C10001 12/01/30 By pauline mark lra_file 
DATABASE ds
 
GLOBALS "../../config/top.global"
	
DEFINE g_lsa           RECORD LIKE lsa_file.* ,   
       g_wc            STRING,
       g_sql           STRING,
       g_sql1          STRING,
       g_sql2          STRING,       
       g_sql3          STRING,
       g_sql4          STRING,
       g_sql5          STRING,
       s_sql3          STRING,
       s_sql4          STRING,
       s_sql5          STRING,
       g_change_lang   LIKE type_file.chr1,
       l_flag          LIKE type_file.chr1    
DEFINE g_chr           LIKE type_file.chr1        
DEFINE g_cnt           LIKE type_file.num10  
DEFINE g_cnt_4         LIKE type_file.num5
DEFINE g_cnt_5         LIKE type_file.num5 
DEFINE g_cnt_1         LIKE type_file.num10
DEFINE g_cnt_2         LIKE type_file.num10
DEFINE g_cnt_3         LIKE type_file.num10 
DEFINE s_cnt_3         LIKE type_file.num5 
DEFINE s_cnt_4         LIKE type_file.num5 
DEFINE s_cnt_5         LIKE type_file.num5 
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose   
DEFINE g_msg           LIKE type_file.chr1000   
DEFINE g_before_input_done  LIKE type_file.num5  
DEFINE p_cmd           LIKE type_file.chr1  
DEFINE g_flag          LIKE type_file.chr1      
DEFINE g_rxx05         LIKE rxx_file.rxx05
#FUN-C10001 mark START
#DEFINE gg_lra20        LIKE lra_file.lra20 
#DEFINE gg_lra21        LIKE lra_file.lra21
#DEFINE gg_lra19        LIKE lra_file.lra19
#DEFINE g_lra27         LIKE lra_file.lra27
#DEFINE g_lra28         LIKE lra_file.lra28
#DEFINE g_lra23         LIKE lra_file.lra23
#DEFINE g_lra24         LIKE lra_file.lra24
#DEFINE g_lra25         LIKE lra_file.lra25  
#DEFINE w_lra19         LIKE lra_file.lra19
#DEFINE w_lra20         LIKE lra_file.lra20
#DEFINE w_lra21         LIKE lra_file.lra21 
#FUN-C10001 mark END
##add--zj--start---
#DEFINE  g_ooy          RECORD LIKE ooy_file.*
#DEFINE  g_ooa_d        RECORD LIKE ooa_file.*
#DEFINE  g_ooa_acc      DYNAMIC ARRAY OF RECORD
#                       ooa01      LIKE ooa_file.ooa01
#                             END RECORD  
#DEFINE  cn             LIKE type_file.num5
#DEFINE  l_n            LIKE type_file.num5
#DEFINE  g_flag1        LIKE type_file.chr1,
#        g_bookno1      LIKE aza_file.aza81,
#        g_bookno2      LIKE aza_file.aza82
###end--
##############
 
MAIN  
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT

#FUN-BA0105 add START
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_lsa.lsa01 = ARG_VAL(1)
   LET g_bgjob  = ARG_VAL(2)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob='N'
   END IF
#FUN-BA0105 add END
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
      IF g_bgjob='N' THEN      #FUN-BA0105 add
         CALL p030()             #畫面日期欄位處理 
         IF cl_sure(18,20) THEN                    
            LET g_success = 'Y'
            
            BEGIN WORK
            CALL p030_process()   #銷售銷退處理 
            CALL s_showmsg() 
    #NO.FUN-A90040  ---begin -- mark         
          #  IF g_success = 'Y' THEN
               #11/26###合并到一個事務里
          #     CALL s_p030(g_lsa.lsa01)  #zj-add
          #  END IF
   #NO.FUN-A90040  ---end -- mark          
            IF g_success = 'Y' THEN 
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag  
            END IF
               #對產生的axrt400的單據進行拋轉憑証 
               #FOR l_n = 1 TO (g_ooa_acc.getLength()-1)             
               #  CALL sp030_gen_acc(g_ooa_acc[l_n].ooa01) 
               #END FOR
               #end--11/26
           # ELSE                                  
           #    ROLLBACK WORK
           #    CALL cl_end2(2) RETURNING l_flag
           # END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p030_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
     #FUN-BA0105 add
         ELSE
            LET g_success = 'Y'
            CALL p030_process()   #銷售銷退處理
            IF g_success = 'Y' THEN
                COMMIT WORK
            ELSE
                ROLLBACK WORK
            END IF
         EXIT WHILE
         END IF
     #FUN-BA0105 add
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
##add---zj--start--
##拋轉總帳函數###
#FUNCTION sp030_gen_acc(p_ooa01)      
#  DEFINE p_ooa01     LIKE ooa_file.ooa01 
#  DEFINE l_ooyslip   LIKE ooy_file.ooyslip 
#  DEFINE l_occ       RECORD LIKE occ_file.* 
#  DEFINE l_cnt       LIKE type_file.num5 
#  DEFINE l_wc_gl     LIKE type_file.chr1000 
#  DEFINE l_str       LIKE type_file.chr1000 
#
#   SELECT * INTO g_ooa_d.* FROM ooa_file WHERE ooa01 = p_ooa01 
#   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa_d.ooa03
#   IF STATUS THEN
#      CALL s_errmsg('occ01',g_ooa_d.ooa03,'sel occ',STATUS,1)
#      LET g_success='N'
#   END IF
#   CALL s_get_doc_no(g_ooa_d.ooa01) RETURNING l_ooyslip
#   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_ooyslip
#   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN 
#      IF g_success = 'Y' THEN  
#         CALL s_chknpq(g_ooa_d.ooa01,'AR',1,'0',g_bookno1) 
#         IF g_aza.aza63='Y' AND g_success='Y' THEN 
#            CALL s_chknpq(g_ooa_d.ooa01,'AR',1,'1',g_bookno2)
#         END IF
#         LET g_dbs_new = g_dbs CLIPPED,'.' 
#      END IF 
#   END IF
#   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN 
#      LET l_wc_gl = 'npp01 = "',g_ooa_d.ooa01,'" AND npp011 = 1' 
#      LET l_str="axrp590 '",l_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",  
#                g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '", 
#                g_ooa_d.ooa02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"  
#      CALL cl_cmdrun_wait(l_str)
#   END IF
#END FUNCTION 
#add---end--
 
FUNCTION p030()
DEFINE    l_n        LIKE type_file.num5 
DEFINE lc_cmd        LIKE type_file.chr1000         #FUN-BA0105 add 
   WHILE TRUE
      LET g_action_choice = ""
 
      OPEN WINDOW p030_w WITH FORM "alm/42f/almp030"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_init()
 
      CLEAR FORM
      
      INITIALIZE g_lsa.* LIKE lsa_file.*   
    
      LET g_lsa.lsa01 = g_today
      DISPLAY BY NAME g_lsa.lsa01  
       
      INPUT BY NAME g_lsa.lsa01 WITHOUT DEFAULTS     
                 
      BEFORE INPUT 
        LET g_before_input_done = FALSE
        CALL cl_set_comp_entry("lsa01",TRUE) 
        LET g_before_input_done = TRUE   
             
      AFTER FIELD lsa01        
         IF NOT cl_null(g_lsa.lsa01) THEN
            SELECT COUNT(*) INTO l_n FROM lsa_file
             WHERE lsa01 = g_lsa.lsa01 
               AND lsa02 IS NOT NULL
               AND lsa04 IS NOT NULL 
#NO.FUN-A90040  ---begin -- mark                
#             AND lsa10 IS NOT NULL
#              AND lsa12 IS NOT NULL
   #          IF l_n > 0 THEN 
   #             CALL cl_err('','alm-500',1)
   #             NEXT FIELD lsa01 
   #          END IF   
   #      END IF 
#NO.FUN-A90040  ---end -- mark 
#NO.FUN-A90040  ---begin  --add
           IF l_n > 0 THEN   #FUN-AA0057
              IF cl_confirm("alm1009") THEN 
                 DELETE FROM lsa_file WHERE lsa01 =  g_lsa.lsa01
              ELSE
                 NEXT FIELD lsa01 
              END IF 
           END IF      #FUN-AA0057
        END IF   
#NO.FUN-A90040  ---end   --add
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG 
            CALL cl_cmdask()    
      
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about   
            CALL cl_about()   
       
         ON ACTION help      
            CALL cl_show_help() 
       
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()  
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p030_w        
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF  
#FUN-BA0105 add START
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS
        ON ACTION about
           CALL cl_about()
        ON ACTION help
           CALL cl_show_help()
        ON ACTION controlp
           CALL cl_cmdask()
        ON ACTION exit
           LET INT_FLAG=1
           EXIT INPUT
        ON ACTION qbe_save
           CALL cl_qbe_save()
        ON ACTION locale
           LET g_change_lang=TRUE
           EXIT INPUT
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p030_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
      END IF
#FUN-BA0105 add END
   EXIT WHILE       
  END WHILE  
#FUN-BA0105 add START
   IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "almp030"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('almp030','9031',1)
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_lsa.lsa01 CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('almp030',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p030_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
   END IF
#FUN-BA0105 add END
END FUNCTION
 
FUNCTION p030_process() 

    #NO.FUN-A90040  ---begin -- add
DEFINE    l_sql    STRING
    
LET l_sql = "INSERT INTO lsa_file (lsa01, lsa02, lsa03, lsa04, lsa05, lsa06, lsa07, lsa11, lsalegal, lsaplant)",
            "  SELECT oga02, ogb48, lnt01, ogb49, lnt08, lnt09, lnt33, ogb14t, lntlegal, lntplant  ", 
            "    FROM ( SELECT oga02, ogb48, ogb49, sum(ogb14t) AS ogb14t ",
            "             FROM ( SELECT oga02, ogb48, ogb49, ogb14t FROM oga_file ",
            "                      LEFT OUTER JOIN ogb_file  ",
            "                        ON oga01 = ogb01    ",
            "                     WHERE oga02 = '",g_lsa.lsa01,"'",                     
            "                       AND ogb48 is not null AND ogb49 is not null ", #TQC-B10165
            "         UNION ALL  ",                     
            "             SELECT oha02, ohb69, ohb70, ohb14t FROM oha_file ",                           
            "          LEFT OUTER  JOIN ohb_file  ON oha01 = ohb01 ",                            
          # "              WHERE oha02 = '",g_lsa.lsa01,"' )",                                            #TQC-B10165
            "              WHERE oha02 = '",g_lsa.lsa01,"' AND ohb69 IS NOT NULL AND ohb70 IS NOT NULL)", #TQC-B10165
            "   GROUP BY oga02, ogb48, ogb49  ) ",            
            "  LEFT OUTER  JOIN lnt_file
                 ON lnt04 = ogb49 AND lnt06 = ogb48 AND lnt26 = 'Y' AND oga02 BETWEEN lnt17 AND lnt18 "
     PREPARE lsa_prepare FROM l_sql
     EXECUTE lsa_prepare 
     IF SQLCA.sqlcode THEN        
        CALL cl_err('INSERT:',SQLCA.sqlcode,1)      
     END IF         
    
    #NO.FUN-A90040  ---end -- add


#NO.FUN-A90040  ---begin -- mark 
#DEFINE  g_lra20   DYNAMIC ARRAY OF RECORD         
#          lra20    LIKE lra_file.lra20 
#                   END RECORD,  
#        g_lra21   DYNAMIC ARRAY OF RECORD
 #         lra21    LIKE lra_file.lra21 
 #                  END RECORD,  
#        s_lra19   DYNAMIC ARRAY OF RECORD 
#          lra19    LIKE lra_file.lra19
#                   END RECORD,                             
#        g_rxx      DYNAMIC ARRAY OF RECORD
#          rxx04    LIKE rxx_file.rxx04,
#          rxx02    LIKE rxx_file.rxx02  
 #                  END RECORD  
#DEFINE    l_lra27  LIKE lra_file.lra27,
 #         l_lra28  LIKE lra_file.lra28,
 #         l_lra23  LIKE lra_file.lra23,
 #         l_lra24  LIKE lra_file.lra24,
 #         l_lra25  LIKE lra_file.lra25 
#DEFINE    l_rxx05  LIKE rxx_file.rxx05    
#DEFINE    l_n      LIKE type_file.num5 
#DEFINE    l_sql    STRING

  #抓商戶
#  LET g_sql = "SELECT DISTINCT lra20 from lra_file,lrc_file ", 			
#              " WHERE lra01 = lrc01",
#	            "   and lrc13 = '",g_lsa.lsa01,"'"							 
#	PREPARE lra20_prepare FROM g_sql
#	DECLARE lra20_curs CURSOR FOR lra20_prepare						
#   #抓攤位
# 	 LET g_sql1 = "SELECT DISTINCT lra21 from lra_file,lrc_file",
# 	              " WHERE lra01 = lrc01",
# 	              "   and lrc13 = '",g_lsa.lsa01,"'",
# 	              "   and lra20 = ?"
# 	 PREPARE lra21_prepare FROM g_sql1
# 	 DECLARE lra21_curs CURSOR FOR lra21_prepare
 
#  LET g_sql4 = "select distinct lra19 from lra_file,lrc_file",
#               " where lrc13 = '",g_lsa.lsa01,"'",
#               "   and lra01 = lrc01",
#               "   and lra20 = ?",
#               "   and lra21 = ?"
#  PREPARE lra19_prepare FROM g_sql4             
#  DECLARE lra19_curs CURSOR FOR lra19_prepare 
 	 
   #抓該攤位當天銷售的各付款別的匯總金額
#   LET g_sql2 = "SELECT SUM(rxx04),rxx02 FROM rxx_file ",			
#                " WHERE rxx01 IN (SELECT lrc02 FROM lra_file,lrc_file ",			
#                "                  where lra01 = lrc01",                 ######bg notice
#                "                    and lra20 = ? ",	
#                "                    AND lra21 = ?",	
#                "                    and lra19 = ?",    
#                "                    AND lrc13 = '",g_lsa.lsa01,"')",
#                "  and rxx00 = '23'",
#                "  and rxx02 != '07'",
#               " GROUP BY rxx02 "									
#   PREPARE p030_prepare FROM g_sql2                
#   DECLARE p030_cur CURSOR FOR p030_prepare  
          
 	 
#選出商戶號的筆數
#  LET l_n = 0 
#  SELECT COUNT(DISTINCT lra20) INTO l_n 
#    FROM lra_file,lrc_file
#   WHERE lra01 = lrc01 
#     AND lrc13 = g_lsa.lsa01
     
#若l_n>0,則依次走一下步驟
#若l_n=0,則call p030_process_3()
#IF l_n > 0 THEN 
#	LET g_cnt = 1 	
# FOREACH lra20_curs INTO g_lra20[g_cnt].*						
 #    IF STATUS THEN 
 #        CALL cl_err('FOREACH:',STATUS,1)
 #        LET g_success = 'N'
 #        EXIT FOREACH
 #     END IF 						
 	     
 #	    LET g_cnt_1 = 1  
 #	    FOREACH lra21_curs USING g_lra20[g_cnt].lra20
 #	                        INTO g_lra21[g_cnt_1].*                  
 #	       IF STATUS THEN 
 #	         CALL cl_err('FOREACH:',STATUS,1)
 #	         LET g_success = 'N'
 #          EXIT FOREACH
 #        END IF 
      
 #        LET g_cnt_4 = 1 
 #        FOREACH lra19_curs USING g_lra20[g_cnt].lra20,
 #                                 g_lra21[g_cnt_1].lra21
 #                            INTO s_lra19[g_cnt_4].*
                            
                                
  #         IF STATUS THEN  
 #	            CALL cl_err('FOREACH:',STATUS,1)
 #	            LET g_success = 'N'
  #            EXIT FOREACH
 #          END IF 
            #抓出該商戶下的樓棟 樓層 大中小類編號 
 #          LET l_lra27 = NULL
 #          LET l_lra28 = NULL
 #          LET l_lra23 = NULL
 #          LET l_lra24 = NULL
 #          LET l_lra25 = NULL  	
 #         SELECT DISTINCT lra27,lra28,lra23,lra24,lra25
 #          INTO l_lra27,l_lra28,l_lra23,l_lra24,l_lra25          
 #          FROM lra_file,lrc_file
 #         WHERE lra01 IN (SELECT lrc01 FROM lrc_file 			
  #                         WHERE lrc13 = g_lsa.lsa01)				
  #          AND lra20 = g_lra20[g_cnt].lra20			
  #          AND lra21 = g_lra21[g_cnt_1].lra21  
   #         AND lra19 = s_lra19[g_cnt_4].lra19 
   #      
  #         LET g_cnt_2 = 1 	
   #       FOREACH p030_cur USING g_lra20[g_cnt].lra20,
   #                              g_lra21[g_cnt_1].lra21,
  #                               s_lra19[g_cnt_4].lra19
   #                         INTO g_rxx[g_cnt_2].*
                           
                            		
   #         IF STATUS THEN 
    #           CALL cl_err('FOREACH:',STATUS,1)
     #          LET g_success = 'N'
    #           EXIT FOREACH
    #        END IF 						
    #        IF NOT cl_null(g_rxx[g_cnt_2].rxx04) THEN			
    #           INSERT INTO lsa_file(lsa01,lsa02,lsa03,lsa04,lsa05,lsa06, 		 
    #                                lsa07,lsa11,                             #NO.FUN-A90040 
    #                                lsastore,lsalegal)
    #                VALUES(g_lsa.lsa01,g_lra21[g_cnt_1].lra21,s_lra19[g_cnt_4].lra19,
    #                       g_lra20[g_cnt].lra20,l_lra27,l_lra28,			
    #                       l_lra23,                                            #NO.FUN-A90040 
    #                       g_rxx[g_cnt_2].rxx04,g_plant,g_legal)		       #NO.FUN-A90040 
    #          IF STATUS THEN 
    #             CALL cl_err('insert:',STATUS,1)
    #             LET g_success = 'N'
    #             EXIT FOREACH
    #          END IF 										   
    #          LET g_cnt_2 = g_cnt_2 + 1 
    #          IF g_cnt_2 > g_max_rec THEN
    #            CALL cl_err('',9035,0)
    #            EXIT FOREACH
    #          END IF 		
    #        END IF    								
    #      END FOREACH	
          #抓溢收金額
    #      LET l_rxx05 = NULL											
    #      SELECT SUM(rxx05) INTO l_rxx05 
    #        FROM rxx_file											
    #       WHERE rxx01 IN (SELECT lrc02 FROM lra_file,lrc_file	
    #                        WHERE lra20 = g_lra20[g_cnt].lra20 	
    #                          AND lra01 = lrc01                   #####bg notice
    #                          AND lra21 = g_lra21[g_cnt_1].lra21	
    #                          AND lra19 = s_lra19[g_cnt_4].lra19	
    #                          AND lrc13 = g_lsa.lsa01) 
    #         AND rxx00 = '23'
    #         AND rxx02 != '07'                                       		
    #      IF cl_null(l_rxx05) THEN 											
    #         LET l_rxx05 = 0											
    #      END IF	                          
    #      LET g_rxx05  = l_rxx05    
    #      LET gg_lra20 = g_lra20[g_cnt].lra20        
    #      LET gg_lra21 = g_lra21[g_cnt_1].lra21      
    #      LET gg_lra19 = s_lra19[g_cnt_4].lra19      
    #      LET g_lra27  = l_lra27      
    #      LET g_lra28  = l_lra28      
    #      LET g_lra23  = l_lra23      
    #      LET g_lra24  = l_lra24      
    #      LET g_lra25  = l_lra25 
    #      LET w_lra20 = g_lra20[g_cnt].lra20
    #      LET w_lra21 = g_lra21[g_cnt_1].lra21 
    #      LET w_lra19 = s_lra19[g_cnt_4].lra19
       #   CALL p030_process_2()  #處理銷退單   #NO.FUN-A90040   -- mark 
          
    #       LET g_cnt_4 = g_cnt_4 + 1 
    #       IF g_cnt > g_max_rec THEN
    #          CALL cl_err('',9035,0)
    #          EXIT FOREACH
    #       END IF 	
    #     END FOREACH          
                 
 	#        LET g_cnt_1 = g_cnt_1 + 1
 	#        IF g_cnt_1 > g_max_rec THEN 
 	#          CALL cl_err('',9035,0)
 	#          EXIT FOREACH
 	#        END IF  
 	#     END FOREACH   
    #  LET g_cnt = g_cnt + 1 
    #  IF g_cnt > g_max_rec THEN
    #     CALL cl_err('',9035,0)
    #     EXIT FOREACH
    #  END IF 	
 # END FOREACH		
#ELSE
#   CALL p030_process_3()
#END IF 	  
#   CALL p030_process_3()    #No.FUN-960134 ADD
#NO.FUN-A90040  ---end -- mark 
END FUNCTION
#NO.FUN-A90040  ---begin -- mark     
#FUNCTION p030_process_2()
#DEFINE   g_rxx_2   DYNAMIC ARRAY OF RECORD
#            rxx04      LIKE rxx_file.rxx04,
#            rxx02      LIKE rxx_file.rxx02 
#                    END RECORD            
#DEFINE      l_lrd38    LIKE lrd_file.lrd38,		
#            l_lrd39    LIKE lrd_file.lrd39,				
#            l_lrd09    LIKE lrd_file.lrd09,		
#            l_lrd10    LIKE lrd_file.lrd10,	
#            l_lrd11    LIKE lrd_file.lrd11
#DEFINE      l_rxx05_1  LIKE rxx_file.rxx05             			           
#DEFINE      l_count    LIKE type_file.num5                                  
#DEFINE      l_n        LIKE type_file.num5 
 
#檢查當前是否有銷退記錄
#LET l_n = 0											
#SELECT COUNT(*) INTO l_n FROM lrd_file
# WHERE lrd24 = g_lsa.lsa01											
#   AND lrd06 = w_lra20											
#   AND lrd07 = w_lra21
#   AND lrd05 = w_lra19       			
 
 #抓當天銷退的給付款別的匯總金額
#LET g_sql3 = "SELECT SUM(rxx04),rxx02 FROM rxx_file ",	
#             " where rxx01 IN (SELECT lrd01 FROM lrd_file ",
#             "                  WHERE lrd06 = '",w_lra20,"' ",	   
#             "                    AND lrd07 = '",w_lra21,"'",
#             "                    and lrd05 = '",w_lra19,"'",      
#             "                    AND lrd24 = '",g_lsa.lsa01,"')",
#             "   and rxx00 = '24'",
#             "   and rxx02 != '07'",
#             " GROUP BY rxx02 "	
#PREPARE p030_prepare_1 FROM g_sql3 
#DECLARE p030_cur_1 CURSOR WITH HOLD FOR p030_prepare_1 
 
#IF l_n > 0 THEN     #存在銷退記錄
 	    #抓該商戶下的合同 樓棟 樓層 大中小類編號
#      LET l_lrd38 = NULL
#      LET l_lrd39 = NULL
#      LET l_lrd09 = NULL
#      LET l_lrd10 = NULL
#      LET l_lrd11 = NULL
 
#      SELECT DISTINCT lrd38,lrd39,lrd09,lrd10,lrd11
#        INTO l_lrd38,l_lrd39,l_lrd09,l_lrd10,l_lrd11  
#        FROM lrd_file											
#       WHERE lrd24 = g_lsa.lsa01 									
#         AND lrd06 = w_lra20       
#         AND lrd07 = w_lra21 
#         AND lrd05 = w_lra19        
#         AND ROWNUM = 1		
 	   
#      LET g_cnt_3 = 1   
#      FOREACH p030_cur_1 INTO g_rxx_2[g_cnt_3].*		
#         IF STATUS THEN 
#            CALL cl_err('FOREACH:',STATUS,1)
#            LET g_success = 'N'
#            EXIT FOREACH
#         END IF 									
#         IF NOT cl_null(g_rxx_2[g_cnt_3].rxx04) THEN	  #交款金額不為空
#            SELECT COUNT(*) INTO l_count FROM lsa_file  
#             WHERE lsa01 = g_lsa.lsa01 
#               AND lsa02 = w_lra21
#               AND lsa03 = w_lrd19      
#               AND lsa04 = w_lra20 
#               AND lsa05 = l_lrd38 
#               AND lsa06 = l_lrd39 
#               AND lsa07 = l_lrd09 
#               AND lsa08 = l_lrd10
#               AND lsa09 = l_lrd11 
#               AND lsa10 = g_rxx_2[g_cnt_3].rxx02 
#               AND lsa11 = g_rxx_2[g_cnt_3].rxx04 
#               AND lsa12 = '1'
#          IF l_count < 1 THEN 	#lsa_file中午此筆重復資料，則插一筆進去
#            INSERT INTO lsa_file(lsa01,lsa02,lsa03,lsa04,lsa05,lsa06,
#                                 lsa07,lsa08,lsa09,lsa10,lsa11,lsa12,
#                                 lsastore,lsalegal)
#                 VALUES(g_lsa.lsa01,w_lra21,w_lra19,   
#                       w_lra20,l_lrd38,l_lrd39,l_lrd09,
#                       l_lrd10,l_lrd11,g_rxx_2[g_cnt_3].rxx02,
#                       g_rxx_2[g_cnt_3].rxx04,'1',
#                       g_plant,g_legal)		
#          END IF              
#          IF STATUS THEN 
#             CALL cl_err('insert:',STATUS,1)
#             LET g_success = 'N'
#             EXIT FOREACH
#          END IF 					
#       END IF											
#       LET g_cnt_3 = g_cnt_3 + 1
#       IF g_cnt_3 > g_max_rec THEN 
#          CALL cl_err('',9035,0)
#          EXIT FOREACH
#       END IF 										
#     END FOREACH	
     #抓該商戶下的銷退溢交款金額匯總
#     LET l_rxx05_1 = NULL											
#     SELECT SUM(rxx05) INTO l_rxx05_1 											
#       FROM rxx_file											
#      WHERE rxx01 IN (SELECT lrd01 FROM lrd_file	
#                       WHERE lrd24 = g_lsa.lsa01
#                         AND lrd05 = w_lra19   
#                         AND lrd07 = w_lra21
#                         AND lrd06 = w_lra20)
#        AND rxx00 = '24'                 
#     IF cl_null(l_rxx05_1) THEN 											
#        LET l_rxx05_1 = 0											
#     END IF	
#     LET l_count = 0
#     SELECT COUNT(*) INTO l_count FROM lsa_file
#      WHERE lsa01 = g_lsa.lsa01 
#        AND lsa02 = gg_lra21
#        AND lsa03 = w_lra19 
#        AND lsa04 = gg_lra20 
#        AND lsa05 = g_lra27 
#        AND lsa06 = g_lra28  
#        AND lsa07 = g_lra23  
#        AND lsa08 = g_lra24 
#        AND lsa09 = g_lra25 
#        AND lsa12 = '2'
               
#   IF l_count < 1 THEN       #判斷lsa_file中有無重復資料
#     IF (gg_lra20 = w_lra20) AND  #判斷銷售銷退的樓棟樓層等值是否相同,即為同比資料
#        (gg_lra21 = w_lra21) AND (g_lra27 = l_lrd38) AND                            
#        (g_lra28  = l_lrd39) AND (g_lra23 = l_lrd09) AND 
#        (g_lra24  = l_lrd10) AND (g_lra25 = l_lrd11)  THEN            
#         LET g_rxx05 = g_rxx05 - l_rxx05_1      #溢收溢付金額
#         INSERT INTO lsa_file(lsa01,lsa02,lsa03,lsa04,lsa05,
#                              lsa06,lsa07,lsa08,lsa09,lsa10,lsa11,lsa12,
#                              lsastore,lsalegal)
#               VALUES(g_lsa.lsa01,gg_lra21,w_lra19,gg_lra20,g_lra27,g_lra28,  
#                      g_lra23,g_lra24,g_lra25,'10',g_rxx05,'2',
#                      g_plant,g_legal) 
#         IF STATUS THEN 
#           CALL cl_err('insert:',STATUS,1)
#           LET g_success = 'N'           
#         END IF                 
        #####回寫lrc_file lrd_file的是否已日結欄位
#        IF g_success = 'Y' THEN  
#         UPDATE lrc_file SET lrc18 = 'Y'   
#          WHERE lrc01 IN(SELECT lra01 FROM lra_file 
#                          WHERE lra21 = gg_lra21 
#                            AND lra19 = w_lra19    
#                            AND lra20 = gg_lra20) 
#            AND lrc13 = g_lsa.lsa01                  
#          UPDATE lrd_file SET lrd40 = 'Y'
#          WHERE lrd06 = w_lra20 
#            AND lrd07 = w_lra21
#            AND lrd05 = w_lra19                  
#            AND lrd24 = g_lsa.lsa01
 #        END IF    
       #########################################3
#         IF STATUS THEN 
#            CALL cl_err('UPDATE:',STATUS,1)
#            LET g_success = 'N'            
#         END IF                              
#      END IF   
# 	 END IF
#ELSE       #若當天無銷退記錄,則只需處理銷售即可
#	  LET l_rxx05_1 = 0 
#	  LET l_count = 0
#     SELECT COUNT(*) INTO l_count FROM lsa_file
#      WHERE lsa01 = g_lsa.lsa01 
#        AND lsa02 = gg_lra21 
#        AND lsa03 = w_lra19    
#        AND lsa04 = gg_lra20 
#        AND lsa05 = g_lra27 
#        AND lsa06 = g_lra28  
#        AND lsa07 = g_lra23  
#        AND lsa08 = g_lra24 
#        AND lsa09 = g_lra25 
#        AND lsa12 = '2'
#   IF l_count < 1 THEN       
#      LET g_rxx05 = g_rxx05 - l_rxx05_1      #溢收溢付金額
#      INSERT INTO lsa_file(lsa01,lsa02,lsa03,lsa04,lsa05,
#                           lsa06,lsa07,lsa08,lsa09,lsa10,lsa11,lsa12,
#                           lsastore,lsalegal)
#            VALUES(g_lsa.lsa01,gg_lra21,w_lra19,gg_lra20,g_lra27,g_lra28,              
#                   g_lra23,g_lra24,g_lra25,'10',g_rxx05,'2',
#                   g_plant,g_legal) 
#      IF STATUS THEN 
#         CALL cl_err('insert:',STATUS,1)
#         LET g_success = 'N'        
#       END IF                 
      ##回寫lrc_fiile是否已日結欄位,因為無銷退記錄,所以不需要回寫lrd_file
#   IF g_success = 'Y' THEN 
#         UPDATE lrc_file SET lrc18 = 'Y'
#          WHERE lrc01 IN(SELECT lra01 FROM lra_file 
#                          WHERE lra21 = gg_lra21 
#                            AND lra19 = w_lra19     
#                            AND lra20 = gg_lra20) 
#            AND lrc13 = g_lsa.lsa01                               
#      IF STATUS THEN 
#         CALL cl_err('UPDATE:',STATUS,1)
#         LET g_success = 'N'           
#      END IF                              
#   END IF    
#  END IF  
#END IF 	
#END FUNCTION
 
#FUNCTION p030_process_3()
#  DEFINE    s_lrd06   DYNAMIC ARRAY OF RECORD
#            lrd06      LIKE lrd_file.lrd06 
#                    END RECORD,
#          s_lrd07   DYNAMIC ARRAY OF RECORD
#            lrd07      LIKE lrd_file.lrd07 
#                    END RECORD,     
#          s_lrd05   DYNAMIC ARRAY OF RECORD
#            lrd05      LIKE lrd_file.lrd05
#                     END RECORD,                               
#          s_rxx_2   DYNAMIC ARRAY OF RECORD
#            rxx04      LIKE rxx_file.rxx04,
#            rxx02      LIKE rxx_file.rxx02 
#                    END RECORD            
#DEFINE      s_lrd38    LIKE lrd_file.lrd38,
#            s_lrd39    LIKE lrd_file.lrd39,
#            s_lrd09    LIKE lrd_file.lrd09,
#            s_lrd10    LIKE lrd_file.lrd10,
#            s_lrd11    LIKE lrd_file.lrd11
#DEFINE      s_rxx05_1  LIKE rxx_file.rxx05             			           
#DEFINE      s_count    LIKE type_file.num5                                  
#DEFINE      l_cnt      LIKE type_file.num5
 
 #抓銷退單商戶號
#LET s_sql3 = "SELECT DISTINCT lrd06 FROM lrd_file ",
#             " WHERE lrd24 = '",g_lsa.lsa01,"'"				
#PREPARE srd06_prepare FROM s_sql3
#DECLARE srd06_curs CURSOR WITH HOLD FOR srd06_prepare
	
 #抓攤位
# LET s_sql4 = "SELECT DISTINCT lrd07 from lrd_file",
#              " WHERE lrd24 = '",g_lsa.lsa01,"'",
#              "   and lrd06 = ?"
# PREPARE srd07_prepare FROM s_sql4 
# DECLARE srd07_curs CURSOR WITH HOLD FOR srd07_prepare
 
#抓合同號
#LET g_sql5 = "select distinct lrd05 from lrd_file",
#             " where lrd24 ='",g_lsa.lsa01,"'",
#             "   AND lrd06 = ?",
#             "   and lrd07 = ?"
#PREPARE lrd05_prepare FROM g_sql5
#DECLARE lrd05_curs CURSOR WITH HOLD FOR lrd05_prepare            
 
 #抓當天銷退的各付款別的匯總金額
# LET s_sql5 = "SELECT SUM(rxx04),rxx02 FROM rxx_file ",
#              " where rxx01 IN (SELECT lrd01 FROM lrd_file ",	
#              "                  WHERE lrd06 = ? ",	
#              "                    AND lrd07 = ?",
#              "                    and lrd05 = ?",          
#              "                    AND lrd24 = '",g_lsa.lsa01,"')",
#              "   and rxx00 = '24'",
#              "   and rxx02 != '07'",
#              " GROUP BY rxx02 "	
# PREPARE s030_prepare_1 FROM s_sql5 
# DECLARE s030_cur_1 CURSOR WITH HOLD FOR s030_prepare_1 
 	 									
#LET s_cnt_3 = 1 									
#FOREACH srd06_curs INTO s_lrd06[s_cnt_3].*
#   IF STATUS THEN 
#      CALL cl_err('FOREACH:',STATUS,1)
#      LET g_success = 'N'
#      EXIT FOREACH
#   END IF 
 	 
 #	 LET s_cnt_4 = 1 
# 	 FOREACH srd07_curs  USING s_lrd06[s_cnt_3].lrd06
 #	                      INTO s_lrd07[s_cnt_4].*
 	                   
 	                    
 #	    IF STATUS THEN 
# 	       CALL cl_err('FOREACH:',STATUS,1)
# 	       LET g_success = 'N'
# 	       EXIT FOREACH
# 	    END IF 
 	    
# 	    LET g_cnt_5 = 1 
# 	    FOREACH lrd05_curs USING s_lrd06[s_cnt_3].lrd06,
# 	                             s_lrd07[s_cnt_4].lrd07
# 	                        INTO s_lrd05[g_cnt_5].*
 	                      
 	                        
# 	       IF STATUS THEN 
# 	         CALL cl_err('FOREACH:',STATUS,1)
# 	         LET g_success = 'N'
# 	         EXIT FOREACH
# 	       END IF 
 
            #No.FUN-960134 ADD -------------------------
            #檢查重複的
 #              SELECT COUNT(*) INTO l_cnt FROM lsa_file
 #               WHERE lsa01 = g_lsa.lsa01
 #                 AND lsa02 = s_lrd07[g_cnt_5].lrd07
 #                 AND lsa03 = s_lrd05[s_cnt_4].lrd05
 #                 AND lsa04 = s_lrd06[s_cnt_3].lrd06
 #              IF l_cnt > 0 THEN
 #                 CONTINUE FOREACH
 #              END IF
            #No.FUN-960134 ADD -------------------------
 
 	  #抓該商戶下的樓棟樓層大中小類編號
  #       LET s_lrd38 = NULL
  #       LET s_lrd39 = NULL
  #      LET s_lrd09 = NULL
  #       LET s_lrd10 = NULL
   #      LET s_lrd11 = NULL
   #      SELECT DISTINCT lrd38,lrd39,lrd09,lrd10,lrd11
   #        INTO s_lrd38,s_lrd39,s_lrd09,s_lrd10,s_lrd11 
   #        FROM lrd_file											
   #       WHERE lrd24 = g_lsa.lsa01 											
   #         AND lrd05 = s_lrd05[g_cnt_5].lrd05
   #         AND lrd06 = s_lrd06[s_cnt_3].lrd06	
   #         AND lrd07 = s_lrd07[s_cnt_4].lrd07 
   #         AND ROWNUM = 1		
         
   #      LET s_cnt_5 = 1   
   #   FOREACH s030_cur_1  USING s_lrd06[s_cnt_3].lrd06,
   #                             s_lrd07[s_cnt_4].lrd07,
   #                             s_lrd05[g_cnt_5].lrd05  
   #                        INTO s_rxx_2[s_cnt_5].*		
                           
                             
   #      IF STATUS THEN 
   #         CALL cl_err('FOREACH:',STATUS,1)
   #         LET g_success = 'N'
   #         EXIT FOREACH
   #      END IF 
   #      IF NOT cl_null(s_rxx_2[s_cnt_5].rxx04) THEN	         				
   #         INSERT INTO lsa_file(lsa01,lsa02,lsa03,lsa04,lsa05,lsa06,
   #                              lsa07,lsa08,lsa09,lsa10,lsa11,lsa12,
   #                              lsastore,lsalegal)
   #              VALUES(g_lsa.lsa01,s_lrd07[s_cnt_4].lrd07,s_lrd05[g_cnt_5].lrd05,
   #                     s_lrd06[s_cnt_3].lrd06,s_lrd38,s_lrd39,s_lrd09,
   #                     s_lrd10,s_lrd11,s_rxx_2[s_cnt_5].rxx02,
   #                     s_rxx_2[s_cnt_5].rxx04,'1',g_plant,g_legal)							
   #         IF STATUS THEN 
   #            CALL cl_err('insert:',STATUS,1)
   #            LET g_success = 'N'
   #            EXIT FOREACH
   #         END IF 					
   #      END IF		
   #      LET s_cnt_5 = s_cnt_5 + 1
   #      IF s_cnt_5 > g_max_rec THEN 
   #         CALL cl_err('',9035,0)
   #         EXIT FOREACH
   #      END IF 										
   #   END FOREACH	
      #抓該商戶下的銷退溢交款金額匯總
   #   LET s_rxx05_1 = NULL											
   #   SELECT SUM(rxx05) INTO s_rxx05_1 											
   #     FROM rxx_file											
   #    WHERE rxx01 IN (SELECT lrd01 FROM lrd_file		
   #                      WHERE lrd24 = g_lsa.lsa01	
   #                        AND lrd05 = s_lrd05[g_cnt_5].lrd05
   #                        AND lrd07 = s_lrd07[s_cnt_4].lrd07
   #                        AND lrd06 = s_lrd06[s_cnt_3].lrd06)	
   #       AND rxx00 = '24'                 
   #   IF cl_null(s_rxx05_1) THEN 											
   #      LET s_rxx05_1 = 0											
   #   END IF	
   #   LET g_rxx05 = 0 - s_rxx05_1   
   #   INSERT INTO lsa_file(lsa01,lsa02,lsa03,lsa04,lsa05,
   #                        lsa06,lsa07,lsa08,lsa09,lsa10,lsa11,lsa12,
   #                        lsastore,lsalegal)
   #        VALUES(g_lsa.lsa01,s_lrd07[s_cnt_4].lrd07,s_lrd05[g_cnt_5].lrd05,
   #               s_lrd06[s_cnt_3].lrd06,s_lrd38,s_lrd39,s_lrd09,s_lrd10,
   #               s_lrd11,'10',g_rxx05,'2',g_plant,g_legal) 
   #   IF STATUS THEN 
   #      CALL cl_err('insert:',STATUS,1)
   #      LET g_success = 'N'
   #      EXIT FOREACH
  #   END IF     
          
  #   UPDATE lrd_file SET lrd40 = 'Y'
  #    WHERE lrd06 = s_lrd06[s_cnt_3].lrd06 
  #      AND lrd05 = s_lrd05[g_cnt_5].lrd05
  #      AND lrd07 = s_lrd07[s_cnt_4].lrd07 
 #       AND lrd24 = g_lsa.lsa01           
  #   IF STATUS THEN 
  #      CALL cl_err('insert:',STATUS,1)
   #     LET g_success = 'N'
   #     EXIT FOREACH
  #   END IF    
    
    
 	#       LET g_cnt_5 = g_cnt_5 + 1
 	#       IF g_cnt_5 > g_max_rec THEN 
    #        CALL cl_err('',9035,0)
    #        EXIT FOREACH
    #     END IF 	
 	#    END FOREACH 
 	   
 	#  LET s_cnt_4 = s_cnt_4 + 1 
 	#  IF  s_cnt_4 > g_max_rec THEN 
 	#     CALL cl_err('',9035,0)
 	#     EXIT FOREACH
 	#  END IF 			      
 	#  END FOREACH 
  # LET s_cnt_3 = s_cnt_3 + 1
  # IF  s_cnt_3 > g_max_rec THEN 
  #     CALL cl_err(
