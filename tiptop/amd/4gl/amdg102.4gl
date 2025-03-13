# Prog. Version..: '5.30.06-13.04.17(00004)'     #
#
# Pattern name...: amdg102.4gl
# Descriptions...: 營業人媒體檔案申報表
# Date & Author..: 95/02/06 By Danny
#                : 新增列印(36.免用發票)
# Modify canny(9/14): 進項金額，不可用 INTEGER,要用 DEC(13,0)
#                     進項，多增加 amd172 control
# Modify canny(9/15): 加大金額欄位處理
# Modify.........: No.MOD-530087 05/03/14 By cate 報表標題標準化
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify         : No.MOD-590359 05/09/21 by Dido 統一編號擴為20位元
# Modify.........: NO.TQC-5B0201 05/12/13 BY yiting 年月輸入模式統一為：年/起始月份-截止月份
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: N0:MOD-690155 06/12/06 By Smapmin 將發票數列印出來,並修正TQC-5B0201
# Modify.........: No.FUN-710082 07/03/07 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.MOD-740478 07/04/30 By Smapmin 修改where條件
# Modify.........: No.MOD-860162 08/06/26 By Sarah WHERE條件抓amd17改用=,不用MATCHES
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70218 10/07/30 By Dido 發票份數計算邏輯應與 amdr401 相同
# Modify.........: No.FUN-B40092 11/06/03 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B80050 11/08/03 By minpp 程序撰写规范修改 
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.MOD-BC0008 11/12/14 By yangtt GRW套表更新
# Modify.........: No.MOD-D40106 13/04/16 By apo 發票份數改用num20型態
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
         amd173_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
         amd174_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
         #amd173_e    LIKE type_file.num10,      #No.FUN-680074 INTEGER    #MOD-690155
         amd174_e    LIKE type_file.num10,      #No.FUN-680074 INTEGER
         ama01       LIKE ama_file.ama01,
         more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD,
       g_ama02 LIKE ama_file.ama02,
       g_ama03 LIKE ama_file.ama03,
       g_ama05 LIKE ama_file.ama05,
       g_ama08 LIKE ama_file.ama08,  #NO.TQC-5B0201
       g_ama09 LIKE ama_file.ama09,  #NO.TQC-5B0201
       g_ama10 LIKE ama_file.ama10,  #NO.TQC-5B0201
       l_cnt    LIKE type_file.num5          #No.FUN-680074 SMALLINT
#DEFINE g_inv_all    LIKE type_file.num5    #使用發票分數  #MOD-D40106 mark   #MOD-690155
DEFINE g_inv_all    LIKE type_file.num20    #使用發票份數  #MOD-D40106
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_str      STRING   
#No.FUN-710082--end  
 
###GENGRE###START
TYPE sr1_t RECORD
    a311 LIKE amd_file.amd08,
    b311 LIKE amd_file.amd08,
    a312 LIKE amd_file.amd08,
    a313 LIKE amd_file.amd08,
    a321 LIKE amd_file.amd08,
    b321 LIKE amd_file.amd08,
    a322 LIKE amd_file.amd08,
    a323 LIKE amd_file.amd08,
    a331 LIKE amd_file.amd08,
    b331 LIKE amd_file.amd08,
    a332 LIKE amd_file.amd08,
    a333 LIKE amd_file.amd08,
    a341 LIKE amd_file.amd08,
    b341 LIKE amd_file.amd08,
    a342 LIKE amd_file.amd08,
    a343 LIKE amd_file.amd08,
    a351 LIKE amd_file.amd08,
    b351 LIKE amd_file.amd08,
    a352 LIKE amd_file.amd08,
    a353 LIKE amd_file.amd08,
    a361 LIKE amd_file.amd08,
    b361 LIKE amd_file.amd08,
    a362 LIKE amd_file.amd08,
    a363 LIKE amd_file.amd08,
    a21 LIKE amd_file.amd08,
    b21 LIKE amd_file.amd08,
    a22 LIKE amd_file.amd08,
    b22 LIKE amd_file.amd08,
    a23 LIKE amd_file.amd08,
    b23 LIKE amd_file.amd08,
    a24 LIKE amd_file.amd08,
    b24 LIKE amd_file.amd08,
    a25 LIKE amd_file.amd08,
    b25 LIKE amd_file.amd08,
    a26 LIKE amd_file.amd08,
    b26 LIKE amd_file.amd08,
    a27 LIKE amd_file.amd08,
    b27 LIKE amd_file.amd08,
    a28 LIKE amd_file.amd08,
    b28 LIKE amd_file.amd08,
    a29 LIKE amd_file.amd08,
    b29 LIKE amd_file.amd08,
    a211 LIKE amd_file.amd08,
    b211 LIKE amd_file.amd08,
    a221 LIKE amd_file.amd08,
    b221 LIKE amd_file.amd08,
    a231 LIKE amd_file.amd08,
    b231 LIKE amd_file.amd08,
    a241 LIKE amd_file.amd08,
    b241 LIKE amd_file.amd08,
    a251 LIKE amd_file.amd08,
    b251 LIKE amd_file.amd08,
    a261 LIKE amd_file.amd08,
    b261 LIKE amd_file.amd08,
    a271 LIKE amd_file.amd08,
    b271 LIKE amd_file.amd08,
    a281 LIKE amd_file.amd08,
    b281 LIKE amd_file.amd08,
    a291 LIKE amd_file.amd08,
    b291 LIKE amd_file.amd08,
    sum1 LIKE amd_file.amd08,
    sum2 LIKE amd_file.amd08,
    sum3 LIKE amd_file.amd08,
    sum4 LIKE amd_file.amd08,
    sum5 LIKE amd_file.amd08,
    sum6 LIKE amd_file.amd08,
    sum7 LIKE amd_file.amd08,
    sum8 LIKE amd_file.amd08,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    amd173b LIKE type_file.num10,
    amd174b LIKE type_file.num10,
    amd174e LIKE type_file.num10
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.amd173_b = ARG_VAL(7)
   LET tm.amd174_b = ARG_VAL(8)
#-----TQC-610057---------
   #LET tm.amd173_e = ARG_VAL(9)   #MOD-690155
   LET tm.amd174_e = ARG_VAL(9)
   LET tm.ama01   = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.FUN-710082--begin
   LET g_sql ="a311.amd_file.amd08,",
              "b311.amd_file.amd08,",
              "a312.amd_file.amd08,",
              "a313.amd_file.amd08,",
              "a321.amd_file.amd08,",
 
              "b321.amd_file.amd08,",
              "a322.amd_file.amd08,",
              "a323.amd_file.amd08,",
              "a331.amd_file.amd08,",
              "b331.amd_file.amd08,",
 
              "a332.amd_file.amd08,",
              "a333.amd_file.amd08,",
              "a341.amd_file.amd08,",
              "b341.amd_file.amd08,",
              "a342.amd_file.amd08,",
 
              "a343.amd_file.amd08,",
              "a351.amd_file.amd08,",
              "b351.amd_file.amd08,",
              "a352.amd_file.amd08,",
              "a353.amd_file.amd08,",
 
              "a361.amd_file.amd08,",
              "b361.amd_file.amd08,",
              "a362.amd_file.amd08,",
              "a363.amd_file.amd08,",
              "a21.amd_file.amd08,",
 
              "b21.amd_file.amd08,",
              "a22.amd_file.amd08,",
              "b22.amd_file.amd08,",
              "a23.amd_file.amd08,",
              "b23.amd_file.amd08,",
 
              "a24.amd_file.amd08,",
              "b24.amd_file.amd08,",
              "a25.amd_file.amd08,",
              "b25.amd_file.amd08,",
              "a26.amd_file.amd08,",
 
              "b26.amd_file.amd08,",
              "a27.amd_file.amd08,",
              "b27.amd_file.amd08,",
              "a28.amd_file.amd08,",
              "b28.amd_file.amd08,",
 
              "a29.amd_file.amd08,",
              "b29.amd_file.amd08,",
              "a211.amd_file.amd08,",
              "b211.amd_file.amd08,",
              "a221.amd_file.amd08,",
 
              "b221.amd_file.amd08,",
              "a231.amd_file.amd08,",
              "b231.amd_file.amd08,",
              "a241.amd_file.amd08,",
              "b241.amd_file.amd08,",
 
              "a251.amd_file.amd08,",
              "b251.amd_file.amd08,",
              "a261.amd_file.amd08,",
              "b261.amd_file.amd08,",
              "a271.amd_file.amd08,",
 
              "b271.amd_file.amd08,",
              "a281.amd_file.amd08,",
              "b281.amd_file.amd08,",
              "a291.amd_file.amd08,",
              "b291.amd_file.amd08,",
 
              "sum1.amd_file.amd08,",
              "sum2.amd_file.amd08,",
              "sum3.amd_file.amd08,",
              "sum4.amd_file.amd08,",
              "sum5.amd_file.amd08,",
 
              "sum6.amd_file.amd08,",
              "sum7.amd_file.amd08,",
              "sum8.amd_file.amd08,",
              "azi04.azi_file.azi04,",
              "azi05.azi_file.azi05,",
 
              "amd173b.type_file.num10,",
              "amd174b.type_file.num10,",
              "amd174e.type_file.num10"
 
   LET l_table = cl_prt_temptable('amdg102',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   #No.FUN-710082--end  
 
#-----END TQC-610057-----
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g102_tm(0,0)
      ELSE CALL g102()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g102_tm(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(1000)
 
IF p_row = 0 THEN LET p_row = 2 LET p_col = 3 END IF
IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
     LET p_row = 6 LET p_col = 30
ELSE LET p_row = 6 LET p_col = 15
END IF
OPEN WINDOW g102_w AT p_row,p_col
WITH FORM "amd/42f/amdg102"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
LET tm.more = 'N'
LET tm.amd173_b=YEAR(g_today)
LET g_pdate = g_today
LET g_rlang = g_lang
LET g_bgjob = 'N'
LET g_copies = '1'
#-----MOD-690155---------
##NO.TQC-5B0201 START--
#IF cl_null(tm.amd173_e) THEN
#    LET tm.amd173_e = tm.amd173_b
#END IF
##NO.TQC-5B0201 END---
#-----END MOD-690155-----
 
 
WHILE TRUE
   #INPUT BY NAME tm.amd173_b,tm.amd174_b,tm.amd173_e,tm.amd174_e,
   INPUT BY NAME tm.ama01,tm.amd173_b,tm.amd174_b,tm.amd174_e,  #NO.TQC-5B0201
                 tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD amd173_b
         IF cl_null(tm.amd173_b) THEN NEXT FIELD amd173_b END IF
      AFTER FIELD amd174_b
         IF cl_null(tm.amd174_b) THEN NEXT FIELD amd174_b END IF
#NO.TQC-5B0201 MARK
#      AFTER FIELD amd173_e
#         IF cl_null(tm.amd173_e) THEN NEXT FIELD amd173_e END IF
#NO.TQC-5B02021 MARK
 
      AFTER FIELD amd174_e
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF cl_null(tm.amd174_e) THEN NEXT FIELD amd174_e END IF
         #IF tm.amd173_b+tm.amd174_b > tm.amd173_e+tm.amd174_e THEN   #MOD-690155
         IF tm.amd174_b > tm.amd174_e THEN   #MOD-690155
            NEXT FIELD amd174_e
         END IF
      AFTER FIELD ama01
         IF cl_null(tm.ama01) THEN NEXT FIELD ama01
         ELSE
            #--NO.TQC-5B0201 START--
            #SELECT ama02,ama03,ama05 INTO g_ama02,g_ama03,g_ama05
            SELECT ama02,ama03,ama05,ama08,ama09,ama10
              INTO g_ama02,g_ama03,g_ama05,g_ama08,g_ama09,g_ama10
            #--NO.TQC-5B0201 END----
               FROM ama_file WHERE ama01 = tm.ama01 AND amaacti = 'Y'
            IF SQLCA.sqlcode THEN
       #       CALL cl_err(tm.ama01,'amd-002',0) #No.FUN-660093
               CALL cl_err3("sel","ama_file",tm.ama01,"","amd-002","","",0)   #No.FUN-660093
               NEXT FIELD ama01
            END IF
            #NO.TQC-5B0201 START-----
            LET tm.amd173_b = g_ama08
            LET tm.amd174_b = g_ama09 + 1
            IF tm.amd174_b > 12 THEN
                LET tm.amd173_b = tm.amd173_b + 1
                #LET tm.amd173_e = tm.amd173_b   #MOD-690155
                LET tm.amd174_b = tm.amd174_b - 12
            END IF
            LET tm.amd174_e = tm.amd174_b + g_ama10 - 1
            DISPLAY tm.amd173_b TO FORMONLY.amd173_b
            DISPLAY tm.amd174_b TO FORMONLY.amd174_b
            DISPLAY tm.amd174_e TO FORMONLY.amd174_e
            #NO.TQC-5B0201 END-------
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
      #-----MOD-690155---------
      ON ACTION CONTROLP
          CASE WHEN INFIELD(ama01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ama"
                    LET g_qryparam.default1 = tm.ama01
                    CALL cl_create_qry() RETURNING tm.ama01
                    DISPLAY tm.ama01 TO ama01
               OTHERWISE
                    EXIT CASE
           END CASE
      #-----END MOD-690155-----
 
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g102_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdg102'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdg102','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.amd173_b CLIPPED,"'",
                         " '",tm.amd174_b CLIPPED,"'",
                         #" '",tm.amd173_e CLIPPED,"'",   #MOD-690155
                         " '",tm.amd174_e CLIPPED,"'",
                         " '",tm.ama01 CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amdg102',g_time,l_cmd)
      END IF
      CLOSE WINDOW g102_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g102()
   ERROR ""
END WHILE
   CLOSE WINDOW g102_w
END FUNCTION
 
FUNCTION g102()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0068
          l_sql     STRING,                    # RDSQL STATEMENT        #No.FUN-680074
          l_chr     LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,       #No.FUN-680074 SMALLINT
          sr               RECORD
                                  amd17  LIKE amd_file.amd17,   #待抵代碼
                                  amd171 LIKE amd_file.amd171,  #格式
                                  amd172 LIKE amd_file.amd172,  #課稅別
                                  amd07  LIKE amd_file.amd07,   #扣抵金額
                                  amd08  LIKE amd_file.amd08    #扣抵稅額
                           END RECORD
#No.FUN-710082--begin
DEFINE l_a311,l_b311,l_a312,l_a313         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a321,l_b321,l_a322,l_a323         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a331,l_b331,l_a332,l_a333         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a341,l_b341,l_a342,l_a343         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a351,l_b351,l_a352,l_a353         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a361,l_b361,l_a362,l_a363         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a21,l_b21,l_a22,l_b22,l_a23       LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_b23,l_a24,l_b24,l_a25,l_b25       LIKE amd_file.amd07,       #No.FUN-680074 DECIMAL(20,6)
       l_a26,l_b26,l_a27,l_b27             LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a28,l_b28                         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a29,l_b29                         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6) #no:7393 
       l_a211,l_b211,l_a221,l_b221,l_a231  LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_b231,l_a241,l_b241,l_a251,l_b251  LIKE amd_file.amd07,       #No.FUN-680074 DECIMAL(20,6)
       l_a261,l_b261,l_a271,l_b271         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a281,l_b281                       LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_a291,l_b291                       LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6) #no:7393 
       l_x                                 LIKE zaa_file.zaa08,       #No.FUN-680074 VARCHAR(32)
       l_sum1,l_sum2,l_sum3                LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_sum4,l_sum5,l_sum6                LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
       l_sum7,l_sum8                       LIKE amd_file.amd08       #No.FUN-680074 DECIMAL(20,6)
#No.FUN-710082--end  
 
     #No.FUN-710082--begin
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amdg102'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 90 END IF
#    #-->進銷項
#    LET l_sql = "SELECT amd17,amd171,amd172,amd07,amd08 ",
#              " FROM amd_file ",
#              " WHERE (amd173*12+amd174) BETWEEN ",
#                         (tm.amd173_b*12+tm.amd174_b)," AND ",
#                         #(tm.amd173_e*12+tm.amd174_e),   #MOD-690155
#                         (tm.amd173_b*12+tm.amd174_e),   #MOD-690155
#              "   AND amd22 ='",tm.ama01,"'"
#    PREPARE g102_prepare  FROM l_sql
#    IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
#    DECLARE g102_curs CURSOR FOR g102_prepare
 
     CALL cl_del_data(l_table) 
 
#    CALL cl_outnam('amdg102') RETURNING l_name
#    START REPORT g102_rep TO l_name
#    LET g_pageno = 0
 
     CALL g102_sum()  #計算發票數   #MOD-690155
 
#    FOREACH g102_curs INTO sr.*
#         IF SQLCA.sqlcode != 0 THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#         IF cl_null(sr.amd07) THEN LET sr.amd07=0 END IF
#         IF cl_null(sr.amd08) THEN LET sr.amd08=0 END IF
 
      #-->銷項項目
#     LET l_a311=SUM(sr.amd08)  WHERE sr.amd171='31' AND sr.amd172='1'
      SELECT SUM(amd08) INTO l_a311 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='31' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_b311=SUM(sr.amd07)  WHERE sr.amd171='31' AND sr.amd172='1'
      SELECT SUM(amd07) INTO l_b311 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='31' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a312=SUM(sr.amd08)  WHERE sr.amd171='31' AND sr.amd172='2'
      SELECT SUM(amd08) INTO l_a312 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='31' AND amd172='2'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a313=SUM(sr.amd08)  WHERE sr.amd171='31' AND sr.amd172='3'
      SELECT SUM(amd08) INTO l_a313 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='31' AND amd172='3'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a321=SUM(sr.amd08)  WHERE sr.amd171='32' AND sr.amd172='1'
      SELECT SUM(amd08) INTO l_a321 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='32' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_b321=SUM(sr.amd07)  WHERE sr.amd171='32' AND sr.amd172='1'
      SELECT SUM(amd07) INTO l_b321 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='32' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a322=SUM(sr.amd08)  WHERE sr.amd171='32' AND sr.amd172='2'
      SELECT SUM(amd08) INTO l_a322 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='32' AND amd172='2'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a323=SUM(sr.amd08)  WHERE sr.amd171='32' AND sr.amd172='3'
      SELECT SUM(amd08) INTO l_a323 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='32' AND amd172='3'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a331=SUM(sr.amd08)  WHERE sr.amd171='33' AND sr.amd172='1'
      SELECT SUM(amd08) INTO l_a331 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='33' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_b331=SUM(sr.amd07)  WHERE sr.amd171='33' AND sr.amd172='1'
      SELECT SUM(amd07) INTO l_b331 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='33' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a332=SUM(sr.amd08)  WHERE sr.amd171='33' AND sr.amd172='2'
      SELECT SUM(amd08) INTO l_a332 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='33' AND amd172='2'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a333=SUM(sr.amd08)  WHERE sr.amd171='33' AND sr.amd172='3'
      SELECT SUM(amd08) INTO l_a333 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='33' AND amd172='3'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a341=SUM(sr.amd08)  WHERE sr.amd171='34' AND sr.amd172='1'
      SELECT SUM(amd08) INTO l_a341 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='34' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_b341=SUM(sr.amd07)  WHERE sr.amd171='34' AND sr.amd172='1'
      SELECT SUM(amd07) INTO l_b341 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='34' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a342=SUM(sr.amd08)  WHERE sr.amd171='34' AND sr.amd172='2'
      SELECT SUM(amd08) INTO l_a342 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='34' AND amd172='2'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a343=SUM(sr.amd08)  WHERE sr.amd171='34' AND sr.amd172='3'
      SELECT SUM(amd08) INTO l_a343 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='34' AND amd172='3'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a351=SUM(sr.amd08)  WHERE sr.amd171='35' AND sr.amd172='1'
      SELECT SUM(amd08) INTO l_a351 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='35' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_b351=SUM(sr.amd07)  WHERE sr.amd171='35' AND sr.amd172='1'
      SELECT SUM(amd07) INTO l_b351 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='35' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a352=SUM(sr.amd08)  WHERE sr.amd171='35' AND sr.amd172='2'
      SELECT SUM(amd08) INTO l_a352 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='35' AND amd172='2'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a353=SUM(sr.amd08)  WHERE sr.amd171='35' AND sr.amd172='3'
      SELECT SUM(amd08) INTO l_a353 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='35' AND amd172='3'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a361=SUM(sr.amd08)  WHERE sr.amd171='36' AND sr.amd172='1'
      SELECT SUM(amd08) INTO l_a361 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='36' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_b361=SUM(sr.amd07)  WHERE sr.amd171='36' AND sr.amd172='1'
      SELECT SUM(amd07) INTO l_b361 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='36' AND amd172='1'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a362=SUM(sr.amd08)  WHERE sr.amd171='36' AND sr.amd172='2'
      SELECT SUM(amd08) INTO l_a362 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='36' AND amd172='2'
        AND amd30 = 'Y'   #MOD-740478
 
#     LET l_a363=SUM(sr.amd08)  WHERE sr.amd171='36' AND sr.amd172='3'
      SELECT SUM(amd08) INTO l_a363 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171='36' AND amd172='3'
        AND amd30 = 'Y'   #MOD-740478
 
      #-->進項項目
#     LET l_a21=SUM(sr.amd08) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'       #canny(9/14):要加
      SELECT SUM(amd08) INTO l_a21 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '21' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b21=SUM(sr.amd07) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b21 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '21' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a22=SUM(sr.amd08) WHERE sr.amd171='22' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a22 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '22' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b22=SUM(sr.amd07) WHERE sr.amd171='22' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b22 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '22' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a23=SUM(sr.amd08) WHERE sr.amd171='23' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a23 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '23' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b23=SUM(sr.amd07) WHERE sr.amd171='23' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b23 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '23' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a24=SUM(sr.amd08) WHERE sr.amd171='24' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a24 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '24' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b24=SUM(sr.amd07) WHERE sr.amd171='24' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b24 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '24' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a25=SUM(sr.amd08) WHERE sr.amd171='25' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a25 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '25' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b25=SUM(sr.amd07) WHERE sr.amd171='25' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b25 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '25' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a26=SUM(sr.amd08) WHERE sr.amd171='26' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a26 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '26' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b26=SUM(sr.amd07) WHERE sr.amd171='26' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b26 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '26' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a27=SUM(sr.amd08) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a27 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '27' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b27=SUM(sr.amd07) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b27 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '27' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a28=SUM(sr.amd08) WHERE sr.amd171='28' AND sr.amd17 MATCHES '[1]'
      SELECT SUM(amd08) INTO l_a28 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '28' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b28=SUM(sr.amd07) WHERE sr.amd171='28' AND sr.amd17 MATCHES '[1]'
      SELECT SUM(amd07) INTO l_b28 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '28' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a29=SUM(sr.amd08) WHERE sr.amd171='29' AND sr.amd17 MATCHES '[1]'
      SELECT SUM(amd08) INTO l_a29 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '29' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b29=SUM(sr.amd07) WHERE sr.amd171='29' AND sr.amd17 MATCHES '[1]'
      SELECT SUM(amd07) INTO l_b29 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '29' AND amd17 ='1'    #MATCHES '[1]'   #MOD-860162 mod
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a211=SUM(sr.amd08) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a211 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '21' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b211=SUM(sr.amd07) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b211 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '21' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a221=SUM(sr.amd08) WHERE sr.amd171='22' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a221 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '22' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b221=SUM(sr.amd07) WHERE sr.amd171='22' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b221 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '22' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a231=SUM(sr.amd08) WHERE sr.amd171='23' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a231 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '23' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b231=SUM(sr.amd07) WHERE sr.amd171='23' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b231 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '23' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a241=SUM(sr.amd08) WHERE sr.amd171='24' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a241 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '24' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b241=SUM(sr.amd07) WHERE sr.amd171='24' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b241 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '24' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a251=SUM(sr.amd08) WHERE sr.amd171='25' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a251 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '25' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b251=SUM(sr.amd07) WHERE sr.amd171='25' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b251 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '25' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a261=SUM(sr.amd08) WHERE sr.amd171='26' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a261 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '26' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b261=SUM(sr.amd07) WHERE sr.amd171='26' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b261 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '26' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a271=SUM(sr.amd08) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd08) INTO l_a271 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '27' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b271=SUM(sr.amd07) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
      SELECT SUM(amd07) INTO l_b271 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '27' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
	AND amd172 = '1'  
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a281=SUM(sr.amd08) WHERE sr.amd171='28' AND sr.amd17 MATCHES '[2]'
      SELECT SUM(amd08) INTO l_a281 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '28' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b281=SUM(sr.amd07) WHERE sr.amd171='28' AND sr.amd17 MATCHES '[2]'
      SELECT SUM(amd07) INTO l_b281 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '28' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
        AND amd30 = 'Y'   #MOD-740478
#     LET l_a291=SUM(sr.amd08) WHERE sr.amd171='29' AND sr.amd17 MATCHES '[2]'
      SELECT SUM(amd08) INTO l_a291 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '29' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
        AND amd30 = 'Y'   #MOD-740478
#     LET l_b291=SUM(sr.amd07) WHERE sr.amd171='29' AND sr.amd17 MATCHES '[2]'
      SELECT SUM(amd07) INTO l_b291 FROM amd_file
      WHERE (amd173*12+amd174) BETWEEN 
            (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)
        AND amd22 =tm.ama01
        AND amd171 = '29' AND amd17 ='2'    #MATCHES '[2]'   #MOD-860162 mod
        AND amd30 = 'Y'   #MOD-740478
 
      IF cl_null(l_a311) THEN LET l_a311=0 END IF
      IF cl_null(l_b311) THEN LET l_b311=0 END IF
      IF cl_null(l_a312) THEN LET l_a312=0 END IF
      IF cl_null(l_a313) THEN LET l_a313=0 END IF
      IF cl_null(l_a321) THEN LET l_a321=0 END IF
      IF cl_null(l_b321) THEN LET l_b321=0 END IF
      IF cl_null(l_a322) THEN LET l_a322=0 END IF
      IF cl_null(l_a323) THEN LET l_a323=0 END IF
      IF cl_null(l_a331) THEN LET l_a331=0 END IF
      IF cl_null(l_b331) THEN LET l_b331=0 END IF
      IF cl_null(l_a332) THEN LET l_a332=0 END IF
      IF cl_null(l_a333) THEN LET l_a333=0 END IF
      IF cl_null(l_a341) THEN LET l_a341=0 END IF
      IF cl_null(l_b341) THEN LET l_b341=0 END IF
      IF cl_null(l_a342) THEN LET l_a342=0 END IF
      IF cl_null(l_a343) THEN LET l_a343=0 END IF
      IF cl_null(l_a351) THEN LET l_a351=0 END IF
      IF cl_null(l_b351) THEN LET l_b351=0 END IF
      IF cl_null(l_a352) THEN LET l_a352=0 END IF
      IF cl_null(l_a353) THEN LET l_a353=0 END IF
      IF cl_null(l_a361) THEN LET l_a361=0 END IF
      IF cl_null(l_b361) THEN LET l_b361=0 END IF
      IF cl_null(l_a362) THEN LET l_a362=0 END IF
      IF cl_null(l_a363) THEN LET l_a363=0 END IF
      IF cl_null(l_a21) THEN LET l_a21=0 END IF
      IF cl_null(l_b21) THEN LET l_b21=0 END IF
      IF cl_null(l_a22) THEN LET l_a22=0 END IF
      IF cl_null(l_b22) THEN LET l_b22=0 END IF
      IF cl_null(l_a23) THEN LET l_a23=0 END IF
      IF cl_null(l_b23) THEN LET l_b23=0 END IF
      IF cl_null(l_a24) THEN LET l_a24=0 END IF
      IF cl_null(l_b24) THEN LET l_b24=0 END IF
      IF cl_null(l_a25) THEN LET l_a25=0 END IF
      IF cl_null(l_b25) THEN LET l_b25=0 END IF
      IF cl_null(l_a26) THEN LET l_a26=0 END IF
      IF cl_null(l_b26) THEN LET l_b26=0 END IF
      IF cl_null(l_a27) THEN LET l_a27=0 END IF
      IF cl_null(l_b27) THEN LET l_b27=0 END IF
      IF cl_null(l_a28) THEN LET l_a28=0 END IF
      IF cl_null(l_b28) THEN LET l_b28=0 END IF
      IF cl_null(l_a29) THEN LET l_a29=0 END IF            #no:7393
      IF cl_null(l_b29) THEN LET l_b29=0 END IF            #no:7393
      IF cl_null(l_a211) THEN LET l_a211=0 END IF
      IF cl_null(l_b211) THEN LET l_b211=0 END IF
      IF cl_null(l_a221) THEN LET l_a221=0 END IF
      IF cl_null(l_b221) THEN LET l_b221=0 END IF
      IF cl_null(l_a231) THEN LET l_a231=0 END IF
      IF cl_null(l_b231) THEN LET l_b231=0 END IF
      IF cl_null(l_a241) THEN LET l_a241=0 END IF
      IF cl_null(l_b241) THEN LET l_b241=0 END IF
      IF cl_null(l_a251) THEN LET l_a251=0 END IF
      IF cl_null(l_b251) THEN LET l_b251=0 END IF
      IF cl_null(l_a261) THEN LET l_a261=0 END IF
      IF cl_null(l_b261) THEN LET l_b261=0 END IF
      IF cl_null(l_a271) THEN LET l_a271=0 END IF
      IF cl_null(l_b271) THEN LET l_b271=0 END IF
      IF cl_null(l_a281) THEN LET l_a281=0 END IF
      IF cl_null(l_b281) THEN LET l_b281=0 END IF
      IF cl_null(l_a291) THEN LET l_a291=0 END IF             #no:7393
      IF cl_null(l_b291) THEN LET l_b291=0 END IF             #no:7393
 
      LET l_sum1=l_a311+l_a321-l_a331-l_a341+l_a351+l_a361
      LET l_sum2=l_b311+l_b321-l_b331-l_b341+l_b351+l_b361
      LET l_sum3=l_a312+l_a322-l_a332-l_a342+l_a352+l_a362
      LET l_sum4=l_a313+l_a323-l_a333-l_a343+l_a353+l_a363
      LET l_sum5=l_a21+l_a22-l_a23-l_a24-l_a29+l_a25+l_a26+l_a27+l_a28  #no:7393
      LET l_sum6=l_b21+l_b22-l_b23-l_b24-l_b29+l_b25+l_b26+l_b27+l_b28  #no:7393
      LET l_sum7=l_a211+l_a221-l_a231-l_a241-l_a291+l_a251+l_a261+l_a271+l_a281  #no:7393
      LET l_sum8=l_b211+l_b221-l_b231-l_b241-l_b291+l_b251+l_b261+l_b271+l_b281  #no:7393
 
            EXECUTE insert_prep USING l_a311,l_b311,l_a312,l_a313,
                                      l_a321,l_b321,l_a322,l_a323,
                                      l_a331,l_b331,l_a332,l_a333,
                                      l_a341,l_b341,l_a342,l_a343,
                                      l_a351,l_b351,l_a352,l_a353,
                                      l_a361,l_b361,l_a362,l_a363,
                                      l_a21,l_b21,l_a22,l_b22,
                                      l_a23,l_b23,l_a24,l_b24,
                                      l_a25,l_b25,l_a26,l_b26,
                                      l_a27,l_b27,l_a28,l_b28,
                                      l_a29,l_b29,
                                      l_a211,l_b211,l_a221,l_b221,
                                      l_a231,l_b231,l_a241,l_b241,
                                      l_a251,l_b251,l_a261,l_b261,
                                      l_a271,l_b271,l_a281,l_b281,
                                      l_a291,l_b291,
                                      l_sum1,l_sum2,l_sum3,l_sum4,
                                      l_sum5,l_sum6,l_sum7,l_sum8,
                                      g_azi04,g_azi05,
                                      tm.amd173_b,tm.amd174_b,tm.amd174_e
#         OUTPUT TO REPORT g102_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT g102_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730013                   
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                 
 
###GENGRE###     LET l_str = g_ama02 CLIPPED,";",g_ama03 CLIPPED,";",
###GENGRE###                 g_ama05[1,30] CLIPPED,";",g_company CLIPPED,";",
###GENGRE###                 tm.amd173_b CLIPPED,";",
###GENGRE###                 tm.amd174_b CLIPPED,";",tm.amd174_e CLIPPED,";",
###GENGRE###                 g_inv_all CLIPPED
 
   # CALL cl_prt_cs3(g_prog,l_sql,l_str)   #TQC-730113
###GENGRE###     CALL cl_prt_cs3(g_prog,'amdg102',l_sql,l_str) 
    CALL amdg102_grdata()    ###GENGRE###
     #No.FUN-710082--end
END FUNCTION
 
#No.FUN-710082--begin
#REPORT g102_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1)
#      l_idx        LIKE type_file.num5,       #No.FUN-680074 SMALLINT
#      sr       RECORD
#               amd17  LIKE amd_file.amd17,   #扣抵區分
#               amd171 LIKE amd_file.amd171,  #格式
#               amd172 LIKE amd_file.amd172,  #課稅別
#               amd07  LIKE amd_file.amd07,   #扣抵金額
#               amd08  LIKE amd_file.amd08    #扣抵稅額
#               END RECORD,
#      l_a311,l_b311,l_a312,l_a313         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a321,l_b321,l_a322,l_a323         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a331,l_b331,l_a332,l_a333         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a341,l_b341,l_a342,l_a343         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a351,l_b351,l_a352,l_a353         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a361,l_b361,l_a362,l_a363         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a21,l_b21,l_a22,l_b22,l_a23       LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_b23,l_a24,l_b24,l_a25,l_b25       LIKE amd_file.amd07,       #No.FUN-680074 DECIMAL(20,6)
#      l_a26,l_b26,l_a27,l_b27             LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a28,l_b28                         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a29,l_b29                         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6) #no:7393 
#      l_a211,l_b211,l_a221,l_b221,l_a231  LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_b231,l_a241,l_b241,l_a251,l_b251  LIKE amd_file.amd07,       #No.FUN-680074 DECIMAL(20,6)
#      l_a261,l_b261,l_a271,l_b271         LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a281,l_b281                       LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_a291,l_b291                       LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6) #no:7393 
#      l_x                                 LIKE zaa_file.zaa08,       #No.FUN-680074 VARCHAR(32)
#      l_sum1,l_sum2,l_sum3                LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_sum4,l_sum5,l_sum6                LIKE amd_file.amd08,       #No.FUN-680074 DECIMAL(20,6)
#      l_sum7,l_sum8                       LIKE amd_file.amd08       #No.FUN-680074 DECIMAL(20,6)
#    # l_azi04       LIKE azi_file.azi04,  #NO.CHI-6A0004
#    # l_azi05       LIKE azi_file.azi05   #NO.CHI-6A0004
 
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN 5
#        PAGE LENGTH g_page_line
# FORMAT
#  PAGE HEADER
#     LET l_x=g_x[1] #'營業人媒體檔案申報表'
#     PRINT (g_len-FGL_WIDTH(l_x))/2 SPACES,l_x
#     PRINT ' '
##NO.CHI-6A0004--BEGIN
##      SELECT azi04, azi05 INTO l_azi04, l_azi05 FROM azi_file
##       WHERE azi01 = g_aza.aza17
##NO.CHI-6A00004--END
#     LET l_last_sw = 'n' #FUN-550114
 
#  ON LAST ROW
#     #-->銷項項目
#     LET l_a311=SUM(sr.amd08)  WHERE sr.amd171='31' AND sr.amd172='1'
#     LET l_b311=SUM(sr.amd07)  WHERE sr.amd171='31' AND sr.amd172='1'
#     LET l_a312=SUM(sr.amd08)  WHERE sr.amd171='31' AND sr.amd172='2'
#     LET l_a313=SUM(sr.amd08)  WHERE sr.amd171='31' AND sr.amd172='3'
#     LET l_a321=SUM(sr.amd08)  WHERE sr.amd171='32' AND sr.amd172='1'
#     LET l_b321=SUM(sr.amd07)  WHERE sr.amd171='32' AND sr.amd172='1'
#     LET l_a322=SUM(sr.amd08)  WHERE sr.amd171='32' AND sr.amd172='2'
#     LET l_a323=SUM(sr.amd08)  WHERE sr.amd171='32' AND sr.amd172='3'
#     LET l_a331=SUM(sr.amd08)  WHERE sr.amd171='33' AND sr.amd172='1'
#     LET l_b331=SUM(sr.amd07)  WHERE sr.amd171='33' AND sr.amd172='1'
#     LET l_a332=SUM(sr.amd08)  WHERE sr.amd171='33' AND sr.amd172='2'
#     LET l_a333=SUM(sr.amd08)  WHERE sr.amd171='33' AND sr.amd172='3'
#     LET l_a341=SUM(sr.amd08)  WHERE sr.amd171='34' AND sr.amd172='1'
#     LET l_b341=SUM(sr.amd07)  WHERE sr.amd171='34' AND sr.amd172='1'
#     LET l_a342=SUM(sr.amd08)  WHERE sr.amd171='34' AND sr.amd172='2'
#     LET l_a343=SUM(sr.amd08)  WHERE sr.amd171='34' AND sr.amd172='3'
#     LET l_a351=SUM(sr.amd08)  WHERE sr.amd171='35' AND sr.amd172='1'
#     LET l_b351=SUM(sr.amd07)  WHERE sr.amd171='35' AND sr.amd172='1'
#     LET l_a352=SUM(sr.amd08)  WHERE sr.amd171='35' AND sr.amd172='2'
#     LET l_a353=SUM(sr.amd08)  WHERE sr.amd171='35' AND sr.amd172='3'
#     LET l_a361=SUM(sr.amd08)  WHERE sr.amd171='36' AND sr.amd172='1'
#     LET l_b361=SUM(sr.amd07)  WHERE sr.amd171='36' AND sr.amd172='1'
#     LET l_a362=SUM(sr.amd08)  WHERE sr.amd171='36' AND sr.amd172='2'
#     LET l_a363=SUM(sr.amd08)  WHERE sr.amd171='36' AND sr.amd172='3'
#     #-->進項項目
#     #LET l_a21=SUM(sr.amd08) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[1]'
#     LET l_a21=SUM(sr.amd08) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'       #canny(9/14):要加
#     LET l_b21=SUM(sr.amd07) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_a22=SUM(sr.amd08) WHERE sr.amd171='22' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_b22=SUM(sr.amd07) WHERE sr.amd171='22' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_a23=SUM(sr.amd08) WHERE sr.amd171='23' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_b23=SUM(sr.amd07) WHERE sr.amd171='23' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_a24=SUM(sr.amd08) WHERE sr.amd171='24' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_b24=SUM(sr.amd07) WHERE sr.amd171='24' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_a25=SUM(sr.amd08) WHERE sr.amd171='25' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_b25=SUM(sr.amd07) WHERE sr.amd171='25' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_a26=SUM(sr.amd08) WHERE sr.amd171='26' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_b26=SUM(sr.amd07) WHERE sr.amd171='26' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#     LET l_a27=SUM(sr.amd08) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#  #sophia 020213
#     LET l_a28=SUM(sr.amd08) WHERE sr.amd171='28' AND sr.amd17 MATCHES '[1]'
#     LET l_b28=SUM(sr.amd07) WHERE sr.amd171='28' AND sr.amd17 MATCHES '[1]'
#  #sophia 020213
#  #no:7393
#     LET l_a29=SUM(sr.amd08) WHERE sr.amd171='29' AND sr.amd17 MATCHES '[1]'
#     LET l_b29=SUM(sr.amd07) WHERE sr.amd171='29' AND sr.amd17 MATCHES '[1]'
#  #--
#    #No.B588 010525 by plum mod
#    #LET l_b27=SUM(sr.amd07) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[2]'
#    #                          AND sr.amd172 = '1'
#     LET l_b27=SUM(sr.amd07) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[1]'
#			AND sr.amd172 = '1'
#    #No.B588..end
#     LET l_a211=SUM(sr.amd08) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_b211=SUM(sr.amd07) WHERE sr.amd171='21' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_a221=SUM(sr.amd08) WHERE sr.amd171='22' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_b221=SUM(sr.amd07) WHERE sr.amd171='22' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_a231=SUM(sr.amd08) WHERE sr.amd171='23' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_b231=SUM(sr.amd07) WHERE sr.amd171='23' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_a241=SUM(sr.amd08) WHERE sr.amd171='24' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_b241=SUM(sr.amd07) WHERE sr.amd171='24' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_a251=SUM(sr.amd08) WHERE sr.amd171='25' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_b251=SUM(sr.amd07) WHERE sr.amd171='25' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_a261=SUM(sr.amd08) WHERE sr.amd171='26' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_b261=SUM(sr.amd07) WHERE sr.amd171='26' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_a271=SUM(sr.amd08) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_b271=SUM(sr.amd07) WHERE sr.amd171='27' AND sr.amd17 MATCHES '[2]'
#			AND sr.amd172 = '1'
#     LET l_a281=SUM(sr.amd08) WHERE sr.amd171='28' AND sr.amd17 MATCHES '[2]'
#     LET l_b281=SUM(sr.amd07) WHERE sr.amd171='28' AND sr.amd17 MATCHES '[2]'
#     #--no:7393
#     LET l_a291=SUM(sr.amd08) WHERE sr.amd171='29' AND sr.amd17 MATCHES '[2]'
#     LET l_b291=SUM(sr.amd07) WHERE sr.amd171='29' AND sr.amd17 MATCHES '[2]'
#     #--
#     IF cl_null(l_a311) THEN LET l_a311=0 END IF
#     IF cl_null(l_b311) THEN LET l_b311=0 END IF
#     IF cl_null(l_a312) THEN LET l_a312=0 END IF
#     IF cl_null(l_a313) THEN LET l_a313=0 END IF
#     IF cl_null(l_a321) THEN LET l_a321=0 END IF
#     IF cl_null(l_b321) THEN LET l_b321=0 END IF
#     IF cl_null(l_a322) THEN LET l_a322=0 END IF
#     IF cl_null(l_a323) THEN LET l_a323=0 END IF
#     IF cl_null(l_a331) THEN LET l_a331=0 END IF
#     IF cl_null(l_b331) THEN LET l_b331=0 END IF
#     IF cl_null(l_a332) THEN LET l_a332=0 END IF
#     IF cl_null(l_a333) THEN LET l_a333=0 END IF
#     IF cl_null(l_a341) THEN LET l_a341=0 END IF
#     IF cl_null(l_b341) THEN LET l_b341=0 END IF
#     IF cl_null(l_a342) THEN LET l_a342=0 END IF
#     IF cl_null(l_a343) THEN LET l_a343=0 END IF
#     IF cl_null(l_a351) THEN LET l_a351=0 END IF
#     IF cl_null(l_b351) THEN LET l_b351=0 END IF
#     IF cl_null(l_a352) THEN LET l_a352=0 END IF
#     IF cl_null(l_a353) THEN LET l_a353=0 END IF
#     IF cl_null(l_a361) THEN LET l_a361=0 END IF
#     IF cl_null(l_b361) THEN LET l_b361=0 END IF
#     IF cl_null(l_a362) THEN LET l_a362=0 END IF
#     IF cl_null(l_a363) THEN LET l_a363=0 END IF
#     IF cl_null(l_a21) THEN LET l_a21=0 END IF
#     IF cl_null(l_b21) THEN LET l_b21=0 END IF
#     IF cl_null(l_a22) THEN LET l_a22=0 END IF
#     IF cl_null(l_b22) THEN LET l_b22=0 END IF
#     IF cl_null(l_a23) THEN LET l_a23=0 END IF
#     IF cl_null(l_b23) THEN LET l_b23=0 END IF
#     IF cl_null(l_a24) THEN LET l_a24=0 END IF
#     IF cl_null(l_b24) THEN LET l_b24=0 END IF
#     IF cl_null(l_a25) THEN LET l_a25=0 END IF
#     IF cl_null(l_b25) THEN LET l_b25=0 END IF
#     IF cl_null(l_a26) THEN LET l_a26=0 END IF
#     IF cl_null(l_b26) THEN LET l_b26=0 END IF
#     IF cl_null(l_a27) THEN LET l_a27=0 END IF
#     IF cl_null(l_b27) THEN LET l_b27=0 END IF
#     IF cl_null(l_a28) THEN LET l_a28=0 END IF
#     IF cl_null(l_b28) THEN LET l_b28=0 END IF
#     IF cl_null(l_a29) THEN LET l_a29=0 END IF            #no:7393
#     IF cl_null(l_b29) THEN LET l_b29=0 END IF            #no:7393
#     IF cl_null(l_a211) THEN LET l_a211=0 END IF
#     IF cl_null(l_b211) THEN LET l_b211=0 END IF
#     IF cl_null(l_a221) THEN LET l_a221=0 END IF
#     IF cl_null(l_b221) THEN LET l_b221=0 END IF
#     IF cl_null(l_a231) THEN LET l_a231=0 END IF
#     IF cl_null(l_b231) THEN LET l_b231=0 END IF
#     IF cl_null(l_a241) THEN LET l_a241=0 END IF
#     IF cl_null(l_b241) THEN LET l_b241=0 END IF
#     IF cl_null(l_a251) THEN LET l_a251=0 END IF
#     IF cl_null(l_b251) THEN LET l_b251=0 END IF
#     IF cl_null(l_a261) THEN LET l_a261=0 END IF
#     IF cl_null(l_b261) THEN LET l_b261=0 END IF
#     IF cl_null(l_a271) THEN LET l_a271=0 END IF
#     IF cl_null(l_b271) THEN LET l_b271=0 END IF
#     IF cl_null(l_a281) THEN LET l_a281=0 END IF
#     IF cl_null(l_b281) THEN LET l_b281=0 END IF
#     IF cl_null(l_a291) THEN LET l_a291=0 END IF             #no:7393
#     IF cl_null(l_b291) THEN LET l_b291=0 END IF             #no:7393
#     LET l_sum1=l_a311+l_a321-l_a331-l_a341+l_a351+l_a361
#     LET l_sum2=l_b311+l_b321-l_b331-l_b341+l_b351+l_b361
#     LET l_sum3=l_a312+l_a322-l_a332-l_a342+l_a352+l_a362
#     LET l_sum4=l_a313+l_a323-l_a333-l_a343+l_a353+l_a363
#     LET l_sum5=l_a21+l_a22-l_a23-l_a24-l_a29+l_a25+l_a26+l_a27+l_a28  #no:7393
#     LET l_sum6=l_b21+l_b22-l_b23-l_b24-l_b29+l_b25+l_b26+l_b27+l_b28  #no:7393
#     LET l_sum7=l_a211+l_a221-l_a231-l_a241-l_a291+l_a251+l_a261+l_a271+l_a281  #no:7393
#     LET l_sum8=l_b211+l_b221-l_b231-l_b241-l_b291+l_b251+l_b261+l_b271+l_b281  #no:7393
 
#     PRINT COLUMN  01,g_x[11],g_x[12],g_x[13] clipped
#     PRINT COLUMN  01,g_x[14] clipped,g_ama02,     #統一編號
##FUN-590359
#           COLUMN  36,g_x[15] clipped,g_ama03,     #稅籍編號
##           COLUMN  26,g_x[15] clipped,g_ama03,     #稅籍編號
##FUN-590359 End
#           COLUMN  74,g_x[15] clipped,             #所屬年月份
#		tm.amd173_b USING '###&','/',
#                       tm.amd174_b USING '#&',  '∼',
#                       #tm.amd173_e USING '###&','/',   #MOD-690155
#                       tm.amd173_b USING '###&','/',   #MOD-690155
#                       tm.amd174_e USING '#&',
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN  01,g_x[18] clipped,g_company CLIPPED,   #公司名稱
#           #COLUMN  74,g_x[19] clipped,g_x[20] clipped,  #使用發票分數   #MOD-690155
#          COLUMN  73,g_x[19] clipped,g_inv_all CLIPPED,g_x[20] clipped,  #使用發票分數   #MOD-690155
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN  01,g_x[21] clipped,g_ama05[1,30],            #營業地址：
#           COLUMN  74,g_x[22] clipped,                 #金 額 單 位 ：新台幣元
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN  01,g_x[23],g_x[24],g_x[25] clipped
#     PRINT COLUMN  01,g_x[26] clipped,                 #銷項項目
#           COLUMN  31,g_x[27] clipped,                 #應收銷售額
#           COLUMN  51,g_x[28] clipped,                 #應稅稅額
#           COLUMN  71,g_x[29] clipped,                 #零稅率銷售額
#           COLUMN  91,g_x[30] clipped,                 #免稅銷售額
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN  01,g_x[31],g_x[32],g_x[33] clipped
#     PRINT COLUMN 01, g_x[34] clipped,            #31. 三聯式  電子計算機發票
#           COLUMN 31,cl_numfor(l_a311,18,g_azi04),#NO.CHI-6A0004
#           COLUMN 51,cl_numfor(l_b311,18,g_azi04),#NO.CHI-6A0004
#           COLUMN 71,cl_numfor(l_a312,18,g_azi04),#NO.CHI-6A0004
#           COLUMN 91,cl_numfor(l_a313,18,g_azi04),#NO.CHI-6A0004
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[35] clipped,             #32. 二聯式  電子計算機發票
#           COLUMN 31,cl_numfor(l_a321,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 51,cl_numfor(l_b321,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 71,cl_numfor(l_a322,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 91,cl_numfor(l_a323,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[36] clipped,             #33. (減)三聯式銷退  折讓
#           COLUMN 31,cl_numfor(l_a331,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 51,cl_numfor(l_b331,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 71,cl_numfor(l_a332,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 91,cl_numfor(l_a333,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[37] clipped,             #34. (減)二聯式銷退  折讓
#           COLUMN 31,cl_numfor(l_a341,18,g_azi04),  #NO.CHI-6A0004
#           COLUMN 51,cl_numfor(l_b341,18,g_azi04),  #NO.CHI-6A0004
#           COLUMN 71,cl_numfor(l_a342,18,g_azi04),  #NO.CHI-6A0004
#           COLUMN 91,cl_numfor(l_a343,18,g_azi04) , #NO.CHI-6A0004
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[38] clipped,              #35. 三聯式收銀機發票
#           COLUMN 31,cl_numfor(l_a351,18,g_azi04), #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b351,18,g_azi04), #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a352,18,g_azi04), #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_a353,18,g_azi04), #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[39] clipped,              #36. 免用發票
#           COLUMN 31,cl_numfor(l_a361,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 51,cl_numfor(l_b361,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 71,cl_numfor(l_a362,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 91,cl_numfor(l_a363,18,g_azi04), #NO.CHI-6A0004
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[40] clipped,               #合      計
#           COLUMN 31,cl_numfor(l_sum1,18,g_azi05),  #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_sum2,18,g_azi05),  #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_sum3,18,g_azi05),  #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_sum4,18,g_azi05),  #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[31],g_x[32],g_x[33] clipped
#     PRINT COLUMN 01,g_x[41] clipped,               #進項項目
#           COLUMN 40,g_x[42] clipped,               #得扣抵金額
#           COLUMN 60,g_x[43] clipped,               #得扣抵稅額
#           COLUMN 76,g_x[44] clipped,               #可扣抵固定資產
#           COLUMN 96,g_x[45] clipped,               #可扣抵資產稅額
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[31],g_x[32],g_x[33] clipped
#     PRINT COLUMN 01,g_x[46] clipped,              #21. 三聯式  電子計算機發票
#           COLUMN 31,cl_numfor(l_a21,18,g_azi04),   #NO.CHI-6A0004
#           COLUMN 51,cl_numfor(l_b21,18,g_azi04),   #NO.CHI-6A0004
#           COLUMN 71,cl_numfor(l_a211,18,g_azi04),  #NO.CHI-6A0004
#           COLUMN 91,cl_numfor(l_b211,18,g_azi04),  #NO.CHI-6A0004
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[47] clipped,               #22. 載有稅額之其他憑證
#           COLUMN 31,cl_numfor(l_a22,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b22,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a221,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_b221,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[48] clipped,	             #28. 海關代徵營業稅繳納扣抵
#           COLUMN 31,cl_numfor(l_a28,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b28,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a281,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_b281,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[49] clipped,                #23. (減)三聯式退貨  折讓
#           COLUMN 31,cl_numfor(l_a23,18,g_azi04),    #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b23,18,g_azi04),    #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a231,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_b231,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[50] clipped,                #24. (減)二聯式退貨  折讓
#           COLUMN 31,cl_numfor(l_a24,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b24,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a241,18,g_azi04), #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_b241,18,g_azi04), #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[51] clipped,              #29. (減)海關退還溢繳營業稅
#           COLUMN 31,cl_numfor(l_a29,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b29,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a291,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_b291,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[52] clipped,              #25. 三聯式收銀機發票
#           COLUMN 31,cl_numfor(l_a25,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b25,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a251,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_b251,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[53] clipped,             #26. 伍佰元以下之三聯式發票
#           COLUMN 31,cl_numfor(l_a26,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b26,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a261,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_b261,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[54] clipped,              #27. 伍佰元以下之其他憑證
#           COLUMN 31,cl_numfor(l_a27,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_b27,18,g_azi04),   #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_a271,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_b271,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN 01,g_x[55] clipped,              #合計
#           COLUMN 31,cl_numfor(l_sum5,18,g_azi05),  #NO.CHI-6A0004    
#           COLUMN 51,cl_numfor(l_sum6,18,g_azi05),  #NO.CHI-6A0004    
#           COLUMN 71,cl_numfor(l_sum7,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 91,cl_numfor(l_sum8,18,g_azi04),  #NO.CHI-6A0004    
#           COLUMN 113,g_x[17] clipped
#     PRINT COLUMN  01,g_x[56],g_x[57],g_x[58] clipped
### FUN-550114
#     LET l_last_sw = 'y'
 
#PAGE TRAILER
#     PRINT ''
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[59]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[59]
#            PRINT g_memo
#     END IF
## END FUN-550114
#END REPORT
#No.FUN-710082--end  
 
#-----MOD-690155---------
FUNCTION g102_sum()
 #SELECT count(*) INTO g_inv_all FROM amd_file                               #MOD-A70218 mark
 #  WHERE (amd173*12+amd174) BETWEEN                                         #MOD-A70218 mark
 #        (tm.amd173_b*12+tm.amd174_b) AND (tm.amd173_b*12+tm.amd174_e)      #MOD-A70218 mark
 #        AND amd22 = tm.ama01                                               #MOD-A70218 mark
 #-MOD-A70218-add-
  SELECT count(*) INTO g_inv_all FROM amd_file
   WHERE amd173 = tm.amd173_b
     AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
     AND amd22 = tm.ama01 AND amd171 MATCHES '3*'
     AND amd171<>'36'     #不含虛擬發票
     AND amd171<>'33'  
     AND amd171<>'34'
     AND amd172<>'F'  
     AND amd30='Y'     
 #-MOD-A70218-end-
  IF cl_null(g_inv_all) THEN LET g_inv_all = 0 END IF
END FUNCTION
#-----END MOD-690155-----
#Patch....NO.TQC-610035 <001> #

###GENGRE###START
FUNCTION amdg102_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("amdg102")
        IF handler IS NOT NULL THEN
            START REPORT amdg102_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE amdg102_datacur1 CURSOR FROM l_sql
            FOREACH amdg102_datacur1 INTO sr1.*
                OUTPUT TO REPORT amdg102_rep(sr1.*)
            END FOREACH
            FINISH REPORT amdg102_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amdg102_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_p1     LIKE ama_file.ama02
    DEFINE l_p2     LIKE ama_file.ama03
    DEFINE l_p3     LIKE ama_file.ama05
    DEFINE l_p8      STRING 
    DEFINE l_option LIKE type_file.num5
    DEFINE l_option1 STRING
    DEFINE l_option2 STRING
    DEFINE l_amd174e STRING
    DEFINE l_option3 STRING
    DEFINE l_amd174b STRING
    DEFINE l_unit    STRING

    #FUN-B40092------add------end
    DEFINE l_fmt     STRING           #MOD-BC0008 add

    
#    ORDER EXTERNAL BY sr1.amd173b                          #FUN-B40092 mod
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_ama02, g_ama03, g_ama05
            PRINTX g_inv_all

              
#        BEFORE GROUP OF sr1.amd173b                        #FUN-B40092 mod
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_fmt = cl_gr_numfmt("amd_file","amd08",sr1.azi04)                #MOD-BC0008 add
            PRINTX l_fmt                                                          #MOD-BC0008 add        
            #FUN-B40092------add------str
            LET l_unit = cl_gr_getmsg("gre-080",g_lang,'0')
            PRINTX l_unit 

            LET l_option2 = sr1.amd174e USING '--,---,---,---,---,--&'
            LET l_amd174e = '/',l_option2
            PRINTX l_amd174e

            LET l_option3 = sr1.amd174b USING '--,---,---,---,---,--&'
            LET l_amd174b = '/',l_option3 
            PRINTX l_amd174b

            SELECT ama02,ama03,ama05 INTO l_p1,l_p2,l_p3
            FROM ama_file WHERE ama01 = tm.ama01 AND amaacti = 'Y' 
            PRINTX l_p1
            PRINTX l_p2
            PRINTX l_p3

#           SELECT count(*) INTO l_option FROM amd_file
#           WHERE amd173 = tm.amd173_b
#           AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
#           AND amd22 = tm.ama01 AND amd171 MATCHES '3*'
#           AND amd171!='36'     
#           AND amd171!='33'
#           AND amd171!='34'
#           AND amd172!='F'
#           AND amd30='Y'
            LET l_option1 = cl_gr_getmsg("gre-079",g_lang,'0')
            LET l_p8 = g_inv_all,l_option1
            PRINTX l_p8

            
            #FUN-B40092------add------end 
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

#        AFTER GROUP OF sr1.amd173b                          #FUN-B40092 mod

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-B80050
