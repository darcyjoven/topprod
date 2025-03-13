# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: gglq301.4gl
# Descriptions...: 明細分類帳
# Input parameter:
# Return code....:
# Date & Author..: No:FUN-850030 08/05/14 By Carrier 報表查詢化 copy from gglr301
# Modify.........: No:FUN-8A0028 08/10/07 By Carrier 報錯信息位置化
# Modify.........: No:MOD-8B0167 08/11/17 By chenyu 原幣和本幣位置顛倒
# Modify.........: No:MOD-8C0126 08/12/15 By wujie   異動期間借貸扺消的應該被抓出來
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:MOD-920084 09/02/05 By chenl   調整勾選打印外幣時，原幣打印不出的問題。
# Modify.........: No:MOD-920129 09/02/10 By chenl   調整臨時表字段大小。
# Modify.........: No:MOD-920187 09/02/16 By chenl    調整期初金額取值問題。
# Modify.........: No:TQC-970049 09/04/08 By xiaofeizhu 新增按幣別分頁選項
# Modify.........: No:MOD-940388 09/04/29 By wujie 字串連接%前要加轉義符\
# Modify.........: No:FUN-A30009 10/03/18 By Carrier 功能重整
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
#                                                  点击单据联查按钮后，光标保持在原来所在的行，而不是回到第一行
# Modify.........: No.FUN-A40020 10/04/09 By Carrier 独立科目层及设置为1
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.FUN-B20055 11/02/22 By destiny 輸入改為DIALOG寫法 
# Modify.........: No.MOD-B30577 11/03/16 By wujie   本年没有凭证资料的外币数据无法查出
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-C50025 12/05/07 By yinhy 勾選打印外幣時，原幣餘額欄位為空
# Modify.........: No:FUN-C70061 12/07/13 By xuxz 增加tm.a "分頁顯示"當tm.a = N時,顯示畫面檔單身增加科目編碼
# Modify.........: No:TQC-C90015 12/09/04 By lujh 輸入qbe後點擊【退出】應只退出查詢界面，不應將整個作業都退出
# Modify.........: No.FUN-C80102 12/09/12 By chenying 報表改善
# Modify.........: No:MOD-CB0063 12/11/09 By yinhy 傳票明細查詢時若aba06='RV'應開啟aglt120，aba06='AC'應開啟aglt130
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢
# Modify.........: No.TQC-CC0122 12/12/26 By chenying gglq300串查時加年度yy,解决gglq300串查期初结存不对的问题
# Modify.........: No.FUN-CB0146 12/12/20 By zhangweib 程序執行效率優化
# Modify.........: No.FUN-C80102 13/01/09 By chenying 單據狀態選擇全部沒有包含未審核憑證，抓aag的sql有問題
# Modify.........: No.FUN-D10072 13/01/15 By yangtt excel匯出單身沒有資料
# Modify.........: No.FUN-D10072 13/01/18 By chenying 餘額中匯率與原幣顯示不正確
# Modify.........:               13/01/23 By chenying gglq301 單據狀態調整
# Modify.........: No.MOD-D20095 13/02/19 By yinhy 開窗修改
# Modify.........: No.MOD-D20151 13/02/25 By yinhy 過濾掉aag38為Y的資料
# Modify.........: No.TQC-D20065 13/02/28 By chenying 匯率顯示錯誤
# Modify.........: No.MOD-D60128 13/06/17 By fengmy 加入優化后漏掉的FUN-C80102內容
# Modify.........: No.TQC-D60067 13/06/24 By yangtt 清空畫面檔資料
# Modify.........: No.MOD-D70035 13/07/05 By fengmy 余额计算修正
# Modify.........: No.TQC-DC0064 13/12/19 By wangrr 當'單據狀態'為'2:已過帳'時'含未審核憑證'不顯示
# Modify.........: No.MOD-E20099 14/02/21 By fengmy 加入原幣金額

DATABASE ds

GLOBALS "../../config/top.global"  #No.FUN-850030  #No.FUN-A30009

DEFINE tm               RECORD                        
                        wc1     STRING,                  
                        wc2     STRING,     #FUN-C80102             
                        bookno  LIKE aaa_file.aaa01,
                        bdate   LIKE type_file.dat,
                        edate   LIKE type_file.dat,
                        t       LIKE type_file.chr1,  #期初為零且當期無異動科目打印
                        x       LIKE type_file.chr1,  #打印獨立科目
                        n       LIKE type_file.chr1,  #打印外幣否
                        curr    LIKE azi_file.azi01,  #打印幣種
                        d1      LIKE type_file.chr1,  #按幣種分頁
                        e       LIKE type_file.chr1,  #打印額外名稱
                        h       LIKE type_file.chr1,  #僅貨幣性科目
                        lvl     LIKE type_file.num5,  #打印科目的層級<=
                        a       LIKE type_file.chr1,  #分页显示   #NO.FUN-C70061 add
                        k       LIKE type_file.chr1,  #資料選項
                        b       LIKE type_file.chr1,  #資料選項   #FUN-D10072 130123
                        more    LIKE type_file.chr1
                        END RECORD
DEFINE yy,y1,mm         LIKE type_file.num10   #FUN-C80102 add y1
DEFINE mm1,nn1          LIKE type_file.num10
DEFINE l_flag           LIKE type_file.chr1
DEFINE g_cnnt           LIKE type_file.num5
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_i              LIKE type_file.num5
DEFINE l_table          STRING
DEFINE g_str            STRING
DEFINE g_sql            STRING
DEFINE g_rec_b          LIKE type_file.num10

DEFINE g_aea05          LIKE aea_file.aea05
DEFINE g_aag02          LIKE aag_file.aag02
DEFINE g_aba04          LIKE aba_file.aba04
DEFINE g_abb24          LIKE abb_file.abb24 #TQC-970049 
DEFINE g_abb            DYNAMIC ARRAY OF RECORD       #最后query結果array
                       #aea05_1    LIKE aea_file.aea05,   #FUN-C80102
                       #aag02_1    LIKE aag_file.aag02,   #FUN-C80102
                        aea05      LIKE aea_file.aea05,   #FUN-C80102
                        aag02      LIKE aag_file.aag02,   #FUN-C80102
                        aea02      LIKE aea_file.aea02,
                        aea03      LIKE aea_file.aea03,
                        # aba11      LIKE aba_file.aba11, #zhouxm150428 add
                        abb04      LIKE abb_file.abb04,
                        abb24      LIKE abb_file.abb24,
                        df         LIKE abb_file.abb07,
                        abb25_d    LIKE abb_file.abb25,
                        d          LIKE abb_file.abb07,
                        cf         LIKE abb_file.abb07,
                        abb25_c    LIKE abb_file.abb25,
                        c          LIKE abb_file.abb07,
                        dc         LIKE type_file.chr10,
                        balf       LIKE abb_file.abb07,
                        abb25_bal  LIKE abb_file.abb25,
                        bal        LIKE abb_file.abb07
                        END RECORD
#No.FUN-CB0146 ---start--- Add
DEFINE g_abbv           DYNAMIC ARRAY OF RECORD       #最后query結果array
                        aea05      LIKE aea_file.aea05,
                        aag02      LIKE aag_file.aag02,
                        aea02      LIKE aea_file.aea02,
                        aea03      LIKE aea_file.aea03,
                        aba11      LIKE aba_file.aba11, #zhouxm150428 add 
                        abb04      LIKE abb_file.abb04,
                        abb24      LIKE abb_file.abb24,
                        df         LIKE abb_file.abb07,
                        abb25_d    LIKE abb_file.abb25,
                        d          LIKE abb_file.abb07,
                        cf         LIKE abb_file.abb07,
                        abb25_c    LIKE abb_file.abb25,
                        c          LIKE abb_file.abb07,
                        dc         LIKE type_file.chr10,
                        balf       LIKE abb_file.abb07,
                        abb25_bal  LIKE abb_file.abb25,
                        bal        LIKE abb_file.abb07
                        END RECORD
#No.FUN-CB0146 ---end  --- Add
DEFINE g_pr             RECORD                        #用于報表輸出的變量
                        aea05      LIKE aea_file.aea05,
                        aag02      LIKE type_file.chr1000,
                        aba04      LIKE aba_file.aba04,
                        type       LIKE type_file.chr1,
                        aea02      LIKE aea_file.aea02,
                        aea03      LIKE aea_file.aea03,
                        aba11      LIKE aba_file.aba11,  #zhouxm150428 add  
                        aea04      LIKE aea_file.aea04,
                        abb04      LIKE abb_file.abb04,
                        abb24      LIKE abb_file.abb24,
                        abb06      LIKE abb_file.abb06,
                        abb07      LIKE abb_file.abb07,
                        abb07f     LIKE abb_file.abb07f,
                        d          LIKE abb_file.abb07,
                        df         LIKE abb_file.abb07,
                        abb25_d    LIKE abb_file.abb25,
                        c          LIKE abb_file.abb07,
                        cf         LIKE abb_file.abb07,
                        abb25_c    LIKE abb_file.abb25,
                        dc         LIKE type_file.chr10,
                        bal        LIKE abb_file.abb07,
                        balf       LIKE abb_file.abb07,
                        abb25_bal  LIKE abb_file.abb25,
                        pagenum    LIKE type_file.num5,
                        azi04      LIKE azi_file.azi04,
                        azi05      LIKE azi_file.azi05,
                        azi07      LIKE azi_file.azi07
                        END RECORD
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_row_count      LIKE type_file.num10
DEFINE g_curs_index     LIKE type_file.num10
DEFINE g_jump           LIKE type_file.num10
DEFINE mi_no_ask        LIKE type_file.num5
DEFINE l_ac             LIKE type_file.num5

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET tm.bookno  = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)            
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.wc1     = ARG_VAL(8)
   LET tm.wc1   = cl_replace_str(tm.wc1, "\\\"", "'") #FUN-C80102 add '
   LET tm.bdate   = ARG_VAL(9) 
   LET tm.edate   = ARG_VAL(10)
   LET tm.t       = ARG_VAL(11)
   LET tm.x       = ARG_VAL(12)
   LET tm.n       = ARG_VAL(13)
   LET tm.curr    = ARG_VAL(14)
   LET tm.d1      = ARG_VAL(15)
   LET tm.e       = ARG_VAL(16)
   LET tm.h       = ARG_VAL(17)
   LET tm.lvl     = ARG_VAL(18)
   LET tm.k       = ARG_VAL(19)
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)
   LET tm.a       = ARG_VAL(24) #FUN-C70061
   LET yy         = ARG_VAL(25) #TQC-CC0122 
   LET tm.b       = ARG_VAL(26) #FUN-D10072 130123
   #TQC-CC0122--add--str--
   IF g_bgjob = 'Y' THEN
      LET yy = YEAR(tm.bdate)
      LET mm = MONTH(tm.bdate)
   END IF
   #TQC-CC0122--add--end--

   CALL q301_out_1()
   IF tm.bookno IS NULL OR tm.bookno = ' ' THEN
      LET tm.bookno = g_aza.aza81
   END IF

   OPEN WINDOW q301_w AT 5,10
        WITH FORM "ggl/42f/gglq301" ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()


   IF cl_null(g_bgjob) OR g_bgjob = 'N'            
      THEN CALL gglq301_tm()                    
      ELSE 
           LET tm.wc2 = " 1=1" #FUN-C80102 
          #CALL gglq301()      #FUN-D10072 mark            
           CALL gglq301v()     #No.FUN-CB0146 Add
           CALL gglq301_t()
   END IF

   CALL q301_menu()
   DROP TABLE gglq301_tmp;
   CLOSE WINDOW q301_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
#darcy:2022/10/26 add s---

function q301_crt_temp()
   define sqlx string

   call q301_drop_temp()
   let sqlx ="
   create table q301_fastexcel(
      aea05      number(10),
      aag02      varchar2(255),
      aea02      date,
      aea03      varchar2(20),
      aba11      number(10),
      abb04      varchar2(80),
      abb24      varchar2(4),
      df         number(20,6),
      abb25_d    number(20,10),
      d          number(20,6),
      cf         number(20,6),
      abb25_c    number(20,10),
      c          number(20,6),
      dc         varchar2(10),
      balf       number(20,6),
      abb25_bal  number(20,10),
      bal        number(30,6)
   )"
   prepare crt_q301_fastexcel from sqlx
   execute crt_q301_fastexcel

   let sqlx = "insert into q301_fastexcel values(
      ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?
   )"
   prepare crt_q301_into from sqlx

end function
#darcy:2022/10/26 add e---
FUNCTION q301_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000

   WHILE TRUE
      CALL q301_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq301_tm()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q301_out_2()
            END IF
         WHEN "drill_down"
            IF cl_chk_act_auth() THEN
               CALL q301_drill_down()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_abbv),'','')  #FUN-D10072 mod g_abb->g_abbv
            END IF
         #darcy:2022/10/26 add s---
         WHEN "fastexcel"
            if cl_chk_act_auth() then
               call q301_fastexcel()
            end if
         #darcy:2022/10/26 add e---
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_aea05 IS NOT NULL THEN
                  LET g_doc.column1 = "aea05"
                  LET g_doc.value1 = g_aea05
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION gglq301_tm()
   DEFINE p_row,p_col      LIKE type_file.num5,
          l_i              LIKE type_file.num5,
          l_cmd            LIKE type_file.chr1000
   DEFINE li_chk_bookno    LIKE type_file.num5   #FUN-B20010
   DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #FUN-B20010 

   CALL s_dsmark(tm.bookno)
   CLEAR FORM #清除畫面 #FUN-C80102
   CALL g_abb.clear()  #FUN-C80102
   CALL g_abbv.clear()  #TQC-D60067
   call q301_crt_temp() #darcy:2022/10/26 add
#FUN-C80102--mark--str--
#  LET p_row = 4 LET p_col = 12
#  OPEN WINDOW gglq301_w1 AT p_row,p_col
#       WITH FORM "ggl/42f/gglq301_1"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)

#  CALL cl_ui_locale("gglq301_1")
#FUN-C80102--mark--end--

   CALL s_shwact(0,0,tm.bookno)
   CALL cl_opmsg('p')

   SELECT azn02 INTO y1 FROM azn_file WHERE azn01 = g_today   #FUN-C80102
   INITIALIZE tm.* TO NULL                 
   LET yy = y1      #FUN-C80102 
   LET tm.bookno  = g_aza.aza81
   LET tm.bdate   = g_today
   LET tm.edate   = g_today
  #LET tm.t    = 'N'  #FUN-C80102
  #LET tm.x    = 'N'  #FUN-C80102 
   LET tm.t    = 'Y'  #FUN-C80102
   LET tm.x    = 'Y'  #FUN-C80102
   LET tm.n    = 'N' 
   LET tm.curr = NULL
   LET tm.d1   = 'N'
   LET tm.e    = 'N'
   LET tm.h    = 'Y'
   LET tm.lvl  = NULL
   LET tm.k    = '1'
   LET tm.b    = 'N'  #FUN-D10072 130123
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   LET tm.a = 'N'      #NO.FUN-C70061 add
   WHILE TRUE
      #No.FUN-B20010  --Begin
      DISPLAY BY NAME tm.bookno
      #FUN-B20055--begin
#      INPUT BY NAME tm.bookno
#            WITHOUT DEFAULTS
#
#         BEFORE INPUT
#            CALL q301_set_entry()
#            CALL q301_set_no_entry()
#
#         AFTER FIELD bookno
#            IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
#            CALL s_check_bookno(tm.bookno,g_user,g_plant)
#                 RETURNING li_chk_bookno
#            IF (NOT li_chk_bookno) THEN
#               NEXT FIELD bookno
#            END IF
#            SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
#            IF SQLCA.sqlcode THEN
#               CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
#               NEXT FIELD bookno
#            END IF 
#         ON ACTION CONTROLZ
#            CALL cl_show_req_fields()
#
#         ON ACTION CONTROLG CALL cl_cmdask()
#
#         ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(bookno)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_aaa'
#                  LET g_qryparam.default1 =tm.bookno
#                  CALL cl_create_qry() RETURNING tm.bookno
#                  DISPLAY BY NAME tm.bookno
#                  NEXT FIELD bookno
#            END CASE
#
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#
#         ON ACTION about
#            CALL cl_about()
#
#         ON ACTION help
#            CALL cl_show_help()
#
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
#      END INPUT
#      #No.FUN-B20010  --End 
#      CONSTRUCT BY NAME tm.wc1 ON aag01
#
#         ON ACTION CONTROLP
#            CASE
#                WHEN INFIELD(aag01)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state= "c"
#                  LET g_qryparam.form = "q_aag"
#                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"   #FUN-B20010 add
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO aag01
#                  NEXT FIELD aag01
#               OTHERWISE
#                  EXIT CASE
#            END CASE
#
#         ON ACTION locale
#            CALL cl_show_fld_cont()
#            LET g_action_choice = "locale"
#            EXIT CONSTRUCT
#
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
#
#         ON ACTION about
#            CALL cl_about()
#
#         ON ACTION help
#            CALL cl_show_help()
#
#         ON ACTION controlg
#            CALL cl_cmdask()
#
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
#      END CONSTRUCT
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
#
#      IF INT_FLAG THEN
##No.FUN-A40009 --begin
##        LET INT_FLAG = 0 CLOSE WINDOW gglq301_w1 EXIT PROGRAM
##     END IF
#      ELSE
##No.FUN-A40009 --end
#
#      #DISPLAY BY NAME tm.bookno,tm.bdate,tm.edate,tm.t,tm.x,           #No.FUN-B20010 mark
#      DISPLAY BY NAME tm.bdate,tm.edate,tm.t,tm.x,                      #No.FUN-B20010
#                      tm.n,tm.curr,tm.d,tm.e,tm.h,tm.lvl,tm.k,tm.more
#      #INPUT BY NAME tm.bookno,tm.bdate,tm.edate,tm.t,tm.x,             #No.FUN-B20010 mark
#      INPUT BY NAME tm.bdate,tm.edate,tm.t,tm.x,                        #No.FUN-B20010 mark
#                    tm.n,tm.curr,tm.d,tm.e,tm.h,tm.lvl,tm.k,tm.more
#            WITHOUT DEFAULTS
#
#         BEFORE INPUT
#            CALL q301_set_entry()
#            CALL q301_set_no_entry()
#        #No.FUN-B20010  --Begin
#        # AFTER FIELD bookno
#        #    IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
#        #    CALL s_check_bookno(tm.bookno,g_user,g_plant)
#        #         RETURNING li_chk_bookno
#        #    IF (NOT li_chk_bookno) THEN
#        #       NEXT FIELD bookno
#        #    END IF
#        #    SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
#        #    IF SQLCA.sqlcode THEN
#        #       CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
#        #       NEXT FIELD bookno
#        #    END IF
#        #No.FUN-B20010  --End
#
#         AFTER FIELD bdate
#            IF cl_null(tm.bdate) THEN
#               NEXT FIELD bdate
#            END IF
#
#         AFTER FIELD edate
#            IF cl_null(tm.edate) THEN
#               LET tm.edate =g_lastdat
#            ELSE
#               IF YEAR(tm.bdate) <> YEAR(tm.edate) THEN NEXT FIELD edate END IF
#            END IF
#            IF tm.edate < tm.bdate THEN
#               CALL cl_err(' ','agl-031',0)
#               NEXT FIELD edate
#            END IF
#
#         AFTER FIELD t
#            IF tm.t NOT MATCHES "[YN]" THEN NEXT FIELD t END IF
#
#         AFTER FIELD x
#            IF tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF
#
#         BEFORE FIELD n
#            CALL q301_set_entry()
#
#         AFTER FIELD n
#            IF cl_null(tm.n) OR tm.n NOT MATCHES'[YN]' THEN NEXT FIELD n END IF
#            CALL q301_set_no_entry()
#
#         AFTER FIELD curr
#            IF NOT cl_null(tm.curr) THEN
#               SELECT * FROM azi_file WHERE azi01=tm.curr
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err3('sel','azi_file',tm.curr,'',SQLCA.sqlcode,'','','0')
#                  NEXT FIELD curr
#               END IF
#            END IF
#
#         AFTER FIELD d
#            IF cl_null(tm.d) OR tm.d NOT MATCHES'[YN]' THEN NEXT FIELD d END IF
#
#         AFTER FIELD e
#            IF cl_null(tm.e) OR tm.e NOT MATCHES'[YN]' THEN NEXT FIELD e END IF
#
#         AFTER FIELD h
#            IF cl_null(tm.h) OR tm.h NOT MATCHES'[YN]' THEN NEXT FIELD h END IF
#
#         AFTER FIELD lvl
#            IF tm.lvl <= 0 THEN NEXT FIELD lvl END IF
#
#         AFTER FIELD k
#            IF cl_null(tm.k) OR tm.k NOT MATCHES '[123]'
#            THEN NEXT FIELD k END IF
#
#         AFTER FIELD more
#            IF tm.more = 'Y'
#               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                         g_bgjob,g_time,g_prtway,g_copies)
#               RETURNING g_pdate,g_towhom,g_rlang,
#                         g_bgjob,g_time,g_prtway,g_copies
#            END IF
#
#         ON ACTION CONTROLZ
#            CALL cl_show_req_fields()
#
#         ON ACTION CONTROLG CALL cl_cmdask()      
#
#         ON ACTION CONTROLP
#            CASE
#             # WHEN INFIELD(tm.bookno)         #No.FUN-A40020                   
#             #No.FUN-B20010  --Begin
#             #  WHEN INFIELD(bookno)            #No.FUN-A40020 
#             #     CALL cl_init_qry_var()
#             #     LET g_qryparam.form = 'q_aaa'
#             #     LET g_qryparam.default1 =tm.bookno
#             #     CALL cl_create_qry() RETURNING tm.bookno
#             #     DISPLAY BY NAME tm.bookno
#             #     NEXT FIELD bookno
#             #No.FUN-B20010  --End
#             # WHEN INFIELD(tm.curr)           #No.FUN-A40020                   
#               WHEN INFIELD(curr)              #No.FUN-A40020
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_azi'
#                  LET g_qryparam.default1 =tm.curr
#                  CALL cl_create_qry() RETURNING tm.curr
#                  DISPLAY BY NAME tm.curr
#                  NEXT FIELD curr
#            END CASE
#
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#
#         ON ACTION about
#            CALL cl_about()
#
#         ON ACTION help
#            CALL cl_show_help()
#
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
#      END INPUT
      CALL cl_set_comp_visible("abb24",TRUE)  #FUN-C80102
      
      DISPLAY BY NAME tm.bdate,tm.edate,    #FUN-C80102 del t,x                  
                      tm.n,tm.d1,tm.e,tm.h,tm.lvl,tm.a,tm.k,tm.b,  #No:FUN-C70061 add tm.a  #FUN-C80102 del tm.more,curr #FUN-D10072 add tm.b 130123
                      yy  #FUN-C80102

      DIALOG ATTRIBUTES(UNBUFFERED)  
 
      INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            CALL q301_set_entry()
            CALL q301_set_no_entry()

         AFTER FIELD bookno
            IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
            CALL s_check_bookno(tm.bookno,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD bookno
            END IF
            SELECT * FROM aaa_file WHERE aaa01 = tm.bookno
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aaa_file",tm.bookno,"","aap-229","","",0)
               NEXT FIELD bookno
            END IF 
       END INPUT      
         
#FUN-C80102--mark--str--
#      CONSTRUCT BY NAME tm.wc1 ON aag01
       
#      END CONSTRUCT 
#FUN-C80102--mark--str--
       
 
       INPUT BY NAME yy,tm.bdate,tm.edate,tm.a,tm.d1,tm.e,tm.n,tm.h,tm.lvl,   #FUN-C80102 add yy del t,k,curr
                     tm.k,tm.b #FUN-D10072 add tm.b 130123  
                   ATTRIBUTE(WITHOUT DEFAULTS=TRUE)#FUN-C70061 add tm.a  #FUN-C80102 del tm.more

         BEFORE INPUT
            CALL q301_set_entry()
            CALL q301_set_no_entry()

         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
               NEXT FIELD bdate
            END IF

         AFTER FIELD edate
            IF cl_null(tm.edate) THEN
               LET tm.edate =g_lastdat
            ELSE
               IF YEAR(tm.bdate) <> YEAR(tm.edate) THEN NEXT FIELD edate END IF
            END IF
            IF tm.edate < tm.bdate THEN
               CALL cl_err(' ','agl-031',0)
               NEXT FIELD edate
            END IF
#FUN-C80102--mark---str--
#        AFTER FIELD t
#           IF tm.t NOT MATCHES "[YN]" THEN NEXT FIELD t END IF

#        AFTER FIELD x
#           IF tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF
#FUN-C80102---mark---end--
         BEFORE FIELD n
            CALL q301_set_entry()

         AFTER FIELD n
            IF cl_null(tm.n) OR tm.n NOT MATCHES'[YN]' THEN NEXT FIELD n END IF
            CALL q301_set_no_entry()
#FUN-C80102--mark--str--
#        AFTER FIELD curr
#           IF NOT cl_null(tm.curr) THEN
#              SELECT * FROM azi_file WHERE azi01=tm.curr
#              IF SQLCA.sqlcode THEN
#                 CALL cl_err3('sel','azi_file',tm.curr,'',SQLCA.sqlcode,'','','0')
#                 NEXT FIELD curr
#              END IF
#           END IF
#FUN-C80102--mark--str--
         AFTER FIELD d1
            IF cl_null(tm.d1) OR tm.d1 NOT MATCHES'[YN]' THEN NEXT FIELD d1 END IF

         AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES'[YN]' THEN NEXT FIELD e END IF

         AFTER FIELD h
            IF cl_null(tm.h) OR tm.h NOT MATCHES'[YN]' THEN NEXT FIELD h END IF

         AFTER FIELD lvl
            IF tm.lvl <= 0 THEN NEXT FIELD lvl END IF

         AFTER FIELD k
            IF cl_null(tm.k) OR tm.k NOT MATCHES '[123]'
            THEN NEXT FIELD k END IF
         #TQC-DC0064--add--str--
         ON CHANGE k
            IF tm.k='2' THEN
               LET tm.b='N'
               CALL cl_set_comp_visible("b",FALSE)
            ELSE
               CALL cl_set_comp_visible("b",TRUE)
            END IF
        #TQC-DC0064--add--end
#FUN-C80102--mark--str--         
#        AFTER FIELD more
#           IF tm.more = 'Y'
#              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
#                        g_bgjob,g_time,g_prtway,g_copies)
#              RETURNING g_pdate,g_towhom,g_rlang,
#                        g_bgjob,g_time,g_prtway,g_copies
#           END IF
#FUN-C80102--mark--end--         
            
       #NO.FUN-C70061 add-----------------------begin
         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES'[YN]' THEN 
               NEXT FIELD a
            END IF
       #NO.FUN-C70061 add-------------------------end
          
        END INPUT 

#FUN-C80102---add--str--

      CONSTRUCT tm.wc1 ON aea05
                  FROM s_abb[1].aea05

        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        END CONSTRUCT

      CONSTRUCT tm.wc2 ON aea02,aea03,abb24
                  FROM s_abb[1].aea02,s_abb[1].aea03,s_abb[1].abb24

        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        END CONSTRUCT 
#FUN-C80102---add--end--

                    
         ON ACTION CONTROLP
            CASE
 
               WHEN INFIELD(bookno)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 =tm.bookno
                  CALL cl_create_qry() RETURNING tm.bookno
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno

#FUN-C80102---add--str--
             WHEN INFIELD(aea05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aea05
                  NEXT FIELD aea05
             WHEN INFIELD(aea03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = 'q_aba'
                  LET g_qryparam.arg1 = tm.bookno
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO aea03
                  NEXT FIELD aea03
#FUN-C80102---add--end--
 
#FUN-C80102--mark--str--
#               WHEN INFIELD(aag01)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state= "c"
#                 LET g_qryparam.form = "q_aag"
#                 LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"   #FUN-B20010 add
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO aag01
#                 NEXT FIELD aag01   
#              WHEN INFIELD(curr)             
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = 'q_azi'
#                 LET g_qryparam.default1 =tm.curr
#                 CALL cl_create_qry() RETURNING tm.curr
#                 DISPLAY BY NAME tm.curr
#                 NEXT FIELD curr                                 
#FUN-C80102--mark--str--
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

         ON ACTION accept
#FUN-C80102--mark--str--
#           IF tm.wc1 = ' 1=1' THEN
#              CALL cl_err('','9046',0)
#              NEXT FIELD bookno
#           ELSE 
#FUN-C80102--mark--str--
               EXIT DIALOG 
#           END IF   #FUN-C80102 
            
         ON ACTION cancel 
            LET INT_FLAG = 1
            EXIT DIALOG  
       #zhouxm170331 add start     
         ON ACTION qbe_save
         CALL cl_qbe_save()

      #No.MOD-CC0102  --Begin
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.MOD-CC0102  --End 
      #zhouxm170331 add  end       
      END DIALOG 
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF    
      IF INT_FLAG THEN
         LET INT_FLAG = 0
        #CLOSE WINDOW gglq301_w1    #FUN-C80102 mark
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211    #TQC-C90015  mark
        #EXIT PROGRAM            #TQC-C90015  mark
        RETURN                   #TQC-C90015  add
      END IF

#No.FUN-A40009 --end      
      #FUN-B20055--end       
#No.FUn-A40009 --begin
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0 CLOSE WINDOW gglq301_w1 EXIT PROGRAM
#     END IF
#No.FUn-A40009 --end
      LET mm1 = MONTH(tm.bdate)
      LET nn1 = MONTH(tm.edate)

      SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = tm.bdate
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      
          WHERE zz01='gglq301'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gglq301','9031',1)
         ELSE
            LET tm.wc1=cl_wcsub(tm.wc1)
            LET l_cmd = l_cmd CLIPPED,
                       " '",tm.bookno  CLIPPED,"'",
                       " '",g_pdate    CLIPPED,"'",
                       " '",g_towhom   CLIPPED,"'",
                       " '",g_rlang    CLIPPED,"'",
                       " '",g_bgjob    CLIPPED,"'",
                       " '",g_prtway   CLIPPED,"'",
                       " '",g_copies   CLIPPED,"'",
                       " '",tm.wc1     CLIPPED,"'",
                       " '",tm.bdate   CLIPPED,"'",
                       " '",tm.edate   CLIPPED,"'",
                       " '",tm.t       CLIPPED,"'",
                       " '",tm.x       CLIPPED,"'",
                       " '",tm.n       CLIPPED,"'",
                       " '",tm.curr    CLIPPED,"'",
                       " '",tm.d1      CLIPPED,"'",
                       " '",tm.e       CLIPPED,"'",
                       " '",tm.h       CLIPPED,"'",
                       " '",tm.lvl     CLIPPED,"'",
                       " '",tm.k       CLIPPED,"'",
                       " '",tm.b       CLIPPED,"'",  #FUN-D10072 130123 add
                       " '",g_rep_user CLIPPED,"'",
                       " '",g_rep_clas CLIPPED,"'",
                       " '",g_template CLIPPED,"'",
                       " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('gglq301',g_time,l_cmd)      
         END IF
         CLOSE WINDOW gglq301_w1
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      #END IF                      #No.FUN-A40009
      CALL cl_wait()
     #CALL gglq301()    #FUN-D10072
      CALL gglq301v()   #No.FUN-CB0146 Add
      ERROR ""
      EXIT WHILE
   END WHILE
#  CLOSE WINDOW gglq301_w1   #FUN-C80102
#No.FUN-A40009 --begin  
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
#No.FUN-A40009 --end 

   CALL gglq301_t()
END FUNCTION

{
#FUN-C80102--add--str--
FUNCTION q301_b_askkey()

   CALL cl_set_comp_visible("abb24",TRUE)
  
   CONSTRUCT tm.wc1 ON aea05,aea02,aea03,abb24
                  FROM s_abb[1].aea05,s_abb[1].aea02,s_abb[1].aea03,s_abb[1].abb24

   BEFORE CONSTRUCT
      CALL cl_qbe_init()


      ON ACTION CONTROLP
       CASE
          WHEN INFIELD(aea05)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'"  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aea05 
               #NEXT FIELD aag01   #MOD-D20095 mark
               NEXT FIELD aea05    #MOD-D20095
          WHEN INFIELD(aea03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = 'q_aba'
               LET g_qryparam.arg1 = tm.bookno
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aea03
               NEXT FIELD aea03
       END CASE
    END CONSTRUCT 
END FUNCTION 
#FUN-C80102--add--end--
}
FUNCTION gglq301()
   DEFINE l_name             LIKE type_file.chr20
   DEFINE l_sql,l_sql1       STRING
   DEFINE l_aea03            LIKE type_file.chr5
   DEFINE l_bal,l_balf       LIKE type_file.num20_6
   DEFINE n_bal,n_balf       LIKE type_file.num20_6
   DEFINE s_abb07,s_abb07f   LIKE type_file.num20_6
   DEFINE l_za05             LIKE type_file.chr1000
   DEFINE l_date,l_date1     LIKE aba_file.aba02
   DEFINE p_aag02            LIKE type_file.chr1000
   DEFINE l_i                LIKE type_file.num5 
   DEFINE l_j                LIKE type_file.num5 
   DEFINE l_curr_cnt         LIKE type_file.num5 
   DEFINE l_n                LIKE type_file.num5    #No.MOD-8C0126 
   DEFINE l_credit           LIKE abb_file.abb07 
   DEFINE l_creditf          LIKE abb_file.abb07f
   DEFINE l_debit            LIKE abb_file.abb07
   DEFINE l_debitf           LIKE abb_file.abb07f
   DEFINE l_aag01_str        LIKE type_file.chr50
   DEFINE sr1                RECORD
                             aag01  LIKE aag_file.aag01,
                             aag02  LIKE aag_file.aag02,
                             aag13  LIKE aag_file.aag13,
                             aag08  LIKE aag_file.aag08,
                             aag07  LIKE aag_file.aag07,
                             aag24  LIKE aag_file.aag24
                             END RECORD 
   DEFINE sr,sr0             RECORD
                             aea05  LIKE aea_file.aea05,    #科目
                             curr   LIKE azi_file.azi01,    #幣種 tm.d='Y'時,curr=abb24,否則為單一值
                             aea02  LIKE aea_file.aea02,    #傳票日期
                             aea03  LIKE aea_file.aea03,    #傳票編號
                             aea04  LIKE aea_file.aea04,    #傳票項次
                             aba04  LIKE aba_file.aba04,    #期間
                             aba02  LIKE aba_file.aba02,    #傳票日期
                             abb04  LIKE abb_file.abb04,    #摘要
                             abb24  LIKE abb_file.abb24,    #實際異動幣種
                             abb25  LIKE abb_file.abb25,    #匯率
                             abb06  LIKE abb_file.abb06,    #借/貸
                             abb07  LIKE abb_file.abb07,    #實際異動本幣值
                             abb07f LIKE abb_file.abb07f,   #實際異動原幣值
                             aag02  LIKE type_file.chr1000, #科目名稱
                             aag08  LIKE aag_file.aag08,    #上級科目
                             qc0    LIKE abb_file.abb07,    #年初本幣余額
                             qc0f   LIKE abb_file.abb07,    #年初原幣余額
                             qc_md  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借本幣金額
                             qc_mdf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借原幣金額
                             qc_mc  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸本幣金額
                             qc_mcf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸原幣金額
                             qc_yd  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借本幣金額
                             qc_ydf LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借原幣金額
                             qc_yc  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的貸本幣金額
                             qc_ycf LIKE abb_file.abb07     #1~MONTH(bdate)月-1的貸原幣金額
                             END RECORD
   DEFINE l_qcye             RECORD
                             qc0    LIKE abb_file.abb07,    #年初本幣余額
                             qc0f   LIKE abb_file.abb07,    #年初原幣余額
                             qc_md  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借本幣金額
                             qc_mdf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借原幣金額
                             qc_mc  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸本幣金額
                             qc_mcf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸原幣金額
                             qc_yd  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借本幣金額
                             qc_ydf LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借原幣金額
                             qc_yc  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的貸本幣金額
                             qc_ycf LIKE abb_file.abb07     #1~MONTH(bdate)月-1的貸原幣金額
                             END RECORD
   DEFINE l_abb24            LIKE abb_file.abb24
   DEFINE l_abb24_o          LIKE abb_file.abb24
   DEFINE l_curr             DYNAMIC ARRAY OF LIKE azi_file.azi01
   DEFINE l_ins              LIKE type_file.chr1
   DEFINE l_aag01            LIKE aag_file.aag01  #FUN-C80102
   DEFINE l_i11              LIKE type_file.num5  #No.FUN-CB0146

   LET g_prog = 'gglr301'
   CALL gglq301_table()

   LET mm1 = MONTH(tm.bdate)
   LET nn1 = MONTH(tm.edate)

   SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = tm.bdate

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.bookno
      AND aaf02 = g_lang

   IF g_priv2='4' THEN
      LET tm.wc1 = tm.wc1 CLIPPED," AND aaguser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN
      LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   END IF
   IF g_priv3 MATCHES "[5678]" THEN
      LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
   END IF

   #foreach 科目 - 最外層
   LET tm.wc1 = cl_replace_str(tm.wc1,"aea05","aag01")    #FUN-C80102
   LET l_sql1= "SELECT aag01,aag02,aag13,aag08,aag07,aag24 ",   
               "  FROM aag_file ",
            #  " WHERE aag03 ='2' AND aag07 MATCHES '[23]'",  #統治科目也會呈現
               " WHERE aag03 ='2' ",
              "   AND aag38 <> 'Y' ",                  #MOD-D20151
               "   AND aag00 = '",tm.bookno,"' ",
              #"   AND ",tm.wc1 CLIPPED  #No.FUN-C80102   Mark
  #No.FUN-CB0146 ---start--- Add
               "   AND NOT (aag24 = 1 AND aag07 = '1')",
               "   AND aag01 IN( SELECT DISTINCT aag01",
               "                   FROM aea_file LEFT OUTER JOIN aag_file ON aea00 = aag00",
               "                  WHERE aag03 ='2'",
               "                    AND aag00 ='",tm.bookno,"')"
   IF NOT cl_null(tm.lvl) THEN
      LET l_sql = l_sql," AND ((aag07 =2 AND aag24 < '",tm.lvl,"') OR (aag07 =1 AND aag24 < '",tm.lvl,"') OR aag07 = 3)"
   END IF
  #No.FUN-CB0146 ---end  --- Add
   #不打印獨立科目
   IF tm.x = 'N' THEN
      LET l_sql1 = l_sql1 CLIPPED," AND aag07 <> '3'"
   END IF
   
   IF tm.h = 'Y' THEN
      LET l_sql1 = l_sql1 CLIPPED," AND aag09 = 'Y' "
   END IF
   LET l_sql1 = l_sql1," ORDER BY aag01"
   PREPARE gglq301_prepare2 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE gglq301_curs2 CURSOR FOR gglq301_prepare2

   #foreach幣別 - 第二層 ,后續用for 實現
   #當tm.d = 'Y' 按外幣分頁時,以幣種+月份 的方式顯示,故幣種要先顯示出來
   #當tm.d = 'N' 時,就賦單一值
   LET l_sql1 = " SELECT UNIQUE abb24 FROM aba_file,abb_file",
                "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                "    AND aba00 = '",tm.bookno,"'",
                "    AND aba03 = ",yy,
                "    AND abaacti='Y' ",
                "    AND aba19 <> 'X' ",  #CHI-C80041
                "    AND abb03 LIKE ? "        #account
   IF NOT cl_null(tm.curr) THEN
      LET l_sql1 = l_sql1 CLIPPED," AND abb24 = '",tm.curr,"'"
   END IF
   IF tm.k = '2' THEN    #審核
      LET l_sql1 = l_sql1 CLIPPED," AND aba19 = 'Y'"
   END IF
   IF tm.k = '3' THEN    #過帳
      LET l_sql1 = l_sql1 CLIPPED," AND abapost = 'Y'"
   END IF
   PREPARE gglq301_abb24_p1 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq301_abb24_cs1 CURSOR FOR gglq301_abb24_p1

   #在期間範圍內的異動明細  - 最明細的foreach資料
   IF tm.k = '3' THEN
      LET l_sql = "SELECT aea05,'',aea02,aea03,aea04,aba04,",
                  "       aba02,abb04,abb24,abb25,abb06,",
                  "       abb07,abb07f,'','',0,0,0,0,0,0,0,0,0,0 ",
                  "  FROM aea_file,aba_file,abb_file ",
                  " WHERE aea05 LIKE ? ",
                  "   AND aea00 = '",tm.bookno,"' ",
                  "   AND aea00 = aba00 ",
                  "   AND aba00 = abb00 ",
                  "   AND aba01 = abb01 ",
                  "   AND abb03 = aea05 ",
                  "   AND aea02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                  "   AND abb01 = aea03 AND abb02 = aea04 ",
                  "   AND aba01 = aea03",
                  "   AND abapost = 'Y' ",
                  "   AND aba04 = ? " 
   ELSE
      LET l_sql = "SELECT abb03,'',aba02,abb01,abb02,aba04,",
                  "       ''   ,abb04,abb24,abb25,abb06,",
                  "       abb07,abb07f,'','',0,0,0,0,0,0,0,0,0,0 ",
                  "  FROM aba_file,abb_file ",
                  " WHERE abb03 LIKE ? ",
                  "   AND abb00 = '",tm.bookno,"' ",
                  "   AND aba00 = abb00 ",
                  "   AND aba01 = abb01 ",
                  "   AND aba02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                  "   AND abaacti='Y' ",
                  "   AND aba19 <> 'X' ",  #CHI-C80041
                  "   AND aba04 = ? " 
   END IF
   IF NOT cl_null(tm.curr) THEN
      LET l_sql = l_sql CLIPPED," AND abb24 = '",tm.curr,"'"
   END IF
   IF tm.k = '2' THEN
      LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
   END IF
   #若tm.d = 'Y'時,當前頁要限制幣種,否則當前頁不限制幣種
   #以下寫法,是為了不因為tm.d='Y'或是'N',分兩種using參數個數
  #IF tm.d= 'Y' OR NOT cl_null(tm.curr) THEN   #MOD-C50025  #No.FUN-C80102  Mark
   IF tm.d1= 'Y' THEN                                       #No.FUN-C80102  Add 
      LET l_sql = l_sql CLIPPED," AND abb24 = ? " 
   ELSE
      LET l_sql = l_sql CLIPPED," AND 1 = ? "
   END IF
   IF tm.k = '3' THEN
      LET l_sql = l_sql CLIPPED," ORDER BY aea05,aba04,abb24,aea02,aea03,aea04 "
   ELSE
      LET l_sql = l_sql CLIPPED," ORDER BY abb03,aba04,abb24,aba02,abb01,abb02 "
   END IF
   PREPARE gglq301_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE gglq301_curs1 CURSOR FOR gglq301_prepare1

   #計算MONTH(tm.bdate)月,1至tm.bdate-1 的借/貸方金額 (僅沒有進tah_file的部分)
   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) ",
               "   FROM abb_file,aba_file ",
               "  WHERE abb00 = aba00 ",
               "    AND abb01 = aba01 ",
               "    AND aba00 = '",tm.bookno,"'",
               "    AND aba03 =  ",yy,
               "    AND aba04 =  ",mm,
               "    AND aba02 < '",tm.bdate,"'",
               "    AND abb03 LIKE ? ",
               "    AND abb06 = ? ",
               "    AND abaacti ='Y' ",
               "    AND aba19 <> 'X' "  #CHI-C80041
 
  #IF tm.d= 'Y' OR NOT cl_null(tm.curr) THEN   #MOD-C50025  #No.FUN-C80102  Mark
   IF tm.d1= 'Y' THEN                                       #No.FUN-C80102  Add   
      LET l_sql = l_sql CLIPPED," AND abb24 = ? "
   ELSE
      LET l_sql = l_sql CLIPPED," AND 1 = ? "
   END IF
   IF tm.k = '2' THEN
      LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
   END IF
   IF tm.k = '3' THEN
      LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
   END IF
   PREPARE gglq301_prepareb FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE gglq301_cursb CURSOR FOR gglq301_prepareb

   #計算1~MONTH(tm.bdate)月的借/貸方金額 (僅沒有進tah_file的部分)
   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) ",
               "   FROM abb_file,aba_file ",
               "  WHERE abb00 = aba00 ",
               "    AND abb01 = aba01 ",
               "    AND aba00 = '",tm.bookno,"'",
               "    AND aba03 =  ",yy,
               "    AND aba04 <  ",mm,
               "    AND abb03 LIKE ? ",
               "    AND abb06 = ? ",
               "    AND abapost ='N' ",
               "    AND abaacti ='Y' ",
               "    AND aba19 <> 'X' "  #CHI-C80041
 
  #IF tm.d= 'Y' OR NOT cl_null(tm.curr) THEN   #MOD-C50025  #No.FUN-C80102  Mark
   IF tm.d1= 'Y' THEN                                       #No.FUN-C80102  Add  
      LET l_sql = l_sql CLIPPED," AND abb24 = ? "
   ELSE
      LET l_sql = l_sql CLIPPED," AND 1 = ? "
   END IF
 
   IF tm.k = '2' THEN
      LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
   END IF
   PREPARE gglq301_preparec FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE gglq301_cursc CURSOR FOR gglq301_preparec

   #LET l_sql = " SELECT SUM(abb07),SUM(abb07f) ",
   #            "   FROM abb_file,aba_file ",
   #            "  WHERE abb00 = aba00 AND aba01 = abb01 ",
   #            "    AND aba00 = '",tm.bookno,"'",
   #            "    AND abb03 LIKE ? ",
   #            "    AND aba02 >= '",tm.bdate,"' AND aba02 <= '",tm.edate,"'",
   #            "    AND aba03 = ",yy,
   #            "    AND abaacti='Y' "
   #IF tm.k = '2' THEN
   #   LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
   #END IF
   #IF tm.k = '3' THEN
   #   LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
   #END IF
   ##TQC-970049  --begin
   #IF tm.d = 'Y' THEN LET l_sql=l_sql CLIPPED," AND abb24 = ? " END IF
   ##TQC-970049  --end
   #PREPARE gglq301_prepared FROM l_sql
   #IF SQLCA.sqlcode != 0 THEN
   #   CALL cl_err('prepare:',SQLCA.sqlcode,1)
   #   EXIT PROGRAM
   #END IF
   #DECLARE gglq301_cursd CURSOR FOR gglq301_prepared

   ##TQC-970049  --begin
   #LET l_sql = " SELECT COUNT(*)",
   #            "   FROM abb_file,aba_file ",
   #            "  WHERE abb00 = aba00 AND aba01 = abb01 ",
   #            "    AND aba00 = '",tm.bookno,"'",
   #            "    AND abb03 LIKE ? ",
   #            "    AND aba02 >= '",tm.bdate,"' AND aba02 <= '",tm.edate,"'",
   #            "    AND aba03 = ",yy,
   #            "    AND abb07 !=0",
   #            "    AND abaacti='Y' "
   #IF tm.k = '2' THEN
   #   LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
   #END IF
   #IF tm.k = '3' THEN
   #   LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
   #END IF
   #IF tm.d = 'Y' THEN LET l_sql=l_sql CLIPPED," AND abb24 = ? " END IF
   #PREPARE gglq301_preparee FROM l_sql
   #IF SQLCA.sqlcode != 0 THEN
   #   CALL cl_err('prepare:',SQLCA.sqlcode,1)
   #   EXIT PROGRAM
   #END IF
   #DECLARE gglq301_curse CURSOR FOR gglq301_preparee
   ##TQC-970049  --end

   CALL cl_outnam('gglr301') RETURNING l_name
   LET g_pageno = 0
   START REPORT gglq301_rep TO l_name
   #1.最外圈的科目foreach
   FOREACH gglq301_curs2 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach gglq301_curs2:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     
      IF cl_null(sr1.aag01) THEN CONTINUE FOREACH END IF

      #最上層的統治科目不打印,ruled by 蔡曉峰
      #No.FUN-A40020  --Begin                                                   
      #IF sr1.aag24 = 1 THEN CONTINUE FOREACH END IF                            
     #IF sr1.aag24 = 1 AND sr1.aag07 = '1' THEN CONTINUE FOREACH END IF     #No.FUN-CB0146 Mark
      #No.FUN-A40020  --End
     #No.FUN-CB0146 ---start--- Mark
     ##有規定打印層級時,獨立科目不在限制中,獨立科目由tm.x限制
     #IF NOT cl_null(tm.lvl) THEN
     #   IF sr1.aag07 <> '3' THEN
     #      IF sr1.aag07 > tm.lvl THEN
     #         CONTINUE FOREACH
     #      END IF
     #   END IF
     #END IF
     #No.FUN-CB0146 ---start--- Mark
   
      #此作業也要打印統治科目的金額，但是abb中都存放得是明細或是獨立科目
      #所以要用LIKE的方式，取出統治科目對應的明細科目的金額
      #此作業的前提，明細科目的前幾碼一定和其上屬統治相同 ruled by 蔡曉峰
      LET l_aag01_str = sr1.aag01 CLIPPED,'\%'  #No.MOD-940388

      #第二層for是用來foreach 幣種,對于tm.d = 'Y'時,則每頁要以幣種的角度
      #來顯示,統計資料等
      #對于tm.d = 'N'時,是以科目的角度來顯示和統計資料的
      #由于兩者結構不一樣,故套用了這一層的foreach,對于tm.d='Y',是真得在做
      #幣種foreach,但是tm.d='N',則是假套了一層
      CALL l_curr.clear()
     #IF tm.d= 'Y' OR NOT cl_null(tm.curr) THEN   #MOD-C50025  #No.FUN-C80102  Mark
      IF tm.d1= 'Y' THEN                                       #No.FUN-C80102  Add  
         LET l_i = 1
         FOREACH gglq301_abb24_cs1 USING l_aag01_str INTO l_curr[l_i]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach gglq301_abb24_cs1',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET l_i = l_i + 1
         END FOREACH
         LET l_curr_cnt = l_i - 1
#No.MOD-B30577 --begin
         IF l_curr_cnt =0 AND NOT cl_null(tm.curr) THEN 
            LET l_curr[1] = tm.curr
            LET l_curr_cnt = 1            
         END IF 
#No.MOD-B30577 --end
      ELSE
         LET l_curr[1] = g_aza.aza17
         LET l_curr_cnt = 1
      END IF

      #第二層FOR ..用于foreach幣種
      FOR l_j = 1 TO l_curr_cnt
          LET n_bal = 0     LET n_balf = 0 
          CALL q301_initialize_qcye_para() RETURNING l_qcye.*
         #IF tm.d= 'Y' OR NOT cl_null(tm.curr) THEN   #MOD-C50025  #No.FUN-C80102  Mark
          IF tm.d1= 'Y' THEN                                       #No.FUN-C80102  Add  
             LET l_abb24 = l_curr[l_j]
          ELSE               
             LET l_abb24 = 1 
          END IF            
          #期初值
          CALL gglq301_qcye_qcyd(sr1.aag01,l_abb24)
               RETURNING l_qcye.*
          #期初值是否為0
          CALL gglq301_check_ins(l_qcye.*) RETURNING l_ins
          IF l_ins = 'Y' THEN
             INITIALIZE sr0.* TO NULL
             LET sr0.aea05= sr1.aag01
             IF tm.e = 'Y' THEN
                LET sr0.aag02=sr1.aag13
             ELSE
                LET sr0.aag02=sr1.aag02
             END IF
             LET sr0.aag08=sr1.aag08
             IF sr1.aag07 = '3' THEN
                LET sr0.aag08 = ''
             ELSE
                CALL gglq301_sjkm(sr1.aag01,sr1.aag24)
                     RETURNING p_aag02
                LET sr0.aag02 = p_aag02
             END IF
             LET sr0.curr = l_curr[l_j]
             LET sr0.abb24= l_curr[l_j]
             LET sr0.aba04 = -1
             LET sr0.qc0    =l_qcye.qc0       #年初本幣余額
             LET sr0.qc0f   =l_qcye.qc0f      #年初原幣余額
             LET sr0.qc_md  =l_qcye.qc_md     #MONTH(bdate)月,1~bdate-1 借本幣金額
             LET sr0.qc_mdf =l_qcye.qc_mdf    #MONTH(bdate)月,1~bdate-1 借原幣金額
             LET sr0.qc_mc  =l_qcye.qc_mc     #MONTH(bdate)月,1~bdate-1 貸本幣金額
             LET sr0.qc_mcf =l_qcye.qc_mcf    #MONTH(bdate)月,1~bdate-1 貸原幣金額
             LET sr0.qc_yd  =l_qcye.qc_yd     #1~MONTH(bdate)月-1的借本幣金額
             LET sr0.qc_ydf =l_qcye.qc_ydf    #1~MONTH(bdate)月-1的借原幣金額
             LET sr0.qc_yc  =l_qcye.qc_yc     #1~MONTH(bdate)月-1的貸本幣金額
             LET sr0.qc_ycf =l_qcye.qc_ycf    #1~MONTH(bdate)月-1的貸原幣金額
             OUTPUT TO REPORT gglq301_rep(sr0.*)
          END IF
          LET n_bal = l_qcye.qc0 + l_qcye.qc_md - l_qcye.qc_mc + l_qcye.qc_yd - l_qcye.qc_yc
          LET n_balf= l_qcye.qc0f+ l_qcye.qc_mdf- l_qcye.qc_mcf+ l_qcye.qc_ydf- l_qcye.qc_ycf
          CALL q301_initialize_qcye_para() RETURNING l_qcye.*

          FOR l_i = mm1 TO nn1
              LET l_flag='N'
              FOREACH gglq301_curs1 USING l_aag01_str,l_i,l_abb24 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach gglq301_curs1:',SQLCA.sqlcode,1)  #No.FUN-8A0028
                    EXIT FOREACH
                 END IF
                 LET sr.aea05 = sr1.aag01
                 LET sr.curr  = l_curr[l_j]  #后續用于排序分組使用的幣種
                 CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
                 LET sr.aba02 = l_date1
                 LET l_flag='Y'
                 IF tm.e = 'Y' THEN
                    LET sr.aag02=sr1.aag13
                 ELSE
                    LET sr.aag02=sr1.aag02
                 END IF
                 LET sr.aag08=sr1.aag08
                 IF sr1.aag07 = '3' THEN
                    LET sr.aag08 = ''
                 ELSE
                    CALL gglq301_sjkm(sr1.aag01,sr1.aag24)
                         RETURNING p_aag02
                    LET sr.aag02 = p_aag02
                 END IF
                 OUTPUT TO REPORT gglq301_rep(sr.*)
                 IF sr.abb06 = "1" THEN
                    LET n_bal  = n_bal  + sr.abb07
                    LET n_balf = n_balf + sr.abb07f
                 ELSE
                    LET n_bal  = n_bal  - sr.abb07
                    LET n_balf = n_balf - sr.abb07f
                 END IF
                 LET l_abb24_o = sr.abb24
              END FOREACH
              IF l_flag = 'N' AND (tm.t = 'Y' OR n_bal <> 0 AND tm.n = 'N'
                 OR (n_bal <> 0 OR n_balf <> 0) AND tm.n = 'Y') THEN
                 INITIALIZE sr.* TO NULL
                 LET sr.aea05= sr1.aag01
                 LET sr.curr = l_curr[l_j]  #后續用于排序分組使用的幣種
                 LET sr.abb24= l_curr[l_j]
                 LET sr.aea02= NULL
                 LET sr.aba04 = l_i
                 CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
                 LET sr.aba02 = l_date1
                 LET sr.abb25 = 1
                 LET sr.abb07=0
                 LET sr.abb07f = 0
                 IF tm.e = 'Y' THEN
                    LET sr.aag02=sr1.aag13
                 ELSE
                    LET sr.aag02=sr1.aag02
                 END IF
                 IF sr1.aag07 = '3' THEN
                    LET sr.aag08 = ''
                 ELSE
                    CALL gglq301_sjkm(sr1.aag01,sr1.aag24)
                         RETURNING p_aag02
                    LET sr.aag02 = p_aag02
                 END IF
                 LET sr.aag08= sr1.aag08
                 LET l_flag = 'Y'
                 OUTPUT TO REPORT gglq301_rep(sr.*)
              END IF
          END FOR
      END FOR
   END FOREACH
   FINISH REPORT gglq301_rep

END FUNCTION

#No.FUN-CB0146 ---start--- Add
FUNCTION gglq301v()
   DEFINE l_name             LIKE type_file.chr20
   DEFINE l_sql,l_sql1       STRING
   DEFINE l_aea03            LIKE type_file.chr5
   DEFINE l_bal,l_balf       LIKE type_file.num20_6
   DEFINE n_bal,n_balf       LIKE type_file.num20_6
   DEFINE s_abb07,s_abb07f   LIKE type_file.num20_6
   DEFINE l_za05             LIKE type_file.chr1000
   DEFINE l_date,l_date1     LIKE aba_file.aba02
   DEFINE p_aag02            LIKE type_file.chr1000
   DEFINE l_i                LIKE type_file.num5 
   DEFINE l_j                LIKE type_file.num5 
   DEFINE l_curr_cnt         LIKE type_file.num5 
   DEFINE l_n                LIKE type_file.num5
   DEFINE l_credit           LIKE abb_file.abb07 
   DEFINE l_creditf          LIKE abb_file.abb07f
   DEFINE l_debit            LIKE abb_file.abb07
   DEFINE l_debitf           LIKE abb_file.abb07f
   DEFINE l_aag01_str        LIKE type_file.chr50
   DEFINE sr1                RECORD
                             aag01  LIKE aag_file.aag01,
                             abb24  LIKE abb_file.abb24,
                             aag02  LIKE aag_file.aag02,
                             aag13  LIKE aag_file.aag13,
                             aag08  LIKE aag_file.aag08,
                             aag07  LIKE aag_file.aag07,
                             aag24  LIKE aag_file.aag24
                             END RECORD 
   DEFINE sr,sr0             RECORD
                             aea05  LIKE aea_file.aea05,    #科目
                             curr   LIKE azi_file.azi01,    #幣種 tm.d='Y'時,curr=abb24,否則為單一值
                             aea02  LIKE aea_file.aea02,    #傳票日期
                             aea03  LIKE aea_file.aea03,    #傳票編號
                             aba11  LIKE aba_file.aba11,    #凭证总号 zhouxm150428 add
                             aea04  LIKE aea_file.aea04,    #傳票項次
                             aba04  LIKE aba_file.aba04,    #期間
                             aba02  LIKE aba_file.aba02,    #傳票日期
                             abb04  LIKE abb_file.abb04,    #摘要
                             abb24  LIKE abb_file.abb24,    #實際異動幣種
                             abb25  LIKE abb_file.abb25,    #匯率
                             abb06  LIKE abb_file.abb06,    #借/貸
                             abb07  LIKE abb_file.abb07,    #實際異動本幣值
                             abb07f LIKE abb_file.abb07f,   #實際異動原幣值
                             aag02  LIKE type_file.chr1000, #科目名稱
                             aag08  LIKE aag_file.aag08,    #上級科目
                             qc0    LIKE abb_file.abb07,    #年初本幣余額
                             qc0f   LIKE abb_file.abb07,    #年初原幣余額
                             qc_md  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借本幣金額
                             qc_mdf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借原幣金額
                             qc_mc  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸本幣金額
                             qc_mcf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸原幣金額
                             qc_yd  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借本幣金額
                             qc_ydf LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借原幣金額
                             qc_yc  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的貸本幣金額
                             qc_ycf LIKE abb_file.abb07     #1~MONTH(bdate)月-1的貸原幣金額
                             END RECORD
   DEFINE l_qcye             RECORD
                             qc0    LIKE abb_file.abb07,    #年初本幣余額
                             qc0f   LIKE abb_file.abb07,    #年初原幣余額
                             qc_md  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借本幣金額
                             qc_mdf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借原幣金額
                             qc_mc  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸本幣金額
                             qc_mcf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸原幣金額
                             qc_yd  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借本幣金額
                             qc_ydf LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借原幣金額
                             qc_yc  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的貸本幣金額
                             qc_ycf LIKE abb_file.abb07     #1~MONTH(bdate)月-1的貸原幣金額
                             END RECORD
   DEFINE l_abb24            LIKE abb_file.abb24
   DEFINE l_abb24_o          LIKE abb_file.abb24
   DEFINE l_curr             DYNAMIC ARRAY OF LIKE azi_file.azi01
   DEFINE l_ins              LIKE type_file.chr1
   DEFINE l_aag01            LIKE aag_file.aag01
   DEFINE l_abb07            LIKE abb_file.abb07
   DEFINE l_abb07f           LIKE abb_file.abb07
   DEFINE l_abb07_d          LIKE abb_file.abb07  #MOD-E20099 add
   DEFINE l_abb07f_d         LIKE abb_file.abb07  #MOD-E20099 add
   DEFINE l_abb07_c          LIKE abb_file.abb07  #MOD-E20099 add
   DEFINE l_abb07f_c         LIKE abb_file.abb07  #MOD-E20099 add
   DEFINE i            LIKE type_file.num5

   LET g_prog = 'gglq301v'
   CALL gglq301_table()
   CALL gglq301_table1()

   DISPLAY "START TIME: ",TIME

   LET mm1 = MONTH(tm.bdate)
   LET nn1 = MONTH(tm.edate)

   LET tm.wc1 = cl_replace_str(tm.wc1,'aea05','aag01')
   
   #計算MONTH(tm.bdate)月,1至tm.bdate-1 的借/貸方金額 (僅沒有進tah_file的部分)
   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) ",
               "   FROM abb_file,aba_file ",
               "  WHERE abb00 = aba00 ",
               "    AND abb01 = aba01 ",
               "    AND aba00 = '",tm.bookno,"'",
               "    AND aba03 =  ",yy,
               "    AND aba04 =  ",mm,
               "    AND aba02 < '",tm.bdate,"'",
               "    AND abb03 LIKE ? ",
               "    AND abb06 = ? ",
               "    AND abaacti ='Y' "
   IF tm.n = 'Y' THEN
      LET l_sql = l_sql," AND abb24 = ?"
   ELSE
      LET l_sql = l_sql," AND 1 = ?"
   END IF
#FUN-D10072-130123--mod
#  IF tm.k = '2' THEN
#     LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' " 
#  END IF  
#  IF tm.k = '3' THEN
#     LET l_sql = l_sql CLIPPED," AND abapost = 'Y' " 
#  END IF  
   IF tm.b = 'Y' THEN 
      IF tm.k = '1' THEN  
         LET l_sql1 = l_sql CLIPPED," AND (aba19 = 'N' OR  aba19 = 'Y')) " 
      END IF  
      IF tm.k = '2' THEN
         LET l_sql1 = l_sql CLIPPED," AND (aba19 = 'N' OR abapost = 'Y') "
      END IF  
   ELSE    
      IF tm.k = '1' THEN    
         LET l_sql1 = l_sql CLIPPED," AND aba19 = 'Y' " 
      END IF
      IF tm.k = '2' THEN
         LET l_sql1 = l_sql CLIPPED," AND abapost = 'Y' "
      END IF
   END IF
#FUN-D10072-130123--mod
   PREPARE gglq301_prepareb1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq301_cursb1 CURSOR FOR gglq301_prepareb1

   #計算1~MONTH(tm.bdate)月的借/貸方金額 (僅沒有進tah_file的部分)
   LET l_sql = " SELECT SUM(abb07),SUM(abb07f) ",
               "   FROM abb_file,aba_file ",
               "  WHERE abb00 = aba00 ",
               "    AND abb01 = aba01 ",
               "    AND aba00 = '",tm.bookno,"'",
               "    AND aba03 =  ",yy,
               "    AND aba04 <  ",mm,
               "    AND abb03 LIKE ? ",
               "    AND abb06 = ? ",
               "    AND abapost ='N' ",
               "    AND abaacti ='Y' "
   IF tm.n = 'Y' THEN
      LET l_sql = l_sql," AND abb24 = ?"
   ELSE
      LET l_sql = l_sql," AND 1 = ?"
   END IF
#FUN-D10072-130123--mod
#  IF tm.k = '2' THEN
#     LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
#  END IF
#MOD-E20099--begin-----------
#   IF tm.b = 'N' THEN
#      IF tm.k = '1' THEN
#         LET l_sql1 = l_sql CLIPPED," AND aba19 = 'Y' "
#      END IF
#   END IF
   IF tm.b = 'Y' THEN 
      IF tm.k = '1' THEN  
         LET l_sql1 = l_sql CLIPPED," AND (aba19 = 'N' OR  aba19 = 'Y')) " 
      END IF  
      IF tm.k = '2' THEN
         LET l_sql1 = l_sql CLIPPED," AND (aba19 = 'N' OR abapost = 'Y') "
      END IF  
   ELSE    
      IF tm.k = '1' THEN    
         LET l_sql1 = l_sql CLIPPED," AND aba19 = 'Y' " 
      END IF
      IF tm.k = '2' THEN
         LET l_sql1 = l_sql CLIPPED," AND abapost = 'Y' "
      END IF
   END IF
#MOD-E20099--end---
#FUN-D10072-130123--mod
   PREPARE gglq301_preparec1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq301_cursc1 CURSOR FOR gglq301_preparec1
   
   LET l_sql = "INSERT INTO q301_temp "
   IF tm.e = 'Y' THEN
      LET l_sql = l_sql," SELECT DISTINCT aag01,aag13,aag08,aag07,aag24"
   ELSE
      LET l_sql = l_sql," SELECT DISTINCT aag01,aag02,aag08,aag07,aag24"
   END IF
      LET l_sql = l_sql,"  FROM aag_file ",
               " WHERE aag03 ='2'",
               "   AND aag00 = '",tm.bookno,"'",
               "   AND aag09 = 'Y'",
               "   AND NOT (aag24 = 1 AND aag07 = '1')",
               "   AND ",tm.wc1 CLIPPED,
               "   AND aag01 IN( SELECT DISTINCT aag01", 
              #"                   FROM aea_file LEFT OUTER JOIN aag_file ON aea00 = aag00",  #FUN-C80102
               "                   FROM aag_file LEFT OUTER JOIN aea_file ON aag00 = aea00",  #FUN-C80102
               "                  WHERE aag03 ='2'",
               "                    AND aag00 ='",tm.bookno,"')"
   IF NOT cl_null(tm.lvl) THEN
      LET l_sql = l_sql," AND ((aag07 =2 AND aag24 < '100') OR (aag07 =1 AND aag24 < '100') OR aag07 = 3)"
   END IF
   PREPARE q301v_aag_prep FROM l_sql
   EXECUTE q301v_aag_prep

   IF tm.n = 'Y' THEN
      LET l_sql = "INSERT INTO q301_temp1 ",
                  "SELECT DISTINCT aag01,abb24,aag02,aag08,aag07,aag24 FROM aba_file,abb_file,q301_temp",
                  " WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "   AND aba00 = '",tm.bookno,"'",
                  "   AND aba03 = ",yy,
                  "   AND abaacti='Y' ",
                  "   AND abb03 LIKE aag01||'%' "
      PREPARE q301v_aag1_prep FROM l_sql
      EXECUTE q301v_aag1_prep
   END IF

   IF tm.n = 'Y' THEN
      LET l_sql = "SELECT aag01,abb24_temp,aag02,aag08,aag07,aag24 FROM q301_temp1 ORDER BY aag01"
   ELSE
      LET l_sql = "SELECT aag01,'",g_aza.aza17,"',aag02,aag08,aag07,aag24 FROM q301_temp ORDER BY aag01"
   END IF
   PREPARE q301v_aag2_prep FROM l_sql
   DECLARE q301v_aag1_dec2 CURSOR FOR q301v_aag2_prep
  #獲取各科目前期結轉
   FOREACH q301v_aag1_dec2 INTO sr1.*
     #每一個科目、幣別對應的期初結轉
      CALL q301_initialize_qcye_para() RETURNING l_qcye.*
     #期初值
      CALL gglq301_qcye_qcyd(sr1.aag01,sr1.abb24) RETURNING l_qcye.*
     #期初值是否為0
      INITIALIZE sr0.* TO NULL
      LET sr0.aea05= sr1.aag01
      LET sr0.aag02=sr1.aag02
      LET sr0.aag08=sr1.aag08
      IF sr1.aag07 = '3' THEN
          LET sr0.aag08 = ''
      END IF
      LET sr0.curr = sr1.abb24
      LET sr0.abb24= sr1.abb24
      LET sr0.aba04 = -1
      LET sr0.qc0    =l_qcye.qc0       #年初本幣余額
      LET sr0.qc0f   =l_qcye.qc0f      #年初原幣余額
      LET sr0.qc_md  =l_qcye.qc_md     #MONTH(bdate)月,1~bdate-1 借本幣金額
      LET sr0.qc_mdf =l_qcye.qc_mdf    #MONTH(bdate)月,1~bdate-1 借原幣金額
      LET sr0.qc_mc  =l_qcye.qc_mc     #MONTH(bdate)月,1~bdate-1 貸本幣金額
      LET sr0.qc_mcf =l_qcye.qc_mcf    #MONTH(bdate)月,1~bdate-1 貸原幣金額
      LET sr0.qc_yd  =l_qcye.qc_yd     #1~MONTH(bdate)月-1的借本幣金額
      LET sr0.qc_ydf =l_qcye.qc_ydf    #1~MONTH(bdate)月-1的借原幣金額
      LET sr0.qc_yc  =l_qcye.qc_yc     #1~MONTH(bdate)月-1的貸本幣金額
      LET sr0.qc_ycf =l_qcye.qc_ycf    #1~MONTH(bdate)月-1的貸原幣金額
     #LET l_abb07  = sr0.qc_md + sr0.qc_yd  #MOD-E20099 mark
     #LET l_abb07f = sr0.qc_mc + sr0.qc_yc  #MOD-E20099 mark
      LET l_abb07_d  = sr0.qc_md + sr0.qc_yd #MOD-E20099 add
      LET l_abb07_c  = sr0.qc_mc + sr0.qc_yc #MOD-E20099 add
      LET l_abb07f_d = sr0.qc_mdf + sr0.qc_ydf  #MOD-E20099 add
      LET l_abb07f_c = sr0.qc_mcf + sr0.qc_ycf  #MOD-E20099 add
      LET l_bal = sr0.qc0 + sr0.qc_md - sr0.qc_mc + sr0.qc_yd - sr0.qc_yc
      LET l_balf= sr0.qc0f+ sr0.qc_mdf- sr0.qc_mcf+ sr0.qc_ydf- sr0.qc_ycf
      INSERT INTO q301_temp2
         VALUES(sr0.aea05,sr0.aag02,sr0.curr,sr0.aba04,'1',tm.bdate,'','','','',sr0.abb24,#zhouxm150428 add '',
        # 0,l_abb07,l_abb07f,l_bal,l_balf,sr1.aag07)  #MOD-E20099 mark
          0,l_abb07_d,l_abb07f_d,l_abb07_c,l_abb07f_c,l_bal,l_balf,sr1.aag07)  #MOD-E20099 add
      FOR i = mm1 TO nn1
         CALL s_azn01(yy,i) RETURNING l_date,l_date1
         INSERT INTO q301_temp2
            VALUES(sr0.aea05,sr0.aag02,sr0.curr,sr0.aba04,'3',l_date1,'','','','',sr0.abb24, #zhouxm150428 add '',
                  #3,l_abb07,l_abb07f,l_bal,l_balf,sr1.aag07)    #MOD-E20099 mark
                   3,l_abb07_d,l_abb07f_d,l_abb07_c,l_abb07f_c,l_bal,l_balf,sr1.aag07)    #MOD-E20099 add
         INSERT INTO q301_temp2
            VALUES(sr0.aea05,sr0.aag02,sr0.curr,sr0.aba04,'4',l_date1,'','','','',sr0.abb24,#zhouxm150428 add '',
                  #4,l_abb07,l_abb07f,l_bal,l_balf,sr1.aag07)    #MOD-E20099 mark
                   4,l_abb07_d,l_abb07f_d,l_abb07_c,l_abb07f_c,l_bal,l_balf,sr1.aag07)    #MOD-E20099 add
      END FOR
   END FOREACH

   #在期間範圍內的異動明細  - 最明細的資料
   LET l_sql = "INSERT INTO q301_temp2 "
  #IF tm.k = '3' THEN  #FUN-D10072--130123
   IF tm.k = '2' AND tm.b = 'N' THEN  #FUN-D10072--130123
     #IF tm.d1 = 'Y' THEN   #MOD-E20099--mark
      IF tm.n = 'Y' THEN   #MOD-E20099--add
         LET l_sql = l_sql,"SELECT aag01,aag02,abb24_temp,aba04,'2',aea02,aea03,aba11,aea04,abb04,",#zhouxm150428 add aba11,
                          #"       abb24,abb06,abb07,abb07f,0,0,aag07",   #MOD-E20099 mark
                           "       abb24,abb06,abb07,abb07f,0,0,0,0,aag07",   #MOD-E20099 add
                           "  FROM aea_file,aba_file,abb_file,q301_temp1 "
      ELSE
         LET l_sql = l_sql,"SELECT aag01,aag02,'",g_aza.aza17,"',aba04,'2',aea02,aea03,aba11,aea04,abb04,",#zhouxm150428 add aba11,
                          #"       abb24,abb06,abb07,abb07f,0,0,aag07",  #MOD-E20099 mark
                           "       abb24,abb06,abb07,abb07f,0,0,0,0,aag07",  #MOD-E20099 add
                           "  FROM aea_file,aba_file,abb_file,q301_temp "
      END IF
      LET l_sql = l_sql," WHERE aea05 LIKE aag01||'%' ",
               "   AND aea00 = '",tm.bookno,"' ",
               "   AND aea00 = aba00 ",
               "   AND aba00 = abb00 ",
               "   AND aba01 = abb01 ",
               "   AND abb03 = aea05 ",
               "   AND aea02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
               "   AND abb01 = aea03 AND abb02 = aea04 ",
               "   AND aba01 = aea03",
               "   AND abapost = 'Y' ",
               "   AND aba04 BETWEEN '",mm1,"' AND '",nn1,"' "
     #IF tm.d1 = 'Y' THEN   #MOD-E20099--mark
      IF tm.n = 'Y' THEN   #MOD-E20099--add
         LET l_sql = l_sql,"   AND abb24 = abb24_temp"
      END IF
   ELSE
     #IF tm.d1 = 'Y' THEN   #MOD-E20099--mark
      IF tm.n = 'Y' THEN   #MOD-E20099--add
         LET l_sql = l_sql,"SELECT aag01,aag02,abb24_temp,aba04,'2',aba02,abb01,aba11,abb02,",#zhouxm150428 add aba11,
                          #"       abb04,abb24,abb06,abb07,abb07f,0,0,aag07",   #MOD-E20099 mark
                           "       abb04,abb24,abb06,abb07,abb07f,0,0,0,0,aag07",   #MOD-E20099 add
                           "  FROM aba_file,abb_file,q301_temp1 "
      ELSE
         LET l_sql = l_sql,"SELECT aag01,aag02,'",g_aza.aza17,"',aba04,'2',aba02,abb01,aba11,abb02,",#zhouxm150428 add aba11,
                          #"       abb04,abb24,abb06,abb07,abb07f,0,0,aag07",  #MOD-E20099 mark
                           "       abb04,abb24,abb06,abb07,abb07f,0,0,0,0,aag07",  #MOD-E20099 add
                           "  FROM aba_file,abb_file,q301_temp "
      END IF
      LET l_sql = l_sql," WHERE abb03 LIKE aag01||'%' ",
                        "   AND abb00 = '",tm.bookno,"' ",
                        "   AND aba00 = abb00 ",
                        "   AND aba01 = abb01 ",
                        "   AND aba02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                        "   AND abaacti='Y' ",
                        "   AND aba04 BETWEEN '",mm1,"' AND '",nn1,"' "
     #IF tm.d1 = 'Y' THEN   #MOD-E20099--mark
      IF tm.n = 'Y' THEN   #MOD-E20099--add
         LET l_sql = l_sql,"   AND abb24 = abb24_temp"
      END IF
   END IF
#FUN-D10072--130123--mod
#  IF tm.k = '2' THEN  #FUN-D10072--130123
#     LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
#  END IF
#MOD-E20099---begin--------------
#   IF tm.k = '1' AND tm.b = 'Y' THEN LET l_sql = l_sql END IF
#   IF tm.k = '1' AND tm.b = 'N' THEN LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' " END IF
#   IF tm.k = '2' AND tm.b = 'Y' THEN LET l_sql = l_sql CLIPPED," AND (aba19 = 'N' or abapost = 'Y') " END IF
   IF tm.b = 'Y' THEN 
      IF tm.k = '1' THEN  
      #   LET l_sql1 = l_sql CLIPPED," AND (aba19 = 'N' OR  aba19 = 'Y')) "    #mark by kuangxj171211
          LET l_sql1 = l_sql CLIPPED," AND (aba19 = 'N' OR  aba19 = 'Y') "    #add by kuangxj171211
      END IF  
      IF tm.k = '2' THEN
         LET l_sql1 = l_sql CLIPPED," AND (aba19 = 'N' OR abapost = 'Y') "
      END IF  
   ELSE    
      IF tm.k = '1' THEN    
         LET l_sql1 = l_sql CLIPPED," AND aba19 = 'Y' " 
      END IF
      IF tm.k = '2' THEN
         LET l_sql1 = l_sql CLIPPED," AND abapost = 'Y' "
      END IF
   END IF
#MOD-E20099---end----------
#FUN-D10072--130123--mod
 #  PREPARE gglq301_prepare3 FROM l_sql   # mark by kuangxj171211
 PREPARE gglq301_prepare3 FROM l_sql1    # add by kuangxj171211
   EXECUTE gglq301_prepare3

   LET tm.wc1 = cl_replace_str(tm.wc1,'aag01','aea05')

   DISPLAY "END  TIME: ",TIME

END FUNCTION

FUNCTION gglq301_b_fill1()
   DEFINE l_type     LIKE type_file.chr1
   DEFINE l_abb06    LIKE abb_file.abb06
   DEFINE l_c,l_d    LIKE abb_file.abb07
   DEFINE l_cf,l_df  LIKE abb_file.abb07   #No.FUN-D10072  Add 2013.01.18
   DEFINE l_c1,l_d1  LIKE abb_file.abb07
   DEFINE l_cf1,l_df1  LIKE abb_file.abb07  #MOD-E20099 add
   DEFINE l_n        LIKE abb_file.abb07
   DEFINE l_nf       LIKE abb_file.abb07   #No.FUN-D10072  Add 2013.01.18
   DEFINE l_mm,i     LIKE type_file.num5
   DEFINE t_aea05    LIKE aea_file.aea05
   DEFINE t_abb24    LIKE abb_file.abb24

   IF tm.a = 'N' THEN
      IF tm.d1 = 'N' THEN
        #LET g_sql = "SELECT aea05,aag02,aea02,aea03,abb04,abb24,abb07f,0,abb07,abb07f,0,abb07,'',balf,0,bal,abb06,type FROM q301_temp2",  #MOD-E20099 mark
         LET g_sql = "SELECT aea05,aag02,aea02,aea03,aba11,abb04,abb24,abb07f_d,0,abb07_d,abb07f_c,0,abb07_c,'',balf,0,bal,abb06,type FROM q301_temp2",  #MOD-E20099 add  #zhouxm150428 add aba11,
                     " WHERE ",tm.wc1 CLIPPED,  #MOD-D60128      
                     "   AND ",tm.wc2 CLIPPED   #MOD-D60128   
                    #" ORDER BY aea05,aea02,abb06"  #FUN-D10072 mark 2013.01.18
         #No.FUN-D10072 ---start--- Add 2013.01.18
         IF tm.n = 'N' THEN
            LET g_sql =g_sql," ORDER BY aea05,aea02,abb06"
         ELSE
            LET g_sql =g_sql," ORDER BY aea05,abb24,aea02,abb06"
         END IF
        #No.FUN-D10072 ---end  --- Add 2013.01.18
      ELSE
        #LET g_sql = "SELECT aea05,aag02,aea02,aea03,abb04,abb24,abb07f,0,abb07,abb07f,0,abb07,'',balf,0,bal,abb06,type FROM q301_temp2",  #MOD-E20099 mark
         LET g_sql = "SELECT aea05,aag02,aea02,aea03,aba11,abb04,abb24,abb07f_d,0,abb07_d,abb07f_c,0,abb07_c,'',balf,0,bal,abb06,type FROM q301_temp2",  #MOD-E20099 add #zhouxm150428 add aba11,
                     " WHERE abb24 = '",g_abb24,"'",
                     "   AND ",tm.wc1 CLIPPED,  #MOD-D60128      
                     "   AND ",tm.wc2 CLIPPED,  #MOD-D60128                  
                     " ORDER BY aea05,abb24,aea02,abb06"
      END IF
   ELSE
      IF tm.d1 = 'N' THEN
        #LET g_sql = "SELECT aea05,aag02,aea02,aea03,abb04,abb24,abb07f,0,abb07,abb07f,0,abb07,'',balf,0,bal,abb06,type FROM q301_temp2",  #MOD-E20099 mark
         LET g_sql = "SELECT aea05,aag02,aea02,aea03,aba11,abb04,abb24,abb07f_d,0,abb07_d,abb07f_c,0,abb07_c,'',balf,0,bal,abb06,type FROM q301_temp2",  #MOD-E20099 add #zhouxm150428 add aba11,
                     " WHERE aea05 = '",g_aea05,"'",
                     "   AND ",tm.wc1 CLIPPED,  #MOD-D60128      
                     "   AND ",tm.wc2 CLIPPED   #MOD-D60128   
                    #" ORDER BY aea05,aea02,abb06"  ##FUN-D10072 mark 2013.01.18
         #No.FUN-D10072 ---start--- Add 2013.01.18
         IF tm.n = 'N' THEN
            LET g_sql =g_sql," ORDER BY aea05,aea02,abb06"
         ELSE
            LET g_sql =g_sql," ORDER BY aea05,abb24,aea02,abb06"
         END IF
        #No.FUN-D10072 ---end  --- Add 2013.01.18
      ELSE
        #LET g_sql = "SELECT aea05,aag02,aea02,aea03,aba11,abb04,abb24,abb07f,0,abb07,abb07f,0,abb07,'',balf,0,bal,abb06,type FROM q301_temp2", #MOD-E20099 mark
         LET g_sql = "SELECT aea05,aag02,aea02,aea03,aba11,abb04,abb24,abb07f_d,0,abb07_d,abb07f_c,0,abb07_c,'',balf,0,bal,abb06,type FROM q301_temp2", #MOD-E20099 add  #zhouxm150428 add aba11,
                     " WHERE abb24 = '",g_abb24,"'",
                     "   AND aea05 = '",g_aea05,"'",
                     "   AND ",tm.wc1 CLIPPED,  #MOD-D60128      
                     "   AND ",tm.wc2 CLIPPED,  #MOD-D60128  
                     " ORDER BY aea05,abb24,aea02,abb06"
      END IF
   END IF

   PREPARE gglq301_pbv FROM g_sql
   DECLARE abb_cursv  CURSOR FOR gglq301_pbv

   CALL g_abbv.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   LET l_c = 0
   LET l_d = 0
   LET l_n = 0
   LET l_c1= 0
   LET l_d1= 0
   LET l_df= 0   #No.FUN-D10072   Add 2013.01.18
   LET l_cf= 0   #No.FUN-D10072   Add 2013.01.18
   LET l_nf= 0   #No.FUN-D10072   Add 2013.01.18
   LET l_df1 = 0 #MOD-E20099 
   LET l_cf1 = 0 #MOD-E20099
  #本幣小數取位
   SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file WHERE azi01 = g_aza.aza17
   FOREACH abb_cursv INTO g_abbv[g_cnt].*,l_abb06,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach abb_curs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

     #計算前期結轉藉方金額、貸方金額
      IF l_abb06 = '0' THEN         
         LET l_d = g_abbv[g_cnt].d             
         #LET l_c = g_abbv[g_cnt].df           #MOD-D70035 mark
         LET l_c = g_abbv[g_cnt].c             #MOD-D70035   
         LET l_n = g_abbv[g_cnt].bal + l_c - l_d  
         #No.FUN-D10072 ---start--- Add 2013.01.18
         #LET l_df= g_abbv[g_cnt].c             #MOD-D70035 mark
         LET l_df= g_abbv[g_cnt].df             #MOD-D70035    
         LET l_cf= g_abbv[g_cnt].cf             
         LET l_nf= g_abbv[g_cnt].balf + l_cf - l_df    
        #No.FUN-D10072---end  --- Add 2013.01.18 

         LET g_abbv[g_cnt].df = NULL
         LET g_abbv[g_cnt].abb25_d = NULL
         LET g_abbv[g_cnt].d = NULL
         LET g_abbv[g_cnt].cf = NULL
         LET g_abbv[g_cnt].abb25_c = NULL
         LET g_abbv[g_cnt].c = NULL

      END IF

     #藉方金額
      IF l_abb06 = '1' THEN
         LET g_abbv[g_cnt].bal = l_d - l_c + l_n + g_abbv[g_cnt].d          
        #LET g_abbv[g_cnt].balf= l_df- l_cf+ l_nf+ g_abbv[g_cnt].df + l_d1  #No.FUN-D10072  Add 2013.01.18   #MOD-D70035 mark
         LET g_abbv[g_cnt].balf= l_df- l_cf+ l_nf+ g_abbv[g_cnt].df         #MOD-D70035   
         LET l_d = l_d + g_abbv[g_cnt].d
         LET l_d1= l_d1+ g_abbv[g_cnt].d
         LET l_df= l_df+ g_abbv[g_cnt].df   #MOD-D70035 add 
         LET l_df1 = l_df1 + g_abbv[g_cnt].df #MOD-E20099
         LET g_abbv[g_cnt].cf = NULL
         LET g_abbv[g_cnt].abb25_c = NULL
         LET g_abbv[g_cnt].c = NULL
         IF g_abbv[g_cnt].d > 0 THEN        
           #LET g_abbv[g_cnt].abb25_d = g_abbv[g_cnt].df / g_abbv[g_cnt].d   #TQC-D20065
            LET g_abbv[g_cnt].abb25_d = g_abbv[g_cnt].d / g_abbv[g_cnt].df   #TQC-D20065
         END IF
         #No.FUN-D10072 ---start--- Add 2013.01.18 
         IF g_abbv[g_cnt].bal > 0 THEN
           #LET g_abbv[g_cnt].abb25_bal = g_abbv[g_cnt].balf / g_abbv[g_cnt].bal  #TQC-D20065
            LET g_abbv[g_cnt].abb25_bal = g_abbv[g_cnt].bal / g_abbv[g_cnt].balf  #TQC-D20065
         END IF
        #No.FUN-D10072---end  --- Add 2013.01.18
      END IF

     #貸方金額
      IF l_abb06 = '2' THEN
         LET g_abbv[g_cnt].cf = g_abbv[g_cnt].df   
         LET g_abbv[g_cnt].c = g_abbv[g_cnt].d     
         LET g_abbv[g_cnt].bal = l_d - l_c + l_n - g_abbv[g_cnt].c           
        #LET g_abbv[g_cnt].balf= l_df- l_cf+ l_nf- g_abbv[g_cnt].cf + l_c1   #No.FUN-D10072  Add 2013.01.18   #MOD-D70035 mark
         LET g_abbv[g_cnt].balf= l_df- l_cf+ l_nf- g_abbv[g_cnt].cf          #MOD-D70035   
         LET l_c = l_c + g_abbv[g_cnt].c
         LET l_c1= l_c1+ g_abbv[g_cnt].c
         LET l_cf= l_cf+ g_abbv[g_cnt].cf    #MOD-D70035 add
         LET l_cf1 = l_cf1 + g_abbv[g_cnt].cf #MOD-E20099
         LET g_abbv[g_cnt].df = NULL
         LET g_abbv[g_cnt].abb25_d = NULL
         LET g_abbv[g_cnt].d = NULL
         IF g_abbv[g_cnt].c > 0 THEN
           #LET g_abbv[g_cnt].abb25_c = g_abbv[g_cnt].cf / g_abbv[g_cnt].c  #TQC-D20065
            LET g_abbv[g_cnt].abb25_c = g_abbv[g_cnt].c / g_abbv[g_cnt].cf  #TQC-D20065
         END IF
         #No.FUN-D10072 ---start--- Add 2013.01.18 
         IF g_abbv[g_cnt].bal > 0 THEN
           #LET g_abbv[g_cnt].abb25_bal = g_abbv[g_cnt].balf / g_abbv[g_cnt].bal  #TQC-D20065
            LET g_abbv[g_cnt].abb25_bal = g_abbv[g_cnt].bal / g_abbv[g_cnt].balf  #TQC-D20065
         END IF
        #No.FUN-D10072 ---end  --- Add 2013.01.18 
      END IF

      IF l_type = '1' THEN
          LET g_abbv[g_cnt].abb04 = cl_getmsg('ggl-010',g_lang)
      END IF
      IF l_type = '3' THEN
         #MOD-E20099--begin-----mark----
#         LET g_abbv[g_cnt].df = NULL
#         LET g_abbv[g_cnt].abb25_d = NULL
#         LET g_abbv[g_cnt].cf = NULL
#         LET g_abbv[g_cnt].abb25_c = NULL         
         #MOD-E20099--end-----mark----
         LET g_abbv[g_cnt].abb04 = cl_getmsg('ggl-011',g_lang)
         LET g_abbv[g_cnt].d = l_d1
         LET g_abbv[g_cnt].c = l_c1
         LET g_abbv[g_cnt].bal = l_d - l_c + l_n   
         LET l_d1 = 0
         LET l_c1 = 0
         #MOD-E20099---begin
         LET g_abbv[g_cnt].df = l_df1               
         LET g_abbv[g_cnt].cf = l_cf1       
         LET g_abbv[g_cnt].balf = l_df - l_cf + l_nf
         LET l_df1 = 0
         LET l_cf1 = 0         
         LET g_abbv[g_cnt].abb25_d = g_abbv[g_cnt].d / g_abbv[g_cnt].df
         LET g_abbv[g_cnt].abb25_c = g_abbv[g_cnt].c / g_abbv[g_cnt].cf
         #MOD-E20099---end
      END IF
      IF l_type = '4' THEN
         #MOD-E20099--begin--mark------
#         LET g_abbv[g_cnt].df = NULL
#         LET g_abbv[g_cnt].abb25_d = NULL
#         LET g_abbv[g_cnt].cf = NULL
#         LET g_abbv[g_cnt].abb25_c = NULL
         #MOD-E20099--end-----mark---
         LET g_abbv[g_cnt].abb04 = cl_getmsg('ggl-012',g_lang)
         LET g_abbv[g_cnt].d = l_d
         LET g_abbv[g_cnt].c = l_c
         LET g_abbv[g_cnt].bal = g_abbv[g_cnt].d - g_abbv[g_cnt].c + l_n
         #MOD-E20099--Begin         
         LET g_abbv[g_cnt].df = l_df
         LET g_abbv[g_cnt].cf = l_cf
         LET g_abbv[g_cnt].balf = g_abbv[g_cnt].df - g_abbv[g_cnt].cf + l_nf
         LET g_abbv[g_cnt].abb25_d = g_abbv[g_cnt].d / g_abbv[g_cnt].df
         LET g_abbv[g_cnt].abb25_c = g_abbv[g_cnt].c / g_abbv[g_cnt].cf        
         #MOD-E20099--end
         
      END IF


      IF g_abbv[g_cnt].bal < 0 THEN
         LET g_abbv[g_cnt].dc = cl_getmsg('ggl-212',g_lang)
         LET g_abbv[g_cnt].bal = g_abbv[g_cnt].bal * (-1)
      ELSE
         IF g_abbv[g_cnt].bal > 0 THEN
            LET g_abbv[g_cnt].dc = cl_getmsg('ggl-211',g_lang)
         ELSE
            LET g_abbv[g_cnt].dc = cl_getmsg('ggl-210',g_lang)
         END IF
      END IF

    #小數取位、數字截位
    IF l_abb06 != '0' THEN    #No.FUN-D10072   Add 2013.01.18
      LET g_abbv[g_cnt].d   = cl_digcut(g_abbv[g_cnt].d,g_azi04)
      LET g_abbv[g_cnt].c   = cl_digcut(g_abbv[g_cnt].c,g_azi04)
      LET g_abbv[g_cnt].bal = cl_digcut(g_abbv[g_cnt].bal,g_azi04)
      LET g_abbv[g_cnt].d   = cl_numfor(g_abbv[g_cnt].d,20,g_azi04)
      LET g_abbv[g_cnt].c   = cl_numfor(g_abbv[g_cnt].c,20,g_azi04)
      LET g_abbv[g_cnt].bal = cl_numfor(g_abbv[g_cnt].bal,20,g_azi04)
    END IF #FUN-D10072
      IF tm.n = 'Y'  THEN
         SELECT azi04,azi05,azi07 INTO g_azi04,g_azi05,g_azi07 FROM azi_file WHERE azi01 = g_abb[g_cnt].abb24
         IF g_abbv[g_cnt].balf < 0 THEN
            LET g_abbv[g_cnt].balf = g_abbv[g_cnt].balf * (-1)
         END IF
         IF g_abbv[g_cnt].bal != 0 THEN
           #LET g_abbv[g_cnt].abb25_bal = g_abbv[g_cnt].balf / g_abbv[g_cnt].bal  #TQC-D20065
            LET g_abbv[g_cnt].abb25_bal = g_abbv[g_cnt].bal / g_abbv[g_cnt].balf  #TQC-D20065
         END IF
         IF l_type = '2' THEN
            IF l_abb06 = '1' THEN    #No.FUN-D10072   Add 2013.01.18
               LET g_abbv[g_cnt].df       = cl_digcut(g_abbv[g_cnt].df,g_azi04)
               LET g_abbv[g_cnt].abb25_d  = cl_digcut(g_abbv[g_cnt].abb25_d,g_azi07)
               LET g_abbv[g_cnt].df       = cl_numfor(g_abbv[g_cnt].df,20,t_azi04)
               LET g_abbv[g_cnt].abb25_d  = cl_numfor(g_abbv[g_cnt].abb25_d,20,t_azi07)
            ELSE                     #No.FUN-D10072   Add 2013.01.18
               LET g_abbv[g_cnt].cf       = cl_digcut(g_abbv[g_cnt].cf,g_azi04)
               LET g_abbv[g_cnt].abb25_c  = cl_digcut(g_abbv[g_cnt].abb25_c,g_azi07) 
               LET g_abbv[g_cnt].cf       = cl_numfor(g_abbv[g_cnt].cf,20,t_azi04)
               LET g_abbv[g_cnt].abb25_c  = cl_numfor(g_abbv[g_cnt].abb25_c,20,t_azi07)
            END IF                   #No.FUN-D10072   Add 2013.01.18
           #LET g_abbv[g_cnt].balf     = cl_digcut(g_abbv[g_cnt].cf,g_azi04)   #FUN-D10072 0118 mark
            LET g_abbv[g_cnt].balf     = cl_digcut(g_abbv[g_cnt].balf,g_azi04) #FUN-D10072 0118 add
            LET g_abbv[g_cnt].balf     = cl_numfor(g_abbv[g_cnt].balf,20,t_azi04)
         END IF
         LET g_abbv[g_cnt].abb25_bal= cl_digcut(g_abbv[g_cnt].abb25_bal,g_azi07) 
         LET g_abbv[g_cnt].abb25_bal= cl_numfor(g_abbv[g_cnt].abb25_bal,20,t_azi07)
      ELSE
         LET g_abbv[g_cnt].balf = NULL
         LET g_abbv[g_cnt].abb25_bal = NULL
      END IF
      #No.FUN-D10072 ---start--- Add  2013.01.18
      #MOD-E20099--mark--begin
#      IF l_type = '3' OR l_type = '4' THEN
#         LET g_abbv[g_cnt].balf = NULL
#         LET g_abbv[g_cnt].abb25_bal = NULL
#      END IF
      #MOD-E20099--mark--end
     #No.FUN-D10072 ---end  --- Add  2013.01.18
      #darcy:2022/10/26 add s---
      execute crt_q301_into USING
      g_abbv[g_cnt].aea05,
      g_abbv[g_cnt].aag02,
      g_abbv[g_cnt].aea02,
      g_abbv[g_cnt].aea03,
      g_abbv[g_cnt].aba11,
      g_abbv[g_cnt].abb04,
      g_abbv[g_cnt].abb24,
      g_abbv[g_cnt].df,
      g_abbv[g_cnt].abb25_d,
      g_abbv[g_cnt].d,
      g_abbv[g_cnt].cf,
      g_abbv[g_cnt].abb25_c,
      g_abbv[g_cnt].c,
      g_abbv[g_cnt].dc,
      g_abbv[g_cnt].balf,
      g_abbv[g_cnt].abb25_bal,
      g_abbv[g_cnt].bal 
      #darcy:2022/10/26 add e---
      LET g_cnt = g_cnt + 1
      IF g_cnt > 1000000  THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      
   END FOREACH
   CALL g_abbv.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1

END FUNCTION

FUNCTION gglq301_table1()
   DROP TABLE q301_temp;
  CREATE TEMP TABLE q301_temp(
                   aag01       LIKE aag_file.aag01,
                   aag02       LIKE aag_file.aag02,
                   aag08       LIKE aag_file.aag08,
                   aag07       LIKE aag_file.aag07,
                   aag24       LIKE aag_file.aag24);

   DROP TABLE q301_temp1;
  CREATE TEMP TABLE q301_temp1(
                   aag01       LIKE aag_file.aag01,
                   abb24_temp  LIKE abb_file.abb24,
                   aag02       LIKE aag_file.aag02,
                   aag08       LIKE aag_file.aag08,
                   aag07       LIKE aag_file.aag07,
                   aag24       LIKE aag_file.aag24);

   DROP TABLE q301_temp2;
  CREATE TEMP TABLE q301_temp2(
                   aea05       LIKE aea_file.aea05,
                   aag02       LIKE type_file.chr1000,
                   curr        LIKE abb_file.abb24,
                   aba04       LIKE aba_file.aba04,
                   type        LIKE type_file.chr1,
                   aea02       LIKE aea_file.aea02,
                   aea03       LIKE aea_file.aea03,
                   aba11       LIKE aba_file.aba11, #zhouxm150428 add 
                   aea04       LIKE aea_file.aea04,
                   abb04       LIKE abb_file.abb04,
                   abb24       LIKE abb_file.abb24,
                   abb06       LIKE abb_file.abb06,
                   abb07_d     LIKE abb_file.abb07,    #MOD-E20099 
                   abb07f_d    LIKE abb_file.abb07f,   #MOD-E20099 
                   abb07_c     LIKE abb_file.abb07,    #MOD-E20099 
                   abb07f_c    LIKE abb_file.abb07f,   #MOD-E20099 
                   bal         LIKE abb_file.abb07,
                   balf        LIKE abb_file.abb07,
                   aag07       LIKE aag_file.aag07);   
   
END FUNCTION
#No.FUN-CB0146 ---end  --- Add

FUNCTION gglq301_cs()
#FUN-C80102--mark--str---
#    IF tm.a = 'Y' THEN  #No:FUN-C70061 add
#       LET g_sql = "SELECT UNIQUE aea05,aag02,curr FROM gglq301_tmp ",
#                   " ORDER BY aea05,aag02,curr "
#    ELSE #No:FUN-C70061 add
#       LET g_sql = "SELECT UNIQUE '','',curr FROM gglq301_tmp ", #No:FUN-C70061 add
#                   " ORDER BY curr " #No:FUN-C70061 add
#    END IF #No:FUN-C70061 add
#    PREPARE gglq301_ps FROM g_sql
#    DECLARE gglq301_curs SCROLL CURSOR WITH HOLD FOR gglq301_ps

#    IF tm.a = 'Y' THEN  #No:FUN-C70061 add
#       LET g_sql = "SELECT UNIQUE aea05,aag02,curr FROM gglq301_tmp ",
#                   "  INTO TEMP x "
#    ELSE #No:FUN-C70061 add
#       LET g_sql = "SELECT UNIQUE curr FROM gglq301_tmp ", #No:FUN-C70061 add
#                   "  INTO TEMP x "  #No:FUN-C70061 add
#    END IF #No:FUN-C70061 add
#    DROP TABLE x
#    PREPARE gglq301_ps1 FROM g_sql
#    EXECUTE gglq301_ps1
#FUN-C80102--mark--end---

#FUN-C80102--add--str---
     LET tm.wc1 = cl_replace_str(tm.wc1,"aag01","aea05")    #FUN-C80102
     IF tm.a = 'Y' THEN  #No:FUN-C70061 add
        IF tm.d1 = 'Y' THEN 
        LET g_sql = "SELECT UNIQUE aea05,aag02,abb24 FROM q301_temp2 ",   #No.FUN-CB0146  Mod gglq301_tmp --> q301_temp2
                    " WHERE ",tm.wc1 CLIPPED,                
                    "   AND ",tm.wc2 CLIPPED,  #FUN-C80102   
                    " ORDER BY aea05,aag02,abb24 "
        ELSE
        LET g_sql = "SELECT UNIQUE aea05,aag02,'' FROM q301_temp2 ",   #No.FUN-CB0146  Mod gglq301_tmp --> q301_temp2
                    " WHERE ",tm.wc1 CLIPPED,               
                    "   AND ",tm.wc2 CLIPPED,  #FUN-C80102  
                    " ORDER BY aea05,aag02 "
        END IF
     ELSE #No:FUN-C70061 add
        IF tm.d1 = 'Y' THEN 
        LET g_sql = "SELECT UNIQUE '','',abb24 FROM q301_temp2 ", #No:FUN-C70061 add  #No.FUN-CB0146  Mod gglq301_tmp --> q301_temp2
                    " WHERE ",tm.wc1 CLIPPED,               
                    "   AND ",tm.wc2 CLIPPED,  #FUN-C80102  
                    " ORDER BY abb24 " #No:FUN-C70061 add
        ELSE
        LET g_sql = "SELECT UNIQUE '','','' FROM q301_temp2 ", #No:FUN-C70061 add   #No.FUN-CB0146  Mod gglq301_tmp --> q301_temp2
                    " WHERE ",tm.wc1 CLIPPED,               
                    "   AND ",tm.wc2 CLIPPED   #FUN-C80102  
        END IF 
     END IF #No:FUN-C70061 add
     PREPARE gglq301_ps FROM g_sql
     DECLARE gglq301_curs SCROLL CURSOR WITH HOLD FOR gglq301_ps
#FUN-C80102--add--end---

#FUN-C80102--mark--str---
#    IF tm.a = 'Y' THEN  #No:FUN-C70061 add
#       LET g_sql = "SELECT UNIQUE aea05,aag02,abb24 FROM gglq301_tmp ",
#                   " WHERE ",tm.wc1 CLIPPED,
#                   "  INTO TEMP x "
#    ELSE #No:FUN-C70061 add
#       LET g_sql = "SELECT UNIQUE abb24 FROM gglq301_tmp ", #No:FUN-C70061 add
#                   " WHERE ",tm.wc1 CLIPPED,
#                   "  INTO TEMP x "  #No:FUN-C70061 add
#    END IF #No:FUN-C70061 add
#FUN-C80102--mark--end---

#FUN-C80102--add--str---
     IF tm.a = 'Y' THEN  #No:FUN-C70061 add
        IF tm.d1 = 'Y' THEN 
#           LET g_sql = "SELECT UNIQUE aea05,aag02,abb24 FROM gglq301_tmp ",  #MOD-D60128 mark
           LET g_sql = "SELECT UNIQUE aea05,aag02,abb24 FROM q301_temp2 ",    #MOD-D60128
                       " WHERE ",tm.wc1 CLIPPED,                   
                       "   AND ",tm.wc2 CLIPPED,  #FUN-C80102      
                       "  INTO TEMP x "
        ELSE
#           LET g_sql = "SELECT UNIQUE aea05,aag02 FROM gglq301_tmp ",      #MOD-D60128  mark
           LET g_sql = "SELECT UNIQUE aea05,aag02 FROM q301_temp2 ",        #MOD-D60128
                       " WHERE ",tm.wc1 CLIPPED,                   
                       "   AND ",tm.wc2 CLIPPED,  #FUN-C80102      
                       "  INTO TEMP x "
        END IF
     ELSE #No:FUN-C70061 add
        IF tm.d1 = 'Y' THEN 
#           LET g_sql = "SELECT UNIQUE abb24 FROM gglq301_tmp ", #No:FUN-C70061 add  #MOD-D60128 mark
           LET g_sql = "SELECT UNIQUE abb24 FROM q301_temp2 ", #No:FUN-C70061 add    #MOD-D60128 mark
                       " WHERE ",tm.wc1 CLIPPED,                  
                       "   AND ",tm.wc2 CLIPPED,  #FUN-C80102     
                       "  INTO TEMP x "  #No:FUN-C70061 add
        END IF
     END IF #No:FUN-C70061 add
#FUN-C80102--add--end---
     DROP TABLE x
     PREPARE gglq301_ps1 FROM g_sql
     EXECUTE gglq301_ps1
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq301_ps2 FROM g_sql
     DECLARE gglq301_cnt CURSOR FOR gglq301_ps2

     OPEN gglq301_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq301_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN gglq301_cnt
        FETCH gglq301_cnt INTO g_row_count
        IF tm.a = 'N' AND tm.d1 = 'N' THEN 
           LET g_row_count = 1
        END IF
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq301_fetch('F')
     END IF
END FUNCTION

FUNCTION gglq301_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10

   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq301_curs INTO g_aea05,g_aag02,g_abb24
      WHEN 'P' FETCH PREVIOUS gglq301_curs INTO g_aea05,g_aag02,g_abb24
      WHEN 'F' FETCH FIRST    gglq301_curs INTO g_aea05,g_aag02,g_abb24
      WHEN 'L' FETCH LAST     gglq301_curs INTO g_aea05,g_aag02,g_abb24
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
         FETCH ABSOLUTE g_jump gglq301_curs INTO g_aea05,g_aag02,g_abb24
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aea05,SQLCA.sqlcode,0)
      INITIALIZE g_aea05 TO NULL
      INITIALIZE g_aag02 TO NULL
      INITIALIZE g_abb24 TO NULL
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

   CALL gglq301_show()
END FUNCTION

FUNCTION gglq301_show()

#FUN-C80102---mark--str--
#  DISPLAY g_aea05 TO aea05
#  DISPLAY g_aag02 TO aag02
#FUN-C80102---mark--str--
   DISPLAY yy TO yy
  #DISPLAY g_abb24 TO b
#FUN-C80102--add--str--
   DISPLAY tm.n TO n     
   DISPLAY tm.d1 TO d1     
   DISPLAY tm.e TO e     
   DISPLAY tm.h TO h     
   DISPLAY tm.a TO a     
   DISPLAY tm.k TO k     
   DISPLAY tm.b TO b   #FUN-D10072 130123 add
   DISPLAY tm.lvl TO lvl 
   DISPLAY tm.bookno TO bookno 
   DISPLAY tm.bdate TO bdate 
   DISPLAY tm.edate TO edate 
#FUN-C80102--add--end--    

  #CALL gglq301_b_fill()   #No.FUN-CB0146   Mark
   CALL gglq301_b_fill1()  #No.FUN-CB0146   Add

   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION gglq301_b_fill()
  DEFINE  l_abb06    LIKE abb_file.abb06
  DEFINE  l_type     LIKE type_file.chr1
  LET tm.wc1 = cl_replace_str(tm.wc1,"aag01","aea05")    #FUN-C80102

  IF tm.a = 'Y' THEN #FUN-C70061 add
     #LET g_sql = "SELECT '','', aea02,aea03,abb04,abb24,df,abb25_d,d,",#FUN-C70061 add '',''  #FUN-C80102
      IF tm.d1 = 'Y' THEN #FUN-C80102 
          LET g_sql = "SELECT aea05,'',aea02,aea03,abb04,abb24,df,abb25_d,d,",#FUN-C70061 add '',''  #FUN-C80102
               "       cf,abb25_c,c,dc,balf,abb25_bal,bal,",
               "       azi04,azi05,azi07,abb06,type ",
               " FROM gglq301_tmp",
               " WHERE aea05 ='",g_aea05,"'",   
              #"   AND curr  ='",g_abb24,"'",  
               "   AND abb24  ='",g_abb24,"'",  
               "   AND ",tm.wc1 CLIPPED,  #FUN-C80102      
               "   AND ",tm.wc2 CLIPPED,  #FUN-C80102      
               " ORDER BY aba04,type,aea02,aea03,aea04 "
#FUN-C80102--add---str--
      ELSE
          LET g_sql = "SELECT aea05,'',aea02,aea03,abb04,abb24,df,abb25_d,d,",#FUN-C70061 add '',''  #FUN-C80102
               "       cf,abb25_c,c,dc,balf,abb25_bal,bal,",
               "       azi04,azi05,azi07,abb06,type ",
               " FROM gglq301_tmp",
               " WHERE aea05 ='",g_aea05,"'",
               "   AND ",tm.wc1 CLIPPED,  #FUN-C80102     
               "   AND ",tm.wc2 CLIPPED,  #FUN-C80102    
               " ORDER BY aba04,type,aea02,aea03,aea04 "
      END IF
#FUN-C80102--add---end--
   #No.FUN-C70061 --add--str
   ELSE
      IF tm.d1 = 'Y' THEN #FUN-C80102
      LET g_sql = "SELECT aea05 ,'', aea02,aea03,abb04,abb24,df,abb25_d,d,",#FUN-C70061 add '',''
               "       cf,abb25_c,c,dc,balf,abb25_bal,bal,",
               "       azi04,azi05,azi07,abb06,type ",
               " FROM gglq301_tmp",
              #"  WHERE curr  ='",g_abb24,"'",
               "  WHERE abb24  ='",g_abb24,"'",
               "   AND ",tm.wc1 CLIPPED,  #FUN-C80102
               "   AND ",tm.wc2 CLIPPED,  #FUN-C80102
               " ORDER BY aea05,aba04,type,aea02,aea03,aea04 "
#FUN-C80102--add--str---
     ELSE
     LET g_sql = "SELECT aea05 ,'', aea02,aea03,abb04,abb24,df,abb25_d,d,",#FUN-C70061 add '',''
               "       cf,abb25_c,c,dc,balf,abb25_bal,bal,",
               "       azi04,azi05,azi07,abb06,type ",
               " FROM gglq301_tmp",
               " WHERE   ",tm.wc1 CLIPPED,  #FUN-C80102
               "   AND ",tm.wc2 CLIPPED,  #FUN-C80102
               " ORDER BY aea05,aba04,type,aea02,aea03,aea04 " 
    END IF
#FUN-C80102--add--end---
   END IF
   #No.FUN-C70061 --add--end
   PREPARE gglq301_pb FROM g_sql
   DECLARE abb_curs  CURSOR FOR gglq301_pb

   CALL g_abb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH abb_curs INTO g_abb[g_cnt].*,t_azi04,t_azi05,t_azi07,l_abb06,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach abb_curs:',SQLCA.sqlcode,1)  #No.FUN-8A0028
         EXIT FOREACH
      END IF
      LET g_abb[g_cnt].d        = cl_numfor(g_abb[g_cnt].d,20,g_azi04)
      LET g_abb[g_cnt].c        = cl_numfor(g_abb[g_cnt].c,20,g_azi04)
      LET g_abb[g_cnt].bal      = cl_numfor(g_abb[g_cnt].bal,20,g_azi04)
      LET g_abb[g_cnt].df       = cl_numfor(g_abb[g_cnt].df,20,t_azi04)
      LET g_abb[g_cnt].cf       = cl_numfor(g_abb[g_cnt].cf,20,t_azi04)
      LET g_abb[g_cnt].balf     = cl_numfor(g_abb[g_cnt].balf,20,t_azi04)
      LET g_abb[g_cnt].abb25_d  = cl_numfor(g_abb[g_cnt].abb25_d,20,t_azi07)
      LET g_abb[g_cnt].abb25_c  = cl_numfor(g_abb[g_cnt].abb25_c,20,t_azi07)
      LET g_abb[g_cnt].abb25_bal= cl_numfor(g_abb[g_cnt].abb25_bal,20,t_azi07)
      
      #NO.FUN-C70061 add--------------begin
     #SELECT aag02 INTO g_abb[g_cnt].aag02_1 FROM aag_file  #FUN-C80102
     # WHERE aag01 = g_abb[g_cnt].aea05_1                   #FUN-C80102
      SELECT aag02 INTO g_abb[g_cnt].aag02   FROM aag_file  #FUN-C80102
       WHERE aag01 = g_abb[g_cnt].aea05                     #FUN-C80102
   #NO.FUN-C70061 add----------------end
   
      IF l_type = '1' THEN
         LET g_abb[g_cnt].d         = NULL
         LET g_abb[g_cnt].df        = NULL
         LET g_abb[g_cnt].abb25_d   = NULL
         LET g_abb[g_cnt].c         = NULL
         LET g_abb[g_cnt].cf        = NULL
         LET g_abb[g_cnt].abb25_c   = NULL 
        #IF tm.d= 'N' AND cl_null(tm.curr) THEN   #MOD-C50025  #No.FUN-C80102  Mark
         IF tm.d1= 'N' THEN                                    #No.FUN-C80102  Add
            LET g_abb[g_cnt].balf      = NULL
            LET g_abb[g_cnt].abb25_bal = NULL
         END IF
      END IF
        #IF tm.d= 'N' AND cl_null(tm.curr) THEN   #MOD-C50025  #No.FUN-C80102  Mark
         IF tm.d1= 'N' THEN                                    #No.FUN-C80102  Add
         IF l_type = '3' OR l_type = '4' THEN
            LET g_abb[g_cnt].df        = NULL
            LET g_abb[g_cnt].cf        = NULL
            LET g_abb[g_cnt].balf      = NULL
            LET g_abb[g_cnt].abb25_d   = NULL
            LET g_abb[g_cnt].abb25_c   = NULL
            LET g_abb[g_cnt].abb25_bal = NULL
         END IF
         IF l_type = '2' THEN
            LET g_abb[g_cnt].balf      = NULL
            LET g_abb[g_cnt].abb25_bal = NULL
         END IF
      END IF
      IF l_abb06 = '1' THEN
         LET g_abb[g_cnt].c       = NULL
         LET g_abb[g_cnt].cf      = NULL
         LET g_abb[g_cnt].abb25_c = NULL
      END IF
      IF l_abb06 = '2' THEN
         LET g_abb[g_cnt].d       = NULL
         LET g_abb[g_cnt].df      = NULL
         LET g_abb[g_cnt].abb25_d = NULL
      END IF
#FUN-C80102--mark--str--
#     IF tm.d1= 'N' AND cl_null(tm.curr) THEN  #MOD-C50025
#        IF l_type <> '2' THEN
#           LET g_abb[g_cnt].abb24 = NULL
#        END IF
#     END IF
#FUN-C80102--mark--end--
      LET g_cnt = g_cnt + 1
      IF g_cnt > 1000000 THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_abb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1

END FUNCTION

FUNCTION gglq301_sjkm(l_aag01,l_aag24)
   DEFINE l_aag24             LIKE aag_file.aag24
   DEFINE l_aag01             LIKE aag_file.aag01
   DEFINE s_aag08             LIKE aag_file.aag08
   DEFINE s_aag24             LIKE aag_file.aag24
   DEFINE s_aag02             LIKE aag_file.aag02
   DEFINE s_aag13             LIKE aag_file.aag13
   DEFINE p_aag02,p_aag021    LIKE type_file.chr1000
   DEFINE l_success,l_i       LIKE type_file.num5
   LET l_success = 1
   LET l_i = 1
   WHILE l_success
   SELECT aag02,aag13,aag08,aag24 INTO s_aag02,s_aag13,s_aag08,s_aag24
     FROM aag_file
    WHERE aag01 = l_aag01
      AND aag00 = tm.bookno
   IF SQLCA.sqlcode THEN
      LET l_success = 0
      EXIT WHILE
   END IF
   IF tm.e = 'Y' THEN LET s_aag02 = s_aag13 END IF
   IF l_i = 1 THEN
      LET p_aag02 = s_aag02
   ELSE
      LET p_aag021 = p_aag02
      LET p_aag02 = s_aag02 CLIPPED,'-',p_aag021 CLIPPED
   END IF
   LET l_i = l_i + 1
   IF s_aag24 = 1 OR s_aag08 = l_aag01 THEN LET l_success = 1 EXIT WHILE END IF
   LET l_aag01 = s_aag08
   LET l_aag24 = l_aag24 - 1
   END WHILE
   RETURN p_aag02
END FUNCTION

REPORT gglq301_rep(sr)
   DEFINE sr,sr0             RECORD
                             aea05  LIKE aea_file.aea05,    #科目
                             curr   LIKE azi_file.azi01,    #幣種 tm.d='Y'時,curr=abb24,否則為單一值
                             aea02  LIKE aea_file.aea02,    #傳票日期
                             aea03  LIKE aea_file.aea03,    #傳票編號
                            # aba11  LIKE aba_file.aba11,    #凭证总号 zhouxm150428 add
                             aea04  LIKE aea_file.aea04,    #傳票項次
                             aba04  LIKE aba_file.aba04,    #期間
                             aba02  LIKE aba_file.aba02,    #傳票日期
                             abb04  LIKE abb_file.abb04,    #摘要
                             abb24  LIKE abb_file.abb24,    #實際異動幣種
                             abb25  LIKE abb_file.abb25,    #匯率
                             abb06  LIKE abb_file.abb06,    #借/貸
                             abb07  LIKE abb_file.abb07,    #實際異動本幣值
                             abb07f LIKE abb_file.abb07f,   #實際異動原幣值
                             aag02  LIKE type_file.chr1000, #科目名稱
                             aag08  LIKE aag_file.aag08,    #上級科目
                             qc0    LIKE abb_file.abb07,    #年初本幣余額
                             qc0f   LIKE abb_file.abb07,    #年初原幣余額
                             qc_md  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借本幣金額
                             qc_mdf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借原幣金額
                             qc_mc  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸本幣金額
                             qc_mcf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸原幣金額
                             qc_yd  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借本幣金額
                             qc_ydf LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借原幣金額
                             qc_yc  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的貸本幣金額
                             qc_ycf LIKE abb_file.abb07     #1~MONTH(bdate)月-1的貸原幣金額
                             END RECORD
   DEFINE l_qcyd             RECORD      #按月累計當月的異動值
                             d      LIKE abb_file.abb07,
                             df     LIKE abb_file.abb07,
                             c      LIKE abb_file.abb07,
                             cf     LIKE abb_file.abb07
                             END RECORD
   DEFINE l_bal,l_balf           LIKE abb_file.abb07  #余額
   DEFINE t_debit,t_debitf             LIKE abb_file.abb07
   DEFINE t_credit,t_creditf           LIKE abb_file.abb07
   DEFINE l_d,l_df,l_c,l_cf            LIKE abb_file.abb07
   DEFINE n_bal,n_balf                 LIKE type_file.num20_6
   DEFINE l_abb25_c,l_abb25_d,l_abb25_bal LIKE abb_file.abb25
   DEFINE l_date2                      LIKE type_file.dat
   DEFINE l_dc                         LIKE type_file.chr10
   DEFINE l_year                       LIKE type_file.num10
   DEFINE l_month                      LIKE type_file.num10

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line

   ORDER BY sr.aea05,sr.curr,sr.aba04,sr.aea02,sr.aea03,sr.aea04

  FORMAT
   PAGE HEADER
      LET g_pageno = g_pageno + 1

   BEFORE GROUP OF sr.curr
      LET l_bal = 0
      LET l_balf= 0
      LET l_qcyd.d = 0 
      LET l_qcyd.df= 0 
      LET l_qcyd.c = 0 
      LET l_qcyd.cf= 0 
      LET t_debit  = 0
      LET t_debitf = 0
      LET t_credit = 0
      LET t_creditf= 0

      IF sr.aba04 = -1 THEN
         LET l_bal = l_bal + sr.qc0 + sr.qc_md - sr.qc_mc + sr.qc_yd - sr.qc_yc
         LET l_balf= l_balf+ sr.qc0f+ sr.qc_mdf- sr.qc_mcf+ sr.qc_ydf- sr.qc_ycf
         LET l_qcyd.d = l_qcyd.d + sr.qc_md
         LET l_qcyd.df= l_qcyd.df+ sr.qc_mdf
         LET l_qcyd.c = l_qcyd.c + sr.qc_mc
         LET l_qcyd.cf= l_qcyd.cf+ sr.qc_mcf
         LET t_debit  = t_debit  + sr.qc_yd  + sr.qc_md
         LET t_debitf = t_debitf + sr.qc_ydf + sr.qc_mdf
         LET t_credit = t_credit + sr.qc_yc  + sr.qc_mc
         LET t_creditf= t_creditf+ sr.qc_ycf + sr.qc_mcf
      END IF

      LET l_date2 = tm.bdate
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.abb24
      IF l_bal > 0 THEN
         LET n_bal = l_bal
         LET n_balf= l_balf
         LET l_dc  = g_x[28]
      ELSE
         IF l_bal = 0 THEN
            LET n_bal = l_bal
            LET n_balf= l_balf
            LET l_dc  = g_x[53]
         ELSE
            LET n_bal = l_bal * -1
            LET n_balf= l_balf* -1
            LET l_dc = g_x[29]
         END IF
      END IF

      LET g_msg = g_x[27]
      LET l_abb25_bal = n_bal / n_balf
      IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
      INSERT INTO gglq301_tmp
      VALUES(sr.aea05,sr.aag02,sr.curr,sr.aba04,'1',l_date2,'','',g_msg,sr.abb24,
             '',0,0,0,0,0,0,0,0,l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)

   AFTER GROUP OF sr.aba04
      #打印當頁的 "1.前期結轉" 部分 資料來源為aba04=-1的期初值
      IF sr.aba04 = -1 THEN
      ELSE      #正常月每月結束,要打印當月的"3.本期合計"及"4.本年合計"
         CALL s_yp(tm.edate) RETURNING l_year,l_month
         IF sr.aba04 = l_month THEN
            LET sr.aba02 = tm.edate
         END IF

         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24

         IF l_bal > 0 THEN
            LET n_bal = l_bal
            LET n_balf= l_balf
            LET l_dc  = g_x[28]
         ELSE
            IF l_bal = 0 THEN
               LET n_bal = l_bal
               LET n_balf= l_balf
               LET l_dc  = g_x[53]
            ELSE
               LET n_bal = l_bal * -1
               LET n_balf= l_balf* -1
               LET l_dc = g_x[29]
            END IF
         END IF

         LET l_d = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
         LET l_df= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '1' AND sr.abb07 IS NOT NULL
         LET l_c = GROUP SUM(sr.abb07)  WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
         LET l_cf= GROUP SUM(sr.abb07f) WHERE sr.abb06 = '2' AND sr.abb07 IS NOT NULL
         IF cl_null(l_d)  THEN LET l_d  = 0 END IF
         IF cl_null(l_df) THEN LET l_df = 0 END IF
         IF cl_null(l_c)  THEN LET l_c  = 0 END IF
         IF cl_null(l_cf) THEN LET l_cf = 0 END IF
         IF sr.aba04 = mm THEN  #若為第一個月時,要加上月初未打印的部分
            LET l_d = l_d + l_qcyd.d
            LET l_df= l_df+ l_qcyd.df
            LET l_c = l_c + l_qcyd.c
            LET l_cf= l_cf+ l_qcyd.cf
         END IF
         LET g_msg = g_x[19]
         LET l_abb25_d = l_d / l_df        
         LET l_abb25_c = l_c / l_cf        
         LET l_abb25_bal = n_bal / n_balf  
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq301_tmp
         VALUES(sr.aea05,sr.aag02,sr.curr,sr.aba04,'3',sr.aba02,'','',g_msg,sr.abb24,
                '',0,0,l_d,l_df,l_abb25_d,l_c,l_cf, l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)

         LET g_msg = g_x[20]
         LET l_abb25_d = t_debit / t_debitf     #No:MOD-8B0167 mark
         LET l_abb25_c = t_credit / t_creditf   #No:MOD-8B0167 mark
         LET l_abb25_bal = n_bal / n_balf       #No:MOD-8B0167 mark
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq301_tmp
         VALUES(sr.aea05,sr.aag02,sr.curr,sr.aba04,'4',sr.aba02,'','',g_msg,sr.abb24,
                '',0,0,
                t_debit,t_debitf,l_abb25_d,t_credit,t_creditf, l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF

   ON EVERY ROW
      #期初值
      IF sr.abb07 <> 0 OR sr.abb07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.abb24
         IF cl_null(sr.abb07) THEN LET sr.abb07 = 0 END IF
         IF cl_null(sr.abb07f) THEN LET sr.abb07f = 0 END IF
         IF sr.abb06 = 1 THEN
            LET l_bal   = l_bal   + sr.abb07
            LET l_balf  = l_balf  + sr.abb07f
            LET t_debit = t_debit + sr.abb07
            LET t_debitf= t_debitf+ sr.abb07f
         ELSE
            LET l_bal    = l_bal    - sr.abb07
            LET l_balf   = l_balf   - sr.abb07f
            LET t_credit = t_credit + sr.abb07
            LET t_creditf= t_creditf+ sr.abb07f
         END IF

         IF l_bal > 0 THEN
            LET n_bal = l_bal
            LET n_balf= l_balf
            LET l_dc  = g_x[28]
         ELSE
            IF l_bal = 0 THEN
               LET n_bal = l_bal
               LET n_balf= l_balf
               LET l_dc  = g_x[53]
            ELSE
               LET n_bal = l_bal * -1
               LET n_balf= l_balf* -1
               LET l_dc = g_x[29]
            END IF
         END IF
         IF sr.abb06 = '1' THEN
            LET l_d  = sr.abb07
            LET l_df = sr.abb07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.abb07
            LET l_cf = sr.abb07f
         END IF

         LET l_abb25_d = l_d / l_df       #No:MOD-8B0167 add
         LET l_abb25_c = l_c / l_cf       #No:MOD-8B0167 add
         LET l_abb25_bal = n_bal / n_balf #No:MOD-8B0167 add
         IF cl_null(l_abb25_bal) THEN LET l_abb25_bal = 0 END IF
         IF cl_null(l_abb25_d) THEN LET l_abb25_d = 0 END IF
         IF cl_null(l_abb25_c) THEN LET l_abb25_c = 0 END IF
         INSERT INTO gglq301_tmp
         VALUES(sr.aea05,sr.aag02,sr.curr,sr.aba04,'2',sr.aea02,sr.aea03,sr.aea04,sr.abb04,
                sr.abb24,sr.abb06,sr.abb07,sr.abb07f,
                l_d,l_df,l_abb25_d,l_c,l_cf,l_abb25_c,
                l_dc,n_bal,n_balf,l_abb25_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF

END REPORT

FUNCTION gglq301_qcye_qcyd(p_aea05,p_abb24)
   DEFINE p_aea05                 LIKE type_file.chr50
   DEFINE p_abb24                 LIKE abb_file.abb24
   DEFINE l_d0,l_d1,l_d2,l_d3     LIKE aah_file.aah04
   DEFINE l_c0,l_c1,l_c2,l_c3     LIKE aah_file.aah04
   DEFINE l_df0,l_df1,l_df2,l_df3 LIKE aah_file.aah04
   DEFINE l_cf0,l_cf1,l_cf2,l_cf3 LIKE aah_file.aah04
   DEFINE l_aea05                 LIKE type_file.chr50 #No.MOD-920187
   DEFINE l_qcye                  RECORD
                                  qc0    LIKE abb_file.abb07,    #年初本幣余額
                                  qc0f   LIKE abb_file.abb07,    #年初原幣余額
                                  qc_md  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借本幣金額
                                  qc_mdf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借原幣金額
                                  qc_mc  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸本幣金額
                                  qc_mcf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸原幣金額
                                  qc_yd  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借本幣金額
                                  qc_ydf LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借原幣金額
                                  qc_yc  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的貸本幣金額
                                  qc_ycf LIKE abb_file.abb07     #1~MONTH(bdate)月-1的貸原幣金額
                                  END RECORD
   #0.去年tah資料 1.1至mm-1 tah資料 2.1至mm-1 未過帳資料 3.mm期1至bdate-1的資料
   LET l_d0  = 0 LET l_d1  = 0 LET l_d2  = 0 LET l_d3  = 0
   LET l_c0  = 0 LET l_c1  = 0 LET l_c2  = 0 LET l_c3  = 0
   LET l_df0 = 0 LET l_df1 = 0 LET l_df2 = 0 LET l_df3 = 0
   LET l_cf0 = 0 LET l_cf1 = 0 LET l_cf2 = 0 LET l_cf3 = 0

   #No.MOD-920187--begin--  
   LET l_aea05 = p_aea05     
   LET p_aea05 = p_aea05,'\%'    #No.MOD-940388  
   #No.MOD-920187---end--- 

  #IF tm.d1= 'Y' OR NOT cl_null(tm.curr) THEN   #MOD-C50025   #No。FUN-C80102  Mark
   IF tm.n= 'Y' THEN    #No.FUN-CB0146   Mod tm.d1 --> tm.n
      #上年結余
      SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
        INTO l_d0,l_c0,l_df0,l_cf0 FROM tah_file
       WHERE tah01 = l_aea05 AND tah02 = yy AND tah03 = 0        #No.MOD-920187
         AND tah00 = tm.bookno
         AND tah08 = p_abb24
   
      #今年 1~MONTH(tm.bdate) 的資料
      SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
        INTO l_d1,l_c1,l_df1,l_cf1 FROM tah_file
       WHERE tah01 = l_aea05 AND tah02 = yy AND tah03 < mm         #No.MOD-920187
         AND tah03 > 0
         AND tah00 = tm.bookno
         AND tah08 = p_abb24
   ELSE
      LET p_abb24 = 1
      #上年結余
      SELECT SUM(tah04),SUM(tah05),0,0
        INTO l_d0,l_c0,l_df0,l_cf0 FROM tah_file
       WHERE tah01 = l_aea05 AND tah02 = yy AND tah03 = 0        #No.MOD-920187
         AND tah00 = tm.bookno
   
      #今年 1~MONTH(tm.bdate) 的資料
      SELECT SUM(tah04),SUM(tah05),0,0
        INTO l_d1,l_c1,l_df1,l_cf1 FROM tah_file
       WHERE tah01 = l_aea05 AND tah02 = yy AND tah03 < mm         #No.MOD-920187
         AND tah03 > 0
         AND tah00 = tm.bookno
   END IF

  #IF tm.k <> '3' THEN   #FUN-D10072--130123
   IF NOT (tm.k = '2' AND tm.b = 'N') THEN  #FUN-D10072--130123
      #今年 1~MONTH(tm.bdate) 的未過帳(審核或未審核)資料
      OPEN gglq301_cursc1 USING p_aea05,'1',p_abb24
      FETCH gglq301_cursc1 INTO l_d2,l_df2
      CLOSE gglq301_cursc1
      OPEN gglq301_cursc1 USING p_aea05,'2',p_abb24
      FETCH gglq301_cursc1 INTO l_c2,l_cf2
      CLOSE gglq301_cursc1
   END IF

   #今年 MONTH(tm.bdate) 的 1~tm.bdate-1 的資料
   OPEN gglq301_cursb1 USING p_aea05,'1',p_abb24
   FETCH gglq301_cursb1 INTO l_d3,l_df3
   CLOSE gglq301_cursb1
   OPEN gglq301_cursb1 USING p_aea05,'2',p_abb24
   FETCH gglq301_cursb1 INTO l_c3,l_cf3
   CLOSE gglq301_cursb1

   IF cl_null(l_d0) THEN LET l_d0 = 0 END IF
   IF cl_null(l_d1) THEN LET l_d1 = 0 END IF
   IF cl_null(l_d2) THEN LET l_d2 = 0 END IF
   IF cl_null(l_d3) THEN LET l_d3 = 0 END IF
   IF cl_null(l_c0) THEN LET l_c0 = 0 END IF
   IF cl_null(l_c1) THEN LET l_c1 = 0 END IF
   IF cl_null(l_c2) THEN LET l_c2 = 0 END IF
   IF cl_null(l_c3) THEN LET l_c3 = 0 END IF

   IF cl_null(l_df0) THEN LET l_df0 = 0 END IF
   IF cl_null(l_df1) THEN LET l_df1 = 0 END IF
   IF cl_null(l_df2) THEN LET l_df2 = 0 END IF
   IF cl_null(l_df3) THEN LET l_df3 = 0 END IF
   IF cl_null(l_cf0) THEN LET l_cf0 = 0 END IF
   IF cl_null(l_cf1) THEN LET l_cf1 = 0 END IF
   IF cl_null(l_cf2) THEN LET l_cf2 = 0 END IF
   IF cl_null(l_cf3) THEN LET l_cf3 = 0 END IF

   LET l_qcye.qc0    = l_d0  - l_c0    #年初本幣余額
   LET l_qcye.qc0f   = l_df0 - l_cf0   #年初原幣余額
   LET l_qcye.qc_md  = l_d3            #MONTH(bdate)月,1~bdate-1 借本幣金額
   LET l_qcye.qc_mdf = l_df3           #MONTH(bdate)月,1~bdate-1 借原幣金額
   LET l_qcye.qc_mc  = l_c3            #MONTH(bdate)月,1~bdate-1 貸本幣金額
   LET l_qcye.qc_mcf = l_cf3           #MONTH(bdate)月,1~bdate-1 貸原幣金額
   LET l_qcye.qc_yd  = l_d1 + l_d2     #1~MONTH(bdate)月-1的借本幣金額
   LET l_qcye.qc_ydf = l_df1 + l_df2   #1~MONTH(bdate)月-1的借原幣金額
   LET l_qcye.qc_yc  = l_c1 + l_c2     #1~MONTH(bdate)月-1的貸本幣金額
   LET l_qcye.qc_ycf = l_cf1 + l_cf2   #1~MONTH(bdate)月-1的貸原幣金額

   IF cl_null(l_qcye.qc0   ) THEN LET l_qcye.qc0    = 0 END IF
   IF cl_null(l_qcye.qc0f  ) THEN LET l_qcye.qc0f   = 0 END IF
   IF cl_null(l_qcye.qc_md ) THEN LET l_qcye.qc_md  = 0 END IF
   IF cl_null(l_qcye.qc_mdf) THEN LET l_qcye.qc_mdf = 0 END IF
   IF cl_null(l_qcye.qc_mc ) THEN LET l_qcye.qc_mc  = 0 END IF
   IF cl_null(l_qcye.qc_mcf) THEN LET l_qcye.qc_mcf = 0 END IF
   IF cl_null(l_qcye.qc_yd ) THEN LET l_qcye.qc_yd  = 0 END IF
   IF cl_null(l_qcye.qc_ydf) THEN LET l_qcye.qc_ydf = 0 END IF
   IF cl_null(l_qcye.qc_yc ) THEN LET l_qcye.qc_yc  = 0 END IF
   IF cl_null(l_qcye.qc_ycf) THEN LET l_qcye.qc_ycf = 0 END IF
  #IF tm.d1= 'N' AND cl_null(tm.curr) THEN   #MOD-C50025   #No。FUN-C80102  Mark
  #IF tm.d1= 'N' THEN                                         #No.FUN-C80102   Add   #MOD-E20099  mark
   IF tm.n= 'N' THEN                                         #No.FUN-C80102   Add   #MOD-E20099
      LET l_qcye.qc0f   = 0       #年初原幣余額
      LET l_qcye.qc_mdf = 0       #MONTH(bdate)月,1~bdate-1 借原幣金額
      LET l_qcye.qc_mcf = 0       #MONTH(bdate)月,1~bdate-1 貸原幣金額
      LET l_qcye.qc_ydf = 0       #1~MONTH(bdate)月-1的借原幣金額
      LET l_qcye.qc_ycf = 0       #1~MONTH(bdate)月-1的貸原幣金額
   END IF
   RETURN l_qcye.*

END FUNCTION

FUNCTION q301_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
  #DISPLAY ARRAY g_abb  TO s_abb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   DISPLAY ARRAY g_abbv TO s_abb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #No.FUN-CB0146   Add

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#No.FUN-A40009 --begin
         IF g_rec_b != 0 AND l_ac != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)     
         END IF                            
#No.FUN-A40009 --end

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION drill_down
         LET g_action_choice="drill_down"
         EXIT DISPLAY

      ON ACTION first
         CALL gglq301_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL gglq301_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL gglq301_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL gglq301_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL gglq301_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

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
      #darcy:2022/10/26 add s---
      ON action fastexcel
         let g_action_choice = "fastexcel"
         exit display
      #darcy:2022/10/26 add e---

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q301_out_1()

   LET g_prog = 'gglq301'
   LET g_sql = " aea05.aea_file.aea05,",
               " aag02.type_file.chr1000,",
               " aba04.aba_file.aba04,",
               " type.type_file.chr1,",
               " aea02.aea_file.aea02,",
               " aea03.aea_file.aea03,",
               " aea04.aea_file.aea04,",
               " abb04.abb_file.abb04,",
               " abb24.abb_file.abb24,",
               " abb06.abb_file.abb06,",
               " abb07.abb_file.abb07,",
               " abb07f.abb_file.abb07f,",
               " d.abb_file.abb07,",
               " df.abb_file.abb07,",
               " abb25_d.abb_file.abb25,",
               " c.abb_file.abb07,",
               " cf.abb_file.abb07,",
               " abb25_c.abb_file.abb25,",
               " dc.type_file.chr10,",
               " bal.abb_file.abb07,",
               " balf.abb_file.abb07,",
               " abb25_bal.abb_file.abb25,",
               " pagenum.type_file.num5,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " azi07.azi_file.azi07 "

   LET l_table = cl_prt_temptable('gglq301',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?)             "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION

FUNCTION q301_out_2()
   DEFINE l_name              LIKE type_file.chr20

   LET g_prog = 'gglq301'

   CALL cl_del_data(l_table)

  #FUN-C70061--mod--str
   LET g_sql = " SELECT aea05, aag02, aba04, type , aea02, ",
               "        aea03, aba11, aea04, abb04, abb24, abb06,abb07, abb07f,  d , df, abb25_d, ",  #zhouxm150428 add aba11
               "        c , cf, abb25_c, dc,      bal,balf, abb25_bal, pagenum, azi04,   azi05,azi07 ",
               "   FROM gglq301_tmp "
   IF tm.a = 'N' AND tm.d1= 'Y' THEN 
      LET g_sql = g_sql CLIPPED ," ORDER BY abb24,aea05,aba04,aea02,aea03,aea04 "
   ELSE
      LET g_sql = g_sql CLIPPED ," ORDER BY aea05,aba04,aea02,aea03,aea04 "
   END IF 
   PREPARE gglq301_tmp_pre FROM g_sql
   DECLARE gglq301_tmp_curs CURSOR FOR gglq301_tmp_pre


  #DECLARE gglq301_tmp_curs CURSOR FOR

  # SELECT aea05, aag02, aba04, type , aea02,
  #        aea03, aea04, abb04, abb24, abb06,
  #        abb07, abb07f,  d , df, abb25_d,
  #        c , cf, abb25_c, dc,      bal,
  #        balf, abb25_bal, pagenum, azi04,   azi05,   
  #        azi07   
  #  FROM gglq301_tmp
  # ORDER BY aea05,aba04,aea02,aea03,aea04
   #FUN-C70061--mod--end
   FOREACH gglq301_tmp_curs INTO g_pr.*
      IF g_pr.type = '1' THEN
         LET g_pr.d         = NULL
         LET g_pr.df        = NULL
         LET g_pr.abb25_d   = NULL
         LET g_pr.c         = NULL
         LET g_pr.cf        = NULL
         LET g_pr.abb25_c   = NULL
        #IF tm.d1= 'N' AND cl_null(tm.curr) THEN   #MOD-C50025   #No.FUN-C80102  Mark
         IF tm.d1= 'N' THEN  
            LET g_pr.balf      = NULL
            LET g_pr.abb25_bal = NULL
         END IF
      END IF
     #IF tm.d1= 'N' AND cl_null(tm.curr) THEN   #MOD-C50025   #No.FUN-C80102  Mark
      IF tm.d1= 'N' THEN
         IF g_pr.type = '3' OR g_pr.type = '4' THEN
            LET g_pr.df        = NULL
            LET g_pr.cf        = NULL
            LET g_pr.balf      = NULL
            LET g_pr.abb25_d   = NULL
            LET g_pr.abb25_c   = NULL
            LET g_pr.abb25_bal = NULL
         END IF
         IF g_pr.type = '2' THEN
            LET g_pr.balf      = NULL
            LET g_pr.abb25_bal = NULL
         END IF
      END IF
      IF g_pr.abb06 = '1' THEN
         LET g_pr.c       = NULL
         LET g_pr.cf      = NULL
         LET g_pr.abb25_c = NULL
      END IF
      IF g_pr.abb06 = '2' THEN
         LET g_pr.d       = NULL
         LET g_pr.df      = NULL
         LET g_pr.abb25_d = NULL
      END IF

      #IF tm.d1= 'N' AND cl_null(tm.curr) THEN   #MOD-C50025   #No.FUN-C80102  Mark
      IF tm.d1= 'N' THEN
         IF g_pr.type <> '2' THEN
            LET g_pr.abb24 = NULL
         END IF
      END IF
      EXECUTE insert_prep USING g_pr.*
   END FOREACH

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''

   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'aag01')
           RETURNING g_str
   END IF
   LET g_str = g_str,";",yy,";",tm.e,";",tm.bdate USING "yyyy/mm/dd" ,";",g_azi04
   IF tm.a = 'Y'  THEN #FUN-C70061 add
      IF tm.n = 'N' THEN
         LET l_name = 'gglq301'
      ELSE
         IF tm.d1='Y' THEN           #No.TQC-970049 
            LET l_name = 'gglq301_2' #No.TQC-970049  
         ELSE                        #No.TQC-970049         
            LET l_name = 'gglq301_1'
         END IF                      #No.TQC-970049
      END IF
   #FUN-C70061-add--str
   ELSE
      IF tm.n = 'N' THEN
         LET l_name = 'gglq301_3'
      ELSE
         IF tm.d1='Y' THEN          
            LET g_sql = g_sql CLIPPED," ORDER BY abb24 "
            LET l_name = 'gglq301_5'
         ELSE                       
            LET l_name = 'gglq301_4'
         END IF                     
      END IF 
   END IF 
   #FUN-C70061--add--end
   CALL cl_prt_cs3('gglq301',l_name,g_sql,g_str)

END FUNCTION

FUNCTION gglq301_table()
     DROP TABLE gglq301_tmp;
     CREATE TEMP TABLE gglq301_tmp(
                    aea05       LIKE aea_file.aea05,
                    aag02       LIKE type_file.chr1000, #No.MOD-920129 aag_file->type_file
                    curr        LIKE abb_file.abb24,
                    aba04       LIKE aba_file.aba04,
                    type        LIKE type_file.chr1,
                    aea02       LIKE aea_file.aea02,
                    aea03       LIKE aea_file.aea03,
                    aba11       LIKE aba_file.aba11, #zhouxm150428 add 
                    aea04       LIKE aea_file.aea04,
                    abb04       LIKE abb_file.abb04,
                    abb24       LIKE abb_file.abb24,
                    abb06       LIKE abb_file.abb06,
                    abb07       LIKE abb_file.abb07,
                    abb07f      LIKE abb_file.abb07f,
                    d           LIKE abb_file.abb07,
                    df          LIKE abb_file.abb07,
                    abb25_d     LIKE abb_file.abb25,
                    c           LIKE abb_file.abb07,
                    cf          LIKE abb_file.abb07,
                    abb25_c     LIKE abb_file.abb25,
                    dc          LIKE type_file.chr10,
                    bal         LIKE abb_file.abb07,
                    balf        LIKE abb_file.abb07,
                    abb25_bal   LIKE abb_file.abb25,
                    pagenum     LIKE type_file.num5,
                    azi04       LIKE azi_file.azi04,
                    azi05       LIKE azi_file.azi05,
                    azi07       LIKE azi_file.azi07);

END FUNCTION

FUNCTION gglq301_t()
   IF tm.n = 'Y' THEN
      CALL cl_set_comp_visible("abb24,df,d,cf,c,balf,bal",TRUE)
      CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",TRUE)
      CALL cl_getmsg("ggl-201",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("df",g_msg CLIPPED)
      CALL cl_getmsg("ggl-202",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-203",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("cf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-204",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-205",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-206",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
#FUN-D10072 130123 --mark
#     #TQC-970049  --begin
#     IF tm.d1= 'Y' THEN
#        CALL cl_set_comp_visible("b",TRUE)
#     ELSE
#        CALL cl_set_comp_visible("b",FALSE)
#     END IF
#     #TQC-970049  --end
#FUN-D10072 130123 --mark
   ELSE
      CALL cl_set_comp_visible("abb24,abb25,df,cf,balf",FALSE) #TQC-970049  #FUN-D10072 del b 
      CALL cl_set_comp_visible("abb25_d,abb25_c,abb25_bal",FALSE)
      CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   END IF
#FUN-C80102--mark--str--
#  #No:FUN-C70061 --add--str
#  IF tm.a = 'Y' THEN
#     CALL cl_set_comp_visible("aea05_1,aag02_1",TRUE) #FUN-C80102 false->true
#     CALL cl_set_comp_visible("aea05,aag02",FALSE)    #FUN-C80102 true->false
#  ELSE 
#     CALL cl_set_comp_visible("aea05_1,aag02_1",FALSE)#FUN-C80102 true->false
#     CALL cl_set_comp_visible("aea05,aag02",TRUE)     #FUN-C80102 false->true
#  END IF 
#  #No:FUN-C70061 --add--end
#FUN-C80102--mark--end--
   LET g_aea05 = NULL
   LET g_aag02 = NULL
   CLEAR FORM
   CALL g_abb.clear()
   CALL gglq301_cs()
END FUNCTION

FUNCTION q301_drill_down()  
   DEFINE 
          #l_wc    LIKE type_file.chr50
          l_wc         STRING       #NO.FUN-910082
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_aba06 LIKE aba_file.aba06  #MOD-CB0063

   #FUN-C70061 --add--str
   IF tm.a = 'N' THEN 
     #IF cl_null(g_abb[l_ac].aea05_1) THEN RETURN END IF   #FUN-C80102 
     #IF cl_null(g_abb[l_ac].aea05  ) THEN RETURN END IF   #FUN-C80102   #NO.FUN-CB0146   Mark
      IF cl_null(g_abbv[l_ac].aea05  ) THEN RETURN END IF                #NO.FUN-CB0146   Add
   ELSE
   #FUN-C70061 add --end
      IF cl_null(g_aea05) THEN RETURN END IF
   END IF #FUN-C70061
   IF l_ac = 0 THEN RETURN END IF
  #IF cl_null(g_abb[l_ac].aea03) THEN RETURN END IF    #NO.FUN-CB0146   Mark
   IF cl_null(g_abbv[l_ac].aea03) THEN RETURN END IF   #NO.FUN-CB0146   Add
  #No.FUN-CB0146 ---start--- Mod  g_abb --> g_abbv
   #No.MOD-CB0063 --Begin
   SELECT aba06 INTO l_aba06 FROM aba_file WHERE aba00=g_aaz.aaz64 AND aba01=g_abbv[l_ac].aea03
   IF l_aba06 = 'RV' THEN
      LET g_msg = "aglt120 '",g_aaz.aaz64,"' '", g_abbv[l_ac].aea03,"'"
   ELSE
      IF l_aba06 = 'AC' THEN
        LET g_msg = "aglt130 '",g_abbv[l_ac].aea03,"'"
      ELSE
        LET g_msg = "aglt110 '",g_abbv[l_ac].aea03,"'"
      END IF
   END IF
   #No.MOD-CB0063 --End
  #No.FUN-CB0146 ---end--- Mod  g_abb --> g_abbv
   CALL cl_cmdrun(g_msg)

END FUNCTION

FUNCTION q301_set_entry()

  #CALL cl_set_comp_entry("d1,curr",TRUE)  #FUN-C80102
   CALL cl_set_comp_entry("d1",TRUE)  #FUN-C80102

END FUNCTION

FUNCTION q301_set_no_entry()

   IF tm.n = 'N' THEN
      LET tm.d1= 'N'
     #LET tm.curr = NULL                  #FUN-C80102
     #DISPLAY BY NAME tm.d1,tm.curr       #FUN-C80102
      DISPLAY tm.d1  TO d1         #FUN-C80102
     #CALL cl_set_comp_entry("d1,curr",FALSE)   #FUN-C80102
      CALL cl_set_comp_entry("d1",FALSE)        #FUN-C80102
   END IF

END FUNCTION


FUNCTION q301_initialize_qcye_para()
   RETURN 0,0,0,0,0,0,0,0,0,0
END FUNCTION

FUNCTION gglq301_check_ins(p_qcye)
   DEFINE p_qcye      RECORD
                      qc0    LIKE abb_file.abb07,    #年初本幣余額
                      qc0f   LIKE abb_file.abb07,    #年初原幣余額
                      qc_md  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借本幣金額
                      qc_mdf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 借原幣金額
                      qc_mc  LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸本幣金額
                      qc_mcf LIKE abb_file.abb07,    #MONTH(bdate)月,1~bdate-1 貸原幣金額
                      qc_yd  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借本幣金額
                      qc_ydf LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的借原幣金額
                      qc_yc  LIKE abb_file.abb07,    #1~MONTH(bdate)月-1的貸本幣金額
                      qc_ycf LIKE abb_file.abb07     #1~MONTH(bdate)月-1的貸原幣金額
                      END RECORD
   DEFINE l_ins       LIKE type_file.chr1
   
   LET l_ins = 'N'
   IF tm.d1= 'N' THEN
      IF p_qcye.qc0   <> 0 OR 
         p_qcye.qc_md <> 0 OR 
         p_qcye.qc_mc <> 0 OR 
         p_qcye.qc_yd <> 0 OR 
         p_qcye.qc_yc <> 0 THEN
         LET l_ins = 'Y'
      END IF
   ELSE
      IF p_qcye.qc0   <> 0 OR p_qcye.qc0f  <> 0 OR 
         p_qcye.qc_md <> 0 OR p_qcye.qc_mdf<> 0 OR 
         p_qcye.qc_mc <> 0 OR p_qcye.qc_mcf<> 0 OR 
         p_qcye.qc_yd <> 0 OR p_qcye.qc_ydf<> 0 OR 
         p_qcye.qc_yc <> 0 OR p_qcye.qc_ycf<> 0 THEN
         LET l_ins = 'Y'
      END IF
   END IF
   RETURN l_ins

END FUNCTION


#darcy:2022/10/26 add s---
function q301_fastexcel()
   define file string
   define title string
   define err like type_file.chr1
   define n   om.DomNode
   
   # let n = base.typeinfo.create(g_abbv)
   # call n.writexml("/u1/out/darcy.xml")

   let title = "科目编号,科目名称,凭证日期,凭证编号,总号,摘要,原币币种,原币借方金额,汇率,本币借方金额,原币贷方金额,汇率,本币贷方金额,借贷,原币余额,汇率,本币余额"

   call cs_darcy_set_title("q301_fastexcel",title,"明细分类帐查询") returning err
   call cs_darcy_excel("q301_fastexcel",g_prog) returning file,err

end function


function q301_drop_temp()
   whenever any error continue
      drop table q301_fastexcel;
   whenever any error stop
end function
#darcy:2022/10/26 add e---
