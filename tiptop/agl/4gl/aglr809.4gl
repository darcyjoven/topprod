# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr809.4gl
# Descriptions...: 異動碼費用與預算比較表
# Input parameter:
# Return code....:
# Date & Author..: 92/10/15 By Roger
#                  By Melody    aee00 改為 no-use
#
# Modify.........: No.FUN-590110 05/10/08 By will  報表轉xml格式
# Modify.........: No.TQC-5B0045 05/11/09 By Smapmin 報表無法列印
# Modify.........: No: FUN-5C0015 06/01/05 By kevin
#                  畫面QBE加aee021異動碼類型代號，^p q_ahe。
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0093 06/11/23 By wujie  增加總頁數 
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-6B0021 07/03/16 By jamie 預算欄位開窗查詢
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/10 By Lynn   會計科目加帳套
# Modify.........: No.FUN-790008 07/09/04 By dxfwo CR報表的制作
# Modify.........: No.TQC-820008 08/02/16 By baofei 修改INSERT INTO temptable語法
# Modify.........: No.FUN-810069 08/03/03 By ChenMoyan 取消預算編號控管
# Modify.........: No.FUN-830139 08/04/02 By douzh 畫面上拿掉預算編號
# Modify.........: No.FUN-8A0068 09/01/15 by shiwuying 修改bug:cl_wcchp() 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60139 10/06/22 by Dido 調整 foreach 抓取欄位問題 
# Modify.........: No.FUN-AB0020 10/11/05 By chenying 畫面上新增預算項目afc01
# Modify.........: No.FUN-B20054 11/02/22 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No:CHI-B60055 11/06/15 By Sarah 預算金額應含追加和挪用部份
# Modify.........: No:TQC-BC0037 11/12/07 By Carrier 变量和foreach不对应

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,       # Where condition  #TQC-630166
              bookno  LIKE aag_file.aag00,        #No.FUN-740020
              st      LIKE type_file.chr2,        # Sorting Order               #No.FUN-680098 integer 
              jp      LIKE type_file.chr1,        # 每一科目列印完是否跳頁(Y/N) #No.FUN-680098 integer
              yyyy    LIKE type_file.num10,       # 年度                        #No.FUN-680098 INTEGER
              bmm     LIKE type_file.num5,        # 起始期別                    #No.FUN-680098 SMALLINT
              emm     LIKE type_file.num5,        # 截止期別                    #No.FUN-680098 SMALLINT
#             afc01   LIKE afc_file.afc01,        # 預算編號                    #No.FUN-810139
              afc01   LIKE afc_file.afc01,        # 預算項目                    #No.FUN-AB0020 
              zero_amt LIKE type_file.chr1,       # Surpress when amt = 0 (Y/N) #No.FUN-680098 VARCHAR(1)
              e       LIKE type_file.chr1,        #FUN-6C0012
              more    LIKE type_file.chr1         # Input more condition(Y/N)   #No.FUN-680098 VARCHAR(1)
              END RECORD 
#         g_bookno   LIKE aah_file.aah00, #帳別     #No.FUN-740020
DEFINE   l_afc01    LIKE afc_file.afc01   # 預算編號
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680098  smallint
DEFINE   l_table         STRING                   #No.FUN-790008                                                                    
DEFINE   g_sql           STRING                   #No.FUN-790008                                                                    
DEFINE   g_str           STRING                   #No.FUN-790008 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-790008---Begin                                                                                                              
   LET g_sql = " aed01.aed_file.aed01,",                                                                                            
               " aed03.aed_file.aed03,",                                                                                            
               " aag02.aag_file.aag02,",                                                                                            
               " aag13.aag_file.aag13,",                                                                                            
               " aag06.aag_file.aag06,",                                                                                            
               " aed02.aed_file.aed02,",                                                                                            
               " aed04.aed_file.aed04,",                                                                                            
               " m_a.type_file.num20_6,",                                                                                           
               " m_b.type_file.num20_6,",                                                                                           
               " y_a.type_file.num20_6,",                                                                                           
               " y_b.type_file.num20_6,",                                                                                           
               " azi04.azi_file.azi04, ",                                                                                           
               " azi05.azi_file.azi05  "
           LET l_table = cl_prt_temptable('aglr809',g_sql) CLIPPED                                                                  
           IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
#           LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED, #No.TQC-820008                                                                    
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-820008 
                       " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"                                                   
           PREPARE insert_prep FROM g_sql                                                                                           
           IF STATUS THEN                                                                                                           
              CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                     
           END IF                                                                                                                   
   #No.FUN-790008---End
 
	#金額小數位數
    SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_aaz.aaz64
    SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03        #No.CHI-6A0004 g_azi-->t_azi
#   LET g_bookno = ARG_VAL(1)        #NO.FUN-740020
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc     = ARG_VAL(8)
   LET tm.yyyy   = ARG_VAL(9)
   LET tm.bmm    = ARG_VAL(10)
   LET tm.emm    = ARG_VAL(11)
#  LET tm.afc01  = ARG_VAL(12)       #No.FUN-810139 
   LET tm.afc01  = ARG_VAL(12)       #FUN-AB0020 add 
   LET tm.st     = ARG_VAL(13)
   LET tm.jp     = ARG_VAL(14)
   LET tm.zero_amt= ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   #No.FUN-570264 ---end---
   LET tm.e   = ARG_VAL(19)   #FUN-6C0012
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
#NO.FUN-740020      --Begin
#   IF cl_null(g_bookno) THEN  
#      LET g_bookno = g_aaz.aaz64
#   END IF
#NO.FUN-740020     --End
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aglr809_tm(0,0)        # Input print condition
      ELSE CALL aglr809()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr809_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400)
DEFINE l_azfacti      LIKE azf_file.azfacti   #FUN-AB0020 add 
DEFINE li_chk_bookno    LIKE type_file.num5           #No.FUN-B20054
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
#   CALL s_dsmark(g_bookno)               #NO.FUN-740020
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 11
   END IF
   OPEN WINDOW aglr809_w AT p_row,p_col
        WITH FORM "agl/42f/aglr809"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)     #NO.FUN-740020                 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yyyy  = YEAR(TODAY)
   LET tm.bookno = '00'     #No.FUN-740020
   LET tm.st    = '12'
   LET tm.jp    = 'Y'
   LET tm.zero_amt= 'N'
   LET tm.e     = 'N'   #FUN-6C0012
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.st[1,1]
   LET tm2.s2   = tm.st[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
 
WHILE TRUE
#NO.FUN-B20054--add--start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD bookno
              IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD bookno
                END IF
             END IF
         END INPUT

#NO.FUN-B20054--add--end--


   #  FUN-5C0015 mod (s)
   #  add aee021
   #CONSTRUCT BY NAME tm.wc ON aee03,aee01,aee02
   CONSTRUCT BY NAME tm.wc ON aee03,aee01,aee02,aee021  
   #  FUN-5C0015 mod (e)
 
       # FUN-5C0015 (s)
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark-start-- 
#         ON ACTION controlp
#            CASE
#              WHEN INFIELD(aee021) #異動碼類型代號
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_ahe"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aee021
#                NEXT FIELD aee021
#              WHEN INFIELD(aee00) 
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_aag"
#                LET g_qryparam.state    = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO aee00
#                NEXT FIELD aee00
#              OTHERWISE EXIT CASE
#            END CASE
#         # FUN-5C0015 (e)
# 
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
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
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark-end--
 
  END CONSTRUCT
#No.FUN-B20054--mark-start--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW aglr809_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#      EXIT PROGRAM
#         
#   END IF
#   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
##  INPUT BY NAME tm.bookno,tm.yyyy,tm.bmm,tm.emm,tm.afc01,tm2.s1,tm2.s2,
#   INPUT BY NAME tm.bookno,tm.yyyy,tm.bmm,tm.emm,tm.afc01,tm2.s1,tm2.s2,       #No.FUN-810139 #FUN-AB0020 add tm.afc01
#                 tm.jp,tm.zero_amt,tm.e,tm.more     #FUN-6C0012
#                 WITHOUT DEFAULTS
#No.FUN-B20054--mark-end-- 
    INPUT BY NAME tm.yyyy,tm.bmm,tm.emm,tm.afc01,tm2.s1,tm2.s2,
                  tm.jp,tm.zero_amt,tm.e,tm.more ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
        #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yyyy
         IF cl_null(tm.yyyy )
            THEN NEXT FIELD yyyy
         END IF
      AFTER FIELD bmm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bmm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
            IF g_azm.azm02 = 1 THEN
               IF tm.bmm > 12 OR tm.bmm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bmm
               END IF
            ELSE
               IF tm.bmm > 13 OR tm.bmm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bmm
               END IF
            END IF
         END IF
#         IF cl_null(tm.bmm) OR tm.bmm > 13 THEN
#            CALL cl_err('aed04','agl-013',0)
#            NEXT FIELD bmm
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD emm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.emm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yyyy
            IF g_azm.azm02 = 1 THEN
               IF tm.emm > 12 OR tm.emm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD emm
               END IF
            ELSE
               IF tm.emm > 13 OR tm.emm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD emm
               END IF
            END IF
         END IF
#         IF cl_null(tm.emm) OR tm.emm > 13 THEN
#            CALL cl_err('aed04','agl-013',0)
#            NEXT FIELD emm
#         END IF
#No.TQC-720032 -- end --
#No.FUN-810139--begin
#     AFTER FIELD afc01
#       IF cl_null(tm.afc01)
#          THEN NEXT FIELD afc01
#       END IF
#       SELECT afa01 INTO l_afc01 FROM afa_file
#             WHERE afa01 = tm.afc01
#               AND afa00 = tm.bookno             #No.FUN-740020
#       IF SQLCA.sqlcode !=0 OR cl_null(l_afc01) THEN
#           CALL cl_err(tm.afc01,'agl-158',0)   
#           NEXT FIELD afc01
#       END IF
#No.FUN-810139--end

#FUN-AB0020--------------add--------------str--------
      AFTER FIELD afc01
        IF NOT cl_null(tm.afc01) THEN
           SELECT azf01 FROM azf_file  
             WHERE azf01 = tm.afc01 AND azf02 = '2'
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","azf_file",tm.afc01,"","agl-005","","",0)
              NEXT FIELD afc01
           ELSE
              SELECT azfacti INTO l_azfacti FROM azf_file
               WHERE azf01 = tm.afc01 AND azf02 = '2'
              IF l_azfacti = 'N' THEN
                 CALL cl_err(tm.afc01,'agl1002',0)
              END IF
           END IF 
        END IF                 
#FUN-AB0020--------------add-------------end-----------

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#No.FUN-B20054--mark--start--
#
#################################################################################
## START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
## END genero shell script ADD
#################################################################################
#      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
##     ON ACTION CONTROLP CALL aglr809_wc()   # Input detail Where Condition
#No.FUN-B20054--mark--end--
      AFTER INPUT
      LET tm.st=tm2.s1[1,1],tm2.s2[1,1]
#No.FUN-B20054--mark--start--
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
# 
#     #No.FUN-580031 --start--
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#     #No.FUN-580031 ---end---
# 
# 
# 
#      ON ACTION CONTROLP
#         CASE
#         #No.FUN-740020 ---begin
#            WHEN INFIELD(bookno)                        
#               CALL cl_init_qry_var()                  
#               LET g_qryparam.form = 'q_aaa'           
#               LET g_qryparam.default1 = tm.bookno      
#               CALL cl_create_qry() RETURNING tm.bookno
#               DISPLAY BY NAME tm.bookno
#               NEXT FIELD bookno
#         #No.FUN-740020 ---end
#            #FUN-6B0021---add---end---
##No.FUN-810139--begin
##           WHEN INFIELD(afc01)                        
##              CALL cl_init_qry_var()                  
##              LET g_qryparam.form = 'q_afa'           #No.FUN-810069
##              LET g_qryparam.form = 'q_azf'           #No.FUN-810069
##              LET g_qryparam.default1 = tm.afc01      
##              LET g_qryparam.arg1 = tm.bookno         #No.FUN-810069 
##              LET g_qryparam.arg1 = '2'               #No.FUN-810069
##              CALL cl_create_qry() RETURNING tm.afc01
##              DISPLAY BY NAME tm.afc01
##              NEXT FIELD afc01
##No.FUN-810139--end
#            #FUN-6B0021---add---end---
#
#
##FUN-AB0020------add------str---------   
#            WHEN INFIELD(afc01)
#                 CALL cl_init_qry_var()   
#                 LET g_qryparam.form = 'q_azf'
#                 LET g_qryparam.default1 = tm.afc01    
#                 LET g_qryparam.arg1 = '2'        
#                 CALL cl_create_qry() RETURNING tm.afc01   
#                 DISPLAY BY NAME tm.afc01     
#                 NEXT FIELD afc01
##FUN-AB0020------add------end---------            
#         END CASE
#No.FUN-B20054--mark--end-- 
   END INPUT

#No.FUN-B20054--add--start--
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(bookno)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa'
                LET g_qryparam.default1 = tm.bookno
                CALL cl_create_qry() RETURNING tm.bookno
                DISPLAY BY NAME tm.bookno
                NEXT FIELD bookno
             WHEN INFIELD(aee01)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aag02"
                LET g_qryparam.state    = "c"
                LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aee01
                NEXT FIELD aee01
             WHEN INFIELD(afc01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_azf'
                LET g_qryparam.default1 = tm.afc01
                LET g_qryparam.arg1 = '2'
                CALL cl_create_qry() RETURNING tm.afc01
                DISPLAY BY NAME tm.afc01
                NEXT FIELD afc01
             WHEN INFIELD(aee021) #異動碼類型代號
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_ahe"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aee021
                NEXT FIELD aee021
             WHEN INFIELD(aee00)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_aag"
                LET g_qryparam.state    = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aee00
                NEXT FIELD aee00
             OTHERWISE EXIT CASE
        END CASE
       ON ACTION locale
          CALL cl_show_fld_cont()
          LET g_action_choice = "locale"
          EXIT DIALOG

       ON ACTION CONTROLR
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
          EXIT DIALOG

       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG
   END DIALOG

   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF

#No.FUN-B20054--add-end--
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglr809_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF  #No.FUN-B20054
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr809'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('aglr809','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
#		         " '",g_bookno CLIPPED,"'",          #NO.FUN-740020
                         " '",tm.bookno CLIPPED,"'",         #No.FUN-740020
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yyyy  CLIPPED,"'",
                         " '",tm.bmm   CLIPPED,"'",
                         " '",tm.emm   CLIPPED,"'",
#                        " '",tm.afc01 CLIPPED,"'",          #No.FUN-830139
                         " '",tm.afc01 CLIPPED,"'",          #FUN-AB0020 add 
                         " '",tm.st CLIPPED,"'",
                         " '",tm.jp CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",     #FUN-6C0012
                         " '",tm.zero_amt CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aglr809',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr809_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr809()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr809_w
END FUNCTION
{
FUNCTION aglr809_wc()
   DEFINE l_wc  LIKE type_file.chr1000      #No.FUN-680098   VARCHAR(300)
 
#  OPEN WINDOW aglr809_w2 AT 2,2
#       WITH FORM "agl/42f/aglu010"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aglu010")
# END genero shell script ADD
################################################################################
#  CALL cl_opmsg('q')
#  CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
#       aedprsw,aedprdt,
#       aedp2sw,aedp2dt,
#       aedsign,aedsseq,aedsmax,
#       aeduser,aedgrup,aedmodu,aeddate
#  CLOSE WINDOW aglr809_w2
#  LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglr809_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
END FUNCTION
}
FUNCTION aglr809()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0073
          l_sql     STRING,     # RDSQL STATEMENT #TQC-630166     
          l_za05    LIKE za_file.za05,            #No.FUN-680098 VARCHAR(40)
          l_order ARRAY[2] OF LIKE aed_file.aed02,#No.FUN-680098 VARCHAR(20)
          l_oname ARRAY[2] OF LIKE aag_file.aag02,#No.FUN-680098 VARCHAR(30)
          i         LIKE type_file.num5,          #No.FUN-680098  smallint
          l_aed03   LIKE aed_file.aed03,          #年度     #MOD-A60139  
          l_m_a,l_m_b,l_y_a,l_y_b LIKE type_file.num20_6,                 #No.FUN-680098  dec(20,6)
          sr            RECORD aed01 LIKE aed_file.aed01,  # 科目編號
                               aag02 LIKE aag_file.aag02,  # 科目名稱
                               aag13 LIKE aag_file.aag13,  # 額外名稱  #FUN-6C0012
                               aag06 LIKE aag_file.aag06,  # Normal D/C
                               aed02 LIKE aed_file.aed02,  # 異動碼
                              #aed03 LIKE aed_file.aed03,  #No:FUN-790008   #MOD-A60139 mark
                              #aed04 LIKE aed_file.aed04,  # 異動碼名稱     #MOD-A60139 mark
                               aee04 LIKE aee_file.aee04   # 異動碼名稱
                              #m_a,m_b LIKE type_file.num20_6, #No.FUN-680098 DEC(20,6)   #MOD-A60139 mark
                              #y_a,y_b LIKE type_file.num20_6  #No.FUN-680098 DEC(20,6)   #MOD-A60139 mark
                        END RECORD
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-8A0068 add
#    SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.aee00           #NO.FUN-740020  #09/10/20 xiaofeizhu Mark
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno                          #09/10/20 xiaofeizhu Add
			AND aaf02 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND aeeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND aeegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND aeegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aeeuser', 'aeegrup')
     #End:FUN-980030
 
 
#    LET l_sql = "SELECT aee01, aag02, aag13, aag06, aee03,aed03,aed04,aee04",   #FUN-6C0012  #09/10/20 xiaofeizhu Add aed03,aed04  #No.TQC-BC0037
     LET l_sql = "SELECT aee01, aag02, aag13, aag06, aee03,aee04 ",              #FUN-6C0012  #09/10/20 xiaofeizhu Add aed03,aed04  #No.TQC-BC0037
#                "  FROM aee_file, OUTER aag_file ",                 #09/10/20 xiaofeizhu Mark
                 "  FROM aee_file LEFT OUTER JOIN aag_file ",        #09/10/20 xiaofeizhu Add 
                 "    ON aee01 = aag01 AND aee00 = aag00 ",          #09/10/20 xiaofeizhu Add
                 " WHERE ",tm.wc CLIPPED,
#                "   AND aee_file.aee01 = aag_file.aag01",           #09/10/20 xiaofeizhu Mark 
                 "   AND aee00 = '",tm.bookno,"'"                    #No.FUN-740020
#                "   AND aee_file.aee00 = aag_file.aag00"            #NO.FUN-740020 #09/10/20 xiaofeizhu Mark
                
 
     PREPARE aglr809_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0
        THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
        END IF
     DECLARE aglr809_curs1 CURSOR FOR aglr809_prepare1
 
#    CALL cl_outnam('aglr809') RETURNING l_name           #No.FUN-790008 
#    START REPORT aglr809_rep TO l_name                   #No.FUN-790008 
 
     LET g_pageno = 0
     FOREACH aglr809_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        SELECT SUM(aed05-aed06) INTO l_m_a FROM aed_file
         WHERE aed01 = sr.aed01
           AND aed02 = sr.aed02 AND aed03 = tm.yyyy
           AND aed04 BETWEEN tm.bmm AND tm.emm
           AND aed00 = tm.bookno    #no.7277             #NO.FUN-740020
        SELECT SUM(aed05-aed06) INTO l_y_a FROM aed_file
         WHERE aed01 = sr.aed01
           AND aed02 = sr.aed02 AND aed03 = tm.yyyy
           AND aed04 BETWEEN 1 AND tm.emm
           AND aed00 = tm.bookno #no.7277                #NO.FUN-740020
        IF cl_null(tm.afc01) THEN                        #FUN-AB0020 add
          #SELECT SUM(afc06) INTO l_m_b                                                  #CHI-B60055 mark
           SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO l_m_b  #CHI-B60055
             FROM afc_file
           WHERE afc00 = tm.bookno                         #AND afc01 = tm.afc01  #NO.FUN-740020  #No.FUN-810139
             AND afc02 = sr.aed01 AND afc03 = tm.yyyy AND afc04 = sr.aed02
             AND afc05 BETWEEN tm.bmm AND tm.emm
            #AND afc041 = '' AND afc042 = ''               #No.FUN-810069   #MOD-A60139 mark
             AND afc041 = ' ' AND afc042 = ' '             #No.FUN-810069   #MOD-A60139
        #FUN-AB0020----add-----str--------------------------
        ELSE
          #SELECT SUM(afc06) INTO l_m_b                                                  #CHI-B60055 mark
           SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO l_m_b  #CHI-B60055
             FROM afc_file
            WHERE afc00 = tm.bookno AND afc01 = tm.afc01  
             AND afc02 = sr.aed01 AND afc03 = tm.yyyy AND afc04 = sr.aed02
             AND afc05 BETWEEN tm.bmm AND tm.emm
             AND afc041 = ' ' AND afc042 = ' '
        END IF
        IF cl_null(tm.afc01) THEN  
        #FUN-AB0020----add-----end--------------------------
          #SELECT SUM(afc06) INTO l_y_b                                                  #CHI-B60055 mark
           SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO l_y_b  #CHI-B60055
             FROM afc_file
           WHERE afc00 = tm.bookno                         #AND afc01 = tm.afc01  #NO.FUN-740020  #No.FUN-810139
             AND afc02 = sr.aed01 AND afc03 = tm.yyyy AND afc04 = sr.aed02
             AND afc05 BETWEEN 1 AND tm.emm
            #AND afc041 = '' AND afc042 = ''               #No.FUN-810069   #MOD-A60139 mark
             AND afc041 = ' ' AND afc042 = ' '             #No.FUN-810069   #MOD-A60139
        #FUN-AB0020----add-----str--------------------------
        ELSE
          #SELECT SUM(afc06) INTO l_y_b                                                  #CHI-B60055 mark
           SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0)) INTO l_y_b  #CHI-B60055
             FROM afc_file
            WHERE afc00 = tm.bookno  AND afc01 = tm.afc01  
             AND afc02 = sr.aed01 AND afc03 = tm.yyyy AND afc04 = sr.aed02
             AND afc05 BETWEEN 1 AND tm.emm
             AND afc041 = ' ' AND afc042 = ' '   
        END IF
        #FUN-AB0020----add-----end---------------------------- 
        LET l_aed03 = tm.yyyy                                             #MOD-A60139 
        IF l_m_a IS NULL THEN LET l_m_a = 0.00002 END IF
        IF l_y_a IS NULL THEN LET l_y_a = 0.00002 END IF
        IF l_m_b IS NULL THEN LET l_m_b = 0.00001 END IF
        IF l_y_b IS NULL THEN LET l_y_b = 0.00001 END IF
        IF l_m_a = 0.00002 AND l_y_a = 0.00002 AND
           l_m_b = 0.00001 AND l_y_b = 0.00001 AND
           tm.zero_amt = 'N' THEN CONTINUE FOREACH
        END IF
        IF sr.aag06 = '2' THEN
           LET l_m_a = l_m_a * -1 LET l_y_a = l_y_a * -1
        END IF
        FOR i = 1 TO 2
           CASE WHEN tm.st[i,i] = 1 LET l_order[i] = sr.aed02
                                    LET l_oname[i] = sr.aee04
                WHEN tm.st[i,i] = 2 LET l_order[i] = sr.aed01
                                    #FUN-6C0012.....begin
                                    IF tm.e = 'N' THEN
                                       LET l_oname[i] = sr.aag02
                                    ELSE
                                       LET l_oname[i] = sr.aag13
                                    END IF
                                    #FUN-6C0012.....end
           END CASE
        END FOR
       #EXECUTE insert_prep USING sr.aed01,sr.aed03,sr.aag02,sr.aag13,sr.aag06,sr.aed02,sr.aed04,   #MOD-A60139 mark
                           #sr.m_a,sr.m_b,sr.y_a,sr.y_b,g_azi04,g_azi05                             #MOD-A60139 mark 
        EXECUTE insert_prep USING sr.aed01,l_aed03,sr.aag02,sr.aag13,sr.aag06,sr.aed02,sr.aee04,    #MOD-A60139 
                            l_m_a,l_m_b,l_y_a,l_y_b,g_azi04,g_azi05                                 #MOD-A60139  
#       OUTPUT TO REPORT aglr809_rep(l_order[1],l_oname[1],
#                                    l_order[2],l_oname[2],
#                                    l_m_a,l_m_b,l_y_a,l_y_b)
     END FOREACH
     IF g_zz05 = 'Y' THEN                                                        
     #  CALL cl_wcchp(tm.wc,'tm.wc ON aee03,aee01,aee02,aee021')  #NO.FUN-8A0068 mark
        CALL cl_wcchp(tm.wc,'aee03,aee01,aee02,aee021')           #NO.FUN-8A0068       
             RETURNING tm.wc                                                     
        LET g_str = tm.wc                                                        
     END IF                                                                                                                          
#    LET g_str = tm.wc,";",tm.afc01,";",tm.yyyy,";",tm.bmm,";",tm.emm,";",  #No.FUN-810139
#    LET g_str = tm.wc,";",'',";",tm.yyyy,";",tm.bmm,";",tm.emm,";",               #No.FUN-810139 FUN-AB0020 mark
     LET g_str = tm.wc,";",tm.afc01,";",tm.yyyy,";",tm.bmm,";",tm.emm,";",         #FUN-AB0020 add
                 tm.st[1,1],";",tm.st[2,2],";",g_azi04,";",g_azi05                                                                 
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('aglr809','aglr809',l_sql,g_str)  
#    FINISH REPORT aglr809_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
{                               #No.FUN-790008
REPORT aglr809_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-680098 VARCHAR(1)
          sr            RECORD order1 LIKE type_file.chr20,    #No.FUN-680098 VARCHAR(20)
                               oname1 LIKE type_file.chr50,    #No.FUN-680098 VARCHAR(30)
                               order2 LIKE type_file.chr20,    #No.FUN-680098 VARCHAR(20)
                               oname2 LIKE type_file.chr50,      #No.FUN-680098 VARCHAR(30)
                               m_a,m_b LIKE type_file.num20_6, #No.FUN-680098 DEC(20,6)
                               y_a,y_b LIKE type_file.num20_6  #No.FUN-680098 DEC(20,6)
                        END RECORD,
      l_chr        LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
      l_m_a,l_m_b,l_y_a,l_y_b  LIKE type_file.num20_6, #No.FUN-680098  DEC(20,6)
      l_m_dif,l_y_dif          LIKE aah_file.aah04,    #No.FUN-680098 # 差異金額 dec(20,6)
      l_m_per,l_y_per          LIKE type_file.num5     #No.FUN-680098 smallint 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2
  FORMAT
   PAGE HEADER
#No.FUN-590110  --begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'    #No.TQC-6B0093
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF cl_null(g_towhom) OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT g_x[21] CLIPPED,tm.afc01,' ',               #No.FUN-810139
            g_x[13] CLIPPED,tm.yyyy USING '####',' ',
           # g_x[14] CLIPPED,tm.bmm USING '##','-',tm.emm USING '##'
           COLUMN ((g_len-FGL_WIDTH(g_x[14])-5)/2)+1, g_x[14] CLIPPED,tm.bmm USING '##','-',tm.emm USING '##'
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 57,g_x[13] CLIPPED,tm.yyyy  USING "####",
#           COLUMN 68,g_x[14] CLIPPED,tm.bmm USING "##",
#                                 '-',tm.emm USING "##",
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      CASE WHEN tm.st[1,1] = '1' PRINT g_x[16] CLIPPED,' / ';
           WHEN tm.st[1,1] = '2' PRINT g_x[17] CLIPPED,' / ';
           WHEN tm.st[1,1] = '3' PRINT g_x[18] CLIPPED,' / ';
      END CASE
      CASE WHEN tm.st[2,2] = '1' PRINT g_x[16] CLIPPED;
           WHEN tm.st[2,2] = '2' PRINT g_x[17] CLIPPED;
           WHEN tm.st[2,2] = '3' PRINT g_x[18] CLIPPED;
      END CASE
#     PRINT COLUMN 36,
#           '<---------------------------  ',g_x[10] CLIPPED,'  ----------------------------> ',
#           '<---------------------------  ',g_x[11] CLIPPED,'  ---------------------------->'
#     PRINT COLUMN 36,g_x[12],'       %     ',g_x[12],'       %   '
      PRINT COLUMN g_c[33],g_x[22],g_x[10] CLIPPED,g_x[23],
            COLUMN g_c[37],g_x[22],g_x[11] CLIPPED,g_x[23]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                     g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash[1,g_len]   #TQC-5B0045
      PRINT g_dash1   #TQC-5B0045
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.jp = 'Y' AND (PAGENO > 1 OR LINENO > 10)
         THEN SKIP TO TOP OF PAGE
      END IF
      PRINT sr.order1 CLIPPED,' ',sr.oname1
      PRINT
 
   AFTER GROUP OF sr.order2
      LET l_m_a = GROUP SUM(sr.m_a)
      LET l_m_b = GROUP SUM(sr.m_b)
      LET l_y_a = GROUP SUM(sr.y_a)
      LET l_y_b = GROUP SUM(sr.y_b)
      LET l_m_dif = l_m_a - l_m_b
      IF l_m_b != 0
         THEN LET l_m_per = (l_m_dif / l_m_b) * 100
         ELSE LET l_m_per = 0
      END IF
      LET l_y_dif = l_y_a - l_y_b
      IF l_y_b != 0
         THEN LET l_y_per = (l_y_dif / l_y_b) * 100
         ELSE LET l_y_per = 0
      END IF
#     PRINT COLUMN 8, sr.order2 CLIPPED,' ',sr.oname2 CLIPPED,
#           COLUMN 35, cl_numfor(l_m_a ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_m_b ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_m_dif,18,g_azi04) CLIPPED,' ',
#                      l_m_dif USING '----#.#','%',' ',
#                      cl_numfor(l_y_a ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_y_b ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_y_dif,18,g_azi04) CLIPPED,' ',
#                      l_y_dif USING '---#.#','%'
      PRINT COLUMN g_c[32], sr.order2 CLIPPED,' ',sr.oname2 CLIPPED,
            COLUMN g_c[33], cl_numfor(l_m_a ,33,t_azi04) CLIPPED,           #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[34], cl_numfor(l_m_b ,34,t_azi04) CLIPPED,           #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[35], cl_numfor(l_m_dif,35,t_azi04) CLIPPED,          #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[36], l_m_dif USING '------#.#','%',       #FUN-6C0012 
            COLUMN g_c[37], cl_numfor(l_y_a ,37,t_azi04) CLIPPED,           #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[38], cl_numfor(l_y_b ,38,t_azi04) CLIPPED,           #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[39], cl_numfor(l_y_dif,39,t_azi04) CLIPPED,          #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[40], l_y_dif USING '------#.#','%'        #FUN-6C0012
 
   AFTER GROUP OF sr.order1
      LET l_m_a = GROUP SUM(sr.m_a)
      LET l_m_b = GROUP SUM(sr.m_b)
      LET l_y_a = GROUP SUM(sr.y_a)
      LET l_y_b = GROUP SUM(sr.y_b)
      LET l_m_dif = l_m_a - l_m_b
      IF l_m_b != 0
         THEN LET l_m_per = (l_m_dif / l_m_b) * 100
         ELSE LET l_m_per = 0
      END IF
      LET l_y_dif = l_y_a - l_y_b
      IF l_y_b != 0
         THEN LET l_y_per = (l_y_dif / l_y_b) * 100
         ELSE LET l_y_per = 0
      END IF
      PRINT
#     PRINT COLUMN 27, g_x[19] CLIPPED,
#           COLUMN 35, cl_numfor(l_m_a ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_m_b ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_m_dif,18,g_azi04) CLIPPED,' ',
#                      l_m_dif USING '---#.#','%',' ',
#                      cl_numfor(l_y_a ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_y_b ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_y_dif,18,g_azi04) CLIPPED,' ',
#                      l_y_dif USING '---#.#','%'
      PRINT COLUMN 27, g_x[19] CLIPPED,
            COLUMN g_c[33], cl_numfor(l_m_a ,33,t_azi04) CLIPPED,            #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[34], cl_numfor(l_m_b ,34,t_azi04) CLIPPED,            #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[35], cl_numfor(l_m_dif,35,t_azi04) CLIPPED,           #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[36], l_m_dif USING '------#.#','%',      #FUN-6C0012
            COLUMN g_c[37], cl_numfor(l_y_a ,37,t_azi04) CLIPPED,          #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[38], cl_numfor(l_y_b ,38,t_azi04) CLIPPED,          #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[39], cl_numfor(l_y_dif,39,t_azi04) CLIPPED,         #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[40], l_y_dif USING '------#.#','%'       #FUN-6C0012
      #FUN-6C0012.....begin
      IF tm.jp = 'N' THEN
         PRINT g_dash[1,g_len]
      END IF
      #FUN-6C0012.....end
 
   ON LAST ROW
      IF tm.jp = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_m_a = SUM(sr.m_a)
      LET l_m_b = SUM(sr.m_b)
      LET l_y_a = SUM(sr.y_a)
      LET l_y_b = SUM(sr.y_b)
      LET l_m_dif = l_m_a - l_m_b
      IF l_m_b != 0
         THEN LET l_m_per = (l_m_dif / l_m_b) * 100
         ELSE LET l_m_per = 0
      END IF
      LET l_y_dif = l_y_a - l_y_b
      IF l_y_b != 0
         THEN LET l_y_per = (l_y_dif / l_y_b) * 100
         ELSE LET l_y_per = 0
      END IF
#     PRINT COLUMN 27, g_x[20] CLIPPED,
#           COLUMN 35, cl_numfor(l_m_a ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_m_b ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_m_dif,18,g_azi04) CLIPPED,' ',
#                      l_m_dif USING '----#.#','%',' ',
#                      cl_numfor(l_y_a ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_y_b ,18,g_azi04) CLIPPED,' ',
#                      cl_numfor(l_y_dif,18,g_azi04) CLIPPED,' ',
#                      l_y_dif USING '----#.#','%'
      PRINT COLUMN 27, g_x[20] CLIPPED,
            COLUMN g_c[33], cl_numfor(l_m_a ,33,t_azi04) CLIPPED,        #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[34], cl_numfor(l_m_b ,34,t_azi04) CLIPPED,        #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[35], cl_numfor(l_m_dif,35,t_azi04) CLIPPED,       #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[36], l_m_dif USING '------#.#','%',     #FUN-6C0012
            COLUMN g_c[37], cl_numfor(l_y_a ,37,t_azi04) CLIPPED,        #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[38], cl_numfor(l_y_b ,38,t_azi04) CLIPPED,        #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[39], cl_numfor(l_y_dif,39,t_azi04) CLIPPED,       #No.CHI-6A0004 g_azi-->t_azi
            COLUMN g_c[40], l_y_dif USING '------#.#','%'      #FUN-6C0012
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'aee01,aee02,aee03')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
        #TQC-630166
        #      IF tm.wc[001,120] > ' ' THEN            # for 132
        #  PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
        #      IF tm.wc[121,240] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
        #      IF tm.wc[241,300] > ' ' THEN
        #  PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
#FUN-590110  --end
END REPORT
#Patch....NO.TQC-610035 <001> #   }   #No.FUN-790008
