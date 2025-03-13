# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr500.4gl
# Descriptions...: 客戶應收明細帳
# Date & Author..: 95/02/22 by Nick
# Modify.........: 97/08/28 By Sophia 新增帳別(ooo11)
# Modify.........: MOD-440725 04/07/28 By ching 選本幣列印 幣別印本幣
# Modify.........: No.FUN-4C0100 05/01/04 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550071 05/05/27 By yoyo單據編號格式放大
# Modify.........: No.MOD-610132 06/01/23 By Smapmin 修正報表格式
# Modify.........: No.MOD-620046 06/02/15 By Smapmin 若期初有值，本期未異動，則抓不出資料
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6A0102 06/11/21 By johnray 報表修改
# Modify.........: No.MOD-720047 07/02/27 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740009 07/04/03 By Judy 會計科目加帳套
# Modify.........: No.TQC-750226 07/05/30 By rainy CR未列印年度期別
# Modify.........: No.MOD-7B0225 07/11/28 By Smapmin 因為npq05有可能為一個空白或NULL,故抓取npq的條件需加以調整
# Modify.........: No.MOD-890111 08/09/11 By Sarah r500_cur2的SQL增加ORDER BY npp02,npq01
# Modify.........: No.FUN-8C0009 08/12/23 By xiaofeizhu 報表加入是否納入多營運中心及關係人選項
# Modify.........: No.MOD-920201 09/02/16 By liuxqa 小計的余額錯誤
# Modify.........: No.MOD-920217 09/02/18 By liuxqa 列印應該不包括未審核的部分.
# Modify.........: No.FUN-940102 09/04/28 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No:TQC-A50082 10/05/24 By Carrier join少了aag00的条件
# Modify.........: No:MOD-A70050 10/07/06 By Dido 當 MISC 客戶時資料會有誤,增加簡稱條件
# Modify.........: No:CHI-A70006 10/07/12 By Summer 增加aza63判斷使用s_azmm 
# Modify.........: No.FUN-B20054 10/02/22 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.TQC-B30147 11/03/17 By yinhy CONSTRUCT BY 多了ooo11
# Modify.........: No.FUN-C40001 12/04/16 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_bdate,g_edate,d    LIKE type_file.dat      #No.FUN-680123 DATE
   DEFINE tm  RECORD                            # Print condition RECORD
              wc      LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(1000)           # Where condition
	            y       LIKE type_file.num5,      #No.FUN-680123 SMALLINT
	            b1      LIKE type_file.num5,      #No.FUN-680123 SMALLINT
	            b2      LIKE type_file.num5,      #No.FUN-680123 SMALLINT
	            n       LIKE type_file.chr1,      #No.FUN-680123 VARCHAR(1)
  ##NO.FUN-A10098  mark--begin
#              b       LIKE type_file.chr1,      #No.FUN-8C0009 VARCHAR(1)
#              p1      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p2      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p3      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p4      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p5      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p6      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p7      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
#              p8      LIKE azp_file.azp01,      #No.FUN-8C0009 VARCHAR(10)
  ##NO.FUN-A10098  mark--end
              s       LIKE type_file.chr4,      #No.FUN-8C0009 VARCHAR(4)
              t       LIKE type_file.chr4,      #No.FUN-8C0009 VARCHAR(4) 
              u       LIKE type_file.chr4,      #No.FUN-8C0009 VARCHAR(4)
              ooo11   like ooo_file.ooo11,	    #FUN-B20054  
              more    LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)              # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5          #No.FUN-680123 SMALLINT       #count/index for any purpose        
DEFINE   i               LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE l_table        STRING,                   ### CR11 ###
       g_str          STRING,                   ### CR11 ###
       g_sql          STRING                    ### CR11 ###
DEFINE g_Logistics    STRING                    #FUN-8C0009 ADD       
DEFINE tok            Base.StringTokenizer      #FUN-8C0009 ADD
  ##NO.FUN-A10098  mark--begin
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8C0009 ARRAY[10]
  ##NO.FUN-A10098  mark--end
DEFINE g_bookno1     LIKE aza_file.aza81       #CHI-A70006 add
DEFINE g_bookno2     LIKE aza_file.aza82       #CHI-A70006 add
DEFINE g_flag        LIKE type_file.chr1       #CHI-A70006 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   LET g_sql = " ooo01.ooo_file.ooo01, ",			#客戶編號
               " ooo02.ooo_file.ooo02, ",			#客戶簡稱
               " ooo03.ooo_file.ooo03, ",			#科目編號
               " aag02.aag_file.aag02, ",			#科目名稱
               " ooo04.ooo_file.ooo04, ",			#部門
               " gem02.gem_file.gem02, ",			#部門名稱
               " ooo05.ooo_file.ooo05, ",			#幣別
               " ooo05a.ooo_file.ooo05, ",			#MOD-440725
               " amt1.ooo_file.ooo08d, ",			#前期   
               " azi03.azi_file.azi03, ",			#
               " azi04.azi_file.azi04, ",			#
               " azi05.azi_file.azi05, ",			#
               " ooo07.ooo_file.ooo07, ",			#no:5890
               " npp02.npp_file.npp02, ",
               " npq01.npq_file.npq01, ",
               " npp00.npp_file.npp00, ",
               " npp00_desc.type_file.chr8, ",       #MOD-7B0225           
               " npq23.npq_file.npq23, ",
               " npq24.npq_file.npq24, ",
               " npq06.npq_file.npq06, ",             #借貸別
               " npq07f.npq_file.npq07f, ",           #原幣
               " npq07.npq_file.npq07, ",             #本幣
               " l_credit.npq_file.npq07f, ",         #借方
               " l_debit.npq_file.npq07f, ",          #貸方
               " l_left.npq_file.npq07f, ",            #餘額 
               " byear.type_file.num5,",          #MOD-7B0225
               " bb.type_file.chr5,",            #期別 #TQC-750226 00-12
               " plant.azp_file.azp01,",           #FUN-8C0009 加入營運中心
               " ooo11.ooo_file.ooo11"             #FUN-8C0009 加入帳別               
 
   LET l_table = cl_prt_temptable('axrr500',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"  ##TQC-75022 add 2 fileds  #FUN-8C0009 ADD 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.y = ARG_VAL(8)
   LET tm.b1 = ARG_VAL(9)
   LET tm.b2 = ARG_VAL(10)
   LET tm.n = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
  ##NO.FUN-A10098  mark--begin   
#   LET tm.b     = ARG_VAL(16)
#   LET tok      = base.StringTokenizer.create(ARG_VAL(17),",")
#   LET tm.p1    = tok.nextToken()
#   LET tm.p2    = tok.nextToken()
#   LET tm.p3    = tok.nextToken()
#   LET tm.p4    = tok.nextToken()
#   LET tm.p5    = tok.nextToken()
#   LET tm.p6    = tok.nextToken()
#   LET tm.p7    = tok.nextToken()
#   LET tm.p8    = tok.nextToken()
  ##NO.FUN-A10098  mark--end   
   LET tm.s     = ARG_VAL(16)
   LET tm.t     = ARG_VAL(17)
   LET tm.u     = ARG_VAL(18)
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
 
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
   
   IF cl_null(tm.wc)
      THEN CALL axrr500_tm(0,0)             # Input print condition
   ELSE 
      CALL axrr500()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr500_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
       l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
        LET p_row = 3 LET p_col =18 
 
   OPEN WINDOW axrr500_w AT p_row,p_col
        WITH FORM "axr/42f/axrr500" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.s='1234'
   LET tm.t='    '
   LET tm.y=YEAR(TODAY)
   LET tm.b1=1
   LET tm.b2=2
   LET tm.n='1'
   LET tm.s ='12 '
   LET tm.t ='Y  '
   LET tm.u ='Y  '
   LET tm.ooo11 = g_aza.aza81
  ##NO.FUN-A10098  mark--begin
#  LET tm.b ='N'
#   LET tm.p1=g_plant
#   CALL p500_set_entry_1()
#   CALL p500_set_no_entry_1()
#   CALL r500_set_comb()
  ##NO.FUN-A10098  mark--end
WHILE TRUE
#FUN-B20054--add--str--
   DIALOG ATTRIBUTE(unbuffered)
      INPUT BY NAME tm.ooo11 ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD ooo11 
            IF NOT cl_null(tm.ooo11) THEN
                   CALL s_check_bookno(tm.ooo11,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD ooo11
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.ooo11
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.ooo11,"","agl-043","","",0)
                   NEXT FIELD ooo11
                END IF
            END IF
       END INPUT
#FUN-B20054--add--end--
   #CONSTRUCT BY NAME tm.wc ON ooo01,ooo03,ooo04,ooo05,ooo11    #TQC-B30147
   CONSTRUCT BY NAME tm.wc ON ooo01,ooo03,ooo04,ooo05           #TQC-B30147
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
#FUN-B20054--mark--str--
#      ON ACTION locale
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
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#FUN-B20054--mark--end--
  END CONSTRUCT


#  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030 #FUN-B20054 TO AFTER END DIALOG
#FUN-B20054--mark--end--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
#FUN-B20054--mark--end--

 
#FUN-B20054--mark--str--					 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW axrr500_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
#      EXIT PROGRAM         
#  END IF
#FUN-B20054--mark--end--
#FUN-B20054--UPDATE TO AFTER END DIALOG--str --
#   IF tm.wc=" 1=1" THEN 
#      CALL cl_err('','9046',0) CONTINUE WHILE
#   END IF 
#FUN-B20054--UPDATE TO AFTER END DIALOG--end--


 
   INPUT BY NAME #tm2.s1,tm2.s2,tm2.s3,                           #FUN-8C0009 MARK
                 tm.y,tm.b1,tm.b2,tm.n,
  ##NO.FUN-A10098  mark--begin
#                 tm.b,tm.p1,tm.p2,tm.p3,                          #FUN-8C0009
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,                   #FUN-8C0009
  ##NO.FUN-A10098  mark--end
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,       #FUN-8C0009
                 tm2.u1,tm2.u2,tm2.u3,                            #FUN-8C0009                                  
                 tm.more
                 #WITHOUT DEFAULTS                                #FUN-B20054
                 ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD y
         IF cl_null(tm.y) THEN
            NEXT FIELD y
         END IF
      AFTER FIELD b1
         IF NOT cl_null(tm.b1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y
            IF g_azm.azm02 = 1 THEN
               IF tm.b1 > 12 OR tm.b1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b1
               END IF
            ELSE
               IF tm.b1 > 13 OR tm.b1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b1
               END IF
            END IF
         END IF
      AFTER FIELD b2
         IF NOT cl_null(tm.b2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y
            IF g_azm.azm02 = 1 THEN
               IF tm.b2 > 12 OR tm.b2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b2
               END IF
            ELSE
               IF tm.b2 > 13 OR tm.b2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b2
               END IF
            END IF
         END IF
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[12]' THEN
            NEXT FIELD n
         END IF
         
  ##NO.FUN-A10098  mark--begin
#      AFTER FIELD b
#         IF NOT cl_null(tm.b)  THEN
#            IF tm.b NOT MATCHES "[YN]" THEN
#               NEXT FIELD b
#            END IF
#         END IF
#      ON CHANGE  b
#         LET tm.p1=g_plant
#         LET tm.p2=NULL
#         LET tm.p3=NULL
#         LET tm.p4=NULL
#         LET tm.p5=NULL
#         LET tm.p6=NULL
#         LET tm.p7=NULL
#         LET tm.p8=NULL
#         DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8
#         CALL p500_set_entry_1()
#         CALL p500_set_no_entry_1()
#         CALL r500_set_comb()
# 
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)
#            NEXT FIELD p1
#         END IF
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1          
#            END IF  
#         END IF              
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)
#               NEXT FIELD p2
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#         END IF
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)
#               NEXT FIELD p3
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#         END IF
# 
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)
#               NEXT FIELD p4
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#         END IF
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)
#               NEXT FIELD p5
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#         END IF
# 
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)
#               NEXT FIELD p6
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#         END IF
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1)
#               NEXT FIELD p7
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#         END IF
# 
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)
#               NEXT FIELD p8
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#         END IF
  ##NO.FUN-A10098  mark--end
           
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

#FUN-B20054--mark--str--
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
#      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#      
#      ON ACTION CONTROLP
#FUN-B20054--mark--end--
  ##NO.FUN-A10098  mark--begin
#         CASE
#            WHEN INFIELD(p1)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p1
#               CALL cl_create_qry() RETURNING tm.p1
#               DISPLAY BY NAME tm.p1
#               NEXT FIELD p1
#            WHEN INFIELD(p2)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p2
#               CALL cl_create_qry() RETURNING tm.p2
#               DISPLAY BY NAME tm.p2
#               NEXT FIELD p2
#            WHEN INFIELD(p3)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p3
#               CALL cl_create_qry() RETURNING tm.p3
#               DISPLAY BY NAME tm.p3
#               NEXT FIELD p3
#            WHEN INFIELD(p4)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p4
#               CALL cl_create_qry() RETURNING tm.p4
#               DISPLAY BY NAME tm.p4
#               NEXT FIELD p4
#            WHEN INFIELD(p5)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p5
#               CALL cl_create_qry() RETURNING tm.p5
#               DISPLAY BY NAME tm.p5
#               NEXT FIELD p5
#            WHEN INFIELD(p6)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p6
#               CALL cl_create_qry() RETURNING tm.p6
#               DISPLAY BY NAME tm.p6
#               NEXT FIELD p6
#            WHEN INFIELD(p7)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p7
#               CALL cl_create_qry() RETURNING tm.p7
#               DISPLAY BY NAME tm.p7
#               NEXT FIELD p7
#            WHEN INFIELD(p8)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p8
#               CALL cl_create_qry() RETURNING tm.p8
#               DISPLAY BY NAME tm.p8
#               NEXT FIELD p8
#         END CASE
  ##NO.FUN-A10098  mark--end
      
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
#FUN-B20054--mark--str--
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
#   
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
#      ON ACTION qbe_save
#         CALL cl_qbe_save()   
#FUN-B20054--mark--end--
 
   END INPUT
   #FUN-B20054--add--str--
      ON ACTION CONTROLP
          CASE  
             WHEN INFIELD(ooo11)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = tm.ooo11
                CALL cl_create_qry() RETURNING tm.ooo11
                DISPLAY tm.ooo11 TO FORMONLY.ooo11
                NEXT FIELD ooo11
             WHEN INFIELD(ooo03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.ooo11 CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ooo03
                NEXT FIELD ooo03
             #No.FUN-C40001  --Begin
              WHEN INFIELD(ooo01) #客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo01
                 NEXT FIELD ooo01
              WHEN INFIELD(ooo04) #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo04
                 NEXT FIELD ooo04
              WHEN INFIELD(ooo05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo05
                 NEXT FIELD ooo05
             #No.FUN-C40001  --End
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

      ON ACTION accept
         #No.TQC-B30147  --Begin
         IF cl_null(tm.wc) OR tm.wc = " 1=1" THEN
            CALL cl_err(' ','9046',0)
            NEXT FIELD ooo01 
         END IF
         #No.TQC-B30147  --End
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
    #FUN-B20054--add--end
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM       
   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null)  #FUN-B20054
   IF tm.wc=" 1=1" THEN                                     #FUN-B20054 
	   CALL cl_err('','9046',0) CONTINUE WHILE                #FUN-B20054 
	 END IF                                                   #FUN-B20054 
   #CHI-A70006 add --start--
    CALL s_get_bookno(tm.y)
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y,tm.b1,g_plant,g_bookno1) RETURNING g_chr,g_bdate,d
      CALL s_azmm(tm.y,tm.b2,g_plant,g_bookno1) RETURNING g_chr,d,g_edate
   ELSE
      CALL s_azm(tm.y,tm.b1) RETURNING g_chr,g_bdate,d
      CALL s_azm(tm.y,tm.b2) RETURNING g_chr,d,g_edate
   END IF
   #CHI-A70006 add --end--
	#	由 年度,期別CALL s_azm 傳回 1.有效否,2.起始日期,3.截止日期
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr500','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
#        LET g_Logistics = tm.p1,",",tm.p2,",",tm.p3,",",tm.p4,",",tm.p5,",",     #FUN-8C0009
#                          tm.p6,",",tm.p7,",",tm.p8                              #FUN-8C0009
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.y CLIPPED,"'" ,
                         " '",tm.b1 CLIPPED,"'" ,
                         " '",tm.b2 CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
  ##NO.FUN-A10098  mark--begin
#                        " '",tm.b CLIPPED,"'" ,                #FUN-8C0009
#                        " '",g_Logistics clipped,"'" ,         #FUN-8C0009
  ##NO.FUN-A10098  mark--end
                         " '",tm.s CLIPPED,"'" ,                #FUN-8C0009
                         " '",tm.t CLIPPED,"'",                 #FUN-8C0009
                         " '",tm.u CLIPPED,"'"                  #FUN-8C0009                         
                         
         CALL cl_cmdat('axrr500',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr500()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr500_w
END FUNCTION
 
FUNCTION axrr500()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680123 VARCHAR(20)              # External(Disk) file name
          l_sql     LIKE type_file.chr1000,           #No.FUN-680123 VARCHAR(1000)
          l_cnt     LIKE type_file.num5,           #CR11
          l_za05    LIKE type_file.chr1000,           #No.FUN-680123 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ooo_file.ooo02,  #No.FUN-680123 VARCHAR(20)
          l_npp00_desc   LIKE type_file.chr8,         #CR11   #MOD-7B0225
          l_void         LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1)
          l_conf         LIKE type_file.chr1,         #No.FUN-680123 VARCHAR(1)
          l_ooaconf      LIKE ooa_file.ooaconf,       #No.MOD-920217 add by liuxqa
          l_amt_keep     LIKE npq_file.npq07f,        #CR11 Keep amt1
          l_n            LIKE type_file.num5,         #No.MOD-920201 add by liuxqa
          sr        RECORD        
                order1    LIKE ooo_file.ooo01,        #No.FUN-680123 VARCHAR(10)
                order2    LIKE ooo_file.ooo01,        #No.FUN-680123 VARCHAR(10)
                order3    LIKE ooo_file.ooo01,        #No.FUN-680123 VARCHAR(10)
                order4    LIKE ooo_file.ooo01,        #No.FUN-680123 VARCHAR(10)
                ooo01     LIKE ooo_file.ooo01,			#客戶編號
                ooo02     LIKE ooo_file.ooo02,			#客戶簡稱
                ooo03     LIKE ooo_file.ooo03,			#科目編號
                aag02     LIKE aag_file.aag02,			#科目名稱
                ooo04     LIKE ooo_file.ooo04,			#部門
                gem02     LIKE gem_file.gem02,			#部門名稱
                ooo05     LIKE ooo_file.ooo05,			#幣別
                ooo05a    LIKE ooo_file.ooo05,			#MOD-440725
                amt1      LIKE ooo_file.ooo08d,			#前期
                azi03     LIKE azi_file.azi03,			#
                azi04     LIKE azi_file.azi04,			#
                azi05     LIKE azi_file.azi05,			#
                ooo07     LIKE ooo_file.ooo07,  		#no:5890
                ooo11     LIKE ooo_file.ooo11       #FUN-8C0009 ADD                
                    END RECORD,
                a1        LIKE ooo_file.ooo08c,
                a2        LIKE ooo_file.ooo08d,
                a3        LIKE ooo_file.ooo09c, 
        	l_credit  LIKE npq_file.npq07f,
		l_debit   LIKE npq_file.npq07f,
                sr2   RECORD
                      npp02      LIKE npp_file.npp02,
                      npq01      LIKE npq_file.npq01,
                      npp00      LIKE npp_file.npp00,
                      npq23      LIKE npq_file.npq23,
                      npq24      LIKE npq_file.npq24,
                      npq06      LIKE npq_file.npq06,
                      npq07f     LIKE npq_file.npq07f,
                      npq07      LIKE npq_file.npq07
                 END RECORD
  DEFINE l_bb   LIKE type_file.chr5    #TQC-750226 起迄期別
  DEFINE     l_i        LIKE type_file.num5                 #No.FUN-8C0009 SMALLIN
  DEFINE     l_dbs      LIKE azp_file.azp03                 #No.FUN-8C0009
  DEFINE     l_azp03    LIKE azp_file.azp03                 #No.FUN-8C0009 
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add

  ##NO.FUN-A10098  mark--begin   
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
  ##NO.FUN-A10098  mark--end
   
   #CALL s_azm(tm.y,tm.b1) RETURNING g_chr,g_bdate,d                   #FUN-8C0009 ADD #CHI-A70006 mark
   #CALL s_azm(tm.y,tm.b2) RETURNING g_chr,d,g_edate                   #FUN-8C0009 ADD #CHI-A70006 mark
   #CHI-A70006 add --start--
    CALL s_get_bookno(tm.y)
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y,tm.b1,g_plant,g_bookno1) RETURNING g_chr,g_bdate,d
      CALL s_azmm(tm.y,tm.b2,g_plant,g_bookno1) RETURNING g_chr,d,g_edate
   ELSE
      CALL s_azm(tm.y,tm.b1) RETURNING g_chr,g_bdate,d
      CALL s_azm(tm.y,tm.b2) RETURNING g_chr,d,g_edate
   END IF
   #CHI-A70006 add --end--
   LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]                     #FUN-8C0009 ADD
   LET tm.t = tm2.t1,tm2.t2,tm2.t3                                    #FUN-8C0009 ADD
   LET tm.u = tm2.u1,tm2.u2,tm2.u3                                    #FUN-8C0009 ADD
  ##NO.FUN-A10098  mark--begin 
#   FOR l_i = 1 to 8                                                   #FUN-8C0009 ADD
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                 #FUN-8C0009 ADD
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]    #FUN-8C0009 ADD
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)                                   #FUN-8C0009 ADD  
  ##NO.FUN-A10098  mark--end
 
   LET l_sql="SELECT DISTINCT '','','','',ooo01,ooo02,ooo03,aag02,",   #MOD-620046
             "ooo04,gem02,ooo05,ooo05,0,azi03,azi04,azi05,0,ooo11 ",   #MOD-620046  #FUN-8C0009 Add ooo11
#              " FROM  ",l_dbs CLIPPED,"ooo_file,",                              #FUN-8C0009 ADD
#              " OUTER ",l_dbs CLIPPED,"gem_file,",                              #FUN-8C0009 ADD
#              " OUTER ",l_dbs CLIPPED,"aag_file,",                              #FUN-8C0009 ADD
#              " OUTER ",l_dbs CLIPPED,"azi_file ",                              #FUN-8C0009 ADD             
#            " FROM  ooo_file OUTER gem_file OUTER aag_file OUTER azi_file",
#            " WHERE ooo_file.ooo04=gem_file.gem01 AND ooo_file.ooo03=aag_file.aag01 ",
#            "   AND aag_file.aag00=ooo_file.ooo11 ",             #FUN-740009
             " FROM ooo_file LEFT OUTER join gem_file ON  ooo_file.ooo04=gem_file.gem01 ",
             " LEFT OUTER join aag_file ON ooo_file.ooo03=aag_file.aag01 AND ooo_file.ooo11 = aag_file.aag00",   #No.TQC-A50082
             " LEFT OUTER join azi_file ON azi_file.azi01=ooo_file.ooo05",
#            " AND ooo_file.ooo05=azi_file.azi01 AND ",tm.wc CLIPPED,
             " WHERE ",tm.wc CLIPPED,
             " AND ooo07 <=",tm.b2,  #no:5890   #MOD-620046
             " AND ooo06 =",tm.y     #NO:7441
 
   DISPLAY "l_sql=",l_sql
   LET l_sql= l_sql CLIPPED 
   PREPARE axrr500_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   DECLARE axrr500_curs1 CURSOR FOR axrr500_prepare1
 
   LET g_pageno = 0
   FOREACH axrr500_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH 
      END IF
      DISPLAY sr.ooo01,sr.ooo02,sr.ooo03,sr.ooo04,sr.ooo05
          LET l_sql=" SELECT SUM(ooo08d-ooo08c),SUM(ooo09d-ooo09c)  ",
  ##NO.FUN-A10098  mark--begin
#                   "   FROM ",l_dbs CLIPPED,"ooo_file",
                    "   FROM ooo_file",
  ##NO.FUN-A10098  mark--end                    
                    "  WHERE ooo01='",sr.ooo01,"'",
                    "    AND ooo02='",sr.ooo02,"'",
                    "    AND ooo03='",sr.ooo03,"'",
                    "    AND ooo04='",sr.ooo04,"'",
                    "    AND ooo05='",sr.ooo05,"'",
                    "    AND ooo06=",tm.y,
                    "    AND ooo07<",tm.b1    
          PREPARE ooo_prepare2 FROM l_sql
          DECLARE ooo_c2  CURSOR FOR ooo_prepare2
          OPEN ooo_c2
          FETCH ooo_c2 INTO sr.amt1,a1
      IF tm.n = '2' THEN
         LET sr.amt1=a1 # LET sr.amt2=a2 LET sr.amt3=a3
      END IF
      IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
 
      IF tm.n='2' THEN LET sr.ooo05=g_aza.aza17 END IF
 
      FOR g_i = 1 TO 4
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ooo01
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ooo03
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ooo04
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ooo05
              OTHERWISE LET l_order[g_i] = '-'
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
      LET sr.order4 = l_order[4]
 
      LET l_amt_keep = sr.amt1   #TSD.Ken CR11

      IF sr.ooo04 =' ' OR cl_null(sr.ooo04) THEN 
         LET l_sql="SELECT npp02,npq01,npp00,npq23,npq24,npq06,npq07f,npq07",
  ##NO.FUN-A10098  mark--begin
#                  " FROM ",l_dbs CLIPPED,"npq_file,",l_dbs CLIPPED,"npp_file ",  #FUN-8C0009 ADD                   
                   " FROM npq_file,npp_file ",
  ##NO.FUN-A10098  mark--end
                   " WHERE npq03='",sr.ooo03,"' AND (npq05=' ' OR npq05 IS NULL) AND npp02>='",g_bdate,"'",
                   "    AND npp02<='",g_edate,"' AND npq24='",sr.ooo05a,"'",
                   "    AND npq21='",sr.ooo01,"'",
                   "    AND npq22='",sr.ooo02,"'",                                #MOD-A70050
                   "    AND nppsys=npqsys AND npp00=npq00 AND npp01=npq01", 
                   "    AND npp011=npq011 AND nppsys='AR'"
      ELSE
         LET l_sql="SELECT npp02,npq01,npp00,npq23,npq24,npq06,npq07f,npq07",
  ##NO.FUN-A10098  mark--begin
#                  " FROM ",l_dbs CLIPPED,"npq_file,",l_dbs CLIPPED,"npp_file ", #FUN-8C0009 ADD                   
                   " FROM npq_file,npp_file ",
  ##NO.FUN-A10098  mark--end
                   " WHERE npq03='",sr.ooo03,"' AND npq05='",sr.ooo04,"' AND npp02>='",g_bdate,"'",
                   "    AND npp02<='",g_edate,"' AND npq24='",sr.ooo05a,"'",
                   "    AND npq21='",sr.ooo01,"'",
                   "    AND npq22='",sr.ooo02,"'",                                #MOD-A70050
                   "    AND nppsys=npqsys AND npp00=npq00 AND npp01=npq01", 
                   "    AND npp011=npq011 AND nppsys='AR'"
      END IF
      LET l_sql=l_sql," ORDER BY npp02,npq01"   #MOD-890111 add
      PREPARE r500_p FROM l_sql
      DECLARE r500_cur2 CURSOR FOR r500_p
 
      LET l_credit=0
      LET l_debit=0
      LET l_cnt = 0
      
          IF sr.ooo04 =' ' OR cl_null(sr.ooo04) THEN
             LET l_sql=" SELECT COUNT(*) ",
  ##NO.FUN-A10098  mark--begin
#                       " FROM ",l_dbs CLIPPED,"npq_file,",
#                                l_dbs CLIPPED,"npp_file ",
                        " FROM npq_file,npp_file", 
  ##NO.FUN-A10098  mark--end
                       " WHERE npq03=,",sr.ooo03, "'",
                       " AND (npq05=' ' OR npq05 IS NULL) ",
                       " AND npp02>= '",g_bdate,"'",
                       " AND npp02<= '",g_edate,"'",
                       " AND npq24='",sr.ooo05a,"'",   
                       " AND npq21='",sr.ooo01,"'",
                       " AND npq22='",sr.ooo02,"'",                                #MOD-A70050
                       " AND nppsys=npqsys AND npp00=npq00 AND npp01=npq01 ",
                       " AND npp011=npq011 AND nppsys='AR' "
          ELSE
             LET l_sql=" SELECT COUNT(*) ",
  ##NO.FUN-A10098  mark--begin
#                       " FROM ",l_dbs CLIPPED,"npq_file,",
#                                l_dbs CLIPPED,"npp_file ",
                        " FROM npq_file,npp_file", 
  ##NO.FUN-A10098  mark--end
                       " WHERE npq03=,",sr.ooo03, "'",
                       " AND   npq05=,",sr.ooo04, "'",
                       " AND npp02>= '",g_bdate,"'",
                       " AND npp02<= '",g_edate,"'",
                       " AND npq24='",sr.ooo05a,"'",
                       " AND npq21='",sr.ooo01,"'",
                       " AND npq22='",sr.ooo02,"'",                                #MOD-A70050
                       " AND nppsys=npqsys AND npp00=npq00 AND npp01=npq01 ",
                       " AND npp011=npq011 AND nppsys='AR' "
          END IF
          PREPARE npb_prepare1 FROM l_sql
          DECLARE npb_c1  CURSOR FOR npb_prepare1
          OPEN npb_c1
          FETCH npb_c1 INTO l_cnt
 
      LET l_bb = tm.b1 USING "&&","-",tm.b2 USING "&&"   #TQC-750226
      IF cl_null(l_cnt) OR l_cnt = 0 THEN
         INITIALIZE sr2.* TO NULL
         LET l_npp00_desc = NULL
         EXECUTE insert_prep USING sr.ooo01,sr.ooo02,sr.ooo03,sr.aag02,
                                   sr.ooo04,sr.gem02,sr.ooo05,sr.ooo05a,
                                   l_amt_keep, sr.azi03,sr.azi04,sr.azi05,
                                   sr.ooo07,sr2.npp02,sr2.npq01,sr2.npp00,
                                   l_npp00_desc,sr2.npq23,sr2.npq24,sr2.npq06,
                                   sr2.npq07f,sr2.npq07,l_credit,l_debit,sr.amt1,tm.y,l_bb,   ##TQC-75022 add 年度期別
#                                  m_dbs[l_i],sr.ooo11                                         #FUN-8C0009 ADD 
                                   '',sr.ooo11 
      END IF
      
      LET l_n = 0     #No.MOD-920201 add by liuxqa
      FOREACH r500_cur2 INTO sr2.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach2:',SQLCA.sqlcode,1) 
            EXIT FOREACH 
         END IF
         LET l_n = l_n +1 
         IF  l_n >1 THEN
             LET l_amt_keep = 0
         END IF
         #-------97/08/05 modify已作廢不要印出
          IF sr2.npp00 MATCHES '[123]' THEN  #No.MOD-920217 mod by liuxqa 
               LET l_sql="  SELECT omaconf,omavoid  ",
  ##NO.FUN-A10098  mark--begin
#                        "  FROM ",l_dbs CLIPPED,"oma_file",
                         "  FROM oma_file",
  ##NO.FUN-A10098  mark--end
                         " WHERE oma01 ='", sr2.npq01,"'"
               PREPARE oma_prepare1 FROM l_sql
               DECLARE oma_c1  CURSOR FOR oma_prepare1
               OPEN oma_c1
               FETCH oma_c1 INTO  l_conf,l_void
               IF STATUS=100 THEN
                  LET l_sql=" SELECT ooaconf ",
  ##NO.FUN-A10098  mark--begin
#                           "   FROM ",l_dbs CLIPPED,"ooa_file",
                            "   FROM ooa_file",
  ##NO.FUN-A10098  mark--end
                            "  WHERE ooa01 ='", sr2.npq01,"'"
                  PREPARE ooa_prepare1 FROM l_sql
                  DECLARE ooa_c1 CURSOR FOR ooa_prepare1
                  OPEN ooa_c1
                  FETCH ooa_c1 INTO l_ooaconf
                  IF STATUS=100 THEN CONTINUE FOREACH END IF
                  IF l_ooaconf='N' OR l_ooaconf='X'  THEN CONTINUE FOREACH END IF
               ELSE              
                  IF l_void = 'Y' THEN CONTINUE FOREACH END IF
                  IF l_conf = 'N' THEN CONTINUE FOREACH END IF
               END IF       #No.MOD-920217 add by liuxqa 
         END IF                                  #no:5890
         #幣別判斷
         IF tm.n='2' THEN LET sr2.npq07f=sr2.npq07 END IF 
         IF tm.n='2' THEN LET sr2.npq24=g_aza.aza17 END IF
         IF sr2.npq06 = '1' THEN 
            LET sr.amt1=sr.amt1+sr2.npq07f  #sr.amt存放餘額
         ELSE 
            LET sr.amt1=sr.amt1-sr2.npq07f	
         END IF  # 判斷借貸
 
         CASE sr2.npp00
      	    WHEN '1'
                 CALL cl_getmsg('anm-208',g_lang) RETURNING l_npp00_desc   #MOD-7B0225 
            WHEN '2'
                 CALL cl_getmsg('anm-270',g_lang) RETURNING l_npp00_desc   #MOD-7B0225 
            WHEN '3'
                 CALL cl_getmsg('anm-209',g_lang) RETURNING l_npp00_desc   #MOD-7B0225 
            WHEN '4'
                 CALL cl_getmsg('anm-271',g_lang) RETURNING l_npp00_desc   #MOD-7B0225 
            WHEN '5'
                 CALL cl_getmsg('anm-211',g_lang) RETURNING l_npp00_desc   #MOD-7B0225 
            OTHERWISE
                 LET l_npp00_desc=""
         END CASE
 
         IF sr2.npq06='1' THEN
            LET l_credit = sr2.npq07f
            LET l_debit  = 0
         ELSE
            LET l_credit = 0
            LET l_debit  = sr2.npq07f
         END IF
         
         ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
         EXECUTE insert_prep USING sr.ooo01,sr.ooo02,sr.ooo03,sr.aag02,
                                   sr.ooo04,sr.gem02,sr.ooo05,sr.ooo05a,
                                   l_amt_keep, sr.azi03,sr.azi04,sr.azi05,
                                   sr.ooo07,sr2.npp02,sr2.npq01,sr2.npp00,
                                   l_npp00_desc,sr2.npq23,sr2.npq24,sr2.npq06,
                                   sr2.npq07f,sr2.npq07,l_credit,l_debit,sr.amt1,tm.y,l_bb,   ##TQC-75022 add 年度期別
  ##NO.FUN-A10098  mark--begin
#                                  m_dbs[l_i],sr.ooo11                                         #FUN-8C0009 ADD 
                                   '',sr.ooo11
  ##NO.FUN-A10098  mark--end
         #------------------------------ CR (3) ------------------------------#
      END FOREACH
   END FOREACH
#  END FOR      #FUN-8C0009   
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ooo01,ooo03,ooo04,ooo05,ooo11') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   IF cl_null(tm.s[1,1]) THEN LET tm.s[1,1] = '0' END IF                #FUN-8C0009
   IF cl_null(tm.s[2,2]) THEN LET tm.s[2,2] = '0' END IF                #FUN-8C0009
   IF cl_null(tm.s[3,3]) THEN LET tm.s[3,3] = '0' END IF                #FUN-8C0009
#  IF tm.b = 'Y' THEN                                                   #FUN-8C0009
#    LET l_name = 'axrr500_1'                                          #FUN-8C0009
# ELSE                                                                 #FUN-8C0009
      LET l_name = 'axrr500'                                            #FUN-8C0009
#  END IF                                                               #FUN-8C0009
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",     #FUN-8C0009
  ##NO.FUN-A10098  mark--begin
#              tm.t,";",tm.u,";",tm.b                                   #FUN-8C0009
               tm.t,";",tm.u,";",''    
  ##NO.FUN-A10098  mark--end
   CALL cl_prt_cs3('axrr500',l_name,l_sql,g_str)                        #FUN-8C0009 ADD   
   
   #------------------------------ CR (4) ------------------------------#
   #MOD-720047 - END
END FUNCTION

  ##NO.FUN-A10098  mark--begin 
#FUNCTION p500_set_entry_1()
#   CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION p500_set_no_entry_1()
#   IF tm.b = 'N' THEN
#      CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#      IF tm2.s1 = '5' THEN
#         LET tm2.s1 = ' '
#      END IF
#      IF tm2.s2 = '5' THEN
#         LET tm2.s2 = ' '
#      END IF
#      IF tm2.s3 = '5' THEN
#         LET tm2.s2 = ' '
#      END IF
#   END IF
#END FUNCTION
#FUNCTION r500_set_comb()
# DEFINE comb_value STRING
# DEFINE comb_item  LIKE type_file.chr1000
# 
#   IF tm.b ='N' THEN
#      LET comb_value = '1,2,3,4,5'
#      SELECT ze03 INTO comb_item FROM ze_file
#        WHERE ze01='axr-113' AND ze02=g_lang
#   ELSE
#      LET comb_value = '1,2,3,4,5,6'
#      SELECT ze03 INTO comb_item FROM ze_file
#        WHERE ze01='axr-114' AND ze02=g_lang
#   END IF
#   CALL cl_set_combo_items('s1',comb_value,comb_item)
#   CALL cl_set_combo_items('s2',comb_value,comb_item)
#   CALL cl_set_combo_items('s3',comb_value,comb_item)
#END FUNCTION
  ##NO.FUN-A10098  mark--end
#FUN-9C0072 精簡程式碼
