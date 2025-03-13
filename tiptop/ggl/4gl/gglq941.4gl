# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglq941
# Descriptions...: 現金流量
# Date & Author..: NO.FUN-B40056 2011/04/21 By lixia
# Modify.........: No.TQC-B90234 11/10/10 By wujie  增加第二栏金额  
# Modify.........: No.TQC-C30056 12/03/05 By zhangweib 1.nmz70='1'票據來源時，產生現金流量表修改為抓tic_file，而非先抓nme,再抓tic_file
#                                                      2.去掉程序中 nme14 IS NULL 的條件
# Modify.........: No.TQC-C60049 12/06/05 By lijh nml02“說明”欄位太短，查詢出來的不能顯示完整，例如“處置固定資產、無形資產和其他長期資產而收到的現金淨值”.
 
# Modify.........: No.FUN-C80102 12/12/11 By zhangweib CR報表改善追单
# Modify.........: No.MOD-DC0030 13/12/05 By fengmy 现金流量项目要有效
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD
           title     LIKE zaa_file.zaa08,    #輸入報表名稱 #FUN-B40056
#No.TQC-B90234 --begin  
           title1    LIKE zaa_file.zaa08,    #輸入報表名稱 #FUN-B40056
           title2    LIKE zaa_file.zaa08,    #輸入報表名稱 #FUN-B40056
           y1        LIKE type_file.num5,    #第一栏年度
           bm1       LIKE type_file.num5,    #Begin 期別
           em1       LIKE type_file.num5,    #End 期別
           y2        LIKE type_file.num5,    #第二栏年度
           bm2       LIKE type_file.num5,    #Begin 期別
           em2       LIKE type_file.num5,    #End   期別
#          y1        LIKE type_file.num5,    #輸入起始年度
#          m1        LIKE type_file.num5,    #Begin 期別
#          y2        LIKE type_file.num5,    #輸入截止年度
#          m2        LIKE type_file.num5,    #End   期別
#No.TQC-B90234 --end  
           b         LIKE aaa_file.aaa01,    #帳別
           c         LIKE type_file.chr1,    #異動額及餘額為0者是否列印
           d         LIKE type_file.chr1,    #金額單位
           o         LIKE type_file.chr1,    #轉換幣別否
           r         LIKE azi_file.azi01,    #總帳幣別
           p         LIKE azi_file.azi01,    #轉換幣別
           q         LIKE azj_file.azj03,    #匯率
           MORE      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD,
           bdate,edate  LIKE type_file.dat,    
           l_za05       LIKE type_file.chr1000, 
           g_bookno     LIKE aah_file.aah00,    #帳別
           g_unit       LIKE type_file.num10    
DEFINE  g_i         LIKE type_file.num5    
DEFINE  g_aaa03     LIKE  aaa_file.aaa03
DEFINE  p_cmd       LIKE type_file.chr1    
DEFINE  g_msg       LIKE type_file.chr1000 
DEFINE  l_table     STRING  
DEFINE  g_str       STRING  
DEFINE  g_sql       STRING  
DEFINE  g_yy2       LIKE type_file.num5
DEFINE  g_rec_b     LIKE type_file.num10
DEFINE  g_before_input_done  LIKE type_file.num5 
DEFINE  g_nmz70     LIKE nmz_file.nmz70  

DEFINE  g_nml      DYNAMIC ARRAY OF RECORD
                   #nml02  LIKE type_file.chr50,        #TQC-C60049    mark
                   nml02  LIKE nml_file.nml02,          #TQC-C60049    add
                   nml05  LIKE nml_file.nml05,
                   tic07  LIKE aah_file.aah04,
                   tic07b LIKE aah_file.aah04,
                   tic071 LIKE aah_file.aah04    #No.TQC-B90234  
                   END RECORD
DEFINE  g_pr_ar    DYNAMIC ARRAY OF RECORD
                   type   LIKE type_file.chr1,
                   nml01  LIKE nml_file.nml01,
                   #nml02  LIKE type_file.chr50,        #TQC-C60049    mark
                   nml02  LIKE nml_file.nml02,          #TQC-C60049    add
                   nml03  LIKE nml_file.nml03,
                   nml05  LIKE nml_file.nml05,
                   tic07  LIKE tic_file.tic07,
                   tic07b LIKE tic_file.tic07,
                   tic071 LIKE tic_file.tic07    #No.TQC-B90234    
                   END RECORD
DEFINE  g_pr       RECORD
                   type   LIKE type_file.chr1,
                   nml01  LIKE nml_file.nml01,
                   #nml02  LIKE type_file.chr50,        #TQC-C60049    mark
                   nml02  LIKE nml_file.nml02,          #TQC-C60049    add
                   nml03  LIKE nml_file.nml03,
                   nml05  LIKE nml_file.nml05,
                   tic07  LIKE tic_file.tic07,
                   tic07b LIKE tic_file.tic07,
                   tic071 LIKE tic_file.tic07    #No.TQC-B90234  
                   END RECORD
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_trace = 'N'                # default trace off
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.title = ARG_VAL(8)
   LET tm.y1 = ARG_VAL(9)
   LET tm.y2 = ARG_VAL(10)
#No.TQC-B90234 --begin 
   LET tm.bm1 = ARG_VAL(11)
   LET tm.em1 = ARG_VAL(12)
   LET tm.bm2 = ARG_VAL(13)
   LET tm.em2 = ARG_VAL(14) 
   LET tm.b = ARG_VAL(15)
   LET tm.c = ARG_VAL(16)
   LET tm.d = ARG_VAL(17)
   LET tm.o = ARG_VAL(18)
   LET tm.r = ARG_VAL(19)
   LET tm.p = ARG_VAL(20)
   LET tm.q = ARG_VAL(21)
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  
#No.TQC-B90234 --end  
   IF cl_null(tm.b) THEN LET tm.b=g_aza.aza81 END IF
   LET g_rlang  = g_lang
   SELECT nmz70 INTO g_nmz70 FROM nmz_file
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW q941_w AT 5,10
        WITH FORM "ggl/42f/gglq941" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           
   CALL cl_set_comp_visible('tic07b',FALSE)   #No.TQC-B90234  
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL q941_tm()                         
   ELSE
      CALL q941()                             
   END IF
 
   CALL q941_menu()                                                            
   CLOSE WINDOW q941_w  
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time        
 
END MAIN
 
FUNCTION q941_menu()
   WHILE TRUE
      CALL q941_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q941_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q941_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nml),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q941_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5     #SMALLINT 
   DEFINE p_row,p_col    LIKE type_file.num5,    #SMALLINT
          l_sw           LIKE type_file.chr1,    #VARCHAR(01)   
          l_cmd          LIKE type_file.chr1000  #VARCHAR(400)          
 
   CALL s_dsmark(tm.b)  
   LET p_row = 4 LET p_col = 4
  #No.FUN-C80102 ---start--- Mark
  #OPEN WINDOW q941_w1 AT p_row,p_col
  #WITH FORM "ggl/42f/gglq941_q"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
  #  
  #CALL cl_ui_locale("gglq941_q")  
  #No.FUN-C80102 ---start--- Mark
   CALL s_shwact(0,0,tm.b) 
   CALL cl_opmsg('p')
   
   CALL cl_set_comp_visible("b",g_nmz70 <> '1')
      
   #使用預設帳別之幣別
   #TQC-C30056--mod--str--
   IF g_nmz70 = '1' THEN
      LET g_aaa03 = g_aza.aza17
   ELSE
   #TQC-C30056--mod--end
      SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b 
   END IF  #TQC-C30056
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","sel aaa:",0)
   END IF
   INITIALIZE tm.* TO NULL      
 
   LET tm.title = g_x[1]
 # LET tm.b = g_bookno       #FUN-C80102 mark
   LET tm.b = g_aza.aza81    #FUN-C80102 add
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = tm.r
   LET tm.q = 1
   LET tm.more = 'N'
   LET g_pdate  = g_today
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
  #TQC-C30056--add--str--
   IF g_nmz70 = '1' THEN
      LET tm.b = ' '
   END IF  
  #TQC-C30056--add--end

   WHILE TRUE
 
      INPUT BY NAME tm.title,tm.title1,tm.title2,tm.y1,tm.bm1,tm.em1,tm.y2,tm.bm2,tm.em2,tm.b,tm.d,tm.c,tm.o,   #No.TQC-B90234 
     #              tm.r,tm.p,tm.q,tm.more WITHOUT DEFAULTS   #FUN-C80102 mark
                    tm.r,tm.p,tm.q WITHOUT DEFAULTS     #FUN-C80102 add
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()              
 
         BEFORE INPUT
            CALL q941_set_entry(p_cmd)
            CALL q941_set_no_entry(p_cmd)         
            CALL cl_qbe_init() 
 
         AFTER FIELD y1
            IF NOT cl_null(tm.y1) THEN
               IF tm.y1 = 0 THEN
                  NEXT FIELD y1
               END IF
               LET tm.y2=tm.y1
               LET g_yy2= tm.y1 - 1 
            END IF
 
#No.TQC-B90234 --begin
#         AFTER FIELD m1
#            IF NOT cl_null(tm.m1) THEN
#               SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                       g                WHERE azm01 = tm.y1
#               IF g_azm.azm02 = 1 THEN
#                  IF tm.m1 > 12 OR tm.m1 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m1
#                  END IF
#               ELSE
#                  IF tm.m1 > 13 OR tm.m1 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m1
#                  END IF
#               END IF
#            END IF
#            
#         AFTER FIELD m2
#            IF NOT cl_null(tm.m2) THEN
#               SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                 WHERE azm01 = tm.y1
#               IF g_azm.azm02 = 1 THEN
#                  IF tm.m2 > 12 OR tm.m2 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m2
#                  END IF
#               ELSE
#                  IF tm.m2 > 13 OR tm.m2 < 1 THEN
#                     CALL cl_err('','agl-020',0)
#                     NEXT FIELD m2
#                  END IF
#               END IF
#            END IF 
#            IF tm.y1*13+tm.m1 > tm.y2*13+tm.m2 THEN
#               CALL cl_err('','9011',0)
#               NEXT FIELD m1
#            END IF
 
      AFTER FIELD bm1
         IF NOT cl_null(tm.bm1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1   #No.TQC-B90234  
            IF g_azm.azm02 = 1 THEN
               IF tm.bm1 > 12 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            ELSE
               IF tm.bm1 > 13 OR tm.bm1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm1
               END IF
            END IF
         END IF
         IF tm.bm1 IS NULL THEN NEXT FIELD bm1 END IF
 
      AFTER FIELD em1
         IF NOT cl_null(tm.em1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y1   #No.TQC-B90234            
            IF g_azm.azm02 = 1 THEN
               IF tm.em1 > 12 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            ELSE
               IF tm.em1 > 13 OR tm.em1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em1
               END IF
            END IF
         END IF
         IF tm.em1 IS NULL THEN NEXT FIELD em1 END IF
         IF tm.bm1 > tm.em1 THEN CALL cl_err('','9011',0) NEXT FIELD bm1 END IF
         IF tm.y2 IS NULL THEN  #No.TQC-B90234 
            LET tm.y2 = tm.y1   #No.TQC-B90234 
            LET tm.bm2 = tm.bm1
            LET tm.em2 = 12
            DISPLAY BY NAME tm.y2,tm.bm2,tm.em2  #No.TQC-B90234  
         END IF
#No.TQC-B90234 --end   
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN
	           CALL s_check_bookno(tm.b,g_user,g_plant) RETURNING li_chk_bookno                    
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b
               END IF
               SELECT aaa01 FROM  aaa_file WHERE aaa01 = tm.b AND aaaacti IN ('Y','y')
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","aaa_file",tm.b,"","agl-095","","",0)
                  NEXT FIELD b
               END IF
	        END IF
 
         BEFORE FIELD o
            CALL q941_set_entry(p_cmd)
 
         AFTER FIELD o
            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
               DISPLAY BY NAME tm.q,tm.r
            END IF
            CALL q941_set_no_entry(p_cmd)
 
         AFTER FIELD p
            SELECT azi01 FROM azi_file WHERE azi01 = tm.p
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","azi_file",tm.p,"","mfg3008","","",0) 
               NEXT FIELD p
            END IF
 
         AFTER FIELD q
            IF tm.q <= 0 THEN
               NEXT FIELD q
            END IF
 
        #No.FUN-C80102 ---start--- Mark
        #AFTER FIELD more
        #   IF tm.more = 'Y' THEN
        #      CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
        #                     g_bgjob,g_time,g_prtway,g_copies)
        #           RETURNING g_pdate,g_towhom,g_rlang,
        #                     g_bgjob,g_time,g_prtway,g_copies
        #   END IF
        #No.FUN-C80102 ---start--- Mark
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
            IF tm.d = '1' THEN
               LET g_unit = 1
            END IF
 
            IF tm.d = '2' THEN
               LET g_unit = 1000
            END IF
 
            IF tm.d = '3' THEN
               LET g_unit = 1000000
            END IF
 
            IF tm.o = 'N' THEN
               LET tm.p = tm.r
               LET tm.q = 1
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about       
             CALL cl_about()     
 
          ON ACTION help         
             CALL cl_show_help() 
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(b)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
                  DISPLAY tm.b TO b
                  NEXT FIELD b
               WHEN INFIELD(p)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = tm.p
                  CALL cl_create_qry() RETURNING tm.p
                  DISPLAY tm.p TO p
                  NEXT FIELD p
            END CASE
            
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save() 
      END INPUT
      
    #No.FUN-C80102 ---start--- Mark
    #IF g_bgjob = 'Y' THEN
    #   SELECT zz08 INTO l_cmd FROM zz_file    
    #    WHERE zz01='gglq941'
    #   IF SQLCA.sqlcode OR l_cmd IS NULL THEN
    #      CALL cl_err('gglq941','9031',1)
    #   ELSE
    #      LET l_cmd = l_cmd CLIPPED,       
    #                   " '",g_bookno CLIPPED,"'" ,
    #                   " '",g_pdate CLIPPED,"'",
    #                   " '",g_towhom CLIPPED,"'",
    #                    " '",g_rlang CLIPPED,"'", 
    #                   " '",g_bgjob CLIPPED,"'",
    #                   " '",g_prtway CLIPPED,"'",
    #                   " '",g_copies CLIPPED,"'",
    #                   " '",tm.title CLIPPED,"'" ,
    #                   " '",tm.y1 CLIPPED,"'" ,
    #                   " '",tm.y2 CLIPPED,"'" ,
    ##No.TQC-B90234 --begin
    #                   " '",tm.bm1 CLIPPED,"'" ,
    #                   " '",tm.em1 CLIPPED,"'" ,
    #                   " '",tm.bm2 CLIPPED,"'" ,
    #                   " '",tm.em2 CLIPPED,"'" ,
    ##No.TQC-B90234 --end 
    #                   " '",tm.b CLIPPED,"'" ,
    #                   " '",tm.c CLIPPED,"'" ,
    #                   " '",tm.d CLIPPED,"'" ,
    #                   " '",tm.o CLIPPED,"'" ,
    #                   " '",tm.r CLIPPED,"'" ,
    #                   " '",tm.p CLIPPED,"'" ,
    #                   " '",tm.q CLIPPED,"'" ,
    #                   " '",g_rep_user CLIPPED,"'",
    #                   " '",g_rep_clas CLIPPED,"'",
    #                   " '",g_template CLIPPED,"'"
    #       CALL cl_cmdat('gglq941',g_time,l_cmd)    # Execute cmd at later tim
    #   END IF
    #   CLOSE WINDOW q941_w1
    #   
    #   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
    #   EXIT PROGRAM
    #END IF 
    #No.FUN-C80102 ---start--- Mark
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
        #No.FUN-C80102 ---start--- Mod
        #CLOSE WINDOW q941_w1                            #No.FUN-C80102   Mark
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-C80102   Mark
        #EXIT PROGRAM                                    #No.FUN-C80102   Mark
         RETURN                                          #No.FUN-C80102   Add
        #No.FUN-C80102 ---end  --- Mod
      END IF
 
      CALL cl_wait()
      CALL q941()
 
      ERROR ""
      EXIT WHILE  
   END WHILE
 
   CLOSE WINDOW q941_w1
 
END FUNCTION
 
FUNCTION q941()
DEFINE l_name    LIKE type_file.chr20   
DEFINE l_chr     LIKE type_file.chr1    
DEFINE l_sql     STRING 
DEFINE sr        RECORD
                 type   LIKE type_file.chr1,
                 nml01  LIKE nml_file.nml01,
                 #nml02  LIKE type_file.chr50,        #TQC-C60049    mark
                 nml02  LIKE nml_file.nml02,          #TQC-C60049    add
                 nml03  LIKE nml_file.nml03,
                 nml05  LIKE nml_file.nml05,
                 tic07  LIKE tic_file.tic07,
                 tic07b LIKE tic_file.tic07,
                 tic071 LIKE tic_file.tic07    #No.TQC-B90234   
                 END RECORD
DEFINE l_i       LIKE type_file.num10
DEFINE l_tmp     LIKE type_file.num5 
DEFINE l_tib08   LIKE tib_file.tib08                                            
DEFINE l_nml03   LIKE nml_file.nml03 
DEFINE l_tic07   LIKE tic_file.tic07
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_prog = 'gglq941'
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglq941'
   SELECT zo02 INTO g_company FROM zo_file
    WHERE zo01 = g_rlang
 
   SELECT azi04 INTO t_azi04,t_azi05
     FROM azi_file WHERE azi01 = tm.p  
 
   IF tm.d != '1' THEN
      LET t_azi04 = 0    
      LET t_azi05 = 0
   END IF
   DROP TABLE x
   DROP TABLE y   								
   SELECT nml01,nml02,nml03,nml05,tib08 FROM nml_file,tib_file WHERE 1=0 INTO TEMP x
   #来源是票据时先抓nme_file，再抓tic_file									
  #No.TQC-C30056   ---start--- Mark
  #IF g_nmz70='1' THEN									
  #   SELECT nme_file.*,nmc03 FROM nme_file,nmc_file 									
  #    WHERE YEAR(nme16)*13+MONTH(nme16) >= tm.y1*13+tm.bm1		#No.TQC-B90234 							
  #      AND YEAR(nme16)*13+MONTH(nme16) <= tm.y1*13+tm.em1   #No.TQC-B90234    
  #      AND nme03 = nmc01         
  #     INTO TEMP y	

  #   UPDATE y SET nme08 = nme08*(-1)
  #    WHERE nmc03 = '2' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
  #   UPDATE y SET nme08 = nme08*(-1)
  #    WHERE nmc03 = '1' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')      
  #    
  #   LET l_sql = "INSERT INTO x SELECT nml01,nml02,nml03,nml05,SUM(nme08) ",									
  #               "  FROM nml_file LEFT OUTER JOIN y ON nml01 = y.nme14 ",									
  #               " GROUP BY nml01,nml02,nml03,nml05 "	
  #ELSE
  #   IF g_nmz70='2' OR g_nmz70='3' THEN									
  #No.TQC-C30056   ---start--- Mark
         SELECT * FROM tic_file 									
          WHERE tic_file.tic00 = tm.b									
            AND tic_file.tic01*13+tic_file.tic02 >= tm.y1*13+tm.bm1		#No.TQC-B90234 										
            AND tic_file.tic01*13+tic_file.tic02 <= tm.y1*13+tm.em1		#No.TQC-B90234 	    									
           INTO TEMP y	        
         #UPDATE y SET tic07 =tic07*(-1) WHERE tic03='2'
         IF g_nmz70 <> '1' THEN
            UPDATE y SET tic07 = tic07*(-1)
             WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0' AND nmlacti = 'Y')  #MOD-DC0030 add nmlacti
            UPDATE y SET tic07 = tic07*(-1)
             WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1' AND nmlacti = 'Y')  #MOD-DC0030 add nmlacti
         ELSE
            UPDATE y SET tic07 = tic07*(-1)
             WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0' AND nmlacti = 'Y')  #MOD-DC0030 add nmlacti
            UPDATE y SET tic07 = tic07*(-1)
             WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1' AND nmlacti = 'Y')  #MOD-DC0030 add nmlacti
         END IF
          
         LET l_sql = "INSERT INTO x SELECT nml01,nml02,nml03,nml05,SUM(tic07) ",									
                     "  FROM nml_file LEFT OUTER JOIN y ON nml01 = y.tic06 ",	
                     " WHERE nmlacti = 'Y' ",               #MOD-DC0030 add nmlacti								
                     " GROUP BY nml01,nml02,nml03,nml05 "		
  #   END IF	     #No.TQC-C30056   Mark
  #END IF	     #No.TQC-C30056   Mark

   PREPARE anmq941_gentemp FROM l_sql
   EXECUTE anmq941_gentemp
    
   DECLARE anmq941_curs CURSOR FOR SELECT * FROM x
   IF STATUS THEN
      CALL cl_err('declare',STATUS,0)
      RETURN
   END IF
 
   CALL cl_outnam('gglq941') RETURNING l_name
   START REPORT q941_rep TO l_name
   LET g_pageno = 0
 
   LET g_rec_b = 1
   CALL g_nml.clear() 
   LET g_rec_b = 1
   
   FOREACH anmq941_curs INTO sr.nml01,sr.nml02,sr.nml03,sr.nml05,sr.tic07
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF sr.tic07 IS NULL THEN LET sr.tic07 = 0 END IF
      #LET l_tib08 = 0
      SELECT nml03 INTO l_nml03 FROM nml_file WHERE nml01 =sr.nml01 AND nmlacti = 'Y'   #MOD-DC0030 add nmlacti
#      IF g_nmz70='2' OR g_nmz70='3' THEN									
#         IF l_nml03 MATCHES '*0' THEN 									
#            LET sr.tic07 =sr.tic07*(-1)									
#         END IF									
#      ELSE	
     #No.TQC-C30056   ---start---   Mark
     # IF g_nmz70='1' THEN
     #   DROP TABLE z									
#    #    SELECT * FROM tic_file									
#    #     WHERE tic_file.tic01*13+tic_file.tic02 >= tm.y1*13+tm.m1									
#    #       AND tic_file.tic01*13+tic_file.tic02 <= tm.y2*13+tm.m2									
#    #       AND tic06 = sr.nml01									
#    #       AND tic00 = ' '
     #   DROP TABLE w
     #   SELECT tic_file.* FROM tic_file,nme_file									
     #    WHERE tic_file.tic01*13+tic_file.tic02 >= tm.y1*13+tm.bm1  		#No.TQC-B90234 										
     #      AND tic_file.tic01*13+tic_file.tic02 <= tm.y1*13+tm.em1 		#No.TQC-B90234 	 
     #      AND tic04 = nme12
     #      AND tic05 = nme21
     #      AND tic00 = ' '
     #     #AND nme14 IS NULL      #No.TQC-C30056   Mark
     #     INTO TEMP w 
     #   SELECT * FROM w WHERE tic06 = sr.nml01
     #     INTO TEMP z 	

     #   UPDATE z SET tic07 = tic07*(-1)
     #    WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
     #   UPDATE z SET tic07 = tic07*(-1) 
     #    WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')  
   
     #   SELECT SUM(tic07) INTO l_tic07 FROM z									
#    #    IF l_nml03 MATCHES '*1' THEN 									
#    #       LET sr.tic07 =sr.tic07*(-1)									
#    #       LET l_tic07 =l_tic07*(-1)									
#    #    END IF									
     #   IF cl_null(l_tic07) THEN
     #      LET l_tic07 = 0
     #   END IF
     #   LET sr.tic07 = sr.tic07 + l_tic07									
     #END IF	
     #No.TQC-C30056   ---end---     Mark
      
      LET g_yy2= tm.y1 - 1									
      #取上年同期金额									
#     IF g_nmz70='2' OR g_nmz70='3' THEN      ##No.TQC-C30056   Mark
         DROP TABLE y									
         SELECT * FROM tic_file									
          WHERE tic06 = sr.nml01									
            AND tic00 = tm.b									
            AND tic01*13+tic02 >= g_yy2*13+tm.bm1  #No.TQC-B90234 									
            AND tic01*13+tic02 <= g_yy2*13+tm.em1  #No.TQC-B90234 									
           INTO TEMP y									
#         UPDATE y SET tic07 =tic07*(-1) WHERE tic03='2'									
#         SELECT SUM(tic07) INTO sr.tic07b FROM y									
#         IF l_nml03 MATCHES '*0' THEN 									
#            LET sr.tic07b =sr.tic07b*(-1)									
#         END IF
         IF l_nml03 MATCHES '*0' THEN 
            UPDATE y SET tic07 = tic07*(-1) where tic03 = '1' and tic06 = sr.nml01
         END IF									
         IF l_nml03 MATCHES '*1' THEN 
            UPDATE y SET tic07 = tic07*(-1) where tic03 = '2' and tic06 = sr.nml01	
         END IF									
         SELECT SUM(tic07) INTO sr.tic07b FROM y 
     #No.TQC-C30056   ---start--- Mark
     #ELSE									
#    #    SELECT * FROM nme_file 	
     #   SELECT nme_file.*,nmc03 FROM nme_file,nmc_file								
     #    WHERE YEAR(nme16)*13+MONTH(nme16) >= g_yy2*13+tm.bm1   #No.TQC-B90234									
     #      AND YEAR(nme16)*13+MONTH(nme16) <=g_yy2*13+tm.em1	   #No.TQC-B90234								
     #      AND nme14 = sr.nml01	
     #      AND nme03 = nmc01        
     #     INTO TEMP y	

     #   UPDATE y SET nme08 = nme08*(-1)
     #    WHERE nmc03='2' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
     #   UPDATE y SET nme08 = nme08*(-1)
     #    WHERE nmc03='1' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1') 
     #     
     #   SELECT SUM(nme08) INTO sr.tic07b FROM y									

     #   DROP TABLE z
     #   DROP TABLE w
     #   SELECT * FROM tic_file,nme_file									
     #    WHERE tic_file.tic01*13+tic_file.tic02 >= g_yy2*13+tm.bm1   #No.TQC-B90234
     #      AND tic_file.tic01*13+tic_file.tic02 <= g_yy2*13+tm.em1   #No.TQC-B90234
     #      AND tic04 = nme12
     #      AND tic05 = nme21
     #      AND tic00 = ' '
     #     #AND nme14 IS NULL         #No.TQC-C30056   Mark
     #     INTO TEMP w 

#    #    SELECT * FROM tic_file									
#    #     WHERE tic_file.tic01*13+tic_file.tic02 >= g_yy2*13+tm.m1									
#    #       AND tic_file.tic01*13+tic_file.tic02 <= g_yy2*13+tm.m2									
#    #       AND tic06 = sr.nml01									
#    #       AND tic00 = ' '
     #   SELECT * FROM w WHERE tic06 = sr.nml01
     #     INTO TEMP z 

     #   UPDATE z SET tic07 = tic07*(-1)
     #    WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
     #   UPDATE z SET tic07 = tic07*(-1) 
     #    WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')    
  
     #   SELECT SUM(tic07) INTO l_tic07 FROM z									
#    #    IF l_nml03 MATCHES '*1' THEN 									
#    #       LET sr.tic07b =sr.tic07b*(-1)									
#    #       LET l_tic07 =l_tic07*(-1)									
#    #    END IF									
     #   IF cl_null(l_tic07) THEN  
     #      LET l_tic07 = 0
     #   END IF
     #   LET sr.tic07b = sr.tic07b + l_tic07									
     #END IF									
     #No.TQC-C30056   ---end---   Mark
#No.TQC-B90234 --begin
      #取第二栏金额									
     #IF g_nmz70='2' OR g_nmz70='3' THEN   #No.TQC-C30056    Mark
         DROP TABLE y									
         SELECT * FROM tic_file									
          WHERE tic06 = sr.nml01									
            AND tic00 = tm.b									
            AND tic01*13+tic02 >= tm.y2*13+tm.bm2									
            AND tic01*13+tic02 <= tm.y2*13+tm.em2 									
           INTO TEMP y									
       
         IF g_nmz70 <> '1' THEN  #No.TQC-C30056
            IF l_nml03 MATCHES '*0' THEN 
               UPDATE y SET tic07 = tic07*(-1) where tic03 = '1' and tic06 = sr.nml01
            END IF									
            IF l_nml03 MATCHES '*1' THEN 
               UPDATE y SET tic07 = tic07*(-1) where tic03 = '2' and tic06 = sr.nml01	
            END IF									
         ELSE
            IF l_nml03 MATCHES '*0' THEN 
               UPDATE y SET tic07 = tic07*(-1) where tic03 = '2' and tic06 = sr.nml01
            END IF									
            IF l_nml03 MATCHES '*1' THEN 
               UPDATE y SET tic07 = tic07*(-1) where tic03 = '1' and tic06 = sr.nml01	
            END IF									
         END IF
         SELECT SUM(tic07) INTO sr.tic071 FROM y 
     #No.TQC-C30056   ---start--- Mark
     #ELSE									
     #   SELECT nme_file.*,nmc03 FROM nme_file,nmc_file								
     #    WHERE YEAR(nme16)*13+MONTH(nme16) >= tm.y2*13+tm.bm2									
     #      AND YEAR(nme16)*13+MONTH(nme16) <= tm.y2*13+tm.em2									
     #      AND nme14 = sr.nml01	
     #      AND nme03 = nmc01        
     #     INTO TEMP y	

     #   UPDATE y SET nme08 = nme08*(-1)
     #    WHERE nmc03='2' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
     #   UPDATE y SET nme08 = nme08*(-1)
     #    WHERE nmc03='1' AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1') 
     #     
     #   SELECT SUM(nme08) INTO sr.tic071 FROM y									

     #   DROP TABLE z
     #   DROP TABLE w
     #   SELECT * FROM tic_file,nme_file									
     #    WHERE tic_file.tic01*13+tic_file.tic02 >= tm.y2*13+tm.bm2
     #      AND tic_file.tic01*13+tic_file.tic02 <= tm.y2*13+tm.em2
     #      AND tic04 = nme12
     #      AND tic05 = nme21
     #      AND tic00 = ' '
     #     #AND nme14 IS NULL         #No.TQC-C30056   Mark
     #     INTO TEMP w 

     #   SELECT * FROM w WHERE tic06 = sr.nml01
     #     INTO TEMP z 

     #   UPDATE z SET tic07 = tic07*(-1)
     #    WHERE tic03='2' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*0')
     #   UPDATE z SET tic07 = tic07*(-1) 
     #    WHERE tic03='1' AND tic06 IN (SELECT nml01 FROM nml_file WHERE nml03 MATCHES '*1')    
  
     #   SELECT SUM(tic07) INTO l_tic07 FROM z									
     #  						
     #   IF cl_null(l_tic07) THEN  
     #      LET l_tic07 = 0
     #   END IF
     #   LET sr.tic071 = sr.tic071 + l_tic07									
     #END IF
     #No.TQC-C30056   ---end---   Mark
      IF cl_null(sr.tic071) THEN  
         LET sr.tic071 = 0
      END IF
#No.TQC-B90234 --end									
      LET sr.type = sr.nml03[1,1]									
      IF tm.c = 'N' AND sr.tic07 = 0 AND sr.tic07b = 0 AND sr.tic071 = 0 THEN	  #No.TQC-B90234 								
         CONTINUE FOREACH									
      END IF									
      OUTPUT TO REPORT q941_rep(sr.*)
   END FOREACH
 
   FINISH REPORT q941_rep
   FOR l_i = 1 TO g_rec_b
       LET g_nml[l_i].nml02 = g_pr_ar[l_i].nml02
       LET g_nml[l_i].nml05 = g_pr_ar[l_i].nml05
       LET g_nml[l_i].tic07= g_pr_ar[l_i].tic07
       LET g_nml[l_i].tic07b= g_pr_ar[l_i].tic07b 
       LET g_nml[l_i].tic071= g_pr_ar[l_i].tic071   #No.TQC-B90234   
   END FOR
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END FUNCTION
 
REPORT q941_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1     
   DEFINE l_amt        LIKE nme_file.nme08
   DEFINE l_amt2       LIKE nme_file.nme08
   DEFINE l_cash1      LIKE nme_file.nme08
   DEFINE cash_in1     LIKE nme_file.nme08
   DEFINE cash_out1    LIKE nme_file.nme08
   DEFINE l_count1     LIKE nme_file.nme08
   DEFINE l_count_in1  LIKE nme_file.nme08
   DEFINE l_count_out1 LIKE nme_file.nme08
   DEFINE l_cash2      LIKE nme_file.nme08
   DEFINE cash_in2     LIKE nme_file.nme08
   DEFINE cash_out2    LIKE nme_file.nme08
   DEFINE l_count2     LIKE nme_file.nme08
   DEFINE l_count_in2  LIKE nme_file.nme08
   DEFINE l_count_out2 LIKE nme_file.nme08 
#No.TQC-B90234 --begin 
   DEFINE l_cash3      LIKE nme_file.nme08
   DEFINE cash_in3     LIKE nme_file.nme08
   DEFINE cash_out3    LIKE nme_file.nme08
   DEFINE l_count3     LIKE nme_file.nme08
   DEFINE l_count_in3  LIKE nme_file.nme08
   DEFINE l_count_out3 LIKE nme_file.nme08
#No.TQC-B90234 --end  
   DEFINE p_flag       LIKE type_file.num5   
   DEFINE l_flag       LIKE type_file.num5   
   DEFINE l_unit       LIKE zaa_file.zaa08  
   DEFINE sr           RECORD
                       type   LIKE type_file.chr1,
                       nml01  LIKE nml_file.nml01,
                       #nml02  LIKE type_file.chr50,        #TQC-C60049    mark
                       nml02  LIKE nml_file.nml02,          #TQC-C60049    add
                       nml03  LIKE nml_file.nml03,
                       nml05  LIKE nml_file.nml05,
                       tic07  LIKE tic_file.tic07,
                       tic07b LIKE tic_file.tic07,
                       tic071 LIKE tic_file.tic07    #No.TQC-B90234    
                       END RECORD
   DEFINE g_head1      STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.type,sr.nml03,sr.nml01
 
   FORMAT
      PAGE HEADER
         CASE tm.d
            WHEN '1'
               LET l_unit = g_x[19]
            WHEN '2'
               LET l_unit = g_x[20]
            WHEN '3'
               LET l_unit = g_x[21]
            OTHERWISE
               LET l_unit = ' '
         END CASE
 
      BEFORE GROUP OF sr.type
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type  = sr.type
         LET g_pr_ar[g_rec_b].nml01 = sr.nml01
         LET g_pr_ar[g_rec_b].nml03 = sr.nml03
         CASE sr.type
            WHEN '1'
               LET g_pr_ar[g_rec_b].nml02 = g_x[9]
               LET g_rec_b = g_rec_b + 1
            WHEN '2'
               LET g_pr_ar[g_rec_b].nml02 = g_x[11]
               LET g_rec_b = g_rec_b + 1
            WHEN '3'
               LET g_pr_ar[g_rec_b].nml02 = g_x[13]
               LET g_rec_b = g_rec_b + 1
            WHEN '4'
               LET g_pr_ar[g_rec_b].nml02 = g_x[15]
               LET g_rec_b = g_rec_b + 1
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON EVERY ROW
         LET sr.tic07 = sr.tic07 * tm.q / g_unit 
         LET sr.tic071 = sr.tic071 * tm.q / g_unit   #No.TQC-B90234 
         LET sr.tic07b = sr.tic07b * tm.q / g_unit
         LET g_pr_ar[g_rec_b].* = sr.*
         LET g_rec_b = g_rec_b + 1
 
      AFTER GROUP OF sr.nml03
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03
         LET cash_in1 = GROUP SUM(sr.tic07) WHERE sr.nml03[2,2] = '0'
         LET cash_out1= GROUP SUM(sr.tic07) WHERE sr.nml03[2,2] = '1'
         LET cash_in2 = GROUP SUM(sr.tic07b) WHERE sr.nml03[2,2] = '0'
         LET cash_out2= GROUP SUM(sr.tic07b) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --begin 
         LET cash_in3 = GROUP SUM(sr.tic071) WHERE sr.nml03[2,2] = '0'
         LET cash_out3= GROUP SUM(sr.tic071) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --end 
         IF cl_null(cash_in1) THEN LET cash_in1 = 0 END IF
         IF cl_null(cash_out1) THEN LET cash_out1 = 0 END IF
         IF cl_null(cash_in2) THEN LET cash_in2 = 0 END IF
         IF cl_null(cash_out2) THEN LET cash_out2 = 0 END IF
#No.TQC-B90234 --begin 
         IF cl_null(cash_in3) THEN LET cash_in3 = 0 END IF
         IF cl_null(cash_out3) THEN LET cash_out3 = 0 END IF
#No.TQC-B90234 --end 
 
         IF sr.nml03 <> '40' THEN
            CASE 
              WHEN sr.nml03='1' OR sr.nml03='3'
                   LET g_pr_ar[g_rec_b].nml02 = g_x[18]
              WHEN sr.nml03='2'
                   LET g_pr_ar[g_rec_b].nml02 = g_x[17]
              OTHERWISE
                   LET g_pr_ar[g_rec_b].nml02 = g_x[sr.nml03 MOD 10 + 17]
            END CASE
            IF sr.nml03[2,2] = '0' THEN
#               LET cash_in1 = cash_in1 * tm.q / g_unit   #No.TQC-B90234  
#               LET cash_in2 = cash_in2 * tm.q / g_unit   #No.TQC-B90234   
               LET g_pr_ar[g_rec_b].tic07 = cash_in1
               LET g_pr_ar[g_rec_b].tic07b = cash_in2 
               LET g_pr_ar[g_rec_b].tic071 = cash_in3   #No.TQC-B90234 
            ELSE
#               LET cash_out1 = cash_out1 * tm.q / g_unit   #No.TQC-B90234 
#               LET cash_out2 = cash_out2 * tm.q / g_unit   #No.TQC-B90234 
               LET g_pr_ar[g_rec_b].tic07 = cash_out1
               LET g_pr_ar[g_rec_b].tic07b = cash_out2 
               LET g_pr_ar[g_rec_b].tic071 = cash_out3      #No.TQC-B90234  
            END IF
            LET g_rec_b = g_rec_b + 1
         END IF
 
      AFTER GROUP OF sr.type
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03
 
         LET cash_in1 = GROUP SUM(sr.tic07) WHERE sr.nml03[2,2] = '0'
         LET cash_out1= GROUP SUM(sr.tic07) WHERE sr.nml03[2,2] = '1'
         LET cash_in2 = GROUP SUM(sr.tic07b) WHERE sr.nml03[2,2] = '0'
         LET cash_out2= GROUP SUM(sr.tic07b) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --begin 
         LET cash_in3 = GROUP SUM(sr.tic071) WHERE sr.nml03[2,2] = '0'
         LET cash_out3= GROUP SUM(sr.tic071) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --end 
         IF cl_null(cash_in1) THEN LET cash_in1 = 0 END IF
         IF cl_null(cash_out1) THEN LET cash_out1 = 0 END IF
         IF cl_null(cash_in2) THEN LET cash_in2 = 0 END IF
         IF cl_null(cash_out2) THEN LET cash_out2 = 0 END IF
#No.TQC-B90234 --begin 
         IF cl_null(cash_in3) THEN LET cash_in3 = 0 END IF
         IF cl_null(cash_out3) THEN LET cash_out3 = 0 END IF
#No.TQC-B90234 --end 
 
         CASE sr.type
            WHEN '1'
               LET l_cash1 = (cash_in1 - cash_out1)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash2 = (cash_in2 - cash_out2)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash3 = (cash_in3 - cash_out3)                      #No.TQC-B90234      
               LET g_pr_ar[g_rec_b].nml02 = g_x[10]
               LET g_pr_ar[g_rec_b].tic07= l_cash1
               LET g_pr_ar[g_rec_b].tic07b= l_cash2 
               LET g_pr_ar[g_rec_b].tic071= l_cash3                      #No.TQC-B90234     
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0 
#No.TQC-B90234 --begin 
               LET cash_in3 = 0
               LET cash_out3 = 0 
#No.TQC-B90234 --end                 
            WHEN '2'
               LET l_cash1 = (cash_in1 - cash_out1)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash2 = (cash_in2 - cash_out2)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash3 = (cash_in3 - cash_out3)                      #No.TQC-B90234   
               LET g_pr_ar[g_rec_b].nml02 = g_x[12]
               LET g_pr_ar[g_rec_b].tic07= l_cash1
               LET g_pr_ar[g_rec_b].tic07b= l_cash2
               LET g_pr_ar[g_rec_b].tic071= l_cash3                      #No.TQC-B90234 
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
#No.TQC-B90234 --begin 
               LET cash_in3 = 0
               LET cash_out3 = 0 
#No.TQC-B90234 --end
            WHEN '3'
               LET l_cash1 = (cash_in1 - cash_out1)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash2 = (cash_in2 - cash_out2)   #* tm.q / g_unit   #No.TQC-B90234 
               LET l_cash3 = (cash_in3 - cash_out3)                      #No.TQC-B90234   
               LET g_pr_ar[g_rec_b].nml02 = g_x[14]
               LET g_pr_ar[g_rec_b].tic07= l_cash1
               LET g_pr_ar[g_rec_b].tic07b= l_cash2
               LET g_pr_ar[g_rec_b].tic071= l_cash3                      #No.TQC-B90234 
               LET g_rec_b = g_rec_b + 1
               LET cash_in1 = 0
               LET cash_out1 = 0
               LET cash_in2 = 0
               LET cash_out2 = 0
#No.TQC-B90234 --begin 
               LET cash_in3 = 0
               LET cash_out3 = 0 
#No.TQC-B90234 --end
            OTHERWISE
               EXIT CASE
         END CASE
 
      ON LAST ROW
         INITIALIZE g_pr_ar[g_rec_b].* TO NULL
         LET g_pr_ar[g_rec_b].type = sr.type
         LET g_pr_ar[g_rec_b].nml01= sr.nml01
         LET g_pr_ar[g_rec_b].nml03= sr.nml03
 
         LET l_count_in1 = SUM(sr.tic07) WHERE sr.nml03[2,2] = '0'
         LET l_count_out1= SUM(sr.tic07) WHERE sr.nml03[2,2] = '1'
         LET l_count_in2 = SUM(sr.tic07b) WHERE sr.nml03[2,2] = '0'
         LET l_count_out2= SUM(sr.tic07b) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --begin 
         LET l_count_in3 = SUM(sr.tic071) WHERE sr.nml03[2,2] = '0'
         LET l_count_out3= SUM(sr.tic071) WHERE sr.nml03[2,2] = '1'
#No.TQC-B90234 --end  
         IF cl_null(l_count_in1) THEN LET l_count_in1 = 0 END IF
         IF cl_null(l_count_out1) THEN LET l_count_out1 = 0 END IF
         IF cl_null(l_count_in2) THEN LET l_count_in2 = 0 END IF
         IF cl_null(l_count_out2) THEN LET l_count_out2 = 0 END IF
#No.TQC-B90234 --begin 
         IF cl_null(l_count_in3) THEN LET l_count_in3 = 0 END IF
         IF cl_null(l_count_out3) THEN LET l_count_out3 = 0 END IF
#No.TQC-B90234 --end  
         LET l_count1 = l_count_in1 - l_count_out1
         LET l_count2 = l_count_in2 - l_count_out2 
         LET l_count3 = l_count_in3 - l_count_out3      #No.TQC-B90234  
#         LET l_count1 = l_count1   * tm.q / g_unit     #No.TQC-B90234  
#         LET l_count2 = l_count2   * tm.q / g_unit     #No.TQC-B90234
 
         LET g_pr_ar[g_rec_b].nml02 = g_x[16]
         LET g_pr_ar[g_rec_b].tic07= l_count1
         LET g_pr_ar[g_rec_b].tic07b= l_count2
         LET g_pr_ar[g_rec_b].tic071= l_count3          #No.TQC-B90234 
          
END REPORT
 
FUNCTION q941_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    
 
   CALL cl_set_comp_entry("p,q",TRUE)
 
END FUNCTION
 
FUNCTION q941_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     
 
   IF tm.o = 'N' THEN
      CALL cl_set_comp_entry("p,q",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION q941_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
  #No.FUN-C80102 ---start--- Mark
  #DISPLAY tm.p TO FORMONLY.azi01
  ##No.TQC-B90234 --begin 
  #DISPLAY tm.y1 TO FORMONLY.yy
  #DISPLAY tm.bm1 TO FORMONLY.mm1
  #DISPLAY tm.em1 TO FORMONLY.mm2
  #No.FUN-C80102 ---start--- Mark
   CALL cl_set_comp_att_text('tic07',tm.title1 CLIPPED)
   CALL cl_set_comp_att_text('tic071',tm.title2 CLIPPED)
#  DISPLAY tm.y1 TO FORMONLY.yy
#  DISPLAY tm.m1 TO FORMONLY.mm1
#  DISPLAY tm.m2 TO FORMONLY.mm2
#No.TQC-B90234 --end 
  #DISPLAY tm.d  TO FORMONLY.unit   #No.FUN-C80102   Mark
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nml TO s_nml.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         CALL cl_show_fld_cont()               
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q941_out()
  DEFINE l_i   LIKE type_file.num10
   LET g_prog = 'gglq941'
   LET g_sql = " type.type_file.chr1,", 
               " nml01.nml_file.nml01,",
               #" nml02.type_file.chr50,",       #TQC-C60049    mark
               " nml02.nml_file.nml02,",         #TQC-C60049    add
               " nml03.nml_file.nml03,",
               " nml05.nml_file.nml05,",
               " tic07.tic_file.tic07,",
               " tic07b.tic_file.tic07,",
               " tic071.tic_file.tic07" 

   LET l_table = cl_prt_temptable('gglq941',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?,?         ) "    #No.TQC-B90234      
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
 
   CALL cl_del_data(l_table)
 
   FOR l_i = 1 TO g_rec_b 
       EXECUTE insert_prep USING g_pr_ar[l_i].*
   END FOR
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = g_str,";",tm.title,";",tm.p,";",tm.d,";",
               t_azi04,";",t_azi05,";",tm.title1,";",tm.title2   #No.TQC-B90234  
   CALL cl_prt_cs3('gglq941','gglq941',g_sql,g_str)
END FUNCTION
