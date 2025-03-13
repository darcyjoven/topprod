# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: axrr151.4gl
# Descriptions...: 應收帳款明細帳列印作業
# Date & Author..: 2000/02/22 By
# Modify.........: No.FUN-4C0100 04/12/24 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-5C0086 05/12/19 By Carrier AR月底重評修改 
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.MOD-690133 06/12/06 By Smapmin 回推沖帳金額
# Modify.........: No.MOD-720047 07/03/16 By TSD 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-730073 07/04/02 By sherry 會計科目加帳套
# Modify.........: No.CHI-860040 08/07/09 By Sarah oma00='23'的帳單抓取對應到oma00='12'的oma19>截止日期,已沖金額需加回這些超出截止日期單據的oma52,oma53
# Modify.........: No.MOD-870063 08/07/10 By Sarah FOREACH r151_curs1裡計算sr.oma54t,sr.oma56t前需增加LET l_oma52 = 0,LET l_oma53 = 0
# Modify.........: No.CHI-890004 08/09/24 By Sarah 若未沖完應以原幣金額*帳款匯率計算本幣金額
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.FUN-8B0025 08/12/23 By xiaofeizhu 新增多營運中心INPUT
# Modify.........: No.MOD-8C0271 08/12/26 By clover l_sql 語法修改
# Modify.........: No.MOD-920370 09/02/27 By Smapmin l_oma24_1清空舊值
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0115 09/11/20 By wujie 报表改抓多帐期资料
# Modify.........: No:MOD-9C0030 09/12/07 By Sarah l_oma24_1應給予預設值'',抓不到值時不需給予預設值1
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10098 10/01/20 By baofei GP5.2跨DB報表--財務類
# Modify.........: No:MOD-A20045 10/02/09 By Sarah 回朔金額抓取的SQL需多串子帳期項次條件
# Modify.........: No:MOD-A60133 10/06/21 By Dido 本幣金額重評價計算時增加判斷原幣不為 0 才需重算 
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 
# Modify.........: No:TQC-AB0047 10/11/12 By wujie  重估汇率取不到的时候，抓单据上的汇率
# Modify.........: No:TQC-B10083 11/01/20 By yinhy 重估匯率抓不到不應為'1'
# Modify.........: No:FUN-B20020 11/02/15 By destiny 增加收款单条件
# Modify.........: Mo.CHI-B60073 11/06/30 By sarah 23.預收待抵增加抓取訂金的傳票編號來顯示
# Modify.........: Mo.MOD-B70104 11/07/12 By Dido 預收已沖金額抓取調整 
# Modify.........: No.MOD-BB0050 11/11/03 By Polly 將sr.oma56t,l_oob10,l_oov04,l_oma53做取位動作
# Modify.........: No.MOD-BB0120 11/11/10 By Polly 增加判斷ooz07=Y時，才重新計算l_oma53
# Modify.........: No.MOD-BC0004 11/12/03 By Dido 預收回溯邏輯調整 
# Modify.........: No.MOD-C10005 12/01/04 By Polly 不受ooz07影響，預收待抵本幣金額都是乘以原立帳匯率
# Modify.........: No.MOD-C10175 12/01/21 By yinhy 尾差問題
# Modify.........: No.MOD-C30334 12/03/10 By Polly 查詢條件後需再重新給予 INPUT 欄位變數
# Modify.........: No.MOD-C60114 12/06/14 By Polly 應收餘額調整單的數字需考慮，拿除收款單條件
# Modify.........: No.MOD-C80199 12/10/26 By Elise l_oma24_1都是有資料的,取消 NOT cl_null判斷
# Modify.........: No.MOD-D30113 13/03/12 By apo 在取得t_azi04後才做四捨五入處理
# Modify.........: No:TQC-DA0039 13/10/24 By yangxf “賬款編號”，“賬款客戶”，“會計科目”，“憑證編號”欄位增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE l_table     STRING                        #FUN-710080 add
DEFINE g_sql       STRING                        #FUN-710080 add
DEFINE g_str       STRING                        #FUN-710080 add
DEFINE tm  RECORD
           wc      STRING,
#           b       LIKE type_file.chr1,          # No.FUN-8B0025 VARCHAR(1)  #FUN-A10098
#           p1      LIKE azp_file.azp01,          # No.FUN-8B0025 VARCHAR(10) #FUN-A10098
#           p2      LIKE azp_file.azp01,          # No.FUN-8B0025 VARCHAR(10) #FUN-A10098
#           p3      LIKE azp_file.azp01,          # No.FUN-8B0025 VARCHAR(10) #FUN-A10098
#           p4      LIKE azp_file.azp01,          # No.FUN-8B0025 VARCHAR(10) #FUN-A10098
#           p5      LIKE azp_file.azp01,          # No.FUN-8B0025 VARCHAR(10) #FUN-A10098
#           p6      LIKE azp_file.azp01,          # No.FUN-8B0025 VARCHAR(10) #FUN-A10098
#           p7      LIKE azp_file.azp01,          # No.FUN-8B0025 VARCHAR(10) #FUN-A10098
#           p8      LIKE azp_file.azp01,          # No.FUN-8B0025 VARCHAR(10) #FUN-A10098
           s       LIKE type_file.chr3,          # No.FUN-8B0025 VARCHAR(03)                                                             
           t       LIKE type_file.chr3,          # No.FUN-8B0025 VARCHAR(03)                                                             
           u       LIKE type_file.chr3,          # No.FUN-8B0025 VARCHAR(03)  
           e_date  LIKE type_file.dat,           #No.FUN-680123 DATE
           more    LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)
           END RECORD
 
DEFINE g_i         LIKE type_file.num5         #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE g_bookno    LIKE aza_file.aza81         #No.FUN-730073  
DEFINE g_bookno1   LIKE aza_file.aza81         #No.FUN-730073  
DEFINE g_bookno2   LIKE aza_file.aza81         #No.FUN-730073  
DEFINE g_flag      LIKE type_file.chr1         #No.FUN-730073
DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8B0025 ARRAY[10] OF VARCHAR(20)
DEFINE l_oma16     LIKE oma_file.oma16    #No:FUN-A50103
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oma00.oma_file.oma00,",  
               "oma01.oma_file.oma01," ,
               "oma02.oma_file.oma02," ,
               "oma03.oma_file.oma03," ,
               "oma032.oma_file.oma032,",
               "oma23.oma_file.oma23,"  ,
               "oma33.oma_file.oma33,"  ,
               "oma18.oma_file.oma18,"  ,
               "aag02.aag_file.aag02," ,
               "oma54t.oma_file.oma54t,",
               "oma56t.oma_file.oma56t,",
               "azi04.azi_file.azi04, ", 
               "azi05.azi_file.azi05, ", 
               "g_azi04.azi_file.azi04,",
               "g_azi05.azi_file.azi05,",
               "plant.azp_file.azp01 "              #FUN-8B0025 add plant 
 
   LET l_table = cl_prt_temptable('axrr151',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF# Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"  #FUN-8B0025 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.e_date  = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   LET tm.s  = ARG_VAL(13)
   LET tm.t  = ARG_VAL(14)
   LET tm.u  = ARG_VAL(15)
#FUN-A10098---begin
#   LET tm.b     = ARG_VAL(16)
#   LET tm.p1    = ARG_VAL(17)
#   LET tm.p2    = ARG_VAL(18)
#   LET tm.p3    = ARG_VAL(19)
#   LET tm.p4    = ARG_VAL(20)
#   LET tm.p5    = ARG_VAL(21)
#   LET tm.p6    = ARG_VAL(22)
#   LET tm.p7    = ARG_VAL(23)
#   LET tm.p8    = ARG_VAL(24)
#FUN-A10098---end 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r151_tm(0,0)
      ELSE CALL r151()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r151_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r151_w AT p_row,p_col
        WITH FORM "axr/42f/axrr151"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.e_date    = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s2  = '3'
   LET tm2.u1  = 'N'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
#   LET tm.b ='N'      #FUN-A10098
#   LET tm.p1=g_plant  #FUN-A10098
   CALL r151_set_entry_1()               
   CALL r151_set_no_entry_1()
   CALL r151_set_comb()           
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma01,oma03,oma18,oma33
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
#TQC-DA0039 add begin ---
     ON ACTION controlp
        CASE
           WHEN INFIELD(oma01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_oma011"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oma01
                NEXT FIELD oma01
           WHEN INFIELD(oma03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_oma03"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oma03
                NEXT FIELD oma03
           WHEN INFIELD(oma18)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.where = " aag00 = '",g_aza.aza81,"'"
                LET g_qryparam.form = "q_oma18"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oma18
                NEXT FIELD oma18
           WHEN INFIELD(oma33)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_oma33"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oma33
                NEXT FIELD oma33
        END CASE
#TQC-DA0039 add end -----

       ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r151_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#   INPUT BY NAME tm.b,tm.p1,tm.p2,tm.p3,           #FUN-A10098                                 #FUN-8B0025
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,    #FUN-A10098                                 #FUN-8B0025 
#                 tm2.s1,tm2.s2,tm2.s3,              #FUN-A10098                                #FUN-8B0025
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,              #FUN-A10098                                #FUN-8B0025
                 tm2.t1,tm2.t2,tm2.t3,                                              #FUN-8B0025
                 tm2.u1,tm2.u2,tm2.u3,                                              #FUN-8B0025
                 tm.e_date,tm.more WITHOUT DEFAULTS
 
   
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
        #-------------------MOD-C30334----------------start
         LET tm.e_date = GET_FLDBUF(e_date)
         LET tm2.s1 = GET_FLDBUF(s1)
         LET tm2.s2 = GET_FLDBUF(s2)
         LET tm2.s3 = GET_FLDBUF(s3)
         LET tm2.t1 = GET_FLDBUF(t1)
         LET tm2.t2 = GET_FLDBUF(t2)
         LET tm2.t3 = GET_FLDBUF(t3)
         LET tm2.u1 = GET_FLDBUF(u1)
         LET tm2.u2 = GET_FLDBUF(u2)
         LET tm2.u3 = GET_FLDBUF(u3)
        #-------------------MOD-C30334------------------end
 
      AFTER FIELD e_date
         IF cl_null(tm.e_date) THEN 
            NEXT FIELD e_date 
            CALL s_get_bookno(YEAR(tm.e_date))
                 RETURNING g_flag,g_bookno,g_bookno2
            IF g_flag = '1' THEN   #抓不到帳別
               CALL cl_err(tm.e_date,'aoo-081',1)
               NEXT FIELD e_date
            END IF       
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
#FUN-A10098---beign 
#      AFTER FIELD b
#          IF NOT cl_null(tm.b)  THEN
#             IF tm.b NOT MATCHES "[YN]" THEN
#                NEXT FIELD b       
#             END IF
#          END IF
#                   
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
#         CALL r151_set_entry_1()      
#         CALL r151_set_no_entry_1()
#         CALL r151_set_comb()       
#      
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#            NEXT FIELD p1 
#         END IF
#        IF NOT cl_null(tm.p1) THEN 
#           IF NOT s_chk_demo(g_user,tm.p1) THEN              
#              NEXT FIELD p1          
#           END IF  
#        END IF              
#      
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
#      
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
#      
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
#      
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
#
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#        END CASE                        
#FUN-A10098---end 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r151_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
 
   CALL s_get_bookno(YEAR(tm.e_date))
        RETURNING g_flag,g_bookno,g_bookno2
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axrr151'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr151','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.e_date CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.s CLIPPED,"'",                 #FUN-8B0025
                         " '",tm.t CLIPPED,"'",                 #FUN-8B0025
                         " '",tm.u CLIPPED,"'"                  #FUN-8B0025
              #FUN-A10098---begin
                    #     " '",tm.b CLIPPED,"'" ,                #FUN-8B0025
                    #     " '",tm.p1 CLIPPED,"'" ,               #FUN-8B0025
                    #     " '",tm.p2 CLIPPED,"'" ,               #FUN-8B0025
                    #     " '",tm.p3 CLIPPED,"'" ,               #FUN-8B0025
                    #     " '",tm.p4 CLIPPED,"'" ,               #FUN-8B0025
                    #     " '",tm.p5 CLIPPED,"'" ,               #FUN-8B0025
                    #     " '",tm.p6 CLIPPED,"'" ,               #FUN-8B0025
                    #     " '",tm.p7 CLIPPED,"'" ,               #FUN-8B0025
                    #     " '",tm.p8 CLIPPED,"'"                 #FUN-8B0025                         
              #FUN-A10098---end           
         CALL cl_cmdat('axrr151',g_time,l_cmd)
      END IF
      CLOSE WINDOW r151_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r151()
   ERROR ""
END WHILE
   CLOSE WINDOW r151_w
END FUNCTION
 
FUNCTION r151()
DEFINE l_name     LIKE type_file.chr20   # External(Disk) file name #No.FUN-680123 VARCHAR(20) 
DEFINE l_sql      STRING                 # RDSQL STATEMENT #No.FUN-680123 CHAR(1200) #MOD-B70104 mod STRING
DEFINE l_sql1     STRING                 # RDSQL STATEMENT #No.FUN-680123 CHAR(1200) #MOD-B70104 mod STRING
DEFINE l_za05     LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(40)
DEFINE l_oob09    LIKE oob_file.oob09    #原幣沖帳金額
DEFINE l_oob10    LIKE oob_file.oob10    #本幣沖帳金額
DEFINE l_oob03    LIKE oob_file.oob03    #借貸方
DEFINE l_oov04f   LIKE oov_file.oov04f   #原幣沖帳金額   #MOD-690133
DEFINE l_oov04    LIKE oov_file.oov04    #本幣沖帳金額   #MOD-690133
DEFINE l_oma24    LIKE oma_file.oma24    #匯率           #CHI-890004 add
DEFINE l_oma52    LIKE oma_file.oma52    #原幣訂金       #CHI-860040 add
DEFINE l_oma53    LIKE oma_file.oma53    #本幣訂金       #CHI-860040 add
DEFINE l_oma54t   LIKE oma_file.oma54t   #CHI-860040 add
DEFINE l_oma55    LIKE oma_file.oma55    #CHI-860040 add
DEFINE l_oma56t   LIKE oma_file.oma56t   #CHI-860040 add
DEFINE l_oma57    LIKE oma_file.oma57    #CHI-860040 add
DEFINE l_oma_osum LIKE oma_file.oma57    #CHI-860040 add
DEFINE l_oma_lsum LIKE oma_file.oma57    #CHI-860040 add
DEFINE l_oox01    STRING                 #CHI-830003 add
DEFINE l_oox02    STRING                 #CHI-830003 add
DEFINE l_str      STRING                 #CHI-830003 add
DEFINE l_sql_1    STRING                 #CHI-830003 add
DEFINE l_sql_2    STRING                 #CHI-830003 add
DEFINE l_omb03    LIKE omb_file.omb03    #CHI-830003 add
DEFINE l_count    LIKE type_file.num5    #CHI-830003 add
DEFINE sr         RECORD
                   oma00  LIKE oma_file.oma00,    #帳款類別
                   oma01  LIKE oma_file.oma01,    #帳款編號
                   oma02  LIKE oma_file.oma02,    #帳款日期
                   oma03  LIKE oma_file.oma03,    #帳款客戶
                   oma032 LIKE oma_file.oma032,   #客戶簡稱
                   oma23  LIKE oma_file.oma23,    #幣別
                   oma33  LIKE oma_file.oma33,    #傳票編號
                   oma18  LIKE oma_file.oma18,    #會計科目
                   aag02  LIKE aag_file.aag02,    #科目名稱
                   oma54t LIKE oma_file.oma54t,   #原幣金額
                   oma56t LIKE oma_file.oma56t    #本幣金額
                  END RECORD
DEFINE l_omc02    LIKE omc_file.omc02             #子帳期項次  #MOD-A20045 add
DEFINE l_oma24_1  LIKE oma_file.oma24             #CHI-830003
DEFINE l_dbs      LIKE azp_file.azp03                               
DEFINE l_azp03    LIKE azp_file.azp03                               
DEFINE l_i        LIKE type_file.num5                                        
DEFINE i          LIKE type_file.num5                                   

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #FUN-710080 add
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
#FUN-A10098---begin   
#  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#  LET m_dbs[1]=tm.p1
#  LET m_dbs[2]=tm.p2
#  LET m_dbs[3]=tm.p3
#  LET m_dbs[4]=tm.p4
#  LET m_dbs[5]=tm.p5
#  LET m_dbs[6]=tm.p6
#  LET m_dbs[7]=tm.p7
#  LET m_dbs[8]=tm.p8
# 
#  FOR l_i = 1 to 8                                                          #FUN-8B0025
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8B0025
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8B0025
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8B0025   
#FUN-A10098---end 
   LET l_sql1 ="SELECT SUM(oob09),SUM(oob10)  ",
            #  " FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file",  #FUN-A10098 #FUN-8B0025 mod               
               " FROM ooa_file,oob_file",  #FUN-A10098 #FUN-8B0025 mod               
               " WHERE ooa01=oob01 ",
              #"   AND ooa37='1' ",               #FUN-B20020  #MOD-C60114 mark
               "   AND ooa02 > '",tm.e_date,"' ",
               "   AND ooaconf='Y' ",
               "   AND oob06 IS NOT NULL ",
               "   AND oob06 = ? ",
               "   AND oob03 = ? ",
               "   AND oob19 = ? "  #MOD-A20045 add
   PREPARE r151_poob FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare apg:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   DECLARE r151_coob CURSOR FOR r151_poob
   
   IF g_ooz.ooz07 = 'N' THEN
      LET l_sql = "SELECT oma00,oma01,oma02,oma03,oma032,oma23,",
                  "       oma33,oma18,aag02,(omc08-omc10),",
                  "       (omc09-omc11),omc02,oma16 ",    #No:FUN-A50103  #MOD-A20045 add omc02
             #    " FROM ",l_dbs CLIPPED,"oma_file, OUTER ",l_dbs CLIPPED,"aag_file,",l_dbs CLIPPED,"omc_file", #FUN-A10098
                  " FROM oma_file, OUTER aag_file,omc_file", #FUN-A10098
                  " WHERE oma_file.oma18=aag_file.aag01",                        #No.FUN-730073
                  "   AND aag_file.aag00 = '",g_bookno,"'",             #No.FUN-730073	
                  "   AND oma01 = omc01",                      #No.MOD-9B0115
                  "   AND omavoid = 'N'",                      #作廢否='N'
                  "   AND omaconf = 'Y'",                      #已確認
                  "   AND ", tm.wc CLIPPED,
                  "   AND oma02 <='",tm.e_date,"' ",
                  "   AND ( (oma56t-oma57) >0 OR ",
               #  "       oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file ",    #FUN-A10098
                  "       oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",    #FUN-A10098
                  "                  WHERE ooa01=oob01  ",
                  "                    AND ooaconf='Y' ",
                 #"                    AND ooa37='1' ",               #FUN-B20020  #MOD-C60114 mark
                  "                    AND oob06 IS NOT NULL ",
                  "                    AND ooa02 >'",tm.e_date,"' ) OR ",    #CHI-860040 mod
                # "       oma01 IN (SELECT oma19 FROM oma_file ",            #CHI-860040 add
                  "       oma16 IN (SELECT oma19 FROM oma_file ",            #CHI-860040 add    #No:FUN-A50103
                  "                  WHERE omaconf='Y' AND omavoid='N'",     #CHI-860040 add
                  "                    AND (oma00='12' OR oma00='13')",      #CHI-860040 add
                  "                    AND oma02 >'",tm.e_date,"' )",        #CHI-860040 add
                  "     ) "
   ELSE                                                                                                                           
      LET l_sql = "SELECT oma00,oma01,oma02,oma03,oma032,oma23,",                                                                
                  "       oma33,oma18,aag02,(omc08-omc10),",
                  "       omc13,omc02,oma16 ",  #MOD-A20045 add omc02    #No:FUN-A50103
            #     " FROM ",l_dbs CLIPPED,"oma_file, OUTER ",l_dbs CLIPPED,"aag_file,",l_dbs CLIPPED,"omc_file",  #FUN-A10098                                                                             
                  " FROM oma_file, OUTER aag_file,omc_file",  #FUN-A10098                                                                             
                  " WHERE oma_file.oma18=aag_file.aag01",                                                                                  
                  "   AND aag_file.aag00 = '",g_bookno,"'",               #No.FUN-730073 
                  "   AND oma01 = omc01",                        #No.MOD-9B0115
                  "   AND omavoid = 'N'",                        #作廢否='N'                                                                           
                  "   AND omaconf = 'Y'",                        #已確認                                                                               
                  "   AND ", tm.wc CLIPPED,                                                                                       
                  "   AND oma02 <='",tm.e_date,"' ",                                                                              
                  "   AND (oma61 >0 OR ",                                                                                          
            #     "      oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file ",    #FUN-A10098                                                      
                  "      oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",    #FUN-A10098                                                      
                  "                 WHERE ooa01=oob01  ",                                                                       
                  "                   AND ooaconf='Y' ",     
                 #"                   AND ooa37='1' ",               #FUN-B20020  #MOD-C60114 mark
                  "                   AND oob06 IS NOT NULL ",                                                                  
                  "                   AND ooa02 >'",tm.e_date,"' ) OR ",           #CHI-860040 mod
            #     "      oma01 IN (SELECT oma19 FROM ",l_dbs CLIPPED,"oma_file ",  #CHI-860040 add  #FUN-A10098
                 #"      oma01 IN (SELECT oma19 FROM oma_file ",  #CHI-860040 add  #FUN-A10098
                  "      oma16 IN (SELECT oma19 FROM oma_file ",  #CHI-860040 add  #FUN-A10098    #No:FUN-A50103
                  "                 WHERE omaconf='Y' AND omavoid='N'",            #CHI-860040 add
                  "                   AND (oma00='12' OR oma00='13')",             #CHI-860040 add
                  "                   AND oma02 >'",tm.e_date,"' )",               #CHI-860040 add
                  "     ) "
   END IF                                                                                                                         
 
   PREPARE r151_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   DECLARE r151_curs1 CURSOR FOR r151_prepare1
   FOREACH r151_curs1 INTO sr.*,l_omc02,l_oma16   #MOD-A20045 add l_omc02    #No:FUN-A50103
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      IF g_ooz.ooz07 = 'Y' THEN
         LET l_oox01 = YEAR(tm.e_date)
         LET l_oox02 = MONTH(tm.e_date)                           	 
         LET l_oma24_1 = ''   #MOD-9C0030 add
         WHILE cl_null(l_oma24_1)
            IF g_ooz.ooz62 = 'N' THEN
           #    LET l_sql_2 = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oox_file",  #FUN-8B0025 mod     #FUN-A10098          
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",  #FUN-8B0025 mod     #FUN-A10098          
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 = '0'"
               PREPARE r151_prepare7 FROM l_sql_2
               DECLARE r151_oox7 CURSOR FOR r151_prepare7
               OPEN r151_oox7
               FETCH r151_oox7 INTO l_count
               CLOSE r151_oox7                       
               IF l_count = 0 THEN
                  #LET l_oma24_1 = '1'     #TQC-B10083 mark
                  EXIT WHILE               #TQC-B10083 add
               ELSE                  
            #      LET l_sql_1 = "SELECT oox07 FROM ",l_dbs CLIPPED,"oox_file", #FUN-8B0025 mod      #FUN-A10098                         
                  LET l_sql_1 = "SELECT oox07 FROM oox_file", #FUN-8B0025 mod      #FUN-A10098                         
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '0'"
               END IF                 
            ELSE
          #     LET l_sql_2 = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oox_file", #FUN-8B0025 mod   #FUN-A10098            
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file", #FUN-8B0025 mod   #FUN-A10098            
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 <> '0'"
               PREPARE r151_prepare8 FROM l_sql_2
               DECLARE r151_oox8 CURSOR FOR r151_prepare8
               OPEN r151_oox8
               FETCH r151_oox8 INTO l_count
               CLOSE r151_oox8                       
               IF l_count = 0 THEN
                  #LET l_oma24_1 = '1'    #TQC-B10083 mark 
                  EXIT WHILE              #TQC-B10083 add 
               ELSE            
                  LET l_sql = "SELECT MIN(omb03) ",                                                                              
           #                   "  FROM ",l_dbs CLIPPED,"omb_file",       #FUN-A10098
                              "  FROM omb_file",       #FUN-A10098
                              " WHERE omb01='",sr.oma01,"'"                                                                                                                                                                                  
                  PREPARE r151_pre FROM l_sql                                                                                          
                  DECLARE r151_c  CURSOR FOR r151_pre                                                                                 
                  OPEN r151_c                                                                                    
                  FETCH r151_c INTO l_omb03
                  IF cl_null(l_omb03) THEN
                     LET l_omb03 = 0
                  END IF       
            #      LET l_sql_1 = "SELECT oox07 FROM ",l_dbs CLIPPED,"oox_file",     #FUN-8B0025 mod    #FUN-A10098                           
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",     #FUN-8B0025 mod    #FUN-A10098                           
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '",l_omb03,"'"                                      
               END IF
            END IF   
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE r151_prepare07 FROM l_sql_1
               DECLARE r151_oox07 CURSOR FOR r151_prepare07
               OPEN r151_oox07
               FETCH r151_oox07 INTO l_oma24_1
               CLOSE r151_oox07
            END IF              
         END WHILE                                       
      END IF                                                                                 
#No.TQC-AB0047 --begin
      IF cl_null(l_oma24_1) THEN 
         SELECT oma24 INTO l_oma24_1 FROM oma_file WHERE oma01 = sr.oma01
      END IF 
#No.TQC-AB0047 101112 --end       
      #讀取截止日之後的沖帳金額
      IF sr.oma00[1,1]='1' THEN
         LET l_oob03 = '2'
      ELSE
         LET l_oob03 = '1'
      END IF
      LET l_oob09  =0
      LET l_oob10  =0
      OPEN r151_coob USING sr.oma01,l_oob03,l_omc02  #MOD-A20045 add l_omc02
      FETCH r151_coob INTO l_oob09,l_oob10
      IF SQLCA.SQLCODE <> 0 THEN
         LET l_oob09 =0
         LET l_oob10 =0
      END IF
      CLOSE r151_coob
      IF cl_null(sr.oma54t) THEN LET sr.oma54t=0 END IF
     #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN                               #CHI-830003   #MOD-A60133 mark
      IF g_ooz.ooz07 = 'Y' AND l_count <> 0 AND sr.oma54t <> 0 THEN            #CHI-830003   #MOD-A60133   #TQC-B10083 mark  #MOD-C80199 remark
     #IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) AND sr.oma54t <> 0 THEN  #TQC-B10083   #MOD-C80199 mark 
         #LET sr.oma56t = sr.oma54t * l_oma24_1                                 #CHI-830003 #mark by wy20170426
         #CALL cl_digcut(sr.oma56t,g_azi04) RETURNING sr.oma56t                 #MOD-BB0050 add #mark by wy20170426
      END IF                                                                   #CHI-830003      
      IF cl_null(sr.oma56t) THEN LET sr.oma56t=0 END IF
      IF cl_null(l_oob09)  THEN LET l_oob09=0 END IF
      IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN                               #CHI-830003   #TQC-B10083 mark  #MOD-C80199 remark
     #IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) THEN                     #TQC-B10083 mod   #MOD-C80199 mark
        # LET l_oob10 = l_oob09 * l_oma24_1          #mark by wy20170426                            #CHI-830003
        # CALL cl_digcut(l_oob10,g_azi04) RETURNING l_oob10  #mark by wy20170426                    #MOD-BB0050 add
      END IF                                                                   #CHI-830003      
      IF cl_null(l_oob10)  THEN LET l_oob10=0 END IF
      LET l_oov04f = 0
      LET l_oov04  = 0
      
      LET l_sql = "SELECT SUM(oov04f),SUM(oov04)",                                                                              
           #       "  FROM ",l_dbs CLIPPED,"oov_file",  #FUN-A10098
                  "  FROM oov_file",  #FUN-A10098
                  " WHERE oov03='",sr.oma01,"'",                                                                                                                                                                                  
           #       "   AND oov01 IN (SELECT oma01 FROM ",l_dbs CLIPPED,"oma_file ",  #FUN-A10098
                  "   AND oov01 IN (SELECT oma01 FROM oma_file ",  #FUN-A10098
                  "                  WHERE oma00 LIKE '2%'     ",
                  "                    AND oma02 > '",tm.e_date,"')",  #MOD-8C0271                                                                                          
                  "   AND oov05= ",l_omc02   #MOD-A20045 add
      PREPARE r151_pre1 FROM l_sql                                                                                          
      DECLARE r151_c1 CURSOR FOR r151_pre1                                                                                 
      OPEN r151_c1                                                                                    
      FETCH r151_c1 INTO l_oov04f,l_oov04
                                  
      IF cl_null(l_oov04f) THEN LET l_oov04f = 0 END IF
      IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN                                 #CHI-830003   #TQC-B10083 mark  #MOD-C80199 remark                 
     #IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) THEN                       #TQC-B10083   #MOD-C80199 mark  
         LET l_oov04 = l_oov04f * l_oma24_1                                      #CHI-830003
         CALL cl_digcut(l_oov04,g_azi04) RETURNING l_oov04                       #MOD-BB0050 add
      END IF                                                                     #CHI-830003      
      IF cl_null(l_oov04) THEN LET l_oov04 = 0 END IF
      LET l_oma52 = 0   LET l_oma53 = 0   #MOD-870063 add
     #當oma00='23'的帳單號碼抓取對應到oma00='12'的oma19其單據日期>截止日期,
     #已沖金額需加回這些超出截止日期單據的oma52,oma53
      IF sr.oma00 = '23' THEN                              
         LET sr.oma54t = 0   LET sr.oma56t = 0
        #str MOD-A20045 mod
        #改抓多帳期
        #LET l_sql ="SELECT oma54t,oma55,oma56t,oma57,oma24",
        #     #     "  FROM ",l_dbs CLIPPED,"oma_file",         #FUN-A10098      
        #           "  FROM oma_file",         #FUN-A10098      
        #           " WHERE oma01='",sr.oma01,"'"
        #LET l_sql ="SELECT omc08,omc10,omc09,omc11,omc06",   #MOD-BC0004 mark
         LET l_sql ="SELECT omc08-omc10,omc09-omc11,omc06",   #MOD-BC0004
                    "  FROM omc_file",
                    " WHERE omc01='",sr.oma01,"'",
                    "   AND omc02= ",l_omc02
        #end MOD-A20045 mod
         PREPARE r151_pre2 FROM l_sql                                                                                          
         DECLARE r151_c2 CURSOR FOR r151_pre2                                                                                 
         OPEN r151_c2                                                                                    
        #FETCH r151_c2 INTO l_oma54t,l_oma55,l_oma56t,l_oma57,l_oma24  #MOD-BC0004 mark 
         FETCH r151_c2 INTO l_oma54t,l_oma56t,l_oma24                  #MOD-BC0004
          
         IF cl_null(l_oma54t) THEN LET l_oma54t=0 END IF
        #IF cl_null(l_oma55)  THEN LET l_oma55 =0 END IF        #MOD-BC0004 mark
         IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN                  #CHI-830003  #TQC-B10083 mark  #MOD-C80199 remark                     
        #IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) THEN        #TQC-B10083  #MOD-C80199 mark 
            LET l_oma56t = l_oma54t * l_oma24_1                      #CHI-830003
           #LET l_oma57 = l_oma55 * l_oma24_1                                       #CHI-830003 #MOD-BC0004 mark
            CALL cl_digcut(l_oma56t,g_azi04) RETURNING l_oma56t                     #MOD-BB0050 add
           #CALL cl_digcut(l_oma57,g_azi04) RETURNING l_oma57                       #MOD-BB0050 add #MOD-BC0004 mark
         END IF                                                      #CHI-830003         
         IF cl_null(l_oma56t) THEN LET l_oma56t=0 END IF
        #IF cl_null(l_oma57)  THEN LET l_oma57 =0 END IF   #MOD-BC0004 mark
         IF cl_null(l_oma24)  THEN LET l_oma24 =1 END IF   #CHI-890004 add
        #LET l_sql = "SELECT SUM(oma52)+SUM(oma54)+SUM(oma54x),SUM(oma53)+SUM(oma56)+SUM(oma56x)", #MOD-B70104 mark 
         LET l_sql = "SELECT SUM(oma52),SUM(oma53) ",              #MOD-B70104 
                #     "  FROM ",l_dbs CLIPPED,"oma_file",   #FUN-A10098
                     "  FROM oma_file",   #FUN-A10098
                    #" WHERE oma19='",sr.oma01,"'",
                     " WHERE oma19='",l_oma16,"'",     #No:FUN-A50103
                     "   AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N' ",
                     "   AND oma02 > '",tm.e_date,"'"   #MOD-8C0271 #MOD-BC0004 mod <= -> > 
         PREPARE r151_pre3 FROM l_sql                                                                                          
         DECLARE r151_c3 CURSOR FOR r151_pre3                                                                                
         OPEN r151_c3                                                                                    
         FETCH r151_c3 INTO l_oma_osum,l_oma_lsum
            
         IF cl_null(l_oma_osum) THEN LET l_oma_osum=0 END IF
         IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN                  #CHI-830003  #TQC-B10083 mark  #MOD-C80199 remark
        #IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) THEN        #TQC-B10083  #MOD-C80199 mark
            LET l_oma_lsum = l_oma_osum * l_oma24_1                  #CHI-830003           
            CALL cl_digcut(l_oma_lsum,g_azi04) RETURNING l_oma_lsum                 #MOD-BB0050 add 
         END IF                                                      #CHI-830003         
         IF cl_null(l_oma_lsum) THEN LET l_oma_lsum=0 END IF
         #當原幣合計金額等於原幣已沖合計金額,那就讓本幣合計金額等於本幣已沖金額
         IF l_oma_osum=l_oma55 THEN LET l_oma_lsum=l_oma57 END IF
 
         #未沖金額 = 應收 - 已收
         LET l_oma52 = l_oma54t + l_oma_osum  #MOD-BC0004 mod - -> +
        #IF g_ooz.ooz07 = 'Y' THEN                                #MOD-BB0120 add #MOD-C10005 mark
        #預收待抵本幣金額 = 預收剩餘原幣 x 原立帳匯率
         LET l_oma53 = l_oma52 * l_oma24                          #CHI-890004
        #ELSE                                                     #MOD-BB0120 add #MOD-C10005 mark
        #   LET l_oma53 = l_oma56t + l_oma_lsum                   #MOD-BB0120 add #MOD-BC0004 mod - -> +  #MOD-C10005 mark
        #END IF                                                   #MOD-BB0120 add #MOD-C10005 mark
         CALL cl_digcut(l_oma53,g_azi04) RETURNING l_oma53        #MOD-BB0050 add 
      END IF
      IF cl_null(l_oma52) THEN LET l_oma52 =0 END IF
      IF cl_null(l_oma53) THEN LET l_oma53 =0 END IF
      LET sr.oma54t = sr.oma54t + l_oob09 + l_oov04f + l_oma52   #CHI-860040 #MOD-BC0004 move sr.oma54t #MOD-C10005加回sr.oma54t
      LET sr.oma56t = sr.oma56t + l_oob10 + l_oov04  + l_oma53   #CHI-860040 #MOD-BC0004 move sr.oma56t #MOD-C10005加回sr.oma54t
     #LET sr.oma54t = cl_digcut(sr.oma54t,t_azi04)  #MOD-D30113 mark   #MOD-C10175
      LET sr.oma56t = cl_digcut(sr.oma56t,g_azi04)  #MOD-C10175
      IF sr.oma00[1,1] = '2' THEN
         LET sr.oma54t = sr.oma54t * -1
         LET sr.oma56t = sr.oma56t * -1
      END IF
       
     #str MOD-A20045 add
     #原幣與本幣金額皆為0時,不需印出
      IF sr.oma54t=0 AND sr.oma56t=0 THEN
         CONTINUE FOREACH
      END IF
     #end MOD-A20045 add

      LET l_sql = "SELECT azi04,azi05",                                                                              
           #      "  FROM ",l_dbs CLIPPED,"azi_file",  #FUN-A10098
                  "  FROM azi_file",  #FUN-A10098
                  " WHERE azi01='",sr.oma23,"'"                                                                                                                                                                                  
      PREPARE r151_pre4 FROM l_sql                                                                                          
      DECLARE r151_c4 CURSOR FOR r151_pre4                                                                                
      OPEN r151_c4                                                                                    
      FETCH r151_c4 INTO t_azi04,t_azi05
       
      LET sr.oma54t = cl_digcut(sr.oma54t,t_azi04)  #MOD-D30113
      IF sr.oma18 IS NULL THEN LET sr.oma18=' ' END IF

     #str CHI-B60073 add
     #23.預收待抵增加抓取訂金的傳票編號來顯示
      IF sr.oma00='23' THEN
         SELECT oma33 INTO sr.oma33 FROM oma_file
          WHERE oma19=sr.oma01 AND oma00='11'
      END IF
     #end CHI-B60073 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
  #   EXECUTE insert_prep USING  sr.*,t_azi04,t_azi05,g_azi04,g_azi05,m_dbs[l_i] #FUN-A10098 #FUN-8B0025 add m_dbs[l_i]
      EXECUTE insert_prep USING  sr.*,t_azi04,t_azi05,g_azi04,g_azi05,' ' # FUN-A10098 #FUN-8B0025 add m_dbs[l_i]
      #------------------------------ CR (3) ------------------------------#
      LET l_oma24_1 = ''   #MOD-920370
   END FOREACH
 #  END FOR  #FUN-8B0025 add   #FUN-A10098
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oma01,oma03,oma18,oma33')
           RETURNING tm.wc
      LET g_str = tm.wc
   ELSE                #FUN-8B0025 add
      LET tm.wc=""     #FUN-8B0025 add      
   END IF
   LET g_str = g_str CLIPPED,";",tm.e_date,';',
               tm.u[1,1],';',tm.u[2,2],';',tm.u[3,3],';',   #FUN-8B0025 add
               tm.t[1,1],';',tm.t[2,2],';',tm.t[3,3],';',   #FUN-8B0025 add
               tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3]        #FUN-8B0025 add   
 #    IF tm.b='Y' THEN   #FUN-A10098
 #       CALL cl_prt_cs3('axrr151','axrr151_1',l_sql,g_str)  #FUN-A10098
 #    ELSE     #FUN-A10098
      CALL cl_prt_cs3('axrr151','axrr151',l_sql,g_str)   #FUN-710080 modify
 #    END IF   #FUN-A10098
END FUNCTION
 
FUNCTION r151_set_entry_1()
    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
END FUNCTION
 
FUNCTION r151_set_no_entry_1()
#    IF tm.b = 'N' THEN    #FUN-A10098
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)   #FUN-A10098
       IF tm2.s1 = '5' THEN                                                                                                         
          LET tm2.s1 = ' '                                                                                                          
       END IF                                                                                                                       
       IF tm2.s2 = '5' THEN                                                                                                         
          LET tm2.s2 = ' '                                                                                                          
       END IF                                                                                                                       
       IF tm2.s3 = '5' THEN                                                                                                         
          LET tm2.s2 = ' '                                                                                                          
       END IF
#    END IF    #FUN-A10098
END FUNCTION
 
FUNCTION r151_set_comb()                                                                                                            
  DEFINE comb_value STRING                                                                                                          
  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
                                                                                                                                    
#    IF tm.b ='N' THEN                               #FUN-A10098                                                                          
       LET comb_value = '1,2,3,4'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axr-830' AND ze02=g_lang                                                                                      
#    ELSE                                            #FUN-A10098                                                                                
#       LET comb_value = '1,2,3,4,5'                 #FUN-A10098                                                                                  
#       SELECT ze03 INTO comb_item FROM ze_file      #FUN-A10098                                                                                
#         WHERE ze01='axr-831' AND ze02=g_lang       #FUN-A10098                                                                                
#    END IF          #FUN-A10098                                                                                                                  
    CALL cl_set_combo_items('s1',comb_value,comb_item)
    CALL cl_set_combo_items('s2',comb_value,comb_item)
    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
END FUNCTION
#No.FUN-9C0072 精簡程式碼
