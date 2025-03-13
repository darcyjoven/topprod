# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi590.4gl
# Descriptions...: 積分換券設定作業 
# Date & Author..: 08/11/12 By hongmei                                                                                                
# Modify.........: No.FUN-960134 09/07/17 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:MOD-A30218 10/03/26 By Smapmin 程式改善
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-A80022 10/09/15 BY suncx add lstpos已傳POS否
# Modify.........: No.MOD-B10146 11/01/21 By huangtao 取消簽核功能 
# Modify.........: No.TQC-B30004 11/03/10 By suncx 取消已傳POS否
# Modify.........: No:FUN-B50042 11/05/10 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B60077 11/06/09 By baogc 將lstpos欄位預設為 '1'
# Modify.........: No.FUN-B60059 11/06/13 By baogc 將程式由t類改成i類
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode,是另外一組的,在五行以外
# Modify.........: No.FUN-BC0058 11/12/16 By yangxf 加入兌換來源類型
# Modify.........: No.TQC-C30054 12/03/03 By pauline mark lss06,lpx02欄位 
# Modify.........: No.TQC-C30136 12/03/08 By xujing 處理ON ACITON衝突問題
# Modify.........: No.FUN-C50085 12/05/28 By pauline 積分換券優化處理 
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60089 12/07/20 By pauline 將兌換來源納入PK值
# Modify.........: No.CHI-C80047 12/08/21 By pauline 將卡種納入PK值
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE
    g_lst           RECORD LIKE lst_file.*,        
    g_lst_t         RECORD LIKE lst_file.*,       
    g_lst_o         RECORD LIKE lst_file.*,
    g_lst01         LIKE lst_file.lst01,      
    g_lst01_t       LIKE lst_file.lst01,            
    g_ydate         DATE,                                
    g_lss           DYNAMIC ARRAY OF RECORD       #
        lss02       LIKE lss_file.lss02,          #積分達
        lss03       LIKE lss_file.lss03,          #累計消費達   FUN-BC0058 ADD
        lss04       LIKE lss_file.lss04,          #兌換基數
        lss05       LIKE lss_file.lss05           #兌換基數換券金額
       #lss06       LIKE lss_file.lss06,          #券類型編號  #TQC-C30054 mark
       #lpx02       LIKE lpx_file.lpx02           #券類型名稱  #TQC-C30054 mark
                    END RECORD,
    g_lss_t         RECORD                        #
        lss02       LIKE lss_file.lss02,      
        lss03       LIKE lss_file.lss03,          #FUN-BC0058 ADD    
        lss04       LIKE lss_file.lss04,
        lss05       LIKE lss_file.lss05 
       #lss06       LIKE lss_file.lss06,  #TQC-C30054 mark
       #lpx02       LIKE lpx_file.lpx02   #TQC-C30054 mark
                    END RECORD, 
    g_lss_o         RECORD                        #
        lss02       LIKE lss_file.lss02,          
        lss03       LIKE lss_file.lss03,          #FUN-BC0058 ADD
        lss04       LIKE lss_file.lss04,
        lss05       LIKE lss_file.lss05 
       #lss06       LIKE lss_file.lss06,  #TQC-C30054 mark
       #lpx02       LIKE lpx_file.lpx02   #TQC-C30054 mark
                    END RECORD,
    g_lsr           DYNAMIC ARRAY OF RECORD      
        lsr02       LIKE lsr_file.lsr02,         
        lpx02_1     LIKE lpx_file.lpx02       
                    END RECORD,
    g_lsr_t         RECORD                       
        lsr02       LIKE lsr_file.lsr02,         
        lpx02_1     LIKE lpx_file.lpx02 
                    END RECORD, 
    g_lsr_o         RECORD                       
        lsr02       LIKE lsr_file.lsr02,         
        lpx02_1     LIKE lpx_file.lpx02  
                    END RECORD,        
    g_sql           STRING,                       #CURSOR
    g_wc            STRING,                       #
    g_wc2           STRING, 
    g_wc3           STRING,                       #No.FUN-960134
    g_rec_b         LIKE type_file.num5, 
    g_rec_b1        LIKE type_file.num5,          #No.FUN-960134         
    l_ac            LIKE type_file.num5          
                                             
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE 
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10 
DEFINE g_jump              LIKE type_file.num10 
DEFINE g_no_ask            LIKE type_file.num5  
DEFINE g_argv1             LIKE lst_file.lst01 
DEFINE g_argv2             STRING             
DEFINE g_b_flag            STRING                 
DEFINE g_flag              LIKE type_file.chr1     #FUN-BC0058 add 
DEFINE g_t1                LIKE oay_file.oayslip   #FUN-BC0058 add
DEFINE g_lni02             LIKE lni_file.lni02     #FUN-C60089 add   #類別  
DEFINE g_lst03_t           LIKE lst_file.lst03     #CHI-C80047 add
MAIN
   OPTIONS                             
       INPUT NO WRAP    #No.FUN-9B0136
   #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT                
   LET g_argv1 = ARG_VAL(1)       #FUN-BC0058 ADD    
                        
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
    
   WHENEVER ERROR CALL cl_err_msg_log
   IF g_argv1 = '1' THEN 
      LET g_prog = 'almi591'
      LET g_lni02 = '2'  #FUN-C60089 add #累計消費換券
   ELSE                  #FUN-C60089 add
      LET g_lni02 = '1'  #FUN-C60089 add #積分換券
   END IF 

  #FUN-C60089 add START
   IF cl_null(g_argv1) THEN
      LET g_lst.lst00 = '0'
   ELSE
      IF g_argv1 = '1' THEN
         LET g_lst.lst00 = '1'
      END IF
   END IF
  #FUN-C60089 add END

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
  #LET g_forupd_sql = "SELECT * FROM lst_file WHERE lst01 = ? AND lst14 = ? FOR UPDATE"  #FUN-C50085 add lst14   #FUN-C60089 mark
  #LET g_forupd_sql = "SELECT * FROM lst_file WHERE lst01 = ? AND lst14 = ? AND lst00 = ? FOR UPDATE"   #FUN-C60089 add   #CHI-C80047 mark
   LET g_forupd_sql = "SELECT * FROM lst_file WHERE lst01 = ? AND lst14 = ? ",            #CHI-C80047 add
                      "                         AND lst00 = ? AND lst03 = ? FOR UPDATE"   #CHI-C80047 add
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i590_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i590_w WITH FORM "alm/42f/almi590"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   #FUN-BC0058 ---begin---
   IF cl_null(g_argv1) THEN 
      CALL cl_set_comp_visible("lst13,lss03",FALSE)
   ELSE 
      IF g_argv1 = '1' THEN 
         CALL cl_set_comp_visible("lss02",FALSE)
      END IF 
   END IF   

   DISPLAY BY NAME g_lst.lst00    #FUN-C60089 add

   #FUN-BC0058 ---end---
   #TQC-B30004 ------mark begin---------------
   ##FUN-A80022 -----------------add satrt---------------------
   #IF g_aza.aza88 = 'Y' THEN
   #   CALL cl_set_comp_visible("lstpos",TRUE)
   # ELSE
   #   CALL cl_set_comp_visible("lstpos",FALSE)
   # END IF
   ##FUN-A8002 ---------------------add end by vealxu -----------
   #TQC-B30004 ------mark--end----------------
   CALL cl_set_comp_visible("lstpos",FALSE) #TQC-B30004 add
   LET g_action_choice = ""
   CALL i590_menu()
   CLOSE WINDOW i590_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION i590_cs()
 
   CLEAR FORM          
   CALL g_lss.clear()  
   CALL g_lsr.clear()
   #FUN-BC0058 ---begin---
   IF cl_null(g_argv1) THEN
      LET g_lst.lst00 = '0'
   ELSE
      IF g_argv1 = '1' THEN
         LET g_lst.lst00 = '1'
      END IF
   END IF
   DISPLAY BY NAME g_lst.lst00
   #FUN-BC0058 ---END ---
 #  CONSTRUCT BY NAME g_wc ON lstplant,lstlegal,lst01,lst02,lst03,lst04,lst05,lst06,lst07,lstpos,      #FUN-A80022 add lstpos    #MOD-B10146 mark
 #                            lst08,lst09,lst10,lst11,lst12,                                          #MOD-B10146  mark
 #  CONSTRUCT BY NAME g_wc ON lstplant,lstlegal,lst01,lst02,lst03,lst04,lst05,lst06,                  #MOD-B10146  #FUN-B50042 remove POS #FUN-BC0058 mark
    CONSTRUCT BY NAME g_wc ON lst14,lst01,lst15,lst03,lst04,lst05,lst06,               #FUN-BC0058     #FUN-C50085 add lst14,lst15,remove lst02
                              lst18,lst19,                                                   #FUN-C50085 add
                              lst13,lst09,lst10,lst11,lst16,lst17,lst12,lstplant,lstlegal,   #MOD-B10146  #FUN-BC0058 add lst13,lstplant,lstlegal  #FUN-C50085 add lst16,lst17
                              lstuser,lstgrup,lstoriu,lstorig,  #No.FUN-9B0136
                              lstcrat,lstmodu,lstacti,lstdate
      ON ACTION controlp
         CASE
           WHEN INFIELD(lstplant)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lstplant"
#FUN-BC0058 add begin ---
              IF cl_null(g_argv1) THEN
                 LET g_qryparam.where = " lst00 = '0' "
              ELSE 
                 LET g_qryparam.where = " lst00 = '",g_argv1,"'"
              END IF 
#FUN-BC0058 add end ----
              LET g_qryparam.state = "c"              
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lstplant
              NEXT FIELD lstplant                     
      
           WHEN INFIELD(lstlegal)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lstlegal"
#FUN-BC0058 add begin ---
              IF cl_null(g_argv1) THEN
                 LET g_qryparam.where = " lst00 = '0' "
              ELSE 
                 LET g_qryparam.where = " lst00 = '",g_argv1,"'"
              END IF  
#FUN-BC0058 add end ----
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lstlegal
              NEXT FIELD lstlegal
            WHEN INFIELD(lst01)   #方案編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lst"
#FUN-BC0058 add begin ---
               IF cl_null(g_argv1) THEN
                  LET g_qryparam.where = " lst00 = '0' " 
               ELSE 
                  LET g_qryparam.where = " lst00 = '",g_argv1,"'"     
               END IF 
#FUN-BC0058 add end ----
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lst01
               NEXT FIELD lst01
            WHEN INFIELD(lst03)   #卡種編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lst03"
#FUN-BC0058 add begin ---
               IF cl_null(g_argv1) THEN
                  LET g_qryparam.where = " lst00 = '0' "
               ELSE 
                  LET g_qryparam.where = " lst00 = '",g_argv1,"'"
               END IF 
#FUN-BC0058 add end ----
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lst03
               CALL i590_lst03('d')
               NEXT FIELD lst03
            WHEN INFIELD(lst10)  #審核人
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lst10"
#FUN-BC0058 add begin ---
               IF cl_null(g_argv1) THEN
                  LET g_qryparam.where = " lst00 = '0' "
               ELSE 
                  LET g_qryparam.where = " lst00 = '",g_argv1,"'"
               END IF 
#FUN-BC0058 add end ----
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lst10
               NEXT FIELD lst10    
           #FUN-C50085 add START
            WHEN INFIELD(lst14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lst14"
               IF cl_null(g_argv1) THEN
                  LET g_qryparam.where = " lst00 = '0' "
               ELSE
                  LET g_qryparam.where = " lst00 = '",g_argv1,"'"
               END IF
               LET g_qryparam.state = "c"
               CALL cl_create_qry()
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lst14
               NEXT FIELD lst14
           #FUN-C50085 add END 
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lstuser', 'lstgrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN       
   #      LET g_wc = g_wc clipped," AND lstuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN      
   #      LET g_wc = g_wc clipped," AND lstgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
     #CONSTRUCT g_wc2 ON lss02,lss03,lss04,lss05,lss06        #FUN-BC0058 add lss03  #TQC-C30054 mark
      CONSTRUCT g_wc2 ON lss02,lss03,lss04,lss05              #TQC-C30054 add
           FROM s_lss[1].lss02,s_lss[1].lss03,s_lss[1].lss04, #FUN-BC0058 add lss03
               #s_lss[1].lss05, s_lss[1].lss06   #TQC-C30054 mark
                s_lss[1].lss05  #TQC-C30054 add 

#TQC-C30054 mark START
#     ON ACTION CONTROLP 
#        CASE 
#          WHEN INFIELD(lss06)  #券類型編號
#             CALL cl_init_qry_var()
#             LET g_qryparam.state= "c"
#             LET g_qryparam.form ="q_lss06_1"
# #FUN-BC0058 add begin ---
#             IF cl_null(g_argv1) THEN
#                LET g_qryparam.arg1 = '0'
#             ELSE
#                LET g_qryparam.arg1 = g_argv1
#             END IF
# #FUN-BC0058 add end ----
#             CALL cl_create_qry() RETURNING g_qryparam.multiret
#             DISPLAY g_qryparam.multiret TO lss06 
#             NEXT FIELD lss06
#           OTHERWISE EXIT CASE
#        END CASE
#TQC-C30054 mark END 

         ON ACTION about
            CALL cl_about() 
             
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
       CONSTRUCT g_wc3 ON lsr02,lpx02_1
                FROM s_lsr[1].lsr02, s_lsr[1].lpx02_1  
           
           ON ACTION CONTROLP 
             CASE 
               WHEN INFIELD(lsr02)  #券類型編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form ="q_lsr02_1"
#FUN-BC0058 add begin ---
                  IF cl_null(g_argv1) THEN
                     LET g_qryparam.arg1 = '0' 
                  ELSE
                     LET g_qryparam.arg1 =g_argv1
                  END IF
#FUN-BC0058 add end ----
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO lsr02 
                  NEXT FIELD lsr02
                OTHERWISE EXIT CASE
             END CASE

           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
       
           ON ACTION about        
              CALL cl_about()     
       
           ON ACTION help         
              CALL cl_show_help() 
           
           ON ACTION controlg     
              CALL cl_cmdask()    
           
		       ON ACTION qbe_save
		          CALL cl_qbe_save()
       
       
       END CONSTRUCT
       IF INT_FLAG THEN
          RETURN
       END IF
        
       IF cl_null(g_wc3) THEN     
          LET g_wc3=' 1=1'
       END IF   
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
               
   #FUN-BC0058 ---begin--
   LET g_wc = " lst00 = '",g_lst.lst00,"' AND ",g_wc CLIPPED
   #FUN-BC0058 ---end---
   IF g_wc2 = " 1=1" THEN     
      IF g_wc3 = " 1=1" THEN  #FUN-C60089 add 
         LET g_sql = "SELECT lst01,lst14,lstplant,lst03 FROM lst_file ",  #FUN-C50085 add lst14,lstplant  #CHI-C80047 add lst03
                     " WHERE ", g_wc CLIPPED,
                     "   AND lstplant = '",g_plant ,"'",    #FUN-C60089 add
                     " ORDER BY lst01"
     #FUN-C60089 add START
      ELSE
         LET g_sql = " SELECT DISTINCT lst01,lst14,lstplant,lst03 ",   #CHI-C80047 add lst03 
                     "  FROM lst_file,lsr_file ",
                     "   WHERE lst00 = lsr00 AND lsr01 = lst01 ",
                     "     AND lsr04 = lst03 ",   #CHI-C80047 add 
                     "     AND lst14 = lsr03 ",
                     "     AND ",g_wc3 CLIPPED,
                     "     AND ",g_wc CLIPPED,
                     "     AND lstplant = '",g_plant ,"'",    #FUN-C60089 add
                     "     AND lstplant = lsrplant ",   #FUN-C60089 add
                     " ORDER BY lst01 "
      END IF
     #FUN-C60089 add END
   ELSE                      
      IF g_wc3 = " 1=1" THEN      #FUN-C60089 add
         LET g_sql = "SELECT UNIQUE lst01,lst14,lstplant,lst03 ",       #FUN-C50085 add lst14,lstplant  #CHI-C80047 add lst03
                     "  FROM lst_file, lss_file ",
                     " WHERE lst01 = lss01",
                     "   AND lst00 = lss00",   #FUN-C60089 add
                     "   AND lst03 = lss08",   #CHI-C80047 add
                     "   AND lst14 = lss07",   #FUN-C60089 add
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND lstplant = lssplant ",   #FUN-C60089 add
                     "   AND lstplant = '",g_plant ,"'",    #FUN-C60089 add
                     " ORDER BY lst01"
     #FUN-C60089 add START
      ELSE 
         LET g_sql = "SELECT UNIQUE lst01,lst14,lstplant,lst03 ",    #CHI-C80047 add lst03 
                     "  FROM lst_file, lss_file,lsr_file ",
                     " WHERE lst01 = lss01 ",
                     "   AND lst00 = lss00 ",    
                     "   AND lst03 = lss08 ",   #CHI-C80047 add
                     "   AND lst03 = lsr04 ",   #CHI-C80047 add
                     "   AND lss07 = lst14 ",
                     "   AND lst00 = lsr00 AND lsr01 = lst01 ",
                     "   AND lst14 = lsr03 ",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED,
                     "   AND lstplant = lssplant ",   #FUN-C60089 add
                     "   AND lstplant = lsrplant ",   #FUN-C60089 add
                     "   AND lstplant = '",g_plant ,"'",    #FUN-C60089 add
                     " ORDER BY lst01"
      END IF
     #FUN-C60089 add END
   END IF
 
   PREPARE i590_prepare FROM g_sql
   DECLARE i590_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i590_prepare
 
   IF g_wc2 = " 1=1" THEN   
      IF g_wc3 = " 1=1" THEN    #FUN-C60089 add 
         LET g_sql="SELECT COUNT(*) FROM lst_file ",
                   " WHERE ",g_wc CLIPPED, 
                   "   AND lstplant = '",g_plant,"' "    #FUN-C60089 add 
     #FUN-C60089 add START
      ELSE
         LET g_sql = " SELECT COUNT(*) ",
                     "  FROM lst_file,lsr_file ",
                     "   WHERE lst00 = lsr00 AND lsr01 = lst01 ",
                     "     AND lst03 = lsr04 ",   #CHI-C80047 add
                     "     AND lst14 = lsr03 AND lsrplant = lstplant ",
                     "     AND lstplant = lsrplant ",   #FUN-C60089 add
                     "     AND lstplant = '",g_plant ,"'",    #FUN-C60089 add 
                     "     AND ",g_wc3 CLIPPED,
                     "     AND ",g_wc CLIPPED
      END IF
     #FUN-C60089 add END
   ELSE
      IF g_wc3 = " 1=1" THEN    #FUN-C60089 add
         LET g_sql="SELECT COUNT(DISTINCT lst01) FROM lst_file,lss_file WHERE ",
                   "       lss01=lst01 AND lss00 = lst00 ",   #FUN-C60089 add
                   "   AND lst03 = lsr08 ",         #CHI-C80047 add
                   "   AND lstplant = lssplant ",   #FUN-C60089 add
                   "   AND lstplant = '",g_plant ,"'",    #FUN-C60089 add
                   "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
     #FUN-C60089 add START
      ELSE
         LET g_sql = "SELECT COUNT(DISTINCT lst01) ",
                     "  FROM lst_file, lss_file,lsr_file ",
                     " WHERE lst01 = lss01 ",
                     "   AND lst00 = lss00 ",
                     "   AND lst03 = lss08 ",   #CHI-C80047 add
                     "   AND lss07 = lst14 ",
                     "   AND lst00 = lsr00 AND lsr01 = lst01 ",
                     "   AND lst03 = lsr04 ",   #CHI-C80047 add
                     "   AND lst14 = lsr03 ",
                     "   AND lstplant = lssplant ",   #FUN-C60089 add
                     "   AND lstplant = lsrplant ",   #FUN-C60089 add
                     "   AND lstplant = '",g_plant ,"'",    #FUN-C60089 add
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND ", g_wc3 CLIPPED
      END IF
     #FUN-C60089 add END
   END IF
   PREPARE i590_precount FROM g_sql
   DECLARE i590_count CURSOR FOR i590_precount
 
END FUNCTION
 
FUNCTION i590_menu()
   DEFINE l_str  LIKE type_file.chr1000
   DEFINE l_msg  LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i590_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i590_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i590_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i590_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i590_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i590_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i590_copy()
            END IF
 
         WHEN "detail"
           IF cl_chk_act_auth() THEN         
             IF g_b_flag IS NULL OR g_b_flag ='1' THEN
                 CALL i590_b()
              ELSE 
              	 CALL i590_b1()
              END IF 
           ELSE
              LET g_action_choice = NULL
           END IF
            
#         WHEN "output"                                                        
#            IF cl_chk_act_auth() THEN
#               CALL i590_out()
#            END IF
            
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exporttoexcel"                                                   
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lst),'','')
            END IF
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            
#        WHEN "ef_approval"   #簽核
#           IF cl_chk_act_auth() THEN
#              CALL i590_ef()
#           END IF 
              
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i590_y()
            END IF
         
         WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
              CALL i590_z()
           END IF

         WHEN "category"
           IF cl_chk_act_auth() THEN
              IF g_lst.lst01 IS NULL THEN
                 CALL cl_err('',-400,0)
              ELSE 
                #LET l_msg = "almi553  '",g_lst.lst01 CLIPPED,"'  '1' '",g_lst.lst14 CLIPPED,"' "                    #FUN-C60089 mark 
                #LET l_msg = "almi553  '",g_lst.lst01 CLIPPED,"'  '",g_lni02 CLIPPED,"' '",g_lst.lst14 CLIPPED,"' "  #FUN-C60089 add   #CHI-C80047 mark        
                 LET l_msg = "almi553  '",g_lst.lst01 CLIPPED,"'  '",g_lni02 CLIPPED,"' '",g_lst.lst14 CLIPPED,"' '",g_lst.lst03 CLIPPED,"' "  #CHI-C80047 add 
                 CALL cl_cmdrun_wait(l_msg)
              END IF
           END IF

#        WHEN "volid"
#          IF cl_chk_act_auth() THEN
#             CALL i590_v()
#          END IF
       #FUN-C50085 add START
         WHEN "issued"
           IF cl_chk_act_auth() THEN
              CALL i590_iss()
           END IF
       #FUN-C50085 add END
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i590_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   CALL cl_set_act_visible("accept,cancel",FALSE )   #FUN-C50085 add

   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)   
#  DISPLAY ARRAY g_tc_npb TO s_tc_npb.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
   DISPLAY ARRAY g_lss TO s_lss.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY
      # CALL cl_set_act_visible("accept,cancel",FALSE )   #FUN-C50085 mark 
        LET g_b_flag='1'                                 
        CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
     #####TQC-C30136---mark---str##### 
     #ON ACTION accept
     #   LET g_action_choice="detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DIALOG
     #####TQC-C30136---mark---end#####
   END DISPLAY
   
   DISPLAY ARRAY g_lsr TO s_lsr.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
      #  CALL cl_set_act_visible("accept,cancel",FALSE )          #FUN-C50085 mark 
         CALL cl_navigator_setting( g_curs_index, g_row_count )   
         LET g_b_flag='2'
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 
     #####TQC-C30136---mark---str#####
     #ON ACTION accept
     #   LET g_action_choice="detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DIALOG
     #####TQC-C30136---mark---end#####
   END DISPLAY 
   
   BEFORE DIALOG   
       ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
   
      ON ACTION first
         CALL i590_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION previous
         CALL i590_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG 

      ON ACTION jump
         CALL i590_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL i590_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL i590_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

        
#     ON ACTION ef_approval    #簽核 
#        LET g_action_choice="ef_approval"
#        IF cl_chk_act_auth() THEN
#           CALL i590_ef()
#        END IF 

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
         
      ON ACTION confirm 
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL i590_y()
         END IF 
      
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         IF cl_chk_act_auth() THEN
            CALL i590_z()
         END IF

      ON ACTION category
         LET g_action_choice="category"
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

     #FUN-C50085 add START

       ON ACTION invalid
          LET g_action_choice="invalid"
          EXIT DIALOG 

      ON ACTION issued
         LET g_action_choice = "issued"
         EXIT DIALOG

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG  
     #FUN-C50085 add END
               
     #AFTER DIALOG
     #   CONTINUE DIALOG
   END DIALOG 
   
   CALL cl_set_act_visible("accept,cancel",TRUE) 
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#   DISPLAY ARRAY g_lss TO s_lss.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting(g_curs_index,g_row_count)
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
# 
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
# 
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
# 
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#         
##      ON ACTION output                                                          
##           LET g_action_choice="output"                                           
##           EXIT DISPLAY
#           
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
# 
#      ON ACTION first
#         CALL i590_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
# 
#      ON ACTION previous
#         CALL i590_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
# 
#      ON ACTION jump
#         CALL i590_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
# 
#      ON ACTION next
#         CALL i590_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
# 
#      ON ACTION last
#         CALL i590_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)
#         CALL fgl_set_arr_curr(1)
# 
#      ON ACTION invalid
#         LET g_action_choice="invalid"
#         EXIT DISPLAY
# 
##     ON ACTION reproduce
##        LET g_action_choice="reproduce"
##        EXIT DISPLAY
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
# 
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
# 
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#         
#      ON ACTION ef_approval    #簽核 
#         LET g_action_choice="ef_approval"
#         IF cl_chk_act_auth() THEN
#            CALL i590_ef()
#         END IF 
#         
#      ON ACTION confirm 
#         LET g_action_choice="confirm"
#         IF cl_chk_act_auth() THEN
#            CALL i590_y()
#         END IF 
#      
#      ON ACTION unconfirm
#         LET g_action_choice="unconfirm"
#         IF cl_chk_act_auth() THEN
#            CALL i590_z()
#         END IF
#       
#   #  ON ACTION volid
#   #     LET g_action_choice="volid"
#   #     IF cl_chk_act_auth() THEN
#   #        CALL i590_v()
#   #     END IF   
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i590_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_lss.clear()
   CALL g_lsr.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lst.* LIKE lst_file.*    
   LET g_lst01_t = NULL
 
   LET g_lst.lst09 = 'N'
   LET g_lst_t.* = g_lst.*
   LET g_lst_o.* = g_lst.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      #FUN-BC0058 ---begin---
      IF cl_null(g_argv1) THEN 
         LET g_lst.lst00 = '0'
         LET g_lst.lst13 = ' '
      ELSE 
         IF g_argv1 = '1' THEN 
            LET g_lst.lst00 = '1' 
            LET g_lst.lst13 = '0'
         END IF 
      END IF 
      #FUN-BC0058 ---END---
      LET g_lst.lst07='N'
      LET g_lst.lst08='0'
      LET g_lst.lst09='N'
      #LET g_lst.lstpos = 'N'      #FUN-A80022 add lstpso #FUN-B50042 mark
      LET g_lst.lstpos = '1'       #MOD-B60077 ADD
      LET g_lst.lstplant = g_plant
      LET g_lst.lstlegal = g_legal   
      LET g_lst.lstoriu = g_user   #No.FUN-A10060
      LET g_lst.lstorig = g_grup   #No.FUN-A10060
      LET g_data_plant = g_plant   #No.FUN-A10060
      LET g_lst.lstuser=g_user
      LET g_lst.lstcrat=g_today
      LET g_lst.lstgrup=g_grup
#     LET g_lst.lstdate=g_today
      LET g_lst.lstacti='Y' 
     #FUN-C50085 add START
      LET g_lst.lst14 = g_plant      #制定營運中心 
      LET g_lst.lst15 = 0            #版本號
      LET g_lst.lst16 = 'N'          #發佈否
      LET g_lst.lst18 = '1'          #兌換限制
      LET g_lst.lst19 = 0            #兌換次數
      CALL i590_lst14()
     #FUN-C50085 add END   
      CALL i590_i("a")  
 
      IF INT_FLAG THEN 
         INITIALIZE g_lst.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lst.lst01) THEN  
         CONTINUE WHILE
      END IF
 
      LET g_lst.lstoriu = g_user      #No.FUN-980030 10/01/04
      LET g_lst.lstorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO lst_file VALUES (g_lst.*)
 
      IF SQLCA.sqlcode THEN        
      #   ROLLBACK WORK      #FUN-B80060 下移兩行
         CALL cl_err(g_lst.lst01,SQLCA.sqlcode,1)   
         ROLLBACK WORK       #FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK         
         CALL cl_flow_notify(g_lst.lst01,'I')
      END IF


      SELECT * INTO g_lst.* FROM lst_file
       WHERE lst01 = g_lst.lst01
         AND lst00 = g_lst.lst00  #FUN-C60089 add
         AND lst03 = g_lst.lst03  #CHI-C80047 add
         AND lst14 = g_lst.lst14  #FUN-C50085 add
         AND lstplant = g_plant   #FUN-C60089 add
      LET g_lst01_t = g_lst.lst01   
      LET g_lst_t.* = g_lst.*
      LET g_lst_o.* = g_lst.*
      CALL g_lss.clear()
 
      LET g_rec_b = 0  
      LET g_rec_b1 = 0
      CALL i590_b()
      IF g_flag = 'Y' THEN #FUN-BC0058 add
         CALL i590_b1()  #No.FUN-960134
      END IF             #FUN-BC0058 add
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i590_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lst.lst01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lst.* FROM lst_file
    WHERE lst01=g_lst.lst01 
      AND lst00 = g_lst.lst00  #FUN-C60089 add
      AND lst03 = g_lst.lst03  #CHI-C80047 add
      AND lst14 = g_lst.lst14  #FUN-C50085 add
      AND lstplant = g_plant   #FUN-C60089 add
 
   IF g_lst.lstacti ='N' THEN  
      CALL cl_err(g_lst.lst01,'mfg1000',0)
      RETURN
   END IF

   IF g_lst.lst09 = 'Y' OR g_lst.lst09 ='X' THEN 
      CALL cl_err('',9022,0) 
      RETURN
   END IF

  #FUN-C50085 add START
   IF g_plant <> g_lst.lst14 THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
  #FUN-C50085 add END

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lst01_t = g_lst.lst01
   LET g_lst03_t = g_lst.lst03  #CHI-C80047 add
   BEGIN WORK
 
   OPEN i590_cl USING g_lst.lst01,g_lst.lst14, g_lst.lst00,    #FUN-C50085 add lst14   #FUN-C60089 add lst00 
                      g_lst.lst03                              #CHI-C80047 add
   IF STATUS THEN
      CALL cl_err("OPEN i590_cl:", STATUS, 1)
      CLOSE i590_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i590_cl INTO g_lst.* 
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lst.lst01,SQLCA.sqlcode,0) 
       CLOSE i590_cl
       ROLLBACK WORK
       RETURN
   END IF
   
   CALL i590_show()
 
   WHILE TRUE
      LET g_lst01_t = g_lst.lst01
      LET g_lst_o.* = g_lst.*
      LET g_lst.lstmodu=g_user
      LET g_lst.lstdate=g_today
      IF g_lst.lst08 MATCHES '[Ss11WwRr]' THEN 
         LET g_lst.lst08 = '0'
      END IF  
      CALL i590_i("u")  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lst.*=g_lst_t.*
         CALL i590_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lst.lst01 != g_lst01_t THEN    
         UPDATE lss_file SET lss01 = g_lst.lst01
          WHERE lss01 = g_lst01_t
            AND lss00 = g_lst.lst00          #FUN-C60089 add
            AND lss08 = g_lst03_t            #CHI-C80047 add
            AND lss07 = g_lst.lst14          #FUN-C50085 add
            AND lssplant = g_plant           #FUN-C60089 add 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lss_file",g_lst01_t,"",SQLCA.sqlcode,"","lss",1) 
            CONTINUE WHILE
         END IF
      END IF
     #CHI-C80047 add START
      IF g_lst03_t <> g_lst.lst03 THEN 
         UPDATE lss_file
            SET lss08 = g_lst.lst03
          WHERE lss00 = g_lst.lst00
            AND lss01 = g_lst01_t
            AND lss07 = g_lst.lst14 
            AND lss08 = g_lst03_t
         IF SQLCA.sqlcode  THEN
            CALL cl_err3("upd","lss_file",g_lst01_t,"",SQLCA.sqlcode,"","lss",1)
            CONTINUE WHILE
         END IF
         UPDATE lsr_file
            SET lsr04 = g_lst.lst03
          WHERE lsr00 = g_lst.lst00
            AND lsr01 = g_lst01_t 
            AND lsr03 = g_lst.lst14
            AND lsr04 = g_lst03_t
         IF SQLCA.sqlcode  THEN
            CALL cl_err3("upd","lss_file",g_lst01_t,"",SQLCA.sqlcode,"","lss",1)
            CONTINUE WHILE
         END IF
         UPDATE lni_file
            SET lni15 = g_lst.lst03
          WHERE lni01 = g_lst01_t
            AND lni02 = g_lni02
            AND lni14 = g_lst.lst14
            AND lni15 = g_lst03_t
         IF SQLCA.sqlcode  THEN
            CALL cl_err3("upd","lss_file",g_lst01_t,"",SQLCA.sqlcode,"","lss",1)
            CONTINUE WHILE
         END IF
      END IF
     #CHI-C80047 add END
      #FUN-A80022 -------------add start by vealxu -------------
      #IF g_aza.aza88 =	'Y'  THEN        #FUN-B50042 mark
      #   LET g_lst.lstpos = 'N'         #FUN-B50042 mark
      #   DISPLAY g_lst.lstpos TO lstpos #FUN-B50042 mark
      #END IF                            #FUN-B50042 mark
      #FUN-A80022 ---------------add end------------ 
      UPDATE lst_file SET lst_file.* = g_lst.*
       WHERE lst01 = g_lst01_t
         AND lst00 = g_lst.lst00    #FUN-C60089 add
         AND lst03 = g_lst03_t      #CHI-C80047 add
         AND lst14 = g_lst.lst14    #FUN-C50085 
         AND lstplant = g_plant     #FUN-C60089 add
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lst_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i590_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lst.lst01,'U')
 
END FUNCTION
 
FUNCTION i590_i(p_cmd)
 
DEFINE l_n,l_n1    LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr8  
DEFINE li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lst.lstplant,g_lst.lstlegal,g_lst.lst01,g_lst.lst03,  #FUN-C50085 remove lst02
                   g_lst.lst04,g_lst.lst05,g_lst.lst06,g_lst.lst13,g_lst.lst00,        #FUN-BC0058 add lst13 lst00
   #                g_lst.lst07,g_lst.lst08,g_lst.lst09,                           #MOD-B10146 mark
                   g_lst.lst09,                                                    #MOD-B10146
                   g_lst.lst10,g_lst.lst11,g_lst.lst12,               #FUN-A80022 add lstpos #FUN-B50042 remove POS
                   g_lst.lstuser,g_lst.lstcrat,g_lst.lstmodu,
                   g_lst.lstgrup,g_lst.lstdate,g_lst.lstacti,g_lst.lstoriu,g_lst.lstorig,
                   g_lst.lst14,g_lst.lst15,g_lst.lst16,              #FUN-C50085 add
                   g_lst.lst18,g_lst.lst19                           #FUN-C50085 add
 
   INPUT BY NAME  #g_lst.lst01,g_lst.lst02,g_lst.lst03,  #FUN-C50085 mark  
                   g_lst.lst01,g_lst.lst03,              #FUN-C50085 add
                   g_lst.lst04,g_lst.lst05,g_lst.lst06,g_lst.lst13,        #FUN-BC0058 add lst13
                   g_lst.lst18,g_lst.lst19,                                #FUN-C50085 add
   #                g_lst.lst07,g_lst.lstpos,g_lst.lst08,g_lst.lst09,      #FUN-A80022 add lstpos         #MOD-B10146 mark
                   g_lst.lst09,                                            #MOD-B10146 #FUN-B50042 remove POS
                   g_lst.lst10,g_lst.lst11,g_lst.lst12,
                   g_lst.lstuser,g_lst.lstcrat,g_lst.lstmodu,
                   g_lst.lstgrup,g_lst.lstdate,g_lst.lstacti
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         #LET g_lst.lstpos = 'N'        #NO.FUN-A80022 已傳POS否的值為'N' #FUN-B50042 mark
         LET g_before_input_done = FALSE
         CALL i590_set_entry(p_cmd)
         CALL i590_set_no_entry(p_cmd)
         CALL i590_entry_lst19()
         CALL i590_lstplant()
         LET g_before_input_done = TRUE
 
      AFTER FIELD lst01
         #CHI-C80047 mark START
         #IF cl_null(g_lst.lst01) THEN
         #   CALL cl_err('','alm-809',0)
         #   NEXT FIELD lst01  
         #END IF
         #CHI-C80047 mark END
          IF g_lst.lst01 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_lst.lst01 !=g_lst01_t) THEN
                IF NOT cl_null(g_lst.lst03) THEN  #CHI-C80047 add
                   LET l_n = 0   #CHI-C80047 ad 
                   SELECT COUNT(*) INTO l_n FROM lst_file
                    WHERE lst01 = g_lst.lst01
                      AND lst14 = g_lst.lst14      #FUN-C50085 add
                      AND lstacti = 'Y'            #FUN-C50085 add 
                      AND lst00 = g_lst.lst00      #FUN-C60089 add
                      AND lstplant = g_plant       #FUN-C60089 add
                      AND lst03 = g_lst.lst03      #CHI-C80047 add
                   IF l_n>0 THEN
                      CALL cl_err(g_lst.lst01,-239,0)
                      NEXT FIELD lst01
                   END IF
                END IF   #CHI-C80047 add
               #FUN-C50085 add START
                CALL i590_lst01('a')  
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD lst01
                END IF
               #FUN-C50085 add END
             END IF
          END IF
          
     # AFTER FIELD lst02
     #   IF cl_null(g_lst.lst02) THEN 
     #       CALL cl_err('','alm-809',0)
     #       NEXT FIELD lst02 
     #    END IF
              
      AFTER FIELD lst03
         IF cl_null(g_lst.lst03) THEN 
            DISPLAY '' TO FORMONLY.lph02
         ELSE          
           #CHI-C80047 add START
            LET l_n = 0 
            IF NOT cl_null(g_lst.lst01) THEN
               IF p_cmd = 'a' OR 
                  (p_cmd = 'u' AND g_lst.lst03 <> g_lst_o.lst03) THEN
                  SELECT COUNT(*) INTO l_n FROM lst_file
                   WHERE lst01 = g_lst.lst01
                     AND lst14 = g_lst.lst14    
                     AND lstacti = 'Y'          
                     AND lst00 = g_lst.lst00    
                     AND lstplant = g_plant     
                     AND lst03 = g_lst.lst03    
                  IF l_n>0 THEN
                     CALL cl_err(g_lst.lst01,-239,0)
                     NEXT FIELD lst03
                  END IF
               END IF
            END IF
           #CHI-C80047 add END
            SELECT COUNT(*) INTO l_n1 FROM lph_file
                WHERE lph01 = g_lst.lst03
            IF l_n1=0 THEN
              #CALL cl_err(g_lst.lst03,'alm-802',0)  #FUN-C50085 mark
               CALL cl_err(g_lst.lst03,'alm-h46',0)  #FUN-C50085 add
               NEXT FIELD lst03
            END IF
            CALL i590_lst03(p_cmd) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD lst03
            END IF
         END IF
      
      AFTER FIELD lst04
         IF NOT cl_null(g_lst.lst04) THEN
            IF g_lst.lst04 < g_today THEN 
               CALL cl_err('','alm-804',0)
               NEXT FIELD lst04
            END IF 
         END IF 
         IF NOT cl_null(g_lst.lst05) THEN
            IF g_lst.lst05 < g_lst.lst04 THEN
               CALL cl_err('','alm-805',0)
               NEXT FIELD lst04
            END IF
         END IF
      
      AFTER FIELD lst05
         IF NOT cl_null(g_lst.lst05) THEN
            IF g_lst.lst05 < g_lst.lst04 THEN 
               CALL cl_err('','alm-805',0)
               NEXT FIELD lst05
            END IF 
         END IF
       
      AFTER FIELD lst06
         IF cl_null(g_lst.lst06) THEN
            CALL cl_err('','alm-809',0)
            NEXT FIELD lst06
         END IF        

     #FUN-BC0058 add START
      ON CHANGE lst18
         CALL i590_entry_lst19()
         IF g_lst.lst18 <> '1' THEN
            IF g_lst.lst19 < 1 THEN
               CALL cl_err('','aec-042',0)
               NEXT FIELD lst19
            END IF
         ELSE
            LET g_lst.lst19 = 0
            DISPLAY BY NAME g_lst.lst19
         END IF
       
      AFTER FIELD lst19 
         IF NOT cl_null(g_lst.lst19) THEN
            IF g_lst.lst18 <> '1' THEN
               IF g_lst.lst19 < 1 THEN
                  CALL cl_err('','aec-042',0)
                  NEXT FIELD lst19
               END IF
            END IF
         END IF
     #FUN-BC0058 add END
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF   
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
 
      ON ACTION controlp
         CASE                                                              
           #FUN-C50085 add START
            WHEN INFIELD(lst01) #方案編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lsl02"        
               LET g_qryparam.arg1 = g_plant  
               LET g_qryparam.default1 = g_lst.lst01
               CALL cl_create_qry() RETURNING g_lst.lst01
               DISPLAY g_lst.lst01 TO lst01
               CALL i590_lst01('a')
               NEXT FIELD lst01
           #FUN-C50085 add END
            WHEN INFIELD(lst03) #卡種編號
               CALL cl_init_qry_var()                                     
#              LET g_qryparam.form ="q_lph01_1"         #No.FUN-960134 mark                    
               LET g_qryparam.form ="q_lph01_2"         #No.FUN-960134                     
               LET g_qryparam.default1 = g_lst.lst03                      
               CALL cl_create_qry() RETURNING g_lst.lst03                 
               DISPLAY g_lst.lst03 TO lst03 
               CALL i590_lst03('d')                               
               NEXT FIELD lst03
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
   END INPUT
 
END FUNCTION
 
FUNCTION i590_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lss.clear()
   CALL g_lsr.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   CALL i590_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lst.* TO NULL
      RETURN
   END IF
 
   OPEN i590_cs  
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lst.* TO NULL
   ELSE
      OPEN i590_count
      FETCH i590_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i590_fetch('F')   
   END IF
 
END FUNCTION
 
FUNCTION i590_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1   
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i590_cs INTO g_lst.lst01,g_lst.lst14,g_lst.lstplant,g_lst.lst03    #FUN-C50085 add lst14,lstplant   #CHI-C80047 add lst03
      WHEN 'P' FETCH PREVIOUS i590_cs INTO g_lst.lst01,g_lst.lst14,g_lst.lstplant,g_lst.lst03    #FUN-C50085 add lst14,lstplant   #CHI-C80047 add lst03
      WHEN 'F' FETCH FIRST    i590_cs INTO g_lst.lst01,g_lst.lst14,g_lst.lstplant,g_lst.lst03    #FUN-C50085 add lst14,lstplant   #CHI-C80047 add lst03
      WHEN 'L' FETCH LAST     i590_cs INTO g_lst.lst01,g_lst.lst14,g_lst.lstplant,g_lst.lst03    #FUN-C50085 add lst14,lstplant   #CHI-C80047 add lst03
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
      ON ACTION controlg       
         CALL cl_cmdask()      
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i590_cs INTO g_lst.lst01,g_lst.lst14,g_lst.lstplant,g_lst.lst03    #FUN-C50085 add lst14,lstplant  #CHI-C80047 add lst03
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lst.lst01,SQLCA.sqlcode,0)
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
      DISPLAY g_curs_index TO FORMONLY.idx                    
   END IF
 
   SELECT * INTO g_lst.* FROM lst_file 
    WHERE lst01 = g_lst.lst01
      AND lst00 = g_lst.lst00        #FUN-C60089 add
      AND lst03 = g_lst.lst03        #CHI-C80047 add
      AND lst14 = g_lst.lst14        #FUN-C50085 add 
      AND lstplant = g_lst.lstplant  #FUN-C50085 add
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lst_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lst.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lst.lstuser       
   LET g_data_group = g_lst.lstgrup       
   LET g_data_plant = g_lst.lstplant
   CALL i590_show()
 
END FUNCTION
 
FUNCTION i590_show()
   LET g_lst_t.* = g_lst.* 
   LET g_lst_o.* = g_lst.*  
   DISPLAY BY NAME g_lst.lstplant,g_lst.lstlegal,g_lst.lst01,g_lst.lst03,  #FUN-C50085 remove lst02
                   g_lst.lst04,g_lst.lst05,g_lst.lst06,g_lst.lst13,g_lst.lst00,     #FUN-BC0058 add lst13,lst00
   #                g_lst.lst07,g_lst.lstpos,g_lst.lst08,g_lst.lst09,               #FUN-A80022 add lstpos  #MOD-B10146 mark
                   g_lst.lst09,                                                     #MOD-B10146 #FUN-B50042 remove POS
                   g_lst.lst10,g_lst.lst11,g_lst.lst12,      
                   g_lst.lstuser,g_lst.lstgrup,
                   g_lst.lstcrat,g_lst.lstmodu,
                   g_lst.lstdate,g_lst.lstacti,
                   g_lst.lstoriu,g_lst.lstorig,
                   g_lst.lst14,g_lst.lst15, g_lst.lst16, g_lst.lst17,   #FUN-C50085 add
                   g_lst.lst18,g_lst.lst19                           #FUN-C50085 add
                 
   CALL i590_lst14()       #FUN-C50085 add 
   CALL i590_lst01('d')  #FUN-C50085 add
   CALL i590_lstplant() 
   CALL i590_lst03('d')
   CALL i590_b_fill(g_wc2) 
   CALL i590_b1_fill(g_wc3)     #No.FUN-960134     
   CALL i590_field_pic()
END FUNCTION
 
FUNCTION i590_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lst.lst01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lst.lst09 != 'N' THEN CALL cl_err('','8888',0) RETURN END IF

  #FUN-C50085 add START
   IF g_plant <> g_lst.lst14 THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
  #FUN-C50085 add END

   BEGIN WORK
 
   OPEN i590_cl USING g_lst.lst01,g_lst.lst14,g_lst.lst00,   #FUN-C50085 add lst14   #FUN-C60089 add lst00
                      g_lst.lst03                            #CHI-C80047 add
   IF STATUS THEN
      CALL cl_err("OPEN i590_cl:", STATUS, 1)
      CLOSE i590_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i590_cl INTO g_lst.*     
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lst.lst01,SQLCA.sqlcode,0)   
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i590_show()
 
   IF cl_exp(0,0,g_lst.lstacti) THEN  
      LET g_chr=g_lst.lstacti
      IF g_lst.lstacti='Y' THEN
         LET g_lst.lstacti='N'
      ELSE
         LET g_lst.lstacti='Y'
      END IF
 
      UPDATE lst_file SET lstacti=g_lst.lstacti,
                          lstmodu=g_user,
                          lstdate=g_today
       WHERE lst01=g_lst.lst01
         AND lst00 = g_lst.lst00  #FUN-C60089 add
         AND lst03 = g_lst.lst03  #CHI-C80047 add
         AND lst14=g_lst.lst14    #FUN-C50085 
         AND lstplant = g_plant   #FUN-C60089 add
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lst_file",g_lst.lst01,"",SQLCA.sqlcode,"","",1)  
         LET g_lst.lstacti=g_chr
      END IF
   END IF
 
   CLOSE i590_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lst.lst01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lstacti,lstmodu,lstdate,lstcrat
     INTO g_lst.lstacti,g_lst.lstmodu,g_lst.lstdate,g_lst.lstcrat
     FROM lst_file
    WHERE lst01=g_lst.lst01
      AND lst00 = g_lst.lst00  #FUN-C60089 add
      AND lst03 = g_lst.lst03  #CHI-C80047 add
      AND lst14 = g_lst.lst14  #FUN-C50085 add
      AND lstplant = g_plant   #FUN-C60089 add
   DISPLAY BY NAME g_lst.lstacti,g_lst.lstmodu,g_lst.lstdate,g_lst.lstcrat
   CALL i590_field_pic() 
END FUNCTION
 
FUNCTION i590_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lst.lst01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lst.* FROM lst_file
    WHERE lst01=g_lst.lst01
      AND lst00 = g_lst.lst00  #FUN-C60089 add
      AND lst03 = g_lst.lst03  #CHI-C80047 add
      AND lst14 = g_lst.lst14  #FUN-C50085 add
      AND lstplant = g_plant   #FUN-C60089 add
   IF g_lst.lstacti ='N' THEN  
      CALL cl_err(g_lst.lst01,'mfg1000',0)
      RETURN
   END IF
   IF g_lst.lst08 MATCHES '[Ss11WwRr]' THEN 
       CALL cl_err('','mfg3557',0)
       RETURN
   END IF  
   IF g_lst.lst09 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_lst.lst09 = 'X' THEN CALL cl_err('',9028,0) RETURN END IF
   
   BEGIN WORK
 
   OPEN i590_cl USING g_lst.lst01,g_lst.lst14,g_lst.lst00,  #FUN-C50085 add lst14  #FUN-C60089 add lst00
                      g_lst.lst03                           #CHI-C80047 add
   IF STATUS THEN
      CALL cl_err("OPEN i590_cl:", STATUS, 1)
      CLOSE i590_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i590_cl INTO g_lst.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lst.lst01,SQLCA.sqlcode,0)    
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i590_show()
 
   IF cl_delh(0,0) THEN     
      DELETE FROM lst_file WHERE lst00 = g_lst.lst00 AND lst01 = g_lst.lst01     #FUN-C60089 add lst00
                             AND lst03 = g_lst.lst03                             #CHI-C80047 add
                             AND lst14 = g_lst.lst14 AND lstplant = g_plant      #FUN-C50085 lst14   #FUN-C60089 add lstplant
      DELETE FROM lss_file WHERE lss00 = g_lst.lst00 AND lss01 = g_lst.lst01     #FUN-C60089 add lss00
                             AND lss08 = g_lst.lst03                             #CHI-C80047 add
                             AND lss07 = g_lst.lst14 AND lssplant = g_plant      #FUN-C50085 lst14   #FUN-C60089 add lssplant
      DELETE FROM lsr_file WHERE lsr00 = g_lst.lst00 AND lsr01 = g_lst.lst01     #FUN-C60089 add lsr00
                             AND lsr04 = g_lst.lst03                             #CHI-C80047 add
                             AND lsr03 = g_lst.lst14 AND lsrplant = g_plant      #FUN-C50085 lst14   #FUN-C60089 add lsrplant
     #DELETE FROM lni_file WHERE lni01 = g_lst.lst01 AND lni02 = '1' AND lni14 = g_lst.lst14  #FUN-C50085 add   #FUN-C60089 mark 
      DELETE FROM lni_file WHERE lni01 = g_lst.lst01 AND lni02 = g_lni02         #FUN-C60089 add
                             AND lni14 = g_lst.lst14 AND lniplant = g_plant      #FUN-C60089 add 
                             AND lni15 = g_lst.lst03                             #CHI-C80047 add
      CLEAR FORM
      CALL g_lss.clear()
      CALL g_lsr.clear() #CHI-C80047 add 
      OPEN i590_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i590_cs
          CLOSE i590_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
      FETCH i590_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i590_cs
          CLOSE i590_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i590_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i590_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i590_fetch('/')
      END IF
   END IF
 
   CLOSE i590_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lst.lst01,'D')
 
END FUNCTION
 
FUNCTION i590_b()
DEFINE
    l_ac_t          LIKE type_file.num5,  
    l_n,l_n1,l_n2   LIKE type_file.num5, 
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_sfb08         LIKE sfb_file.sfb08
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lst.lst01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_lst.* FROM lst_file
     WHERE lst01=g_lst.lst01
       AND lst00 = g_lst.lst00   #FUN-C60089 add 
       AND lst03 = g_lst.lst03   #CHI-C80047 add
       AND lst14 = g_lst.lst14   #FUN-C50085 add
       AND lstplant = g_plant    #FUN-C60089 add
 
    IF g_lst.lstacti ='N' THEN   
       CALL cl_err(g_lst.lst01,'mfg1000',0)
       RETURN
    END IF
    IF g_lst.lst09 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lst.lst09 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

   #FUN-C50085 add START
    IF g_plant <> g_lst.lst14 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
   #FUN-C50085 add END

    CALL cl_opmsg('b')
   #LET g_forupd_sql = "SELECT lss02,lss03,lss04,lss05,lss06,'' ",              #FUN-BC0058   add lss03  #TQC-C30054 mark
    LET g_forupd_sql = "SELECT lss02,lss03,lss04,lss05 ",   #TQC-C30054 add
                       "  FROM lss_file",  
                       " WHERE lss00 = '",g_lst.lst00,"' AND lss01=? AND lss02=? ",    #FUN-C60089 add lss00
                       "   AND lss08 = '",g_lst.lst03,"' ",                            #CHI-C80047 add
                       "   AND lss03 = ? AND lss07 = ? FOR UPDATE"    #FUN-BC0058 add lss03  #FUN-C50085 add lss07
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i590_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   
 
    INPUT ARRAY g_lss WITHOUT DEFAULTS FROM s_lss.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i590_cl USING g_lst.lst01,g_lst.lst14,g_lst.lst00,   #FUN-C50085 add lst14   #FUN-C60089 add lst00
                              g_lst.lst03
           IF STATUS THEN
              CALL cl_err("OPEN i590_cl:", STATUS, 1)
              CLOSE i590_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i590_cl INTO g_lst.*     
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lst.lst01,SQLCA.sqlcode,0)   
              CLOSE i590_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lss_t.* = g_lss[l_ac].*  #BACKUP
              LET g_lss_o.* = g_lss[l_ac].*  #BACKUP
              OPEN i590_bcl USING g_lst.lst01,g_lss[l_ac].lss02,g_lss[l_ac].lss03,g_lst.lst14    #FUN-BC0058  add lss03  #FUN-C50085 add
              IF STATUS THEN
                 CALL cl_err("OPEN i590_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i590_bcl INTO g_lss[l_ac].*
                 IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_lst.lst02,SQLCA.sqlcode,1)  #FUN-C50085 mark 
                    CALL cl_err(g_lst.lst01,SQLCA.sqlcode,1)  #FUN-C50085 add
                    LET l_lock_sw = "Y"
                 END IF
                #SELECT lpx02 INTO g_lss[l_ac].lpx02              #TQC-C30054 mark
                #   FROM lpx_file WHERE lpx01=g_lss[l_ac].lss06   #TQC-C30054 mark
              END IF
              CALL i590_set_entry_b(p_cmd)     
              #FUN-BC0058 ---begin--- 
              IF cl_null(g_argv1) THEN
                 NEXT FIELD lss02
              ELSE
                 IF g_argv1 = '1' THEN
                    NEXT FIELD lss03
                 END IF
              END IF
              #FUN-BC0058 ---end---
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_lss[l_ac].* TO NULL      
           #FUN-BC0058 ---begin---
           IF cl_null(g_argv1) THEN 
              LET g_lss[l_ac].lss03 = 0
           ELSE
              IF g_argv1 = '1' THEN
                 LET g_lss[l_ac].lss02 = 0
              END IF 
           END IF  
           #FUN-BC0058 ---end ---
           LET g_lss_t.* = g_lss[l_ac].*    
           LET g_lss_o.* = g_lss[l_ac].*   
           CALL i590_set_entry_b(p_cmd) 
           #FUN-BC0058 ---begin--- 
           IF cl_null(g_argv1) THEN   
              NEXT FIELD lss02
           ELSE
              IF g_argv1 = '1' THEN
                 NEXT FIELD lss03
              END IF
           END IF
           #FUN-BC0058 ---end---
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
          #INSERT INTO lss_file(lssplant,lsslegal,lss01,lss02,lss03,lss04,lss05,lss06)                     #FUN-BC0058  add lss03  #TQC-C30054 mark
          #VALUES(g_plant,g_legal,g_lst.lst01,g_lss[l_ac].lss02,g_lss[l_ac].lss03,g_lss[l_ac].lss04,       #FUN-BC0058  add lss03  #TQC-C30054 mark
          #       g_lss[l_ac].lss05,g_lss[l_ac].lss06)                                                     #TQC-C30054 mark
          #FUN-C60089 mark START
          ##TQC-C30054 add START
          #INSERT INTO lss_file(lssplant,lsslegal,lss01,lss02,lss03,lss04,lss05,lss07)                     #FUN-BC0058  add lss03    #FUN-C50085 add lss07
          #VALUES(g_plant,g_legal,g_lst.lst01,g_lss[l_ac].lss02,g_lss[l_ac].lss03,g_lss[l_ac].lss04,       #FUN-BC0058  add lss03  
          #       g_lss[l_ac].lss05,g_plant)                                                               #FUN-C50085 add g_plant
          ##TQC-C30054 add END
          #FUN-C60089 mark END
          #FUN-C60089 add START 
           INSERT INTO lss_file(lssplant,lsslegal,lss00,lss01,lss02,lss03,lss04,lss05,lss07,lss08)         #CHI-C80047 add lss08             
           VALUES(g_plant,g_legal,g_lst.lst00,g_lst.lst01,g_lss[l_ac].lss02,g_lss[l_ac].lss03,g_lss[l_ac].lss04,     
                  g_lss[l_ac].lss05,g_plant,g_lst.lst03)                                                   #CHI-C80047 add lst03
          #FUN-C60089 add END 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lss_file",g_lst.lst01,g_lss[l_ac].lss02,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
       AFTER FIELD lss02
          IF NOT cl_null(g_lss[l_ac].lss02) THEN
#            CALL cl_err('','alm-809',0)
#            NEXT FIELD lss02
#          ELSE
             IF (g_lss[l_ac].lss02 !=g_lss_t.lss02) OR 
                g_lss_t.lss02 IS NULL  THEN
                SELECT COUNT(*) INTO l_n FROM lss_file 
                 WHERE lss01=g_lst.lst01
                   AND lss00 = g_lst.lst00    #FUN-C60089 add
                   AND lss02=g_lss[l_ac].lss02
                   AND lss07 = g_lst.lst14    #FUN-C50085 add
                   AND lss08 = g_lst.lst03    #CHI-C80047 add
                IF l_n > 0 THEN                         
                   CALL cl_err("",-239,1)
                   LET g_lss[l_ac].lss02=g_lss_t.lss02  
                   NEXT FIELD lss02
                END IF
             END IF
#            IF g_lss[l_ac].lss02 < 0 THEN      #FUN-BC0058  mark
             IF g_lss[l_ac].lss02 <= 0 THEN     #FUN-BC0058 
                CALL cl_err("","alm-808",0)
                NEXT FIELD lss02
             END IF    
          END IF
       #FUN-BC0058  ---begin--- 
       AFTER FIELD lss03
          IF NOT cl_null(g_lss[l_ac].lss03) THEN
             IF (g_lss[l_ac].lss03 !=g_lss_t.lss03) OR
                g_lss_t.lss03 IS NULL  THEN
                SELECT COUNT(*) INTO l_n FROM lss_file
                 WHERE lss01=g_lst.lst01
                   AND lss00 = g_lst.lst00    #FUN-C60089 add
                   AND lss03=g_lss[l_ac].lss03
                   AND lss07 = g_lst.lst14    #FUN-C50085 add
                   AND lss08 = g_lst.lst03    #CHI-C80047 add
                   AND lssplant = g_plant     #FUN-C60089 add
                IF l_n > 0 THEN
                   CALL cl_err("",-239,1)
                   LET g_lss[l_ac].lss03=g_lss_t.lss03
                   NEXT FIELD lss03
                END IF
             END IF
             IF g_lss[l_ac].lss03 <= 0 THEN
                CALL cl_err("","alm-808",0)
                NEXT FIELD lss03
             END IF
          END IF       
       #FUN-BC0058  ---end---
  
       AFTER FIELD lss04
         IF NOT cl_null(g_lss[l_ac].lss04) THEN
            IF g_lss[l_ac].lss04 < 0 THEN 
                CALL cl_err("","alm-808",0)
                NEXT FIELD lss04
             END IF
         END IF 
                    
       AFTER FIELD lss05
         IF NOT cl_null(g_lss[l_ac].lss05) THEN
            IF g_lss[l_ac].lss05 < 0 THEN 
                CALL cl_err("","alm-808",0)
                NEXT FIELD lss05
             END IF
         END IF
       #TQC-C30054 mark START  
       #AFTER FIELD lss06
       #  IF cl_null(g_lss[l_ac].lss06) THEN
       #     LET g_lss[l_ac].lpx02 = '' 
       #     DISPLAY g_lss[l_ac].lpx02 TO lpx02 
#      #      CALL cl_err('','alm-809',0)
#      #      NEXT FIELD lss06
       #  ELSE 
       #     #-----MOD-A30218---------
       #     #SELECT COUNT(*) INTO l_n2 FROM lpx_file
       #     # WHERE lpx01 = g_lss[l_ac].lss06
       #     #IF l_n2=0 THEN
       #     #   CALL cl_err(g_lss[l_ac].lss06,'alm-802',0)
       #     #   NEXT FIELD lss06
       #     #END IF
       #     #-----END MOD-A30218-----
       #     CALL i590_lss06(p_cmd)
       #     IF NOT cl_null(g_errno) THEN
       #        #CALL cl_err(g_lss[l_ac].lss06,'alm-802',0)   #MOD-A30218
       #        CALL cl_err(g_lss[l_ac].lss06,g_errno,0)   #MOD-A30218
       #        NEXT FIELD lss06
       #     END IF
       #  END IF 
       #TQC-C30054 mark END                   

        BEFORE DELETE    
           IF NOT cl_null(g_lss_t.lss02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lss_file
               WHERE lss01 = g_lst.lst01
                 AND lss00 = g_lst.lst00       #FUN-C60089 add
                 AND lss02 = g_lss_t.lss02
                 AND lss03 = g_lss_t.lss03     #FUN-C60089 add
                 AND lss07 = g_lst.lst14       #FUN-C50085 add 
                 AND lss08 = g_lst.lst03       #CHI-C80047 add
                 AND lssplant = g_plant        #FUN-C60089 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lss_file","","",SQLCA.sqlcode,"","",1)   
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lss[l_ac].* = g_lss_t.*
              CLOSE i590_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lss[l_ac].lss02,-263,1)
              LET g_lss[l_ac].* = g_lss_t.*
           ELSE
              IF g_argv1 <> '1' THEN  #TQC-C30054 add     
                 UPDATE lss_file SET lss02=g_lss[l_ac].lss02,
                                     lss04=g_lss[l_ac].lss04,
                                     lss03=g_lss[l_ac].lss03,   #FUN-C60089 add
                                     lss05=g_lss[l_ac].lss05 
                                    #lss06=g_lss[l_ac].lss06  #TQC-C30054 mark
                  WHERE lss01=g_lst.lst01
                    AND lss00 = g_lst.lst00      #FUN-C60089 addd
                    AND lss02=g_lss_t.lss02
                    AND lss03 = g_lss_t.lss03    #FUN-C50085 add
                    AND lss07 = g_lst.lst14      #FUN-C50085 add 
                    AND lss08 = g_lst.lst03      #CHI-C80047 add
                    AND lssplant = g_plant       #FUN-C60089 add
              ELSE      #TQC-C30054 add
                 UPDATE lss_file SET lss02=g_lss[l_ac].lss02,
                                     lss03=g_lss[l_ac].lss03,   #FUN-C60089 add
                                     lss04=g_lss[l_ac].lss04,
                                     lss05=g_lss[l_ac].lss05
                  WHERE lss01=g_lst.lst01
                    AND lss00 = g_lst.lst00      #FUN-C60089 add
                    AND lss02 = g_lss_t.lss02    #FUN-C50085 add
                    AND lss03=g_lss_t.lss03
                    AND lss07 = g_lst.lst14      #FUN-C50085 add
                    AND lss08 = g_lst.lst03      #CHI-C80047 add
                    AND lssplant = g_plant       #FUN-C60089 add
              END IF    #TQC-C30054 add
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lss_file",g_lst.lst01,g_lss_t.lss02,SQLCA.sqlcode,"","",1)  
                 LET g_lss[l_ac].* = g_lss_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac     #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lss[l_ac].* = g_lss_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lss.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE i590_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30033 Add
           CLOSE i590_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO     
           IF INFIELD(lss02) AND l_ac > 1 THEN
              LET g_lss[l_ac].* = g_lss[l_ac-1].*
              LET g_lss[l_ac].lss02 = g_rec_b + 1
              NEXT FIELD lss02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
       #TQC-C30054 mark START
       #ON ACTION controlp
       #   CASE
       #      WHEN INFIELD(lss06)  #券類型編號
       #         CALL cl_init_qry_var()
#      #         LET g_qryparam.form ="q_lpx01"      #mark by hellen 090709
       #         LET g_qryparam.form ="q_lpx01_2"    #add by hellen 090709
       #         LET g_qryparam.default1 = g_lss[l_ac].lss06
       #         CALL cl_create_qry() RETURNING g_lss[l_ac].lss06
       #         DISPLAY BY NAME g_lss[l_ac].lss06
       #         CALL i590_lss06('d')
       #         NEXT FIELD lss06
       #       OTHERWISE EXIT CASE
       #    END CASE
       #TQC-C30054 mark END
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
    END INPUT
 
#    LET g_lst.lstmodu = g_user
#    LET g_lst.lstdate = g_today
#    UPDATE lst_file 
#       SET lstmodu = g_lst.lstmodu,
#           lstdate = g_lst.lstdate
#     WHERE lst01 = g_lst.lst01
    DISPLAY BY NAME g_lst.lstcrat,g_lst.lstmodu,g_lst.lstdate
 
    CLOSE i590_bcl
    COMMIT WORK
    CALL i590_delall()
 
END FUNCTION
 
FUNCTION i590_delall()
 
    LET g_flag = 'Y'   #FUN-BC0058 add  
    SELECT COUNT(*) INTO g_cnt FROM lss_file
     WHERE lss01 = g_lst.lst01
       AND lss00 = g_lst.lst00   #FUN-C60089 add
       AND lss07 = g_lst.lst14   #FUN-C50085 add
       AND lss08 = g_lst.lst03   #CHI-C80047 add
       AND lssplant = g_plant    #FUN-C60089 add

   #FUN-C60089 add START
    IF cl_null(g_cnt) OR g_cnt = 0 THEN
       SELECT COUNT(*) INTO g_cnt FROM lsr_file
          WHERE lsr00 = g_lst.lst00 
            AND lsr01 = g_lst.lst01
            AND lsr03 = g_lst.lst14
            AND lsr04 = g_lst.lst03    #CHI-C80047 add
            AND lsrplant = g_plant     #FUN-C60089 add
    END IF
   #FUN-C60089 add END 
    IF g_cnt = 0 THEN      
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM lst_file WHERE lst01 = g_lst.lst01
                              AND lst00 = g_lst.lst00 AND lst14 = g_lst.lst14  #FUN-C60089 add
                              AND lst03 = g_lst.lst03    #CHI-C80047 add
                              AND lstplant = g_plant     #FUN-C60089 add
       LET g_flag = 'N'    #FUN-BC0058 add 
    END IF
 
END FUNCTION
 
FUNCTION i590_b_askkey()
 
    DEFINE l_wc2           STRING
   #TQC-C30054 mark START 
   #CONSTRUCT l_wc2 ON lss02,lss04,lss05,lss06,lpx02
   #        FROM s_lss[1].lss02,s_lss[1].lss04,
   #             s_lss[1].lss05,s_lss[1].lss06,s_lss[1].lpx02
   #TQC-C30054 mark END
   #TQC-C30054 add START
    CONSTRUCT l_wc2 ON lss02,lss04,lss05
            FROM s_lss[1].lss02,s_lss[1].lss04,s_lss[1].lss05
   #TQC-C30054 add END
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
      ON ACTION controlg      
         CALL cl_cmdask()     
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i590_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i590_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2       STRING
 
   #LET g_sql = "SELECT lss02,lss03,lss04,lss05,lss06,'' ",    #FUN-BC0058 add lss03  #TQC-C30054 mark
    LET g_sql = "SELECT lss02,lss03,lss04,lss05 ",    #TQC-C30054 add
                "  FROM lss_file",   
                " WHERE lss01 ='",g_lst.lst01,"' ",
                "   AND lss00 ='",g_lst.lst00,"' ",           #FUN-C60089 add
                "   AND lss07 ='",g_lst.lst14,"' ",           #FUN-C50085 add
                "   AND lss08 ='",g_lst.lst03,"' ",           #CHI-C80047 add 
               #"   AND lssplant = '",g_plant,"' "            #FUN-C60089 add  #CHI-C80047 mark 
                "   AND lssplant = '",g_lst.lstplant,"' "     #CHI-C80047 add 
#               "   AND lssplant IN ",g_auth,
#               "   AND lpx01= lss06 " ## and ",p_wc2 CLIPPED,
#               " ORDER BY lss02 "
 
   IF NOT cl_null(p_wc2) THEN                                                   
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED                             
   END IF                                                                       
   LET g_sql=g_sql CLIPPED," ORDER BY lss02 "            
   DISPLAY g_sql             
 
    PREPARE i590_pb FROM g_sql
    DECLARE lss_cs                       #CURSOR
        CURSOR FOR i590_pb
 
    CALL g_lss.clear()
    LET g_cnt = 1
 
    FOREACH lss_cs INTO g_lss[g_cnt].* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     #TQC-C30054 mark START
     #SELECT lpx02 INTO g_lss[g_cnt].lpx02 
     #  FROM lpx_file 
     # WHERE lpx01 = g_lss[g_cnt].lss06 
     #TQC-C30054 mark END
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF
    END FOREACH
    CALL g_lss.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i590_copy()
DEFINE
         l_newno         LIKE lst_file.lst01,
         l_newdate       LIKE lst_file.lst02,
         l_n             LIKE type_file.num5,
         l_oldno         LIKE lst_file.lst01
DEFINE   li_result       LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    IF g_lst.lst01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i590_set_entry('a')
    LET g_before_input_done = TRUE
    LET l_newdate= NULL                                                                                                             
    
    SELECT * INTO g_lst.* FROM lst_file 
       WHERE lst00 = g_lst.lst00     #FUN-C60089 add
         AND lst01 = g_lst.lst01 AND lst14 = g_lst.lst14    
         AND lst03 = g_lst.lst03     #CHI-C80047 add
         AND lstplant = g_plant   #FUN-C60089 add
    LET g_lst_o.* = g_lst.*
    LET g_lst.lst01 = NULL          #CHI-C80047 add
    DISPLAY '' TO FORMONLY.lsl03    #CHI-C80047 add
    LET g_lst.lst07='N'
    LET g_lst.lst08='0'
    LET g_lst.lst09='N'
    LET g_lst.lstpos = '1'       
    LET g_lst.lstplant = g_plant
    LET g_lst.lstlegal = g_legal
    LET g_lst.lstoriu = g_user   
    LET g_lst.lstorig = g_grup   
    LET g_data_plant = g_plant   
    LET g_lst.lstuser=g_user
    LET g_lst.lstcrat=g_today
    LET g_lst.lstgrup=g_grup
    LET g_lst.lstacti='Y'
    LET g_lst.lst14 = g_plant      #制定營運中心
    LET g_lst.lst15 = 0            #版本號
    LET g_lst.lst16 = 'N'          #發佈否
    CALL i590_field_pic() 

    CALL i590_i("a")
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_lst.* = g_lst_o.*
       CALL i590_field_pic()
       CALL i590_show()
       ROLLBACK WORK
       RETURN
    END IF

    INSERT INTO lst_file VALUES (g_lst.*)

    DROP TABLE y

    DROP TABLE x
  
    DROP TABLE z   #CHI-C80047 add

    SELECT * FROM lss_file 
        WHERE lss01=g_lst_o.lst01
          AND lss00 = g_lst.lst00  #FUN-C60089 add
          AND lss08 = g_lst_o.lst03  #CHI-C80047 add
          AND lss07 = g_lst_o.lst14  #FUN-C50085 add
          AND lssplant = g_plant   #FUN-C60089 add
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err("",SQLCA.sqlcode,1)  
        RETURN
    END IF

    UPDATE x
        SET lss01 = g_lst.lst01,
            lss07 = g_lst.lst14,  #CHI-C80047 add
            lss08 = g_lst.lst03   #CHI-C80047 add
         
    INSERT INTO lss_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)  
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK 
    END IF

    DROP TABLE y

    SELECT * FROM lsr_file
        WHERE lsr01=g_lst_o.lst01
          AND lsr00 = g_lst.lst00         #FUN-C60089 add
          AND lsr03 = g_lst_o.lst14       #FUN-C50085 add
          AND lsr04 = g_lst_o.lst03         #CHI-C80047 add
          AND lsrplant = g_plant          #FUN-C60089 add
        INTO TEMP y
    IF SQLCA.sqlcode THEN
        CALL cl_err("",SQLCA.sqlcode,1)
        RETURN
    END IF

    UPDATE y
        SET lsr01 = g_lst.lst01,
            lsr03 = g_lst.lst14,  #CHI-C80047 add
            lsr04 = g_lst.lst03   #CHI-C80047 add

    INSERT INTO lsr_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF

   #CHI-C80047 add START
    DROP TABLE z
    SELECT * FROM lni_file
       WHERE lni01 = g_lst_o.lst01 
         AND lni02 = g_lni02
         AND lni14 = g_lst_o.lst14
         AND lni15 = g_lst_o.lst03 
         AND lniplant = g_plant 
     INTO TEMP z
    
    UPDATE z 
       SET lni01 = g_lst.lst01,
           lni14 = g_lst.lst14,
           lni15 = g_lst.lst03

    INSERT INTO lni_file 
       SELECT * FROM z

    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
   #CHI-C80047 add END

    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_lst_o.lst01
    SELECT lst_file.* INTO g_lst.* FROM lst_file 
      WHERE lst00 = g_lst.lst00                    #FUN-C60089 add 
        AND lst01 = g_lst.lst01 AND lst14 = g_lst.lst14
        AND lst03 = g_lst.lst03   #CHI-C80047 add
        AND lstplant  = g_plant   #FUN-C60089 add

    CALL i590_b()
    CALL i590_b1()
    CALL i590_show()

END FUNCTION
 
 
FUNCTION i590_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("lst01,",TRUE)
  END IF
 
END FUNCTION
FUNCTION i590_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
  CALL cl_set_comp_entry("lst10,lst11",FALSE)
 
  IF p_cmd='u' AND g_chkey='N' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("lst01",FALSE)
  END IF
   
END FUNCTION
 
FUNCTION i590_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",TRUE)
  END IF
  #FUN-BC0058 ---begin---
  IF cl_null(g_argv1) THEN
     CALL cl_set_comp_required("lss02,lss05,lss04",TRUE)
  ELSE 
    IF g_argv1 = '1' THEN
       CALL cl_set_comp_required("lss05,lss04",TRUE)
    END IF 
  END IF 
  #FUN-BC0058 ---end---
 #CALL cl_set_comp_required("lss06",FALSE) #TQC-C30054 mark
END FUNCTION
 
FUNCTION i590_set_entry_b1(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",TRUE)
  END IF
  CALL cl_set_comp_required("lsr02",TRUE)
END FUNCTION
 
FUNCTION i590_y()
   DEFINE l_n LIKE type_file.num5      #FUN-BC0058 add
   IF g_lst.lst01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 --------------- add ----------------- begin
   IF g_lst.lst09 !='N' THEN
      CALL cl_err('','8888',0)
      RETURN
   END IF
   IF g_lst.lstacti = 'N' THEN
      CALL cl_err('','9028',0)
      RETURN
   END IF
   IF g_lst.lst07 = 'Y'AND (cl_null(g_lst.lst08) OR  g_lst.lst08  ! = '1') THEN
      CALL cl_err('','alm-029',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF 
   SELECT * INTO g_lst.* FROM lst_file 
    WHERE lst01 = g_lst.lst01
      AND lst00 = g_lst.lst00  #FUN-C60089 add
      AND lst03 = g_lst.lst03  #CHI-C80047 add
      AND lst14 = g_lst.lst14  #FUN-C50085 add
      AND lstplant = g_plant   #FUN-C60089 add
   IF g_lst.lst01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 --------------- add ----------------- end
   IF g_lst.lst09 !='N' THEN
      CALL cl_err('','8888',0)      
      RETURN
   END IF
   IF g_lst.lstacti = 'N' THEN
      CALL cl_err('','9028',0)      
      RETURN
   END IF
   IF g_lst.lst07 = 'Y'AND (cl_null(g_lst.lst08) OR  g_lst.lst08  ! = '1') THEN
      CALL cl_err('','alm-029',0)  
      RETURN
   END IF 
   #FUN-C50085 add START
    SELECT COUNT(*) INTO l_n FROM lni_file 
     WHERE lni01 = g_lst.lst01
       AND lniplant = g_lst.lstplant
      #AND lni02 = '1'  #FUN-C60089 mark
       AND lni02 = g_lni02   #FUN-C60089 add
       AND lni13 = 'Y'
       AND lni14 = g_lst.lst14  
       AND lni15 = g_lst.lst03    #CHI-C80047 add
       AND lni04 = g_lst.lst14
    IF l_n = 0 THEN
       CALL cl_err('','alm-h42',0)
       RETURN
    END IF
    CALL i590_chk_lni04()   #判斷生效營運中心是否與卡生效營運中心符合
    IF g_success = 'N' THEN
       RETURN
    END IF
    IF g_plant <> g_lst.lst14 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
   #FUN-C50085 add END

   #FUN-BC0058 ---begin---
   SELECT COUNT(*) INTO l_n 
     FROM lni_file 
    WHERE lni01 = g_lst.lst01
      AND lniplant = g_lst.lstplant
     #AND lni02 = '1'      #FUN-C60089 mark
      AND lni02 = g_lni02  #FUN-C60089 add
      AND lni13 = 'Y'
      AND lni14 = g_lst.lst14  #FUN-C50085 add
      AND lni15 = g_lst.lst03  #CHI-C80047 add
   IF l_n = 0 THEN 
      CALL cl_err('','alm1367',0)
      RETURN
   END IF 
   #FUN-BC0058 ---END---
  #TQC-C30054 add START
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM lsr_file
      WHERE lsr01 = g_lst.lst01
        AND lsr00 = g_lst.lst00      #FUN-C60089 add
        AND lsrplant = g_plant
        AND lsr03 = g_lst.lst14      #FUN-C50085 add  
        AND lsr04 = g_lst.lst03      #CHI-C80047 add
   IF l_n= 0 THEN
      CALL cl_err('','alm-h11',0)
      RETURN
   END IF
  #TQC-C30054 add END
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
 
   OPEN i590_cl USING g_lst.lst01,g_lst.lst14,g_lst.lst00,   #FUN-C50085 add lst14   #FUN-C60089 add lst00
                      g_lst.lst03
   IF STATUS THEN
       CALL cl_err("OPEN i590_cl:", STATUS, 1)
       CLOSE i590_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i590_cl INTO g_lst.*      
    LET g_lst.lst09 = 'Y'
    LET g_lst.lst10=g_user
    LET g_lst.lst11=g_today
    UPDATE lst_file SET lst09 = g_lst.lst09,
                        lst10 = g_lst.lst10,
                        lst11 = g_lst.lst11
                     WHERE lst01 = g_lst.lst01
                       AND lst00 = g_lst.lst00  #FUN-C60089 add
                       AND lst03 = g_lst.lst03  #CHI-C80047 add
                       AND lst14=g_lst.lst14    #FUN-C50085 
                       AND lstplant = g_plant   #FUN-C60089 add
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lst_file",g_lst.lst01,"",SQLCA.sqlcode,"","",0)
       ROLLBACK WORK
       RETURN
    END IF
    CLOSE i590_cl
    COMMIT WORK
    DISPLAY BY NAME g_lst.lst09
    DISPLAY BY NAME g_lst.lst10
    DISPLAY BY NAME g_lst.lst11
    CALL i590_field_pic()
END FUNCTION 
 
FUNCTION i590_z()
DEFINE l_cnt LIKE type_file.num5
   IF g_lst.lst01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT count(*) INTO l_cnt FROM lrj_file WHERE lrj05 = g_lst.lst01
                                              AND lrj10 <> 'X'  #CHI-C80041
     IF l_cnt > 0 THEN
        CALL cl_err('','alm-810',0)
        RETURN
     END IF
   #FUN-C50085 add START
    IF g_plant <> g_lst.lst14 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    IF g_lst.lst16 = 'Y' THEN
       CALL cl_err('','art-888',0)
       RETURN
    END IF
   #FUN-C50085 add END

   IF g_lst.lst09="N" OR g_lst.lstacti="N" OR g_lst.lst09="X" THEN
      CALL cl_err("",'atm-365',1)
   ELSE
      IF cl_confirm('aap-224') THEN
         BEGIN WORK
         UPDATE lst_file SET lst09="N",
                            #CHI-D20015--modify--str--
                            # lst10 = '',
                            # lst11 = ''
                             lst10 = g_user,
                             lst11 = g_today 
                            #CHI-D20015--modify--end--
                            #,lstpos= 'N'    #No.FUN-A80022 #FUN-B50042 mark
                         WHERE lst01=g_lst.lst01
                           AND lst00 = g_lst.lst00  #FUN-C60089 add
                           AND lst03 = g_lst.lst03  #CHI-C80047 add
                           AND lst14=g_lst.lst14    #FUN-C50085
                           AND lstplant = g_plant   #FUN-C60089 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lst_file",g_lst.lst01,"",SQLCA.sqlcode,"","lst09",1)
            ROLLBACK WORK
         ELSE
            COMMIT WORK
            LET g_lst.lst09="N"
            #CHI-D20015--modify--str--
            #LET g_lst.lst10=""
            #LET g_lst.lst11=""
            LET g_lst.lst10= g_user
            LET g_lst.lst11= g_today
            #CHI-D20015--modify--end--
            #LET g_lst.lstpos='N'         #No.FUN-A80022 #FUN-B50042 mark
            #DISPLAY BY NAME g_lst.lstpos #No.FUN-A80022 #FUN-B50042 mark
            DISPLAY BY NAME g_lst.lst09
            DISPLAY BY NAME g_lst.lst10
            DISPLAY BY NAME g_lst.lst11
            CALL i590_field_pic()
         END IF
      END IF
   END IF
END FUNCTION
 
#FUNCTION i590_v()
#DEFINE l_cnt LIKE type_file.num5   
#  IF g_lst.lst01 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#  IF g_lst.lst09 ='Y' THEN
#     CALL cl_err('','8889',0)      
#     RETURN
#  END IF
#  IF g_lst.lstacti = 'N' THEN
#     CALL cl_err('','9028',0)      
#     RETURN
#  END IF
#  IF g_lst.lst08 MATCHES '[Ss11WwRr]' THEN 
#     CALL cl_err('','mfg3557',0)
#     RETURN
#  END IF 
#  SELECT count(*) INTO l_cnt FROM lrj_file WHERE lrj05 = g_lst.lst01
#    IF l_cnt > 0 THEN
#       CALL cl_err('','alm-810',0)
#       RETURN
#    END IF
## IF NOT cl_confirm('lib-016') THEN RETURN END IF
#  BEGIN WORK
 
#  OPEN i590_cl USING g_lst.lst01
#  IF STATUS THEN
#      CALL cl_err("OPEN i590_cl:", STATUS, 1)
#      CLOSE i590_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   FETCH i590_cl INTO g_lst.*      
#   IF g_lst.lst09 != 'X' THEN 
#      IF NOT cl_confirm('alm-085') THEN RETURN END IF
#      LET g_lst.lst09 = 'X'
#      LET g_lst.lst10=g_user
#      LET g_lst.lst11=g_today
#   ELSE 
#   	 IF NOT cl_confirm('alm-086') THEN RETURN END IF
#      LET g_lst.lst09 = 'N'
#      LET g_lst.lst10 =''
#      LET g_lst.lst11 =''
#   END IF       
#   UPDATE lst_file SET lst08 = g_lst.lst08,
#                       lst09 = g_lst.lst09,
#                       lstmodu=g_user,
#                       lstdate=g_today
#                    WHERE lst01 = g_lst.lst01
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("upd","lst_file",g_lst.lst01,"",SQLCA.sqlcode,"","",0)
#      ROLLBACK WORK
#      RETURN
#   END IF
#   CLOSE i590_cl
#   COMMIT WORK
#  SELECT lst08,lstmodu,lstdate
#    INTO g_lst.lst08,g_lst.lstmodu,g_lst.lstdate
#    FROM lst_file 
#    WHERE lst01=g_lst.lst01
#   DISPLAY BY NAME g_lst.lst08    
#   DISPLAY BY NAME g_lst.lst09
#   DISPLAY BY NAME g_lst.lst10
#   DISPLAY BY NAME g_lst.lst11
#   DISPLAY BY NAME g_lst.lstmodu
#   DISPLAY BY NAME g_lst.lstdate
#END FUNCTION  
 
FUNCTION i590_lst03(p_cmd)  
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_lph02     LIKE lph_file.lph02 
    DEFINE l_lph03     LIKE lph_file.lph03
    DEFINE l_lph06     LIKE lph_file.lph06 
    DEFINE l_lph24     LIKE lph_file.lph24
    DEFINE l_lphacti   LIKE lph_file.lphacti
    LET g_errno = ' '
    SELECT lph02,lph03,lph06,lph24,lphacti
      INTO l_lph02,l_lph03,l_lph06,l_lph24,l_lphacti
      FROM lph_file WHERE lph01 = g_lst.lst03 
                      AND lphacti='Y'
   #CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006'     #FUN-C50085 mark                     
    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm-h43'     #FUN-C50085 add
        #WHEN l_lphacti='N'      LET g_errno = 'mfg9028'     #FUN-C60089 mark
         WHEN l_lphacti='N'      LET g_errno = '9029'     #FUN-C60089 add                     
#        WHEN l_lph03 <> '0'     LET g_errno = 'alm-565'   #No.FUN-960134 mark
         WHEN l_lph06  ='N'      LET g_errno = 'alm-628'        
         WHEN l_lph24 <> 'Y'     LET g_errno = '9029'               
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'    
    END CASE                                                                    
    IF p_cmd = 'd' OR cl_null(g_errno) THEN                                                         
    DISPLAY l_lph02 TO FORMONLY.lph02                                           
    END IF                                                     
END FUNCTION
#TQC-C30054 mark START 
#FUNCTION i590_lss06(p_cmd)  
#   DEFINE p_cmd       LIKE type_file.chr1
#   DEFINE p_code      LIKE type_file.chr1
#   DEFINE l_lpx02     LIKE lpx_file.lpx02
#   DEFINE l_lpx15     LIKE lpx_file.lpx15
#   DEFINE l_lpxacti   LIKE lpx_file.lpxacti
#   LET g_errno = ' '
#   SELECT lpx02,lpx15,lpxacti INTO l_lpx02,l_lpx15,l_lpxacti
#     FROM lpx_file WHERE lpx01 = g_lss[l_ac].lss06
#                     AND lpxacti='Y'
#   #CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006'   #MOD-A30218
#   CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm-802'    #MOD-A30218
#        #WHEN l_lpxacti='N'      LET g_errno = 'mfg9028'   #MOD-A30218
#        WHEN l_lpx15 <> 'Y'     LET g_errno = '9029'
#        OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'        END CASE
#   IF p_cmd = 'd' OR cl_null(g_errno) THEN
#      LET g_lss[l_ac].lpx02 = l_lpx02  
#      DISPLAY g_lss[l_ac].lpx02 TO lpx02 
#   END IF
#END FUNCTION 
#TQC-C30054 mark END

FUNCTION i590_lsr02(p_cmd)  
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_lpx02     LIKE lpx_file.lpx02
    DEFINE l_lpx15     LIKE lpx_file.lpx15
    DEFINE l_lpxacti   LIKE lpx_file.lpxacti
    LET g_errno = ' '
    SELECT lpx02,lpx15,lpxacti INTO l_lpx02,l_lpx15,l_lpxacti
      FROM lpx_file WHERE lpx01 = g_lsr[l_ac].lsr02
                      AND lpxacti='Y'
    #CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006'   #MOD-A30218
    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm-758'    #MOD-A30218
         #WHEN l_lpxacti='N'      LET g_errno = 'mfg9028'   #MOD-A30218
         WHEN l_lpx15 <> 'Y'     LET g_errno = '9029'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'        END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_lsr[l_ac].lpx02_1 = l_lpx02  
       DISPLAY BY NAME g_lsr[l_ac].lpx02_1
    END IF
END FUNCTION 
 
#MOD-B10146 -------------------mark
#FUNCTION i590_ef()   #簽核
#  IF cl_null(g_lst.lst01) THEN 
#     CALL cl_err('','-400',0) 
#     RETURN 
#  END IF
#  
#  SELECT * INTO g_lst.* FROM lst_file
#   WHERE lst01=g_lst.lst01
#
#  IF g_lst.lst09 ='Y' THEN    
#     CALL cl_err(g_lst.lst01,'alm-005',0)
#     RETURN
#  END IF
#  
#  IF g_lst.lst09='X' THEN 
#     CALL cl_err('','9024',0)
#     RETURN
#  END IF
#  
#  IF g_lst.lst08 MATCHES '[Ss1WwRr]' THEN 
#     CALL cl_err('','mfg3557',0)
#     RETURN
#  END IF
# 
#  IF g_lst.lst07='N' THEN 
#     CALL cl_err('','mfg3549',0)
#     RETURN
#  END IF
#
#  IF g_success = "N" THEN
#     RETURN
#  END IF
#
##  CALL aws_condition() 
#  IF g_success = 'N' THEN
#     RETURN
#  END IF
#
#  IF aws_efcli2(base.TypeInfo.create(g_lst),'','','','','')
#  
#  THEN
#      LET g_success = 'Y'
#      LET g_lst.lst08 = 'S'
#      LET g_lst.lst07 = 'Y' 
#      DISPLAY BY NAME g_lst.lst10,g_lst.lst11
#  ELSE
#      LET g_success = 'N'
#  END IF
#END FUNCTION
#MOD-B10146 ----------------------mark
 
 FUNCTION i590_field_pic()
    DEFINE l_flag   LIKE type_file.chr1
 
    CASE
      WHEN g_lst.lstacti = 'N' 
         CALL cl_set_field_pic("","","","","","N")
      WHEN g_lst.lst09 = 'Y' 
         CALL cl_set_field_pic("Y","","","","","")
      OTHERWISE
         CALL cl_set_field_pic("","","","","","")
    END CASE
 END FUNCTION
 
#FUNCTION i590_out()
#  DEFINE l_cmd  LIKE type_file.chr1000   
#
#     IF cl_null(g_wc) AND NOT cl_null(g_lst01) THEN                         
#        LET g_wc = " lst01 = '",g_lst01,"'"                                 
#     END IF                                                                     
#     IF g_wc IS NULL THEN                                                       
#        CALL cl_err('','9057',0)                                                
#        RETURN                                                                  
#     END IF  
  ##NO.FUN-960134 GP5.2 add--begin	
FUNCTION i590_b1()
DEFINE
    l_ac_t          LIKE type_file.num5,              
    l_n             LIKE type_file.num5,              
    l_lock_sw       LIKE type_file.chr1,              
    p_cmd           LIKE type_file.chr1,              
    l_allow_insert  LIKE type_file.chr1,              
    l_allow_delete  LIKE type_file.chr1,              
    l_cnt           LIKE type_file.num10              

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    IF g_lst.lst01 IS NULL THEN
       RETURN
    END IF

    IF g_lst.lstacti ='N' THEN   
       CALL cl_err(g_lst.lst01,'mfg1000',0)
       RETURN
    END IF
    IF g_lst.lst09 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lst.lst09 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

   #FUN-C50085 add START
    IF g_plant <> g_lst.lst14 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
   #FUN-C50085 add END

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    LET g_forupd_sql =
        "SELECT lsr02,'' FROM lsr_file ",
        " WHERE lsr00 = '",g_lst.lst00,"' ",     #FUN-C60089 add
        "   AND lsr01 = '",g_lst.lst01,"' ",
        "   AND lsr03 = '",g_lst.lst14,"' ",     #FUN-C50085 add 
        "   AND lsr04 = '",g_lst.lst03,"' ",     #CHI-C80047 add
        "   AND lsrplant = '",g_plant,"' ",      #FUN-C60089 add
        "   AND lsr02 =? ",
        " ORDER BY lsr02 ", 
        "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i590_bcl2 CURSOR FROM g_forupd_sql      

    INPUT ARRAY g_lsr WITHOUT DEFAULTS FROM s_lsr.*
          ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 

    BEFORE INPUT
       IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF

    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'
        LET l_n  = ARR_COUNT()
        IF g_rec_b1>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_lsr_t.* = g_lsr[l_ac].*  
           OPEN i590_bcl2 USING  g_lsr[l_ac].lsr02
           IF STATUS THEN
              CALL cl_err("OPEN i590_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i590_bcl2 INTO g_lsr[l_ac].* 
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_lsr_t.lsr02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              SELECT lpx02 INTO g_lsr[l_ac].lpx02_1 
                FROM lpx_file 
               WHERE lpx01 =g_lsr[l_ac].lsr02 
           END IF
           CALL cl_show_fld_cont()     
           CALL i590_set_entry_b1(p_cmd)    
        END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_lsr[l_ac].* TO NULL      
           LET g_lsr_t.* = g_lsr[l_ac].*    
           LET g_lsr_o.* = g_lsr[l_ac].*   
           CALL i590_set_entry_b1(p_cmd)    
           NEXT FIELD lsr02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lsr_file(lsrplant,lsrlegal,lsr00,lsr01,lsr02,lsr03,lsr04)   #FUN-C50085 add lsr03  #FUN-C60089 add lsr00 #CHI-C80047 add lsr04
           VALUES(g_plant,g_legal,g_lst.lst00,g_lst.lst01,             #FUN-C60089 add lst00
                  g_lsr[l_ac].lsr02,g_plant,g_lst.lst03)               #FUN-C50085 add g_plant  #CHI-C80047 add lst03
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lsr_file",g_lst.lst01,g_lsr[l_ac].lsr02,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
#             LET g_rec_b=g_rec_b+1       #FUN-BC0058 MARK
              LET g_rec_b1=g_rec_b1+1     #FUN-BC0058
#             DISPLAY g_rec_b TO FORMONLY.cn2  #FUN-BC0058 MARK
              DISPLAY g_rec_b1 TO FORMONLY.cn2  #FUN-BC0058
           END IF

    AFTER FIELD lsr02
           IF NOT cl_null(g_lsr[l_ac].lsr02) THEN
              IF g_lsr[l_ac].lsr02 != g_lsr_t.lsr02
                 OR g_lsr_t.lsr02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM lsr_file
                  WHERE lsr01 = g_lst.lst01
                    AND lsr00 = g_lst.lst00    #FUN-C60089 add
                    AND lsr02 = g_lsr[l_ac].lsr02
                    AND lsr03 = g_lst.lst14    #FUN-C50085 add 
                    AND lsr04 = g_lst.lst03    #CHI-C80047 add
                    AND lsrplant = g_plant     #FUN-C60089 add
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lsr[l_ac].lsr02 = g_lsr_t.lsr02
                    NEXT FIELD lsr02
                 END IF
                 #-----MOD-A30218---------
                 #SELECT COUNT(*) INTO l_n 
                 #  FROM lpx_file 
                 # WHERE lpx01 = g_lsr[l_ac].lsr02 
                 #   AND lpx15 = 'Y' 
                 #IF l_n < 1  THEN
                 #   CALL cl_err('','alm-758',0)
                 #   LET g_lsr[l_ac].lsr02 = g_lsr_t.lsr02
                 #   NEXT FIELD lsr02
                 #END IF                      
                 #-----END MOD-A30218-----
                 CALL i590_lsr02(p_cmd)
                 #-----MOD-A30218---------
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lsr[l_ac].lsr02,g_errno,0)  
                    NEXT FIELD lsr02
                 END IF
                 #SELECT  COUNT(*) INTO l_n FROM lpx_file
                 # WHERE lpx01 = g_lsr[l_ac].lsr02
                 #   AND lpx15 = 'Y'
                 #IF l_n < 0  THEN 
                 #  CALL cl_err('','',1)   
                 #  NEXT FIELD lsr02
                 #END IF
                 #-----END MOD-A30218-----
              END IF
           END IF 

        BEFORE DELETE    
#          IF NOT cl_null(g_lss_t.lss02) THEN   #FUN-BC0058  mark
           IF NOT cl_null(g_lsr_t.lsr02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lsr_file
               WHERE lsr01 = g_lst.lst01
                 AND lsr00 = g_lst.lst00        #FUN-C60089 add
                 AND lsr02 = g_lsr_t.lsr02
                 AND lsr03 = g_lst.lst14        #FUN-C50085 add 
                 AND lsr04 = g_lst.lst03        #CHI-C80047 add
                 AND lsrplant = g_plant         #FUN-C60089 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lsr_file","","",SQLCA.sqlcode,"","",1)   
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF
           COMMIT WORK   

     ON ROW CHANGE
        IF INT_FLAG THEN                 
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_lsr[l_ac].* = g_lsr_t.*
           CLOSE i590_bcl2
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_lsr[l_ac].lsr02,-263,0)
           LET g_lsr[l_ac].* = g_lsr_t.*
        ELSE
           UPDATE lsr_file 
              SET lsr02 =g_lsr[l_ac].lsr02 ,
                  lsrplant = g_plant,
                  lsrlegal = g_legal 
            WHERE lsr01=g_lst.lst01
              AND lsr00 = g_lst.lst00   #FUN-C60089 add
              AND lsr02=g_lsr_t.lsr02
              AND lsr03 = g_lst.lst14   #FUN-C50085 add
              AND lsr04 = g_lst.lst03   #CHI-C80047 add
              AND lsrplant = g_plant    #FUN-C60089 add
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","lsr_file",g_lsr_t.lsr02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_lsr[l_ac].* = g_lsr_t.*
           ELSE
           	 COMMIT WORK 
           END IF
        END IF

     AFTER ROW
        LET l_ac = ARR_CURR()         
       #LET l_ac_t = l_ac         #FUN-D30033 Mark      

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_lsr[l_ac].* = g_lsr_t.*
           #FUN-D30033--add--str--
           ELSE
              CALL g_lsr.deleteElement(l_ac)
              IF g_rec_b1 != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30033--add--end-- 
           END IF
           CLOSE i590_bcl2       
           ROLLBACK WORK        
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac         #FUN-D30033 Add
        CLOSE i590_bcl2          
        COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(lsr02)  #券類型編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpx01_2"    #add by hellen 090709
                 LET g_qryparam.default1 = g_lsr[l_ac].lsr02
                 LET g_qryparam.arg1 =g_plant  #TQC-C30054 add
                 CALL cl_create_qry() RETURNING g_lsr[l_ac].lsr02
                 DISPLAY BY NAME g_lsr[l_ac].lsr02
                 CALL i590_lsr02('d')
                 NEXT FIELD lsr02
               OTHERWISE EXIT CASE
            END CASE

     ON ACTION CONTROLR
         CALL cl_show_req_fields()

     ON ACTION CONTROLG
         CALL cl_cmdask()

     ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
     
     END INPUT


    CLOSE i590_bcl2
    COMMIT WORK
END FUNCTION      

FUNCTION i590_b1_fill(p_wc3)             
DEFINE p_wc3           VARCHAR(200)

    LET g_sql =
        "SELECT lsr02,''  FROM lsr_file ",
        " WHERE lsr01 ='",g_lst.lst01,"' ",
        "   AND lsr00 = '",g_lst.lst00,"' ",            #FUN-C60089 add
        "   AND lsr03 = '",g_lst.lst14,"' ",            #FUN-C50085 add
        "   AND lsr04 = '",g_lst.lst03,"' ",            #CHI-C80047 add
       #"   AND lsrplant = '",g_plant,"' ",             #FUN-C60089 add   #CHI-C80047 mark
        "   AND lsrplant = '",g_lst.lstplant,"' ",      #CHI-C80047 add
#       "   AND lsrplant IN ",g_auth,  
        "   AND ",p_wc3 CLIPPED,
        " ORDER BY lsr02 " 

    PREPARE i590_pd FROM g_sql
    DECLARE lsr_curs CURSOR FOR i590_pd

    CALL g_lsr.clear()
   LET g_cnt = 1

    FOREACH lsr_curs INTO g_lsr[g_cnt].*   
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
              SELECT lpx02 INTO g_lsr[g_cnt].lpx02_1 
                FROM lpx_file 
               WHERE lpx01 =g_lsr[g_cnt].lsr02          
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_lsr.deleteElement(g_cnt)
    LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
END FUNCTION

FUNCTION i590_lstplant()
DEFINE l_rtz13      LIKE rtz_file.rtz13     #FUN-A80148  
DEFINE l_azt02      LIKE azt_file.azt02
 
  DISPLAY '' TO FORMONLY.rtz13
  
  IF NOT cl_null(g_lst.lstplant) THEN 
      SELECT rtz13 INTO l_rtz13 FROM rtz_file 
       WHERE rtz01 = g_lst.lstplant
         AND rtz28 = 'Y'
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   
     SELECT azt02 INTO l_azt02 FROM azt_file
      WHERE azt01 = g_lst.lstlegal
     DISPLAY l_azt02 TO FORMONLY.azt02
  END IF 
END FUNCTION

  ##NO.FUN-960134 GP5.2 add--end                                                                   

#FUN-B60059 將程式由t類改成i類
#FUN-C50085 add START
FUNCTION i590_lst14()  #制定營運中心名稱
DEFINE l_rtz13      LIKE rtz_file.rtz13  

   DISPLAY '' TO FORMONLY.lst14_desc
     
   IF NOT cl_null(g_lst.lst14) THEN
       SELECT rtz13 INTO l_rtz13 FROM rtz_file
        WHERE rtz01 = g_lst.lst14
          AND rtz28 = 'Y'
       DISPLAY l_rtz13 TO FORMONLY.lst14_desc
     
   END IF
END FUNCTION

FUNCTION i590_iss()  #發佈
DEFINE l_sql         STRING
DEFINE l_lni04       LIKE lni_file.lni04
DEFINE l_lnilegal    LIKE lni_file.lnilegal
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5

  #CHI-C80047 add START
      SELECT * INTO g_lst.* FROM lst_file
       WHERE lst01 = g_lst.lst01
         AND lst00 = g_lst.lst00  
         AND lst03 = g_lst.lst03  
         AND lst14 = g_lst.lst14  
         AND lstplant = g_plant   
  #CHI-C80047 add END

   IF cl_null(g_lst.lst01) THEN 
      RETURN 
      CALL cl_err('','-400',0)
   END IF

   IF g_lst.lst09 <> 'Y' THEN 
      CALL cl_err('','art-656',0)
      RETURN 
   END IF 
   IF g_plant <> g_lst.lst14 THEN
      CALL cl_err('','art-663',0)
      RETURN
   END IF  
   IF g_lst.lst16 = 'Y' THEN
      CALL cl_err('','art-662',0)
      RETURN
   END IF
  
   CALL i590_chk_lni04()  #判斷其他生效營運中心是否已存在此兌換單號
   IF g_success = 'N' THEN
      RETURN
   END IF

   IF NOT cl_confirm('art-660') THEN
      RETURN
   END IF 

   DROP TABLE lst_temp
   SELECT * FROM lst_file WHERE 1 = 0 INTO TEMP lst_temp
   DROP TABLE lss_temp
   SELECT * FROM lss_file WHERE 1 = 0 INTO TEMP lss_temp
   DROP TABLE lsr_temp
   SELECT * FROM lsr_file WHERE 1 = 0 INTO TEMP lsr_temp
   DROP TABLE lni_temp
   SELECT * FROM lni_file WHERE 1 = 0 INTO TEMP lni_temp

   BEGIN WORK
   LET g_success = 'Y' 
   LET l_sql="SELECT DISTINCT lni04 FROM lni_file ",
            #" WHERE lni01=? AND lni02=1"                   #FUN-C60089 mark
             " WHERE lni01 = ? AND lni02 = '",g_lni02,"' ", #FUN-C60089 add 
             "   AND lni15 = '",g_lst.lst03,"' ",           #CHI-C80047 add
             "   AND lniplant = '",g_lst.lstplant,"' "      #FUN-C60089 add
   PREPARE lni_pre FROM l_sql
   DECLARE lni_cs CURSOR FOR lni_pre
   FOREACH lni_cs USING g_lst.lst01 
                  INTO l_lni04
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL s_errmsg('','','Foreach lni_cs:',SQLCA.sqlcode,1)
      END IF
      IF cl_null(l_lni04) THEN CONTINUE FOREACH END IF
     #FUN-C60089 mark START
     #IF g_lst.lst14 <> l_lni04 THEN
     #   SELECT COUNT(*) INTO l_cnt FROM azw_file
     #    WHERE azw07 = g_lst.lst14 
     #      AND azw01 = l_lni04
     #   IF l_cnt = 0 THEN
     #      CONTINUE FOREACH
     #   END IF
     #END IF
     #FUN-C60089 mark END
      LET g_plant_new = l_lni04

      DELETE FROM lst_temp
      DELETE FROM lss_temp
      DELETE FROM lsr_temp
      DELETE FROM lni_temp

      SELECT azw02 INTO l_lnilegal FROM azw_file
       WHERE azw01 = l_lni04 AND azwacti='Y'

      IF g_lst.lst14 = l_lni04 THEN     #與當前機構相同則不拋
         UPDATE lst_file SET lst16 = 'Y', lst17 = g_today
          WHERE lst01 =g_lst.lst01 
            AND lst00 = g_lst.lst00  #FUN-C60089 add
            AND lst03 = g_lst.lst03  #CHI-C80047 add
            AND lst14 = g_lst.lst14 
            AND lstplant = g_plant   #FUN-C60089 add 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lst_file",g_lst.lst01,"",STATUS,"","",1)
            LET g_success = 'N'
            EXIT FOREACH  
         END IF
      ELSE  
      #將數據放入臨時表中處理
         INSERT INTO lst_temp SELECT lst_file.* FROM lst_file
                               WHERE lst01 = g_lst.lst01 
                                 AND lst00 = g_lst.lst00  #FUN-C60089 add
                                 AND lst03 = g_lst.lst03  #CHI-C80047 add
                                 AND lst14 = g_lst.lst14
                                 AND lstplant = g_plant   #FUN-C60089 add
         UPDATE lst_temp SET lst16 = 'Y',
                             lst17 = g_today, 
                             lstplant = l_lni04,
                             lstlegal = l_lnilegal

         INSERT INTO lss_temp SELECT lss_file.* FROM lss_file
                               WHERE lss00 = g_lst.lst00   #FUN-C60089 add
                                 AND lss08 = g_lst.lst03   #CHI-C80047 add
                                 AND lss01 = g_lst.lst01 AND lss07 = g_lst.lst14
                                 AND lssplant = g_plant    #FUN-C60089 add
         UPDATE lss_temp SET lssplant = l_lni04,
                             lsslegal = l_lnilegal

         INSERT INTO lsr_temp SELECT lsr_file.* FROM lsr_file      
                               WHERE lsr00 = g_lst.lst00    #FUN-C60089 add
                                 AND lsr04 = g_lst.lst03    #CHI-C80047 add
                                 AND lsr01 = g_lst.lst01 AND lsr03 = g_lst.lst14
                                 AND lsrplant = g_plant     #FUN-C60089 add
         UPDATE lsr_temp SET lsrplant = l_lni04,
                             lsrlegal = l_lnilegal

         INSERT INTO lni_temp SELECT lni_file.* FROM lni_file      
                              #WHERE lni01 = g_lst.lst01 AND lni02 = '1' AND lni14 = g_lst.lst14      #FUN-C60089 mark
                               WHERE lni01 = g_lst.lst01 AND lni02 = g_lni02 AND lni14 = g_lst.lst14  #FUN-C60089 add
                                 AND lni15 = g_lst.lst03         #CHI-C80047 add
                                 AND lniplant = g_lst.lstplant   #FUN-C60089 add
         UPDATE lni_temp SET lniplant = l_lni04,
                             lnilegal = l_lnilegal

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lst_file'),   #單頭
                     " SELECT * FROM lst_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lst FROM l_sql
         EXECUTE trans_ins_lst
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lst_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH   
         END IF

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lss_file'),   #第一單身
                     " SELECT * FROM lss_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lss FROM l_sql
         EXECUTE trans_ins_lss
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lss_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH   
         END IF

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lsr_file'),   #第二單身
                     " SELECT * FROM lsr_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lsr FROM l_sql
         EXECUTE trans_ins_lsr
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lsr_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH   
         END IF

         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lni_file'),   #生效營運中心
                     " SELECT * FROM lni_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lni FROM l_sql
         EXECUTE trans_ins_lni
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lni_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH   
         END IF

      END IF  
 
   END FOREACH

   CALL i590_ins_lst()

   IF g_success = 'N' THEN
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   END IF

  #FUN-C60089 add START
   UPDATE lst_file SET lst16 = 'Y', lst17 = g_today
    WHERE lst01 =g_lst.lst01
      AND lst00 = g_lst.lst00  #FUN-C60089 add
      AND lst03 = g_lst.lst03  #CHI-C80047 add
      AND lst14 = g_lst.lst14
      AND lstplant = g_plant   #FUN-C60089 add
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lst_file",g_lst.lst01,"",STATUS,"","",1)
      LET g_success = 'N'
   END IF
  #FUN-C60089 add END

   IF g_success = 'Y' THEN #拋磚成功
      MESSAGE "TRANS_DATA_OK !"
      COMMIT WORK
   END IF

   DROP TABLE lst_temp
   DROP TABLE lss_temp
   DROP TABLE lsr_temp
   DROP TABLE lni_temp

   SELECT DISTINCT lst16,lst17 
      INTO g_lst.lst16,g_lst.lst17 
      FROM lst_file
      WHERE lst00 = g_lst.lst00    #FUN-C60089 add
        AND lst01 = g_lst.lst01 AND lst14 = g_lst.lst14
        AND lst03 = g_lst.lst03    #CHI-C80047 add
        AND lstplant = g_plant     #FUN-C60089 add
   DISPLAY BY NAME g_lst.lst16,g_lst.lst17 

END FUNCTION

#發佈確認後,將資料複製一份到almt590內,版號預計為0
FUNCTION i590_ins_lst()
DEFINE l_sql           STRING
DEFINE l_lni04         LIKE lni_file.lni04
DEFINE l_lnilegal      LIKE lni_file.lnilegal
DEFINE l_lst           RECORD LIKE lst_file.*
DEFINE l_lss           RECORD LIKE lss_file.*
DEFINE l_lsr           RECORD LIKE lsr_file.* 
DEFINE l_lni           RECORD LIKE lni_file.*

   LET l_sql="SELECT DISTINCT lni04 FROM lni_file ",
            #" WHERE lni01=? AND lni02=1 AND lni14 = '",g_lst.lst14,"' "                      #FUN-C60089 mark
             " WHERE lni01 = ? AND lni02 = '",g_lni02,"' AND lni14 = '",g_lst.lst14,"' ",  #FUN-C60089 add
             "   AND lni15 = '",g_lst.lst03,"' ",        #CHI-C80047 add
             "   AND lniplant = '",g_lst.lstplant,"' "   #FUN-C60089 add
   PREPARE lni_pre1 FROM l_sql
   DECLARE lni_cs1 CURSOR FOR lni_pre1
   FOREACH lni_cs1 USING g_lst.lst01
                  INTO l_lni04
      IF cl_null(l_lni04) THEN CONTINUE FOREACH END IF

      SELECT azw02 INTO l_lnilegal FROM azw_file
       WHERE azw01 = l_lni04 AND azwacti='Y'

      SELECT * INTO l_lst.* FROM lst_file     
        WHERE lst00 = g_lst.lst00 AND lst01 = g_lst.lst01 
          AND lst03 = g_lst.lst03                          #CHI-C80047 add
          AND lst14 = g_lst.lst14 AND lstplant = g_lst.lstplant
     
      #單頭 
      LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lsu_file'),
                  "        (lsu00,lsu01,lsu02,lsu03,lsu04,lsu05,lsu06,lsu07,lsu08, ",
                  "         lsu09,lsu10,lsu11,lsu12,lsu13,lsu14,lsuacti,lsucrat,lsudate,lsugrup, ",
                  "         lsulegal,lsumodu,lsuorig,lsuoriu,lsuplant,lsuuser ) ",
                  " VALUES( '",l_lst.lst00,"', '",l_lst.lst01,"', '",l_lst.lst03,"','",l_lst.lst04,"', ",
                  "         '",l_lst.lst05,"','",l_lst.lst06,"', 'Y', '",g_user,"','",g_today,"','",l_lst.lst12,"',",
                  "         '",l_lst.lst13,"','",l_lst.lst14,"',0,'",l_lst.lst18,"','",l_lst.lst19,"', ",
                  "         '",l_lst.lstacti,"','",l_lst.lstcrat,"',",
                  "         '', '",l_lst.lstgrup,"', '",l_lnilegal,"','",l_lst.lstmodu,"', ",
                  "         '",l_lst.lstorig,"', '",l_lst.lstoriu,"','",l_lni04,"','",l_lst.lstuser,"')"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
      PREPARE trans_ins_lsu FROM l_sql
      EXECUTE trans_ins_lsu
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','INSERT INTO lsu_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH   
      END IF
      #第一單身
      LET l_sql = " SELECT * FROM lss_file ",
                  "    WHERE lss01 = '",g_lst.lst01,"' ",
                  "      AND lss00 = '",g_lst.lst00,"' ",  #FUN-C60089 add
                  "      AND lss07 = '",g_lst.lst14,"' ",
                  "      AND lss08 = '",g_lst.lst03,"' ",  #CHI-C80047 add
                  "      AND lssplant = '",g_lst.lst14,"' "
      PREPARE lss_pre FROM l_sql
      DECLARE lss_cs1 CURSOR FOR lss_pre
      FOREACH lss_cs1 INTO l_lss.* 
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lsv_file'),
                     "        (lsv00,lsv01,lsv02,lsv03,lsv04,lsv05,lsv06,lsv07,lsv08,lsvlegal,lsvplant )",   #FUN-C60089 add lsv00  #CHI-C80047 add lsv08
                     " VALUES( '",l_lss.lss00,"', '",l_lss.lss01,"', '",l_lss.lss02,"', '",l_lss.lss03,"','",l_lss.lss04,"', ",   #FUN-C60089 add lss00
                     "         '",l_lss.lss05,"', '",l_lss.lss07,"',0,'",l_lss.lss08,"','",l_lnilegal,"','",l_lni04,"')"         #CHI-C80047 add lss08
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lsv FROM l_sql
         EXECUTE trans_ins_lsv
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lsv_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH  
         END IF 
      END FOREACH
      #第二單身
      LET l_sql = " SELECT * FROM lsr_file ",
                  "    WHERE lsr01 = '",g_lst.lst01,"' ",
                  "      AND lsr00 = '",g_lst.lst00,"' ",  #FUN-C60089 add
                  "      AND lsr03 = '",g_lst.lst14,"' ",
                  "      AND lsr04 = '",g_lst.lst03,"' ",  #CHI-C80047 add
                  "      AND lsrplant = '",g_lst.lst14,"' "
      PREPARE lsr_pre FROM l_sql
      DECLARE lsr_cs CURSOR FOR lsr_pre
      FOREACH lsr_cs INTO l_lsr.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lsw_file'),
                     "        (lsw00,lsw01,lsw02,lsw03,lsw04,lsw05,lswlegal,lswplant) ",   #FUN-C60089 add lsw00  #CHI-C80047 add lsw05
                     " VALUES( '",l_lsr.lsr00,"','",l_lsr.lsr01,"', '",l_lsr.lsr02,"', '",l_lsr.lsr03,"', ",   #FUN-C60089 add lsr00
                     "         0,'",l_lsr.lsr04,"','",l_lnilegal,"','",l_lni04,"')"     #CHI-C80047 add lsr04
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lsw FROM l_sql
         EXECUTE trans_ins_lsw
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lsw_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH  
         END IF
      END FOREACH
      #生效營運中心
      LET l_sql = " SELECT * FROM lni_file ",
                 #"    WHERE  lni01 = '",g_lst.lst01,"' AND lni02 = '1' ",           #FUN-C60089 mark
                  "    WHERE  lni01 = '",g_lst.lst01,"' AND lni02 = '",g_lni02,"' ", #FUN-C60089 add 
                  "      AND lni14 = '",g_lst.lst14,"' ",
                  "      AND lni15 = '",g_lst.lst03,"' ",   #CHI-C80047 add
                  "      AND lniplant = '",g_lst.lst14,"' "
      PREPARE lni_pre2 FROM l_sql
      DECLARE lni_cs2 CURSOR FOR lni_pre2
      FOREACH lni_cs2 INTO l_lni.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_lni04, 'lsz_file'),
                     "        (lsz01,lsz02,lsz03,lsz04,lsz05,lsz06,lsz07,lsz08,",
                     "         lsz09,lsz10,lsz11,lsz12,lsz13,lszlegal,lszplant ) ",       #CHI-C80047 add lsz13
                     " VALUES( '",l_lni.lni01,"', '",l_lni.lni02,"', '",l_lni.lni04,"','",l_lni.lni07,"', ",
                     "         '",l_lni.lni08,"','','','",l_lni.lni11,"','','",l_lni.lni13,"',",
                     "         '",l_lni.lni14,"',0,'",l_lni.lni15,"','",l_lnilegal,"','",l_lni04,"')"   #CHI-C80047 add lni15
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
         PREPARE trans_ins_lsz FROM l_sql
         EXECUTE trans_ins_lsz
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lsz_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH  
         END IF
      END FOREACH
   END FOREACH

END FUNCTION

FUNCTION i590_lst01(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_lsl01     LIKE lsl_file.lsl01
    DEFINE l_lsl02     LIKE lsl_file.lsl02
    DEFINE l_lsl03     LIKE lsl_file.lsl03
    DEFINE l_lsl04     LIKE lsl_file.lsl04
    DEFINE l_lsl05     LIKE lsl_file.lsl05
    DEFINE l_lslconf   LIKE lsl_file.lslconf

    LET g_errno = ' '
    SELECT lsl01,lsl02,lsl03,lsl04,lsl05,lslconf 
      INTO l_lsl01,l_lsl02,l_lsl03,l_lsl04,l_lsl05,l_lslconf
      FROM lsl_file WHERE lsl02 = g_lst.lst01
                      AND lsl01 = g_lst.lst14 

    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm-h43' 
        #WHEN l_lslconf='N'      LET g_errno = 'mfg9028'   #FUN-C60089 mark  
         WHEN l_lslconf='N'      LET g_errno = '9029'   #FUN-C60089 add
         WHEN l_lsl01 <> g_plant LET g_errno = 'art-663'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_lst.lst02 = l_lsl03
    IF p_cmd = 'a' AND g_action_choice <> 'reproduce' THEN         #CHI-C80047 add
       LET g_lst.lst04 = l_lsl04
       LET g_lst.lst05 = l_lsl05
    END IF                       #CHI-C80047 add
    DISPLAY l_lsl03 TO FORMONLY.lsl03
    DISPLAY BY NAME g_lst.lst04, g_lst.lst05
END FUNCTION

FUNCTION i590_chk_lni04()
   DEFINE l_sql        STRING
   DEFINE l_lni04      LIKE lni_file.lni04
   DEFINE l_cnt        LIKE type_file.num5

   CALL s_showmsg_init()
   LET l_sql = "SELECT DISTINCT lni04 FROM lni_file  ",
              #"  WHERE lni01 = '",g_lst.lst01,"' AND lni02 = '1' ",           #FUN-C60089 mark
               "  WHERE lni01 = '",g_lst.lst01,"' AND lni02 = '",g_lni02,"' ", #FUN-C60089 add
               "    AND lni14 = '",g_lst.lst14,"' AND lni13 = 'Y' ",
               "    AND lni15 = '",g_lst.lst03,"' ",        #CHI-C80047 add
               "    AND lniplant = '",g_lst.lstplant,"' "   #FUN-C60089 add
   PREPARE lni_pre3 FROM l_sql
   DECLARE lni_cs3 CURSOR FOR lni_pre3
   FOREACH lni_cs3 INTO l_lni04 
      IF cl_null(l_lni04) THEN CONTINUE FOREACH END IF
      LET l_cnt = 0
      #判斷其他生效營運中心是否已存在此兌換單號
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lni04, 'lst_file'),
                  "   WHERE lst01 = '",g_lst.lst01,"'  AND lst09 = 'Y' AND lst16 = 'Y' ",
                  "     AND lst03 = '",g_lst.lst03,"' ",     #CHI-C80047 add
                  "     AND lstacti = 'Y' AND lst00 = '",g_lst.lst00,"'  "   #FUN-C60089 add lst00
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_lni04) RETURNING l_sql
      PREPARE trans_cnt FROM l_sql
      EXECUTE trans_cnt INTO l_cnt
      IF l_cnt > 0 THEN
         CALL s_errmsg('lni04',l_lni04,l_lni04,'alm-h32',1) 
         LET g_success = 'N' 
      END IF

      #判斷營運中心是否符合卡種生效營運中心
      LET l_cnt = 0
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lni04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_lst.lst03,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",l_lni04,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_lni04 ) RETURNING l_sql
      PREPARE trans_cnt1 FROM l_sql
      EXECUTE trans_cnt1 INTO l_cnt

      IF l_cnt = 0 OR cl_null(l_cnt) THEN
         CALL s_errmsg('lni04',l_lni04,l_lni04,'alm-h33',1)
         LET g_success = 'N' 
      END IF
   END FOREACH
   CALL s_showmsg()
END FUNCTION

FUNCTION i590_entry_lst19()
  IF g_lst.lst18 = '1' THEN   #當兌換限制為1.不限兌換次數時,兌換次數不可編輯
     LET g_lst.lst19 = 0 
     DISPLAY BY NAME g_lst.lst19
     CALL cl_set_comp_entry("lst19,",FALSE)
  ELSE 
     CALL cl_set_comp_entry("lst19,",TRUE)
     CALL cl_set_comp_required("lst19",TRUE) 
  END IF
END FUNCTION

#FUN-C50085 add END
