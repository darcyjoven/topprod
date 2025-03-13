# Prog. Version..: '5.30.06-13.04.02(00004)'     #
#
# Pattern name...: aglq911.4gl
# Descriptions...: 傳票明細表
# Date & Author..: 12/08/29 FUN-C80102 By  chenying 
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No.FUN-D10072 13/01/29 By chenying 新增[對方科目]欄位
# Modify.........: No.TQC-D30014 13/03/05 By xuxz 【串查憑證】按鈕，點擊查不出回沖的憑證
# Modify.........: No.TQC-D60022 13/06/06 By wangrr 將部門為空格或者為NULL的放在一起合計

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            
                 wc  STRING,                    
                 wc2 STRING,                    #FUN-C80102                  
                 s   LIKE abh_file.abh01,       #排列順序
                 t   LIKE abh_file.abh01,       #排列順序
                 u   LIKE abh_file.abh01,       #排列順序
                 d   LIKE type_file.chr1,       #過帳別 (1)未過帳(2)已過帳(3)全部 
                 e   LIKE type_file.chr1,       #是否列印科目名稱及摘要    
                 k   LIKE type_file.chr1,       #是否列印額外名稱
                 m   LIKE type_file.chr1,       #是否輸入其它特殊列印條件  
                 a   LIKE type_file.chr1,       #是否列印原幣金額  #FUN-C80102
                 #FUN-C80102--add--str--
                 b11 LIKE type_file.chr1,      
                 b12 LIKE type_file.chr1,      
                 b13 LIKE type_file.chr1,      
                 b14 LIKE type_file.chr1,      
                 b35 LIKE type_file.chr1,      
                 b36 LIKE type_file.chr1,      
                 b37 LIKE type_file.chr1
                 #FUN-C80102--add--end--
              END RECORD,
          g_bookno  LIKE aba_file.aba00,#帳別編號
          g_orderA  ARRAY[3] OF LIKE aba_file.aba01  #排序名稱                 
   DEFINE g_aaa03   LIKE aaa_file.aaa03 
   DEFINE g_i       LIKE type_file.num5          #count/index for any purpose        
   DEFINE g_msg     LIKE type_file.chr1000       
   DEFINE l_table   STRING                                                                                     
   DEFINE g_sql     STRING                                                                                    
   DEFINE g_str     STRING    
   DEFINE g_rec_b        LIKE type_file.num10
   DEFINE g_cnt          LIKE type_file.num10                  
   DEFINE g_aba          DYNAMIC ARRAY OF RECORD  
                aba00  LIKE aba_file.aba00,    #帳別                                                                                     
               #aba01  LIKE aba_file.aba01,   #傳票編號     #FUN-C80102                                                                            
                aba01  LIKE type_file.chr1000,   #傳票編號  #FUN-C80102                                                                               
                aba02  LIKE aba_file.aba02,   #傳票日期  
                aba03  LIKE aba_file.aba03,
                aba04  LIKE aba_file.aba04,                                                                       
                abb02  LIKE abb_file.abb02,   #Seq
                abb04  LIKE abb_file.abb04,                                                                                      
               #abb03  LIKE abb_file.abb03,   #科目   #FUN-C80102                                                                                  
                abb03  LIKE type_file.chr1000,   #科目    #FUN-C80102                                                                            
                aag02  LIKE aag_file.aag02,   #科目名稱                                                                                 
                aag13  LIKE aag_file.aag13,   #額外名稱                                                                                                      
                abb03_1 LIKE type_file.chr1000,  #FUN-D10072                                                                                 
               #abb05  LIKE abb_file.abb05,   #部門    #FUN-C80102 
                abb05  LIKE type_file.chr1000,   #部門 #FUN-C80102
                gem02  LIKE gem_file.gem02,
                abb24  LIKE abb_file.abb24,                                                                                               
                abb25  LIKE abb_file.abb25,   #匯率 #FUN-C80102
                abb06  LIKE abb_file.abb06,   #借貸別                                                                                   
                abb07  LIKE abb_file.abb07,   #異動金額 \
                abb07f LIKE abb_file.abb07f,                                                                               
                abb11  LIKE abb_file.abb11,   #異動碼-1                                                                                 
                #FUN-C80102---add---str--
                abb12  LIKE abb_file.abb12,   #異動碼-2                                                                              
                abb13  LIKE abb_file.abb13,   #異動碼-3                                                                              
                abb14  LIKE abb_file.abb14,   #異動碼-4                                                                              
                abb35  LIKE abb_file.abb35,   #異動碼-9                                                                              
                abb36  LIKE abb_file.abb36,   #異動碼-10                                                                              
                abb37  LIKE abb_file.abb37,   #異動碼-關係人                                                                          
                rec_d  LIKE abb_file.abb07f,                                                                                          
                rec_c  LIKE abb_file.abb07f,                                                                                          
                #FUN-C80102---add---end--
                amt_d  LIKE abb_file.abb07,                                                                                           
                amt_c  LIKE abb_file.abb07,                                                                                           
                aba24  LIKE aba_file.aba24,   
                gen02  LIKE gen_file.gen02,
                aba37  LIKE aba_file.aba37,   
                gen02_1 LIKE gen_file.gen02,
                aba38  LIKE aba_file.aba38,
                gen02_2 LIKE gen_file.gen02,
                aba06  LIKE aba_file.aba06,
                aba07  LIKE aba_file.aba07
           END RECORD 
   DEFINE g_row_count    LIKE type_file.num10  
   DEFINE g_curs_index   LIKE type_file.num10  
   DEFINE g_jump         LIKE type_file.num10  
   DEFINE mi_no_ask      LIKE type_file.num5
   DEFINE g_no_ask       LIKE type_file.num5    #FUN-C80102 
   DEFINE l_ac           LIKE type_file.num5                                                                                        
   DEFINE g_tot1,g_tot2,g_tot3,g_tot4,g_tot5,g_tot6  LIKE oma_file.oma56t               
   DEFINE g_cmd          LIKE type_file.chr1000  #FUN-C80102
   DEFINE g_aba06        LIKE aba_file.aba06 #TQC-D30014 add
                    
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   OPEN WINDOW q911_w AT 5,10
        WITH FORM "agl/42f/aglq911" ATTRIBUTE(STYLE = g_win_style)  

   CALL cl_ui_init()
   
   LET  g_bookno = ARG_VAL(1)   
   LET g_pdate = ARG_VAL(2)            
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)
   LET tm.e  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   IF g_bookno = ' ' OR g_bookno IS NULL THEN
     #LET g_bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別
      LET g_bookno = g_aza.aza81   #帳別若為空白則使用預設帳別  #FUN-C80102
   END IF
   LET g_max_rec = 10000    #NO.120822 add

#  CALL cl_set_comp_visible("abb07,abb07f,aba00",FALSE)   #FUN-C80102 mark
   CALL cl_set_comp_visible("abb07,abb07f,rec_d,rec_c,abb25,abb24,aag13",FALSE)                 #FUN-C80102 add
   CALL cl_set_comp_visible("abb11,abb12,abb13,abb14,abb35,abb36,abb37",FALSE)  #FUN-C80102 add
   CALL cl_set_comp_visible("b11,b12,b13,b14",FALSE)  #FUN-C80102 add
   IF g_aaz.aaz88 = '0' THEN 
      CALL cl_set_comp_visible("b11,b12,b13,b14",FALSE)
   END IF
   IF g_aaz.aaz88 = '4' THEN 
      CALL cl_set_comp_visible("b11,b12,b13,b14",TRUE)
   END IF
   IF g_aaz.aaz88 = '3' THEN 
      CALL cl_set_comp_visible("b11,b12,b13",TRUE) 
   END IF
   IF g_aaz.aaz88 = '2' THEN 
      CALL cl_set_comp_visible("b11,b12",TRUE)
   END IF
   IF g_aaz.aaz88 = '1' THEN 
      CALL cl_set_comp_visible("b11",TRUE)
   END IF

#FUN-C80102--mark--str--
#  IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
#     CALL aglq911_tm()               
#  ELSE 
#     CALL aglq911_b_fill()                 
#  END IF
#FUN-C80102--mark--end--

   CALL q911_q()   #FUN-C80102
   CALL q911_menu()
   CLOSE WINDOW q911_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q911_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
 
   WHILE TRUE
      CALL q911_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
#              CALL aglq911_tm()   #FUN-C80102 mark
               CALL q911_q()    #FUN-C80102 add
            END IF         
         WHEN "query_account"
            IF cl_chk_act_auth() THEN
               #CALL q910_q_a()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_aba),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               LET g_doc.column1 = "aba01"
               LET g_doc.value1 = ''
               CALL cl_doc()
            END IF
      END CASE
   END WHILE
END FUNCTION

#FUN-C80102--mark--str--
#FUNCTION aglq911_tm()
#DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           
#DEFINE p_row,p_col    LIKE type_file.num5,         
#         l_cmd       LIKE type_file.chr1000        
#DEFINE li_chk_bookno  LIKE type_file.num5             
   
   
#  CALL s_dsmark(g_bookno)
#  IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
#     LET p_row = 2 LET p_col = 16
#  ELSE 
#  	  LET p_row = 4 LET p_col = 15
#  END IF
#  OPEN WINDOW aglq911_w AT p_row,p_col WITH FORM "agl/42f/aglq911_1"   
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
#   CALL cl_ui_init()
 
#  CALL s_shwact(3,2,g_bookno)
#  CALL cl_opmsg('p')
#  INITIALIZE tm.* TO NULL                 
#  LET tm.u = '1'
#  LET tm.d = '3'
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
 
#WHILE TRUE
#     DIALOG ATTRIBUTE(unbuffered)
#        INPUT g_bookno FROM aba00 ATTRIBUTE(WITHOUT DEFAULTS)
#           AFTER FIELD aba00
#             IF NOT cl_null(g_bookno) THEN
#                  CALL s_check_bookno(g_bookno,g_user,g_plant)
#                   RETURNING li_chk_bookno
#               IF (NOT li_chk_bookno) THEN
#                   NEXT FIELD aba00
#               END IF
#               SELECT aaa02 FROM aaa_file WHERE aaa01 = g_bookno
#               IF STATUS THEN
#                  CALL cl_err3("sel","aaa_file",g_bookno,"","agl-043","","",0)
#                  NEXT FIELD  aba00
#               END IF
#            END IF
#        END INPUT

#   CONSTRUCT BY NAME tm.wc ON aba01,aba02,abb03,abb05,abb11,abb02,abb06    
      
#        BEFORE CONSTRUCT
#            CALL cl_qbe_init()
        
#   END CONSTRUCT

#   INPUT BY NAME tm.u,tm.d,tm.m                  
#        ATTRIBUTE(WITHOUT DEFAULTS)   
        
#     BEFORE INPUT
#       CALL cl_qbe_display_condition(lc_qbe_sn)
                                                                                                                           
#     AFTER FIELD d
#        IF tm.d NOT MATCHES "[123]" THEN NEXT FIELD d END IF
      
#     AFTER FIELD u
#        IF tm.u NOT MATCHES "[123]" THEN 
#           NEXT FIELD u 
#        END IF

#    END INPUT
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(aba00)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_aaa'
#                 LET g_qryparam.default1 = g_bookno
#                 CALL cl_create_qry() RETURNING g_bookno
#                 DISPLAY BY NAME g_bookno
#                 NEXT FIELD aba00
               
#              WHEN INFIELD(aba01)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state    = "c"
#                 LET g_qryparam.form = 'q_aba'  
#                 LET g_qryparam.arg1 = g_bookno               
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO aba01
#                 NEXT FIELD aba01
                  
#              WHEN INFIELD(abb03)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state    = "c"
#                 LET g_qryparam.form = "q_aag"
#                 LET g_qryparam.where = " aag00 = '",g_bookno CLIPPED,"'"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO abb03
#                 NEXT FIELD abb03
#              OTHERWISE EXIT CASE
#           END CASE
#      ON ACTION locale
#         CALL cl_show_fld_cont()
#         LET g_action_choice = "locale"
#         EXIT DIALOG
#      ON ACTION CONTROLZ
#         CALL cl_show_req_fields()
#
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DIALOG
#
#      ON ACTION about
#         CALL cl_about()

#      ON ACTION help
#         CALL cl_show_help()

#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT DIALOG

#      ON ACTION qbe_save
#         CALL cl_qbe_save()

#      ON ACTION accept
#         EXIT DIALOG

#      ON ACTION cancel
#         LET INT_FLAG=1
#         EXIT DIALOG
#  END DIALOG
#  IF g_action_choice = "locale" THEN
#     LET g_action_choice = ""
#     CALL cl_dynamic_locale()
#     CONTINUE WHILE
#  END IF

#  IF INT_FLAG THEN
#     LET INT_FLAG = 0 CLOSE WINDOW aglq911_w 
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#     EXIT PROGRAM
         
#  END IF
#  CALL cl_wait()
#  CALL aglq911_b_fill()
#  ERROR ""
#  EXIT WHILE
#END WHILE
#  CLOSE WINDOW aglq911_w
#DISPLAY g_rec_b TO  FORMONLY.cnt
#END FUNCTION
 
FUNCTION aglq911_b_fill()
   DEFINE l_name      LIKE type_file.chr20,           
          l_sql       STRING,                
          l_chr       LIKE type_file.chr1,         
          l_order     ARRAY[5] OF LIKE abb_file.abb11,   #排列順序    
          l_i         LIKE type_file.num5,                    
          l_cnt       LIKE type_file.num5      #FUN-C80102              
   DEFINE l_aba24  LIKE aba_file.aba24
   DEFINE l_aba37  LIKE aba_file.aba37
   DEFINE l_aba38  LIKE aba_file.aba38
   DEFINE l_aba01  LIKE aba_file.aba01
   DEFINE l_abb05  LIKE abb_file.abb05
   DEFINE l_abb03  LIKE abb_file.abb03
   
   LET g_tot1 = 0  
   LET g_tot2 = 0
   LET g_tot3 = 0
   LET g_tot4 = 0
  
   CALL g_aba.clear()   
   LET g_rec_b=0
   LET g_cnt = 1


   CASE tm.u
     WHEN '1'
       LET l_sql = "SELECT distinct aba01 FROM aba_file,abb_file",
                   " WHERE aba00 = abb00",                     
                   "   AND aba01 = abb01",                   
                   "   AND abaacti='Y'",
                   "   AND aba19 <> 'X' ",  #CHI-C80041
                 # "   AND ",tm.wc CLIPPED,           #FUN-C80102 mark
                   "   AND aba00 = '",g_bookno,"'",   #FUN-C80102
                   "   AND ",tm.wc2 CLIPPED   #FUN-C80102
       CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
            WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
            WHEN tm.d = '3' LET l_sql = l_sql CLIPPED," AND aba19 = 'N' "
            WHEN tm.d = '4' LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
       END CASE
                   
       PREPARE q911_pb1 FROM l_sql
       DECLARE aba_curs1 CURSOR FOR q911_pb1
          FOREACH aba_curs1 INTO l_aba01
           #CALL q911_get_aba01(tm.wc,l_aba01)   #FUN-C80102
            CALL q911_get_aba01(tm.wc2,l_aba01)  #FUN-C80102
               LET g_tot1 = g_tot1 + g_aba[g_cnt].abb07f
               LET g_tot2 = g_tot2 + g_aba[g_cnt].amt_d
               LET g_tot3 = g_tot3 + g_aba[g_cnt].amt_c
               
               LET g_cnt = g_cnt + 1
               IF g_cnt > g_max_rec THEN
                  CALL cl_err( '', 9035, 0 )
	          EXIT FOREACH
               END IF
           #END IF   #FUN-C80102
          END FOREACH
          LET g_aba[g_cnt].aba01 = cl_getmsg('alm-h87',g_lang)  #总計 #TQC-D60022 'cmr-003'->'alm-h87'
          LET g_aba[g_cnt].abb07f = g_tot1
          LET g_aba[g_cnt].amt_d = g_tot2
          LET g_aba[g_cnt].amt_c = g_tot3
          
     WHEN '2'
      #LET l_sql = "SELECT distinct abb05 FROM aba_file,abb_file",   #FUN-D10072
      #LET l_sql = "SELECT distinct replace(abb05,' ','') FROM aba_file,abb_file", #FUN-D10072 #TQC-D60022 mark
       LET l_sql = "SELECT distinct trim(abb05) FROM aba_file,abb_file", #TQC-D60022
                   " WHERE aba00 = abb00",                     
                   "   AND aba01 = abb01",                   
                   "   AND abaacti='Y'",
                   "   AND aba19 <> 'X' ",  #CHI-C80041
                 # "   AND ",tm.wc CLIPPED,           #FUN-C80102 mark
                   "   AND aba00 = '",g_bookno,"'",   #FUN-C80102
                   "   AND ",tm.wc2 CLIPPED   #FUN-C80102
      CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
           WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
           WHEN tm.d = '3' LET l_sql = l_sql CLIPPED," AND aba19 = 'N' "
           WHEN tm.d = '4' LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
      END CASE
                   
       PREPARE q911_pb2 FROM l_sql
       DECLARE aba_curs2 CURSOR FOR q911_pb2
          FOREACH aba_curs2 INTO l_abb05
           #CALL q911_get_abb05(tm.wc,l_abb05)   #FUN-C80102
            CALL q911_get_abb05(tm.wc2,l_abb05)   #FUN-C80102
            LET g_tot1 = g_tot1 + g_aba[g_cnt].abb07f
            LET g_tot2 = g_tot2 + g_aba[g_cnt].amt_d
            LET g_tot3 = g_tot3 + g_aba[g_cnt].amt_c
            
            LET g_cnt = g_cnt + 1
            IF g_cnt > g_max_rec THEN
               CALL cl_err( '', 9035, 0 )
	             EXIT FOREACH
            END IF
          END FOREACH
          LET g_aba[g_cnt].abb05 = cl_getmsg('alm-h87',g_lang)  #总計 #TQC-D60022 'cmr-003'->'alm-h87'
          LET g_aba[g_cnt].abb07f = g_tot1
          LET g_aba[g_cnt].amt_d = g_tot2
          LET g_aba[g_cnt].amt_c = g_tot3
          
     WHEN '3'
       LET l_sql = "SELECT distinct abb03 FROM aba_file,abb_file",
                   " WHERE aba00 = abb00",                     
                   "   AND aba01 = abb01",                   
                   "   AND abaacti='Y'",
                   "   AND aba19 <> 'X' ",  #CHI-C80041
                 # "   AND ",tm.wc CLIPPED,           #FUN-C80102 mark
                   "   AND aba00 = '",g_bookno,"'",   #FUN-C80102
                   "   AND ",tm.wc2 CLIPPED   #FUN-C80102
       CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
            WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
            WHEN tm.d = '3' LET l_sql = l_sql CLIPPED," AND aba19 = 'N' "
            WHEN tm.d = '4' LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
       END CASE
                   
       PREPARE q911_pb3 FROM l_sql
       DECLARE aba_curs3 CURSOR FOR q911_pb3
          FOREACH aba_curs3 INTO l_abb03
           #CALL q911_get_abb03(tm.wc,l_abb03)  #FUN-C80102
            CALL q911_get_abb03(tm.wc2,l_abb03)  #FUN-C80102
            LET g_tot1 = g_tot1 + g_aba[g_cnt].abb07f
            LET g_tot2 = g_tot2 + g_aba[g_cnt].amt_d
            LET g_tot3 = g_tot3 + g_aba[g_cnt].amt_c
            
            LET g_cnt = g_cnt + 1
            IF g_cnt > g_max_rec THEN
               CALL cl_err( '', 9035, 0 )
	             EXIT FOREACH
            END IF
          END FOREACH
          LET g_aba[g_cnt].abb03 = cl_getmsg('alm-h87',g_lang)  #总計 #TQC-D60022 'cmr-003'->'alm-h87'
          LET g_aba[g_cnt].abb07f = g_tot1
          LET g_aba[g_cnt].amt_d = g_tot2
          LET g_aba[g_cnt].amt_c = g_tot3
   OTHERWISE                    # FUN-C80102
      CALL q911_get_abb(tm.wc2) #FUN-C80102 
   END CASE  
   LET g_rec_b = g_cnt - 1      
   DISPLAY g_rec_b TO  FORMONLY.cn2
END FUNCTION

FUNCTION q911_get_aba01(p_wc,p_aba01) 
DEFINE p_wc  STRING
DEFINE p_aba01  LIKE aba_file.aba01
DEFINE l_tot1,l_tot2,l_tot3,l_tot4,l_tot5,l_tot6  LIKE oma_file.oma56t
DEFINE l_aba24  LIKE aba_file.aba24
DEFINE l_aba37  LIKE aba_file.aba37
DEFINE l_aba38  LIKE aba_file.aba38
DEFINE l_aba01  LIKE aba_file.aba01
DEFINE l_sql  STRING
  
  LET l_tot1 = 0  
  LET l_tot2 = 0
  LET l_tot3 = 0
  LET l_tot4 = 0
  LET l_tot5 = 0  #FUN-C80102
  LET l_tot6 = 0  #FUN-C80102 

  
   LET l_sql = "SELECT aba00,aba01,aba02,aba03,aba04,",
              #" abb02,abb04,abb03,aag02,aag13,abb05,'',abb24,abb25,abb06,abb07,abb07f,abb11,",    #FUN-D10072
               " abb02,abb04,abb03,aag02,aag13,'',abb05,'',abb24,abb25,abb06,abb07,abb07f,abb11,", #FUN-D10072
               " abb12,abb13,abb14,abb35,abb36,abb37,0,0,0,0,",  #FUN-C80102 add abb25 abb12-abb37
              #" '','','',aba06,aba07,",  #FUN-C80102 
               " aba24,'',aba37,'',aba38,'',aba06,aba07 ",  #FUN-C80102 
              #" aba24,aba37,aba38",  #FUN-C80102
              #" FROM aba_file, abb_file, OUTER aag_file",                            #FUN-C80102 
               " FROM aba_file, abb_file LEFT OUTER JOIN aag_file ON abb03 = aag01 AND abb00 = aag00 ", #FUN-C80102
               " WHERE aba00 = abb00",
              #"   AND aba00 = aag00",  #FUN-C80102     
               "   AND aba01 = abb01",
              #"   AND abb_file.abb03 = aag_file.aag01",  #FUN-C80102
               "   AND abaacti='Y'",
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   AND aba01 = '",p_aba01,"'",
               "   AND aba00 = '",g_bookno,"'",  #FUN-C80102
               "   AND ",tm.wc2,                 #FUN-C80102
               "   ORDER BY abb02"
  #FUN-C80012--mark--str--
  #CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
  #     WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
  #END CASE
  #FUN-C80012--mark--end
 
   PREPARE aglq911_prepare1 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)      
      RETURN
   END IF
   DECLARE aglq911_curs1 CURSOR FOR aglq911_prepare1   
             
  #FOREACH aglq911_curs1 INTO g_aba[g_cnt].*,l_aba24,l_aba37,l_aba38  #FUN-C80102
   FOREACH aglq911_curs1 INTO g_aba[g_cnt].*   #FUN-C80102
     IF STATUS THEN 
        CALL cl_err('foreach:',STATUS,1)        
        EXIT FOREACH
     END IF
 
     SELECT gem02 INTO g_aba[g_cnt].gem02 FROM gem_file
      WHERE gem01 = g_aba[g_cnt].abb05
    #FUN-C80102 
    #SELECT gen02 INTO g_aba[g_cnt].gen02 FROM gen_file WHERE gen01 = l_aba24
    #SELECT gen02 INTO g_aba[g_cnt].gen02_1 FROM gen_file WHERE gen01 = l_aba37
    #SELECT gen02 INTO g_aba[g_cnt].gen02_2 FROM gen_file WHERE gen01 = l_aba38  
     SELECT gen02 INTO g_aba[g_cnt].gen02 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba24
     SELECT gen02 INTO g_aba[g_cnt].gen02_1 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba37
     SELECT gen02 INTO g_aba[g_cnt].gen02_2 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba38  
    #FUN-C80102 
     CALL q911_get_abb03_1(g_aba[g_cnt].aba01,g_aba[g_cnt].abb06) RETURNING g_aba[g_cnt].abb03_1  #FUN-D10072
     IF g_aba[g_cnt].abb06='1' THEN 
        LET g_aba[g_cnt].amt_d=g_aba[g_cnt].abb07 
        LET g_aba[g_cnt].amt_c=0
     ELSE 
     	  LET g_aba[g_cnt].amt_d=0 
     	  LET g_aba[g_cnt].amt_c=g_aba[g_cnt].abb07           
     END IF

     
     IF g_aba[g_cnt].abb06='1' THEN 
        LET g_aba[g_cnt].rec_d=g_aba[g_cnt].abb07f 
        LET g_aba[g_cnt].rec_c=0
     ELSE 
     	  LET g_aba[g_cnt].rec_d=0 
     	  LET g_aba[g_cnt].rec_c=g_aba[g_cnt].abb07f           
     END IF

     LET l_tot1 = l_tot1 + g_aba[g_cnt].abb07f
     LET l_tot2 = l_tot2 + g_aba[g_cnt].amt_d
     LET l_tot3 = l_tot3 + g_aba[g_cnt].amt_c
    
     LET l_aba01 = g_aba[g_cnt].aba01   #FUN-C80102       
 
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
     END IF     
   END FOREACH
   
#  LET g_aba[g_cnt].gem02 = cl_getmsg('amr-003',g_lang)  #合計  #FUN-C80102
   LET g_aba[g_cnt].aba01 = l_aba01," "," ",cl_getmsg('amr-003',g_lang)  #合計  #FUN-C80102
   LET g_aba[g_cnt].abb07f = l_tot1
   LET g_aba[g_cnt].aag13 = p_aba01
   LET g_aba[g_cnt].amt_d = l_tot2
   LET g_aba[g_cnt].amt_c = l_tot3
  
   #FUN-C80102--add--str--
   DISPLAY ARRAY g_aba TO s_aba.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
          EXIT DISPLAY
      END DISPLAY 
   #FUN-C80102--add--end-- 
        
END FUNCTION

FUNCTION q911_get_abb05(p_wc,p_abb05) 
DEFINE p_wc  STRING
DEFINE p_abb05  LIKE abb_file.abb05
DEFINE l_tot1,l_tot2,l_tot3,l_tot4,l_tot5,l_tot6  LIKE oma_file.oma56t
DEFINE l_aba24  LIKE aba_file.aba24
DEFINE l_aba37  LIKE aba_file.aba37
DEFINE l_aba38  LIKE aba_file.aba38
DEFINE l_sql  STRING
DEFINE l_abb05  LIKE abb_file.abb05  #FUN-C80102
   
  LET l_tot1 = 0  
  LET l_tot2 = 0
  LET l_tot3 = 0
  LET l_tot4 = 0
  LET l_tot5 = 0  #FUN-C80102
  LET l_tot6 = 0  #FUN-C80102 
  
   LET l_sql = "SELECT aba00,aba01,aba02,aba03,aba04,",
              #" abb02,abb04,abb03,aag02,aag13,abb05,'',abb24,abb25,abb06,abb07,abb07f,abb11,",   #FUN-D10072
               " abb02,abb04,abb03,aag02,aag13,'',abb05,'',abb24,abb25,abb06,abb07,abb07f,abb11,",#FUN-D10072
               " abb12,abb13,abb14,abb35,abb36,abb37,0,0,0,0,",  #FUN-C80102 add abb25 abb12-abb37
              #" '','','',aba06,aba07,",   #0907
               " aba24,'',aba37,'',aba38,'',aba06,aba07 ", 
              #" aba24,aba37,aba38",
              #" FROM aba_file, abb_file, OUTER aag_file",   #FUN-C80102
               " FROM aba_file, abb_file  LEFT OUTER JOIN aag_file ON abb03 = aag01 AND abb00 = aag00 ",  #FUN-C80102
               " WHERE aba00 = abb00",
              #"   AND aba00 = aag00",  #FUN-C80102     
               "   AND aba01 = abb01",
              #"   AND abb_file.abb03 = aag_file.aag01",   #FUN-C80102
               "   AND abaacti='Y'",
               "   AND aba19 <> 'X' "  #CHI-C80041
              #"   AND abb05 = '",p_abb05,"'",                    #FUN-D10072
              #"   AND (abb05 = '",p_abb05,"' OR abb05 IS NULL)", #FUN-D10072 #TQC-D60022 mark
   #TQC-D60022--add--str--
  IF p_abb05 IS NULL THEN
     LET l_sql=l_sql,"   AND trim(abb05) IS NULL "
  ELSE
     LET l_sql=l_sql,"   AND abb05 = '",p_abb05,"'"
  END IF
  #TQC-D60022--add--end
              #"   AND ",tm.wc,                  #FUN-C80102
  LET l_sql=l_sql,  #TQC-D60022
               "   AND aba00 = '",g_bookno,"'",  #FUN-C80102
               "   AND ",tm.wc2,                 #FUN-C80102
               "   ORDER BY abb02"
  #FUN-C80012--mark--str--
  #CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
  #     WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
  #END CASE
  #FUN-C80012--mark--end
 
   PREPARE aglq911_prepare2 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)      
      RETURN
   END IF
   DECLARE aglq911_curs2 CURSOR FOR aglq911_prepare2 
                 
  #FOREACH aglq911_curs2 INTO g_aba[g_cnt].*,l_aba24,l_aba37,l_aba38
   FOREACH aglq911_curs2 INTO g_aba[g_cnt].*
     IF STATUS THEN 
        CALL cl_err('foreach:',STATUS,1)        
        EXIT FOREACH
     END IF
 
     SELECT gem02 INTO g_aba[g_cnt].gem02 FROM gem_file
      WHERE gem01 = g_aba[g_cnt].abb05
     
     SELECT gen02 INTO g_aba[g_cnt].gen02 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba24
     SELECT gen02 INTO g_aba[g_cnt].gen02_1 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba37
     SELECT gen02 INTO g_aba[g_cnt].gen02_2 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba38
     
     CALL q911_get_abb03_1(g_aba[g_cnt].aba01,g_aba[g_cnt].abb06) RETURNING g_aba[g_cnt].abb03_1  #FUN-D10072
     IF g_aba[g_cnt].abb06='1' THEN 
        LET g_aba[g_cnt].amt_d=g_aba[g_cnt].abb07 LET g_aba[g_cnt].amt_c=0
     ELSE 
     	  LET g_aba[g_cnt].amt_d=0 LET g_aba[g_cnt].amt_c=g_aba[g_cnt].abb07           
     END IF
     IF g_aba[g_cnt].abb06='1' THEN 
        LET g_aba[g_cnt].rec_d=g_aba[g_cnt].abb07f 
        LET g_aba[g_cnt].rec_c=0
     ELSE 
  	  LET g_aba[g_cnt].rec_d=0 
   	  LET g_aba[g_cnt].rec_c=g_aba[g_cnt].abb07f           
     END IF

     
     LET l_tot1 = l_tot1 + g_aba[g_cnt].abb07f
     LET l_tot2 = l_tot2 + g_aba[g_cnt].amt_d
     LET l_tot3 = l_tot3 + g_aba[g_cnt].amt_c
     LET l_abb05 = g_aba[g_cnt].abb05       
 
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
     END IF     
   END FOREACH
   
#  LET g_aba[g_cnt].gem02 = cl_getmsg('amr-003',g_lang)  #合計   #FUN-C80102
   LET g_aba[g_cnt].abb05 = l_abb05," "," ",cl_getmsg('amr-003',g_lang)  #合計   #FUN-C80102
   LET g_aba[g_cnt].abb07f = l_tot1
   LET g_aba[g_cnt].aag13 = p_abb05
   LET g_aba[g_cnt].amt_d = l_tot2
   LET g_aba[g_cnt].amt_c = l_tot3
   
#FUN-C80102--add--str--
   DISPLAY ARRAY g_aba TO s_aba.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
          EXIT DISPLAY
      END DISPLAY 
   #FUN-C80102--add--end-- 
        
END FUNCTION

FUNCTION q911_get_abb03(p_wc,p_abb03)  
DEFINE p_wc  STRING
DEFINE p_abb03  LIKE abb_file.abb03
DEFINE l_tot1,l_tot2,l_tot3,l_tot4,l_tot5,l_tot6  LIKE oma_file.oma56t
DEFINE l_aba24  LIKE aba_file.aba24
DEFINE l_aba37  LIKE aba_file.aba37
DEFINE l_aba38  LIKE aba_file.aba38
DEFINE l_abb03  LIKE abb_file.abb03  #FUN-C80102
DEFINE l_sql  STRING

  LET l_tot1 = 0  
  LET l_tot2 = 0
  LET l_tot3 = 0
  LET l_tot4 = 0
  
   LET l_sql = "SELECT aba00,aba01,aba02,aba03,aba04,",
              #" abb02,abb04,abb03,aag02,aag13,abb05,'',abb24,abb25,abb06,abb07,abb07f,abb11,",     #FUN-D10072
               " abb02,abb04,abb03,aag02,aag13,'',abb05,'',abb24,abb25,abb06,abb07,abb07f,abb11,",  #FUN-D10072
               " abb12,abb13,abb14,abb35,abb36,abb37,0,0,0,0,",  #FUN-C80102 add abb25 abb12-abb37
              #" '','','',aba06,aba07,", 
               " aba24,'',aba37,'',aba38,'',aba06,aba07 ", 
              #" aba24,aba37,aba38",
              #" FROM aba_file, abb_file, OUTER aag_file",   #FUN-C80102
               " FROM aba_file, abb_file  LEFT OUTER JOIN aag_file ON abb03 = aag01 AND abb00 = aag00 ",   #FUN-C80102
               " WHERE aba00 = abb00",
              #"   AND aba00 = aag00",    #FUN-C80102   
               "   AND aba01 = abb01",
              #"   AND abb_file.abb03 = aag_file.aag01",   #FUN-C80102
               "   AND abaacti='Y'",
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   AND abb03 = '",p_abb03,"'",
              #"   AND ",tm.wc,                  #FUN-C80102
               "   AND aba00 = '",g_bookno,"'",  #FUN-C80102
               "   AND ",tm.wc2,                 #FUN-C80102
               "   ORDER BY abb02"
  #FUN-C80012--mark--str--
  #CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
  #     WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
  #END CASE
  #FUN-C80012--mark--end
 
   PREPARE aglq911_prepare3 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)      
      RETURN
   END IF
   DECLARE aglq911_curs3 CURSOR FOR aglq911_prepare3  
                                                               
  #FOREACH aglq911_curs3 INTO g_aba[g_cnt].*,l_aba24,l_aba37,l_aba38
   FOREACH aglq911_curs3 INTO g_aba[g_cnt].*
     IF STATUS THEN 
        CALL cl_err('foreach:',STATUS,1)        
        EXIT FOREACH
     END IF
 
     SELECT gem02 INTO g_aba[g_cnt].gem02 FROM gem_file
      WHERE gem01 = g_aba[g_cnt].abb05
     
     SELECT gen02 INTO g_aba[g_cnt].gen02 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba24
     SELECT gen02 INTO g_aba[g_cnt].gen02_1 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba37
     SELECT gen02 INTO g_aba[g_cnt].gen02_2 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba38
     
     CALL q911_get_abb03_1(g_aba[g_cnt].aba01,g_aba[g_cnt].abb06) RETURNING g_aba[g_cnt].abb03_1  #FUN-D10072
     IF g_aba[g_cnt].abb06='1' THEN 
        LET g_aba[g_cnt].amt_d=g_aba[g_cnt].abb07 LET g_aba[g_cnt].amt_c=0
     ELSE 
     	  LET g_aba[g_cnt].amt_d=0 LET g_aba[g_cnt].amt_c=g_aba[g_cnt].abb07           
     END IF
     IF g_aba[g_cnt].abb06='1' THEN 
        LET g_aba[g_cnt].rec_d=g_aba[g_cnt].abb07f 
        LET g_aba[g_cnt].rec_c=0
     ELSE 
     	  LET g_aba[g_cnt].rec_d=0 
     	  LET g_aba[g_cnt].rec_c=g_aba[g_cnt].abb07f           
     END IF

     
     LET l_tot1 = l_tot1 + g_aba[g_cnt].abb07f
     LET l_tot2 = l_tot2 + g_aba[g_cnt].amt_d
     LET l_tot3 = l_tot3 + g_aba[g_cnt].amt_c
     LET l_abb03 = g_aba[g_cnt].abb03  #FUN-C80102       
 
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
     END IF     
   END FOREACH
   
  #LET g_aba[g_cnt].gem02 = cl_getmsg('amr-003',g_lang)  #合計  #FUN-C80102
   LET g_aba[g_cnt].abb03 = l_abb03," "," ",cl_getmsg('amr-003',g_lang)  #合計  #FUN-C80102
   LET g_aba[g_cnt].abb07f = l_tot1
   LET g_aba[g_cnt].aag13 = p_abb03
   LET g_aba[g_cnt].amt_d = l_tot2
   LET g_aba[g_cnt].amt_c = l_tot3
      
   #FUN-C80102--add--str--
   DISPLAY ARRAY g_aba TO s_aba.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
          EXIT DISPLAY
      END DISPLAY 
   #FUN-C80102--add--end-- 
END FUNCTION


FUNCTION q911_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aba TO s_aba.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index,g_row_count )
         IF g_rec_b != 0 AND l_ac != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)     
         END IF                            

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY      

      {ON ACTION query_account
         LET g_action_choice="query_account"
         EXIT DISPLAY}    


      #FUN-C80102--add--str---
      ON ACTION qry_account
         LET l_ac =  ARR_CURR()
         IF l_ac > 0 THEN
           #TQC-D30014--add--str
           #根據1.aba06=‘AC'調用aglt130
           #    2.aba06 = ’RV‘调用aglt120
           #    3.aba06 not in 'AC','RV'调用aglt110
            SELECT aba06 INTO g_aba06 FROM aba_file
             WHERE aba00 = g_bookno
               AND aba01 = g_aba[l_ac].aba01
            IF g_aba06 = 'RV' THEN LET g_cmd = "aglt120 "," '",g_bookno,"' "," "," '",g_aba[l_ac].aba01 ,"' " END IF
            IF g_aba06 = 'AC' THEN LET g_cmd = "aglt130 "," '",g_aba[l_ac].aba01,"' "," "," '",g_bookno ,"' " END IF
            IF g_aba06 != 'RV' AND g_aba06 !='AC' THEN
           #TQC-D30014--add--end
               LET g_cmd = "aglt110 "," '",g_aba[l_ac].aba01,"' "," "," '",g_bookno ,"' " 
            END IF #TQC-D30014 add
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF    
      #FUN-C80102--add--end---

      #FUN-C80102--add--str--
      ON ACTION first 
         CALL q911_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)   
         END IF
         ACCEPT DISPLAY                   
                              
 
      ON ACTION previous
         CALL q911_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)   
         END IF
         ACCEPT DISPLAY                  
                              
 
      ON ACTION jump
         CALL q911_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)   
         END IF
         ACCEPT DISPLAY                   
                              
 
      ON ACTION next
         CALL q911_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
                              
 
      ON ACTION last
         CALL q911_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)    
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY 
      #FUN-C80102--add--end-- 

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

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document 
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-C80102--add--str--
FUNCTION q911_cs()
   DEFINE  l_cnt LIKE type_file.num5   
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01     
   DEFINE li_chk_bookno  LIKE type_file.num5
 
   CLEAR FORM #清除畫面
   CALL g_aba.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                   # Default condition
   LET tm.u = ' '
   LET tm.d = '5'   
   LET tm.a = 'N'   
   LET tm.b11 = 'N' 
   LET tm.b12 = 'N' 
   LET tm.b13 = 'N' 
   LET tm.b14 = 'N' 
   LET tm.b35 = 'N' 
   LET tm.b36 = 'N' 
   LET tm.b37 = 'N' 
   
   CALL cl_set_comp_visible("rec_c,rec_d,abb24,abb25",FALSE) 
   CALL cl_set_comp_visible("abb11,abb12,abb13,abb14,abb35,abb36,abb37",FALSE) 
 
#  INITIALIZE g_bookno TO NULL  #FUN-C80102 
      DIALOG ATTRIBUTE(UNBUFFERED) 
      #FUN-C80102
      INPUT g_bookno FROM aba00 ATTRIBUTE(WITHOUT DEFAULTS)
         AFTER FIELD aba00
           IF NOT cl_null(g_bookno) THEN
              CALL s_check_bookno(g_bookno,g_user,g_plant)
                  RETURNING li_chk_bookno
              IF (NOT li_chk_bookno) THEN
                  NEXT FIELD aba00
              END IF
              SELECT aaa02 FROM aaa_file WHERE aaa01 = g_bookno
              IF STATUS THEN
                 CALL cl_err3("sel","aaa_file",g_bookno,"","agl-043","","",0)
                 NEXT FIELD  aba00
              END IF
           END IF
         END INPUT
      #FUN-C80102

      INPUT BY NAME tm.u,tm.d,tm.a,                               #FUN-C80102 add tm.a 
                    tm.b11,tm.b12,tm.b13,tm.b14, #FUN-C80102 add abb11-abb37 
                    tm.b35,tm.b36,tm.b37  #FUN-C80102 add abb11-abb37                  
         ATTRIBUTE(WITHOUT DEFAULTS)   
        
         BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)    

#        AFTER FIELD u
#           IF tm.u NOT MATCHES "[123]" THEN 
#              NEXT FIELD u 
#           END IF

         AFTER FIELD d
            IF tm.d NOT MATCHES "[12345]" THEN
               NEXT FIELD d 
            END IF
 
         AFTER FIELD a  
            IF tm.a NOT MATCHES "[YN]" THEN NEXT FIELD a END IF 
            IF tm.a = 'Y' THEN
               CALL cl_set_comp_visible("rec_d,rec_c,abb24,abb25",TRUE) 
            ELSE
               CALL cl_set_comp_visible("rec_d,rec_c,abb24,abb25",FALSE) 
            END IF   
         
         AFTER FIELD b11
            IF tm.b11 = 'Y' THEN CALL cl_set_comp_visible("abb11",TRUE)
                            ELSE CALL cl_set_comp_visible("abb11",FALSE) END IF     
         AFTER FIELD b12
            IF tm.b12 = 'Y' THEN CALL cl_set_comp_visible("abb12",TRUE) 
                            ELSE CALL cl_set_comp_visible("abb12",FALSE) END IF     
         AFTER FIELD b13
            IF tm.b13 = 'Y' THEN CALL cl_set_comp_visible("abb13",TRUE) 
                            ELSE CALL cl_set_comp_visible("abb13",FALSE) END IF     
         AFTER FIELD b14
            IF tm.b14 = 'Y' THEN CALL cl_set_comp_visible("abb14",TRUE) 
                            ELSE CALL cl_set_comp_visible("abb14",FALSE) END IF     
         AFTER FIELD b35
            IF tm.b35 = 'Y' THEN CALL cl_set_comp_visible("abb35",TRUE) 
                            ELSE CALL cl_set_comp_visible("abb35",FALSE) END IF     
         AFTER FIELD b36
            IF tm.b36 = 'Y' THEN CALL cl_set_comp_visible("abb36",TRUE) 
                            ELSE CALL cl_set_comp_visible("abb36",FALSE) END IF     
         AFTER FIELD b37
            IF tm.b37 = 'Y' THEN CALL cl_set_comp_visible("abb37",TRUE) 
                            ELSE CALL cl_set_comp_visible("abb37",FALSE) END IF     

      END INPUT

                                                                                          
      ON ACTION CONTROLP                                                                                                              
          CASE                   
            
             #FUN-C80102 
             WHEN INFIELD(aba00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = g_bookno
                  CALL cl_create_qry() RETURNING g_bookno
                  DISPLAY BY NAME g_bookno
                  NEXT FIELD aba00
             #FUN-C80102
          OTHERWISE EXIT CASE                                                                                                       
       END CASE
                                                                                              
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION accept
#         IF cl_null(g_bookno) THEN
#            CALL cl_err('','aap-099',0)
#            NEXT FIELD aba00
#         ELSE
#            EXIT DIALOG
#         END IF 
          ACCEPT DIALOG


       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG


 
      END DIALOG   
   
     #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null)   #0907
      LET tm.wc = tm.wc2 CLIPPED,cl_get_extra_cond(null, null)  #0907
      IF INT_FLAG THEN RETURN END IF
      CALL q911_b_askkey()
      IF INT_FLAG THEN RETURN END IF

      IF tm.wc2 = " 1=1" THEN 
         LET g_sql = "SELECT distinct aba00 FROM aba_file ",
                     " WHERE abaacti='Y'",
                     "   AND aba19 <> 'X' ",  #CHI-C80041
                     "   AND aba00 = '",g_bookno,"'"   #0907
                    #"   AND ",tm.wc                  #0907   
     ELSE
         LET g_sql = "SELECT distinct aba00 FROM aba_file,abb_file",
                     " WHERE aba00 = abb00",
                     "   AND aba01 = abb01",
                     "   AND abaacti='Y'",
                     "   AND aba19 <> 'X' ",  #CHI-C80041
                     "   AND aba00 = '",g_bookno,"'",  #0907
                    #"   AND ",tm.wc CLIPPED, #0907
                     "   AND ",tm.wc2 CLIPPED
     END IF
     PREPARE q911_pb FROM g_sql
     DECLARE q911_cs SCROLL CURSOR FOR q911_pb
END FUNCTION

FUNCTION q911_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    LET g_cnt = 0 #TQC-D30014 add
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL q911_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE "SERCHING!"
    OPEN q911_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       CALL q911_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION q911_fetch(p_flag)
DEFINE
    p_flag         LIKE type_file.chr1,           #處理方式  #No.FUN-680098   VARCHAR(1)    
    l_abso         LIKE type_file.num10           #絕對的筆數   #No.FUN-680098 integer   
 
    CASE p_flag
        WHEN 'N'  FETCH NEXT     q911_cs INTO g_bookno 
        WHEN 'P'  FETCH PREVIOUS q911_cs INTO g_bookno
        WHEN 'F'  FETCH FIRST    q911_cs INTO g_bookno
        WHEN 'L'  FETCH LAST     q911_cs INTO g_bookno
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about          
                     CALL cl_about()       
 
                  ON ACTION HELP           
                     CALL cl_show_help()  
 
                  ON ACTION controlg       
                     CALL cl_cmdask()      
 
               END PROMPT
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
            END IF
            FETCH ABSOLUTE g_jump q911_cs INTO g_bookno 
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bookno,SQLCA.sqlcode,0)
        INITIALIZE g_bookno TO NULL 
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL q911_show()
END FUNCTION   

FUNCTION q911_show()
   SELECT * INTO g_bookno FROM aba_file WHERE aba00 = g_bookno
   DISPLAY g_bookno TO aba00
   #FUN-C80102
   IF tm.a = 'Y' THEN 
      CALL cl_set_comp_visible("rec_d,rec_c,abb24,abb25",TRUE)
   ELSE
      CALL cl_set_comp_visible("rec_d,rec_c,abb24,abb25",FALSE)
   END IF

   CALL cl_set_comp_visible("abb11",tm.b11='Y')
   CALL cl_set_comp_visible("abb12",tm.b12='Y')
   CALL cl_set_comp_visible("abb13",tm.b13='Y')
   CALL cl_set_comp_visible("abb14",tm.b14='Y')
   CALL cl_set_comp_visible("abb35",tm.b35='Y')
   CALL cl_set_comp_visible("abb36",tm.b36='Y')
   CALL cl_set_comp_visible("abb37",tm.b37='Y')
   #FUN-C80102

   CALL aglq911_b_fill()  
   CALL cl_show_fld_cont()                    
END FUNCTION

FUNCTION q911_b_askkey()
  #CONSTRUCT tm.wc2 ON aba01,aba02,abb02,abb03,abb05,abb06,abb11  #FUN-C80102
   CONSTRUCT tm.wc2 ON aba01,aba02,aba03,aba04,abb02,abb04,abb03,
                       abb05,abb24,abb25,abb06,abb07f,abb11,abb12,
                       abb13,abb14,abb35,abb36,abb37,aba24,aba37,aba38,aba06,aba07  #FUN-C80102
                 #FROM s_aba[1].aba01 ,s_aba[1].aba02 ,s_aba[1].abb02 ,  #FUN-C80102
                 #     s_aba[1].abb03 ,s_aba[1].abb05 ,s_aba[1].abb06 ,
                 #     s_aba[1].abb11
                  FROM s_aba[1].aba01,s_aba[1].aba02,s_aba[1].aba03,s_aba[1].aba04,s_aba[1].abb02,s_aba[1].abb04,
                       s_aba[1].abb03,s_aba[1].abb05,s_aba[1].abb24,s_aba[1].abb25,s_aba[1].abb06,s_aba[1].abb07f,
                       s_aba[1].abb11,s_aba[1].abb12,s_aba[1].abb13,s_aba[1].abb14,
                       s_aba[1].abb35,s_aba[1].abb36,s_aba[1].abb37,s_aba[1].aba24,s_aba[1].aba37,
                       s_aba[1].aba38,s_aba[1].aba06,s_aba[1].aba07  #FUN-C80102
              
      BEFORE CONSTRUCT
         CALL cl_qbe_init()


      ON ACTION CONTROLP
       CASE
         WHEN INFIELD(aba01)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = 'q_aba'  
              LET g_qryparam.arg1 = g_bookno               
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aba01
              NEXT FIELD aba01

         WHEN INFIELD(abb03)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.where = " aag00 = '",g_bookno CLIPPED,"'"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO abb03
              NEXT FIELD abb03

         WHEN INFIELD(abb24)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_azi"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO abb24


         WHEN INFIELD(abb05)     #部門
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_gem"       
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO abb05
              NEXT FIELD abb05

         WHEN INFIELD(aba24) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aba24
              NEXT FIELD aba24
 
         WHEN INFIELD(aba37) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aba37
              NEXT FIELD aba37

         WHEN INFIELD(aba38) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aba38
              NEXT FIELD aba38

             WHEN INFIELD(abb11)    #查詢異動碼-1
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aee"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb11
               WHEN INFIELD(abb12)    #查詢異動碼-2
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb12
               WHEN INFIELD(abb13)    #查詢異動碼-3
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb13
               WHEN INFIELD(abb14)    #查詢異動碼-4
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb14

               WHEN INFIELD(abb35)    #查詢異動碼-9
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pjb4"   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb35
               WHEN INFIELD(abb36)    #查詢異動碼-10-預算項目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azf01a"              
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb36
               WHEN INFIELD(abb37)    #查詢關係人異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aee"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abb37
         

         OTHERWISE EXIT CASE
       END CASE  
        
             
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP          
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()    
		 
      ON ACTION qbe_select
    	 CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
	 
   END CONSTRUCT
END FUNCTION
#FUN-C80102--add--str--

#FUN-C80102
FUNCTION q911_get_abb(p_wc) 
DEFINE p_wc  STRING
DEFINE l_tot1,l_tot2,l_tot3,l_tot4,l_tot5,l_tot6  LIKE oma_file.oma56t
DEFINE l_aba24  LIKE aba_file.aba24
DEFINE l_aba37  LIKE aba_file.aba37
DEFINE l_aba38  LIKE aba_file.aba38
DEFINE l_sql  STRING
  
  LET l_tot1 = 0  
  LET l_tot2 = 0
  LET l_tot3 = 0
  LET l_tot4 = 0

  
   LET l_sql = "SELECT aba00,aba01,aba02,aba03,aba04,",
              #" abb02,abb04,abb03,aag02,aag13,abb05,'',abb24,abb25,abb06,abb07,abb07f,abb11,",     #FUN-D10072
               " abb02,abb04,abb03,aag02,aag13,'',abb05,'',abb24,abb25,abb06,abb07,abb07f,abb11,",  #FUN-D10072 
               " abb12,abb13,abb14,abb35,abb36,abb37,0,0,0,0,", 
               " aba24,'',aba37,'',aba38,'',aba06,aba07 ", 
               " FROM aba_file, abb_file LEFT OUTER JOIN aag_file ON abb03 = aag01 AND abb00 = aag00 ", #FUN-C80102
               " WHERE aba00 = abb00", 
               "   AND aba01 = abb01",
               "   AND abaacti='Y'",
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   AND aba00 = '",g_bookno,"'",  
               "   AND ",tm.wc2 CLIPPED  
   
   CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
        WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
        WHEN tm.d = '3' LET l_sql = l_sql CLIPPED," AND aba19 = 'N' "
        WHEN tm.d = '4' LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
   END CASE
  
   LET l_sql = l_sql CLIPPED," ORDER BY abb01 "
   
 
   PREPARE aglq911_pre FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1)      
      RETURN
   END IF
   DECLARE aglq911_cur CURSOR FOR aglq911_pre  
            
   FOREACH aglq911_cur INTO g_aba[g_cnt].*
     IF STATUS THEN 
        CALL cl_err('foreach:',STATUS,1)        
        EXIT FOREACH
     END IF
 
     SELECT gem02 INTO g_aba[g_cnt].gem02 FROM gem_file
      WHERE gem01 = g_aba[g_cnt].abb05
     
     SELECT gen02 INTO g_aba[g_cnt].gen02 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba24
     SELECT gen02 INTO g_aba[g_cnt].gen02_1 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba37
     SELECT gen02 INTO g_aba[g_cnt].gen02_2 FROM gen_file WHERE gen01 = g_aba[g_cnt].aba38

     CALL q911_get_abb03_1(g_aba[g_cnt].aba01,g_aba[g_cnt].abb06) RETURNING g_aba[g_cnt].abb03_1  #FUN-D10072
     IF g_aba[g_cnt].abb06='1' THEN 
        LET g_aba[g_cnt].amt_d=g_aba[g_cnt].abb07 
        LET g_aba[g_cnt].amt_c=0
     ELSE 
     	  LET g_aba[g_cnt].amt_d=0 
     	  LET g_aba[g_cnt].amt_c=g_aba[g_cnt].abb07           
     END IF
     IF g_aba[g_cnt].abb06='1' THEN 
        LET g_aba[g_cnt].rec_d=g_aba[g_cnt].abb07f 
        LET g_aba[g_cnt].rec_c=0
     ELSE 
     	  LET g_aba[g_cnt].rec_d=0 
     	  LET g_aba[g_cnt].rec_c=g_aba[g_cnt].abb07f           
     END IF


     LET l_tot1 = l_tot1 + g_aba[g_cnt].abb07f
     LET l_tot2 = l_tot2 + g_aba[g_cnt].amt_d
     LET l_tot3 = l_tot3 + g_aba[g_cnt].amt_c
     LET l_tot4 = l_tot4 + g_aba[g_cnt].amt_d - g_aba[g_cnt].amt_c 
     LET l_tot5 = l_tot5 + g_aba[g_cnt].rec_d
     LET l_tot6 = l_tot6 + g_aba[g_cnt].rec_c
        
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
     END IF     
   END FOREACH
   

   LET g_aba[g_cnt].aba01 = cl_getmsg('alm-h87',g_lang)  #总計 #TQC-D60022 'cmr-003'->'alm-h87'
   LET g_aba[g_cnt].abb07f = l_tot1
   LET g_aba[g_cnt].amt_d = l_tot2
   LET g_aba[g_cnt].amt_c = l_tot3
   LET g_aba[g_cnt].rec_d = l_tot5
   LET g_aba[g_cnt].rec_c = l_tot6
 
   DISPLAY ARRAY g_aba TO s_aba.* ATTRIBUTE(COUNT=g_cnt)
      BEFORE DISPLAY
          EXIT DISPLAY
      END DISPLAY 
 
END FUNCTION
#FUN-C80102
#FUN-D10072--add
FUNCTION q911_get_abb03_1(p_aba01,p_abb06)
DEFINE p_aba01 LIKE aba_file.aba01
DEFINE p_abb06 LIKE abb_file.abb06
DEFINE l_abb03    LIKE type_file.chr1000  
DEFINE l_abb03_t  LIKE type_file.chr1000  
DEFINE l_sql      STRING

   LET l_sql = "  SELECT DISTINCT abb03 FROM abb_file LEFT OUTER JOIN aba_file ON abb01 = aba01 ",
               "      WHERE aba01 = '",p_aba01,"'  AND abb06 != '",p_abb06,"' ",
               "      ORDER BY abb03 "     
   PREPARE aglq911_pb_abb03 FROM l_sql
   DECLARE aglq911_curs_abb03 CURSOR FOR aglq911_pb_abb03
   LET l_abb03_t = NULL
   FOREACH aglq911_curs_abb03 INTO l_abb03 
        IF STATUS THEN
           CALL cl_err('foreach:aglq911_curs_abb03',STATUS,1)
           EXIT FOREACH
        END IF
        IF NOT cl_null(l_abb03_t) THEN
           IF NOT cl_null(l_abb03) THEN
              LET l_abb03 = l_abb03_t,",",l_abb03 
           ELSE
              LET l_abb03 = l_abb03_t
           END IF
        END IF
        LET l_abb03_t = l_abb03    
   END FOREACH   
   RETURN l_abb03  
END FUNCTION
#FUN-D10072--add

