# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgr183.4gl (copy from aglr183)
# Descriptions...: 部門費用預算比較報表列印
# Date & Author..: 03/03/11 By Kammy
# Modify.........: No.FUN-580010 05/08/09 By yoyo 憑証類報表原則修改
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/08 By baogui 報表修改
# Modify.........: No.FUN-740029 07/04/11 By johnray 會計科目加帳套
# Modify.........: NO.FUN-750025 07/07/19 BY TSD.c123k 改為crystal report
# Modify.........: NO.FUN-810069 08/02/28 By chenmoyan去掉budget1,budget2
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40036 10/04/22 By Summer 相關有使用afb04,afb041,afb042若給予''者,將改為' '
# Modify.........: No:CHI-A20007 10/10/28 By sabrina 欄位抓錯，afb041、afc041才是部門編號
# Modify.........: No:FUN-AB0020 10/11/08 By suncx 新增欄位預算項目，處理相關邏輯
# Modify.........: No.FUN-B20054 11/02/22 By lixiang 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No:CHI-B30084 11/07/06 By Dido 預算金額應含追加和挪用部份
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc       LIKE type_file.chr1000,   #No.FUN-680061 VARCHAR(200)
              bdept,edept   LIKE aab_file.aab02, #No.FUN-680061 VARCHAR(6)
              defyy    LIKE abk_file.abk03,      #No.FUN-680061 SMALIINT       
              defbm    LIKE afc_file.afc05,      #No.FUN-680061 SMALIINT      
              defem    LIKE afc_file.afc05,      #No.FUN-680061 SMALIINT       
              comyy    LIKE abk_file.abk03,      #No.FUN-680061 SMALIINT       
              combm    LIKE afc_file.afc05,      #No.FUN-680061 SMALIINT      
              comem    LIKE afc_file.afc05,      #No.FUN-680061 SMALIINT    
#             budget1  LIKE afa_file.afa01,      #No.FUN-680061 VARCHAR(4)  #No.FUN-810069
#             budget2  LIKE afa_file.afa01,      #No.FUN-680061 VARCHAR(4)  #No.FUN-810069
              budget1  LIKE azf_file.azf01,      #No.FUN-AB0020 add                                                  
              budget2  LIKE azf_file.azf01,      #No.FUN-AB0020 add
              type     LIKE type_file.chr1,      #No.FUN-680061 VARCHAR(1) 
              diff1    LIKE type_file.num20_6,   #No.FUN-680061 DEC(20,6)
              diff2    LIKE type_file.num20_6,   #No.FUN-680061 DEC(20,6)  
              more     LIKE type_file.chr1,      #No.FUN-680061 VARCHAR(1)
              bookno   LIKE aaa_file.aaa01       #No.FUN-740029
              END RECORD,
          l_buf        LIKE type_file.chr20,     #No.FUN-680061 VARCHAR(10)
 #         g_bookno     LIKE aah_file.aah00,      #帳別    #No.FUN-740029
          t_defcharge  LIKE type_file.num20_6,   #No.FUN-680061 DEC(20,6)
          l_flag       LIKE type_file.chr1       #No.FUN-680061 VARCHAR(1)
DEFINE   g_i           LIKE type_file.num5       #count/index for any purpose    #No.FUN-680061 SMALLINT
DEFINE   g_aaa03       LIKE  aaa_file.aaa03
DEFINE   g_before_input_done  LIKE type_file.num5        #No.FUN-680061 SMALLINT
DEFINE   p_cmd         LIKE type_file.chr1               #No.FUN-680061  VARCHAR(1)
DEFINE   g_msg         LIKE type_file.chr1000            #No.FUN-680061  VARCHAR(100)
DEFINE   g_str         STRING          # FUN-750025 TSD.c123k
DEFINE   l_table       STRING          # FUN-750025 TSD.c123k
DEFINE   g_sql         STRING          # FUN-750025 TSD.c123k  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
 
   # add FUN-750025
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "l_buf.type_file.chr20,",
               "l_st.type_file.chr1,",
               "afc00.afc_file.afc00,",  
               "afc02.afc_file.afc02,",
              #"afc04.afc_file.afc04,",      #CHI-A20007 mark
               "afc041.afc_file.afc041,",    #CHI-A20007 add
               "aag02.aag_file.aag02,",
               "l_defcharge.type_file.num20_6,",
               "l_lastcharge.type_file.num20_6,",
               "l_diff1.type_file.num20_6,",
               "l_difpercent.type_file.num20_6,",
               "l_difperyy.type_file.num20_6,",
               "t_defcharge.type_file.num20_6,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('abgr183',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end Fun-750025
 
   LET g_trace = 'N'                # default trace off
#   LET g_bookno = ARG_VAL(1)       #No.FUN-740029
   LET tm.bookno = ARG_VAL(1)       #No.FUN-740029
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.defyy = ARG_VAL(9)
   LET tm.defbm = ARG_VAL(10)
   LET tm.defem = ARG_VAL(11)
   LET tm.comyy = ARG_VAL(12)
   LET tm.combm = ARG_VAL(13)
   LET tm.comem = ARG_VAL(14)
   LET tm.type  = ARG_VAL(15)
   LET tm.diff1 = ARG_VAL(16)
   LET tm.diff2 = ARG_VAL(17)
#  LET tm.budget1 = ARG_VAL(18)   #No.FUN-810069
#  LET tm.budget2 = ARG_VAL(19)   #No.FUN-810069
   LET tm.budget1 = ARG_VAL(18)   #FUN-AB0020 add
   LET tm.budget2 = ARG_VAL(19)   #FUN-AB0020 add
   LET tm.bdept   = ARG_VAL(20)   #TQC-610054
   LET tm.edept   = ARG_VAL(21)   #TQC-610054
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
   LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

#   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF   #FUN-740029
   IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF   #No.FUN-740029
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r183_tm()                # Input print condition
      ELSE CALL r183()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r183_tm()
   DEFINE p_row,p_col  LIKE type_file.num5,     #No.FUN-680061 SMALLINT
          l_sw         LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(100)
   DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054 
 
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
 
#   CALL s_dsmark(g_bookno)   #No.FUN-740029
   CALL s_dsmark(tm.bookno)   #No.FUN-740029
   LET p_row = 4 LET p_col = 8
   OPEN WINDOW r183_w AT p_row,p_col
        WITH FORM "abg/42f/abgr183"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)  #No.FUN-740029
   CALL s_dsmark(tm.bookno)   #No.FUN-740029
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
 
  #SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
  #IF SQLCA.sqlcode THEN CALL cl_err('sel aaa:',SQLCA.sqlcode,0) END IF
   LET tm.defyy=YEAR(g_today)
   LET tm.defbm=MONTH(g_today)
   LET tm.defem=MONTH(g_today)
   LET tm.type = ' '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_flag   ='Y'
   LET t_defcharge=0
   LET tm.bookno = g_aza.aza81   #No.FUN-B20054
   WHILE TRUE
    #FUN-B20054--add--str--
    LET l_sw = 1
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno 
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 =tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD bookno 
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end
      CONSTRUCT BY NAME tm.wc ON aag01
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

#FUN-B20054--mark--str-- 
#     ON ACTION locale
#         #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#   ON IDLE g_idle_seconds
#      CALL cl_on_idle()
#      CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
END CONSTRUCT

#FUN-B20054--mark--str--
#       LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0 CLOSE WINDOW abgr183_w 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
#       EXIT PROGRAM
#          
#    END IF
#FUN-B20054--mark--end

   #IF tm.wc=" 1=1" THEN  CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
    #LET l_sw = 1    #No.FUN-B20054
    INPUT BY NAME 
          #       tm.bookno,                      #No.FUN-B20054   
                  tm.bdept,tm.edept,              #No.FUN-740029
          #       tm.defyy,tm.defbm,tm.defem,tm.budget1,    #No.FUN-810069
          #       tm.defyy,tm.defbm,tm.defem,               #No.FUN-810069
                  tm.defyy,tm.defbm,tm.defem,tm.budget1,    #No.FUN-AB0020
          #       tm.comyy,tm.combm,tm.comem,tm.budget2,    #No.FUN-810069
          #       tm.comyy,tm.combm,tm.comem,               #No.FUN-810069 
                  tm.comyy,tm.combm,tm.comem,tm.budget2,    #No.FUN-AB0020 
                  tm.diff1,tm.diff2,tm.type,tm.more
          #       WITHOUT DEFAULTS   #FUN-B20054
          ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
#FUN-B20054--mark-str--
#      #No.FUN-740029 -- begin --
#      AFTER FIELD bookno
#         IF tm.bookno IS NULL THEN
#            CALL cl_err('','atm-339',0)
#            NEXT FIELD bookno
#         END IF
#      #No.FUN-740029 -- end --
#FUN-B20054--mark--end
  
      AFTER FIELD defbm
         IF tm.defbm IS NULL OR tm.defbm <=0 OR tm.defbm >13 THEN
            NEXT FIELD defbm
         END IF
         IF NOT cl_null(tm.defbm) THEN                                          
            SELECT azm02 INTO g_azm.azm02 FROM azm_file                      
              WHERE azm01 = tm.defyy                                            
            IF g_azm.azm02 = 1 THEN                                          
               IF tm.defbm > 12 OR tm.defbm < 1 THEN                               
                  CALL cl_err('','agl-020',0)                                
                  NEXT FIELD defbm                                              
               END IF                                                        
            ELSE                                                             
               IF tm.defbm > 13 OR tm.defbm < 1 THEN                               
                  CALL cl_err('','agl-020',0)                                
                  NEXT FIELD defbm                                              
               END IF                                                        
            END IF                                                           
         END IF
 
      AFTER FIELD defem
         IF NOT cl_null(tm.defem) THEN                                          
            SELECT azm02 INTO g_azm.azm02 FROM azm_file                      
               WHERE azm01 = tm.defyy                                            
            IF g_azm.azm02 = 1 THEN                                          
               IF tm.defem > 12 OR tm.defem < 1 THEN                               
                  CALL cl_err('','agl-020',0)                                
                  NEXT FIELD defem                                              
               END IF                                                        
            ELSE                                                             
               IF tm.defem > 13 OR tm.defem < 1 THEN                               
                  CALL cl_err('','agl-020',0)                                
                  NEXT FIELD defem                                              
               END IF                                                        
            END IF                                                           
         END IF
         IF tm.defem IS NULL OR tm.defem <=0 OR tm.defem >13 OR
            tm.defem < tm.defbm THEN
            NEXT FIELD defem
         END IF
 
#     AFTER FIELD budget1                                   #No.FUN-810069 
#        SELECT * FROM afa_file WHERE afa01=tm.budget1      #No.FUN-810069 
#                                 AND (afaacti = 'Y' OR afaacti = 'y')#No.FUN-810069 
#                                 AND afa00 = tm.bookno     #No.FUN-740029 #No.FUN-810069 
#       IF STATUS THEN                   #No.FUN-810069 
#       CALL cl_err('sel afa:',STATUS,0) #FUN-660105
#       CALL cl_err3("sel","afa_file",tm.budget1,"",STATUS,"","sel afa:",0) #FUN-660105 #No.FUN-810069 
#       NEXT FIELD budget1 END IF        #No.FUN-810069 
      #FUN-AB0020 add Begin----------------------------
      AFTER FIELD budget1                                                                                                            
         IF NOT cl_null(tm.budget1) THEN                                                                                                         
            SELECT * FROM azf_file          #FUN-AB0020 add                                                                            
             WHERE azfacti = 'Y' AND azf02 = '2' AND azf01 = tm.budget1    #FUN-AB0020 add                                              
            IF STATUS THEN                                                                                                             
               #CALL cl_err('sel azf:',STATUS,0) #FUN-660105                                                                            
               CALL cl_err3("sel","azf_file",tm.budget1,"",STATUS,"","sel azf:",0) #FUN-660105                                          
               NEXT FIELD budget1                                                                                                       
            END IF   
         END IF
      #FUN-AB0020 add End------------------------------
 
      AFTER FIELD combm
         IF NOT cl_null(tm.combm) THEN                                          
            SELECT azm02 INTO g_azm.azm02 FROM azm_file                      
               WHERE azm01 = tm.comyy                                            
            IF g_azm.azm02 = 1 THEN                                          
               IF tm.combm > 12 OR tm.combm < 1 THEN                               
                  CALL cl_err('','agl-020',0)                                
                  NEXT FIELD combm                                              
               END IF                                                        
            ELSE                                                             
               IF tm.combm > 13 OR tm.combm < 1 THEN                               
                  CALL cl_err('','agl-020',0)                                
                  NEXT FIELD combm                                              
               END IF                                                        
            END IF                                                           
         END IF
         IF tm.combm IS NULL OR tm.combm <=0 OR tm.combm >12 THEN
            NEXT FIELD combm
         END IF
 
      AFTER FIELD comem
         IF NOT cl_null(tm.comem) THEN                                          
            SELECT azm02 INTO g_azm.azm02 FROM azm_file                      
               WHERE azm01 = tm.comyy                                            
            IF g_azm.azm02 = 1 THEN                                          
               IF tm.comem > 12 OR tm.comem < 1 THEN                               
                  CALL cl_err('','agl-020',0)                                
                  NEXT FIELD comem                                              
               END IF                                                        
            ELSE                                                             
               IF tm.comem > 13 OR tm.comem < 1 THEN                               
                  CALL cl_err('','agl-020',0)                                
                  NEXT FIELD comem                                              
               END IF                                                        
            END IF                                                           
         END IF
         IF tm.comem IS NULL OR tm.comem <=0 OR tm.comem >12 OR
            tm.comem < tm.combm THEN
            NEXT FIELD comem
         END IF
#     AFTER FIELD budget2                #No.FUN-810069 
#        SELECT * FROM afa_file WHERE afa01=tm.budget2     #No.FUN-810069 
#                                 AND (afaacti = 'Y' OR afaacti = 'y') #No.FUN-810069 
#                                 AND afa00 = tm.bookno    #No.FUN-740029 #No.FUN-810069 
#       IF STATUS THEN                   #No.FUN-810069 
#       CALL cl_err('sel afa:',STATUS,0) #FUN-660105  
#       CALL cl_err3("sel","afa_file",tm.budget2,"",STATUS,"","sel afa:",0) #FUN-660105 #No.FUN-810069  
#       NEXT FIELD budget2 END IF        #No.FUN-810069 
      #FUN-AB0020 add Begin----------------------------                                                                             
      AFTER FIELD budget2                                                                                                           
         IF NOT cl_null(tm.budget2) THEN                                                                                                         
            SELECT * FROM azf_file          #FUN-AB0020 add                                                                            
             WHERE azfacti = 'Y' AND azf02 = '2' AND azf01 = tm.budget2    #FUN-AB0020 add                                              
            IF STATUS THEN                                                                                                             
               #CALL cl_err('sel azf:',STATUS,0) #FUN-660105                                                                            
               CALL cl_err3("sel","azf_file",tm.budget2,"",STATUS,"","sel azf:",0) #FUN-660105                                          
               NEXT FIELD budget2                                                                                                       
            END IF   
         END IF                                                                                                                     
      #FUN-AB0020 add End------------------------------
 
      AFTER FIELD type
         IF tm.type NOT MATCHES '[ MPRS]' THEN NEXT FIELD type END IF
 
      AFTER FIELD diff1
         IF tm.diff1 IS NULL OR tm.diff1 < 0 THEN NEXT FIELD diff1 END IF
 
 
      AFTER FIELD diff2
         IF tm.diff2 IS NULL OR tm.diff2 < 0 THEN NEXT FIELD diff2 END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
      #   IF INT_FLAG THEN EXIT INPUT END IF    #No.FUN-B20054
         IF tm.defyy IS NULL OR tm.comyy IS NULL THEN
            LET l_sw = 0
            DISPLAY BY NAME tm.defyy,tm.comyy ATTRIBUTE(REVERSE)
            CALL cl_err('',9033,0)
         END IF
         IF l_sw = 0 THEN
            LET l_sw = 1
            NEXT FIELD defyy
            CALL cl_err('',9033,0)
         END IF
 
#FUN-B20054--mark--str--
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()    # Command execution
#        ON ACTION CONTROLT
#            LET g_trace = 'Y'    # Trace on
#        ON ACTION CONTROLP
#         CASE
#          #No.FUN-740029 -- begin --
#           WHEN INFIELD(bookno)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_aaa"
#                 LET g_qryparam.default1 = tm.bookno
#                   CALL cl_create_qry() RETURNING tm.bookno
#                   DISPLAY tm.bookno TO bookno
#            NEXT FIELD bookno
#        #No.FUN-740029 -- end --
#        #   WHEN INFIELD(budget1)                         #No.FUN-810069 
#        #   CALL cl_init_qry_var()                  #No.FUN-810069 
#        #   LET g_qryparam.form ="q_afa"            #No.FUN-810069 
#        #   LET g_qryparam.default1 = tm.budget1    #No.FUN-810069 
#        #   LET g_qryparam.arg1 = tm.bookno         #No.FUN-740029 #No.FUN-810069 
#        #   CALL cl_create_qry() RETURNING tm.budget1 #No.FUN-810069 
#        #   DISPLAY tm.budget1 TO budget1           #No.FUN-810069 
#        #   NEXT FIELD budget1                           #No.FUN-810069 
#        #   WHEN INFIELD(budget2)                        #No.FUN-810069 
#        #   CALL cl_init_qry_var()                  #No.FUN-810069 
#        #   LET g_qryparam.form ="q_afa"            #No.FUN-810069 
#        #   LET g_qryparam.default1 = tm.budget2    #No.FUN-810069 
#        #   LET g_qryparam.arg1 = tm.bookno         #No.FUN-740029
#        #   CALL cl_create_qry() RETURNING tm.budget2 #No.FUN-810069 
#        #   DISPLAY tm.budget2 TO budget2           #No.FUN-810069 
#        #   NEXT FIELD budget2                           #No.FUN-810069
#            #No.FUN-AB0020--START--                                                                                                             
#            WHEN INFIELD(budget1)                                                                                                      
#                 CALL cl_init_qry_var()                                                                                              
#                 LET g_qryparam.form ="q_azf"                                                                                        
#                 LET g_qryparam.default1 = tm.budget1                                                                                 
#                 LET g_qryparam.arg1 = '2'                                                                                           
#                 CALL cl_create_qry() RETURNING tm.budget1                                                                            
#                 DISPLAY tm.budget1 TO budget1                                                                                         
#                 NEXT FIELD budget1
#            WHEN INFIELD(budget2)                                                                                                   
#                 CALL cl_init_qry_var()                                                                                             
#                 LET g_qryparam.form ="q_azf"                                                                                       
#                 LET g_qryparam.default1 = tm.budget2                                                                               
#                 LET g_qryparam.arg1 = '2'                                                                                          
#                 CALL cl_create_qry() RETURNING tm.budget2                                                                          
#                 DISPLAY tm.budget2 TO budget2                                                                                      
#                 NEXT FIELD budget2                                                                                                   
#            #No.FUN-AB0020--END 
#         END CASE
#       ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end
 
   END INPUT

#FUN-B20054--add--str-- 
    ON ACTION locale
       #CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        LET g_action_choice = "locale"
        EXIT DIALOG

     ON ACTION CONTROLP
         CASE
    #No.FUN-740029 -- begin --
           WHEN INFIELD(bookno)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aaa"
                 LET g_qryparam.default1 = tm.bookno
                   CALL cl_create_qry() RETURNING tm.bookno
                   DISPLAY tm.bookno TO bookno
            NEXT FIELD bookno
    #No.FUN-740029 -- end --
#          WHEN INFIELD(budget1)                         #No.FUN-810069
#                CALL cl_init_qry_var()                  #No.FUN-810069
#                LET g_qryparam.form ="q_afa"            #No.FUN-810069
#                LET g_qryparam.default1 = tm.budget1    #No.FUN-810069
#                LET g_qryparam.arg1 = tm.bookno         #No.FUN-740029 #No.FUN-810069
#                CALL cl_create_qry() RETURNING tm.budget1 #No.FUN-810069
#                DISPLAY tm.budget1 TO budget1           #No.FUN-810069
#           NEXT FIELD budget1                           #No.FUN-810069
#           WHEN INFIELD(budget2)                        #No.FUN-810069
#                CALL cl_init_qry_var()                  #No.FUN-810069
#                LET g_qryparam.form ="q_afa"            #No.FUN-810069
#                LET g_qryparam.default1 = tm.budget2    #No.FUN-810069
#                LET g_qryparam.arg1 = tm.bookno         #No.FUN-740029
#                CALL cl_create_qry() RETURNING tm.budget2 #No.FUN-810069
#                DISPLAY tm.budget2 TO budget2           #No.FUN-810069
#           NEXT FIELD budget2                           #No.FUN-810069
            WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag04"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aag01
                NEXT FIELD aag01

            #No.FUN-AB0020--START--
            WHEN INFIELD(budget1)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf"
                 LET g_qryparam.default1 = tm.budget1
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING tm.budget1
                 DISPLAY tm.budget1 TO budget1
                 NEXT FIELD budget1
            WHEN INFIELD(budget2)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf"
                 LET g_qryparam.default1 = tm.budget2
                 LET g_qryparam.arg1 = '2'
                 CALL cl_create_qry() RETURNING tm.budget2
                 DISPLAY tm.budget2 TO budget2
                 NEXT FIELD budget2
            #No.FUN-AB0020--END
         END CASE

    ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DIALOG

    ON ACTION about         #MOD-4C0121
       CALL cl_about()      #MOD-4C0121

    ON ACTION help          #MOD-4C0121
       CALL cl_show_help()  #MOD-4C0121

    ON ACTION controlg      #MOD-4C0121
       CALL cl_cmdask()     #MOD-4C0121

    ON ACTION CONTROLR
       CALL cl_show_req_fields()

    ON ACTION CONTROLT
       LET g_trace = 'Y'    # Trace on

    ON ACTION exit
       LET INT_FLAG = 1
       EXIT DIALOG

    #No.FUN-580031 --start--
    ON ACTION qbe_select
       CALL cl_qbe_select()
    #No.FUN-580031 ---end---

    ON ACTION accept
       EXIT DIALOG

    ON ACTION cancel
       LET INT_FLAG=1
       EXIT DIALOG
  END DIALOG
 #FUN-B20054--add--end

 #FUN-B20054--add--str--
   IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r183_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM

   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup') #FUN-980030
   
#FUN-B20054--add--end

   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abgr183'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr183','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
#                         " '",g_bookno CLIPPED,"'" ,    #No.FUN-740029
                         " '",tm.bookno CLIPPED,"'" ,    #No.FUN-740029
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.defyy CLIPPED,"'",
                         " '",tm.defbm CLIPPED,"'",
                         " '",tm.defem CLIPPED,"'",
                         " '",tm.comyy CLIPPED,"'",
                         " '",tm.combm CLIPPED,"'",
                         " '",tm.comem CLIPPED,"'",
                         " '",tm.type  CLIPPED,"'",
                         " '",tm.diff1 CLIPPED,"'",
                         " '",tm.diff2 CLIPPED,"'",
#                        " '",tm.budget1 CLIPPED,"'",           #No.FUN-810069 
#                        " '",tm.budget2 CLIPPED,"'",           #No.FUN-810069
                         " '",tm.budget1 CLIPPED,"'",           #No.FUN-AB0020                                                      
                         " '",tm.budget2 CLIPPED,"'",           #No.FUN-AB0020 
                         " '",tm.bdept CLIPPED,"'",
                         " '",tm.edept CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr183',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r183_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r183()
   ERROR ""
END WHILE
   CLOSE WINDOW r183_w
END FUNCTION
 
FUNCTION r183()
   DEFINE l_name    LIKE type_file.chr20,    #No.FUN-680061 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0056
          l_sql     LIKE type_file.chr1000,  # RDSQL STATEMENT                  #No.FUN-680061 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,  #No.FUN-680061  VARCHAR(40)
          l_aag01   LIKE aag_file.aag01,
          l_gem01   LIKE gem_file.gem01,
          sr        RECORD
                      afc00       LIKE afc_file.afc00,   #帳別
                      afc02       LIKE afc_file.afc02,   #科目
                     #afc04       LIKE afc_file.afc04,   #部門     #CHI-A20007 mark
                      afc041      LIKE afc_file.afc041,  #部門     #CHI-A20007 add
                      defcharge   LIKE type_file.num20_6,#(1)基準:本月預算 #No.FUN-680061 DEC(20,6)
                      aag02       LIKE aag_file.aag02,   #科目名稱
                      lastcharge  LIKE type_file.num20_6#(2)比較:上月預算  #No.FUN-680061 DEC(20,6)
                    END RECORD
 
     # add FUN-750025
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
     # end FUN-750025
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004 --START
#    SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file
#     WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
     IF tm.diff1 IS NULL THEN LET tm.diff1=0 END IF
     IF tm.diff2 IS NULL THEN LET tm.diff2=0 END IF
     #-->取科目
     LET l_sql = "SELECT aag01,aag02  FROM aag_file",
                 " WHERE aagacti = 'Y' ",
                 "   AND aag03 = '2' AND (aag07 = '2' OR aag07 = '3') ",
                 "   AND aag00 = '",tm.bookno,"' ",          #No.FUN-740029
                 "   AND ",tm.wc CLIPPED
     PREPARE r183_paag FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM 
     END IF
     DECLARE r183_caag CURSOR FOR r183_paag
 
     #-->取部門
     LET l_sql = "SELECT gem01 FROM gem_file",
                 " WHERE gemacti = 'Y' ",
                 "  AND (gem01 BETWEEN '",tm.bdept,"' AND '" ,tm.edept,"')"
 
     IF tm.type='M' THEN                              #管理費用
        LET l_sql=l_sql CLIPPED," AND gem07='M' "
        LET l_buf=g_x[21] CLIPPED
     END IF
     IF tm.type='P' THEN                              #製造費用
        LET l_sql=l_sql CLIPPED," AND gem07='P' "
        LET l_buf=g_x[22] CLIPPED
     END IF
     IF tm.type='R' THEN                              #研發費用
        LET l_sql=l_sql CLIPPED," AND gem07='R' "
        LET l_buf=g_x[23] CLIPPED
     END IF
     IF tm.type='S' THEN                              #銷售費用
        LET l_sql=l_sql CLIPPED," AND gem07='S' "
        LET l_buf=g_x[24] CLIPPED
     END IF
     IF tm.type=' ' THEN                              #全公司
        LET l_buf=g_x[25] CLIPPED
     END IF
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
 
     PREPARE r183_pgem FROM l_sql
     IF STATUS THEN CALL cl_err('pre gem:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM 
     END IF
     DECLARE r183_cgem CURSOR FOR r183_pgem
     #-->取基準月份
     #----------- sql for sum(afc06)----------------------------------------
    #LET l_sql = "SELECT SUM(afc06) ",     #CHI-B30084 mark
     LET l_sql = "SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",   #CHI-B30084
                 "  FROM afc_file,afb_file",
                 " WHERE afb00 = afc00  AND afb01 = afc01 ",
                 "   AND afb02 = afc02  AND afb03 = afc03 ",
                 "   AND afb04 = afc04  ",
#                "   AND afc01 = '",tm.budget1,"'",    #No.FUN-810069 
                 "   AND afc00 = ? ",
                 "   AND afc02 = ? ",
                #"   AND afc04 = ? ",        #CHI-A20007 mark
                 "   AND afc041 = ? ",       #CHI-A20007 add
                 "   AND afc03 = '",tm.defyy,"'",
                 "   AND afc05 BETWEEN '",tm.defbm,"' AND '",tm.defem,"'",
                #"   AND afb15 = '2' "   #部門預算    #CHI-A20007 mark
                 "   AND afc041 = afb041 AND afc042 = afb042",  #No.FUN-810069 
                #"   AND afb041 = ' ' AND afb042 = ' '"         #No.FUN-810069 #CHI-A40036 mod ' ' #CHI-A20007 mark
                 "   AND afb04 = ' ' AND afb042 = ' '"          #CHI-A20007 add 
                ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
     IF NOT cl_null(tm.budget1) THEN LET l_sql = l_sql," AND afc01 = '",tm.budget1,"'" END IF #FUN-AB0020 add 
     PREPARE r183_paaodef FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM 
     END IF
     DECLARE r183_caaodef CURSOR FOR r183_paaodef
 
     #-->取基準月份
     #----------- sql for sum(afc06)----------------------------------------
    #LET l_sql = "SELECT SUM(afc06) ",     #CHI-B30084 mark
     LET l_sql = "SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",   #CHI-B30084
                 "  FROM afc_file,afb_file",
                 " WHERE afb00 = afc00  AND afb01 = afc01 ",
                 "   AND afb02 = afc02  AND afb03 = afc03 ",
                 "   AND afb04 = afc04  ",
#                "   AND afc01 = '",tm.budget2,"'",              #No.FUN-810069
                 "   AND afc00 = ? ",
                 "   AND afc02 = ? ",
                #"   AND afc04 = ? ",     #CHI-A20007 mark
                 "   AND afc041 = ? ",    #CHI-A20007 add
                 "   AND afc03 = '",tm.comyy,"'",
                 "   AND afc05 BETWEEN '",tm.combm,"' AND '",tm.comem,"'",
                 "   AND afc041 = afb041 AND afc042 = afb042",   #No.FUN-810069                                                      
                #"   AND afb041 = ' ' AND afb042 = ' '",           #No.FUN-810069 #CHI-A40036 mod ' ' #CHI-A20007 mark
                 "   AND afb04 = ' ' AND afb042 = ' '"             #CHI-A20007 add 
                #"   AND afb15 = '2' "   #部門預算                 #CHI-A20007 mark
                ,"   AND afbacti = 'Y' "                        #FUN-D70090 add 
     IF NOT cl_null(tm.budget2) THEN LET l_sql = l_sql," AND afc01 = '",tm.budget2,"'" END IF #FUN-AB0020 add 
     PREPARE r183_paaocom FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM 
     END IF
     DECLARE r183_caaocom CURSOR FOR r183_paaocom
 
     CALL cl_outnam('abgr183') RETURNING l_name
     START REPORT abgr183_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r183_caag INTO l_aag01,sr.aag02
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH END IF
       IF g_trace='Y' THEN DISPLAY sr.afc02 END IF
 
       FOREACH r183_cgem INTO l_gem01
#           LET sr.afc00 = g_bookno     #No.FUN-740029
           LET sr.afc00 = tm.bookno     #No.FUN-740029
           LET sr.afc02 = l_aag01
          #LET sr.afc04 = l_gem01       #CHI-A20007 mark
           LET sr.afc041 = l_gem01      #CHI-A20007 add
           #-->(1)基準:實際費用
#           OPEN r183_caaodef USING g_bookno,l_aag01,l_gem01    #No.FUN-740029
           OPEN r183_caaodef USING tm.bookno,l_aag01,l_gem01     #No.FUN-740029
           FETCH r183_caaodef INTO sr.defcharge
           IF cl_null(sr.defcharge) THEN LET sr.defcharge = 0 END IF
           CLOSE r183_caaodef
 
           #-->(1)比較:實際費用
#           OPEN r183_caaocom USING g_bookno,l_aag01,l_gem01    #No.FUN-740029
           OPEN r183_caaocom USING tm.bookno,l_aag01,l_gem01    #No.FUN-740029
           FETCH r183_caaocom INTO sr.lastcharge
 
           OUTPUT TO REPORT abgr183_rep(sr.*)
       END FOREACH
     END FOREACH
 
     FINISH REPORT abgr183_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len) #FUN-750025 TSD.c123k mark
 
     # FUN-750025 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'aag01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.defyy,";",tm.defbm,";",tm.defem,";",tm.comyy,";",tm.combm,";",tm.comem,";",tm.type
  
     CALL cl_prt_cs3('abgr183','abgr183',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     # FUN-750025 end
 
END FUNCTION
 
REPORT abgr183_rep(sr)
  DEFINE  sr        RECORD
                      afc00       LIKE afc_file.afc00,   #帳別
                      afc02       LIKE afc_file.afc02,   #科目
                     #afc04       LIKE afc_file.afc04,   #部門     #CHI-A20007 mark
                      afc041      LIKE afc_file.afc04,   #部門     #CHI-A20007 add
                      defcharge   LIKE type_file.num20_6,#(1)基準:本月預算 #No.FUN-680061 DEC(20,6)
                      aag02       LIKE aag_file.aag02,   #科目名稱 
                      lastcharge  LIKE type_file.num20_6#(2)比較:上月預算  #No.FUN-680061 DEC(20,6)
                    END RECORD,
          l_last_sw         LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(1)
          l_st              LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(1)
          l_gem02           LIKE gem_file.gem02,
          l_defcharge,l_lastcharge,l_diff1    LIKE type_file.num20_6,      #No.FUN-680061 DEC(20,6)
          l_difpercent,l_difperyy,t_defcharge LIKE type_file.num20_6       #No.FUN-680061 DEC(20,6)
#       l_time          LIKE type_file.chr8                #No.FUN-6A0056
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.afc00,sr.afc02    #帳別,科目
 
  FORMAT
   PAGE HEADER
 
   BEFORE GROUP OF sr.afc02
      LET l_defcharge=0  LET l_lastcharge=0 LET l_diff1=0
      LET l_difpercent=0 LET l_difperyy=0
 
   AFTER GROUP OF sr.afc02                        #科目
      IF l_flag='Y' THEN
         LET t_defcharge=SUM(sr.defcharge)
         LET l_flag='N'
      END IF
     #A1:基準: tm.defbm-tm.defem 之實際費用
      LET l_defcharge =GROUP SUM(sr.defcharge)
                       WHERE sr.afc00=sr.afc00 AND sr.afc02=sr.afc02
     #A2:比較: tm.combm-tm.comem 之實際費用
      LET l_lastcharge=GROUP SUM(sr.lastcharge)
                       WHERE sr.afc00=sr.afc00 AND sr.afc02=sr.afc02
      IF  l_defcharge  IS NULL THEN LET l_defcharge=0 END IF
      IF  l_lastcharge IS NULL THEN LET l_defcharge=0 END IF
     #A3:差異 1-2(A1-A2)
      LET l_diff1=l_defcharge - l_lastcharge
     #A4:差異百分比(A3/A2 * 100)
      LET l_difpercent=(l_diff1/l_lastcharge) * 100
     #A5:年度百分比(A1/SUM(A1)  *100 )
      LET l_difperyy=(l_defcharge/t_defcharge) * 100
      LET l_st=' '
     #差異金額 > tm.diff1   -> *
      IF l_diff1 > tm.diff1 THEN LET l_st='*' END IF
     #差異百分比 > tm.diff2 -> %
      IF l_difpercent > tm.diff2 THEN LET l_st='%' END IF
     #兩者均大於        -> &
      IF (l_diff1 > tm.diff1) AND (l_difpercent > tm.diff2) THEN
         LET l_st='&'
      END IF
 
      #FUN-750025 TSD.c123k add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
        #l_buf,   l_st,   sr.afc00,   sr.afc02,   sr.afc04,   sr.aag02,     #CHI-A20007 mark
         l_buf,   l_st,   sr.afc00,   sr.afc02,   sr.afc041,   sr.aag02,    #CHI-A20007 add
         l_defcharge,     l_lastcharge,    l_diff1,    l_difpercent,
         l_difperyy,      t_defcharge,     g_azi04,    g_azi05 
      #------------------------------ CR (3) ------------------------------#
      #FUN-750025 TSD.c123k end
 
   PAGE TRAILER
END REPORT
#Patch....NO.TQC-610035 <001> #
