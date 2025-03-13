# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aemi100.4gl
# Descriptions...: 設備基本資料維護作業
# Date & Author..: 04/07/13 By Carrier
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.FUN-540036 05/04/18 By wujie   多table顯示
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/22 By zdyllq 類型轉換
# Modify.........: No.FUN-690024 06/09/18 By jamie 判斷pmcacti
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720052 07/03/20 By Judy 開窗字段"制造廠商","原產地","供貨商"錄入任何值不報錯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/19 By lala   報表轉為使用p_query
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.MOD-840439 08/04/21 By Mandy 位置欄位為黃色(fai14), 應該是必要欄位,但未輸入確也可以存檔
# Modify.........: No.FUN-840068 08/04/25 By TSD.Wind 自動功能欄位修改
# Modify.........: No.TQC-920110 09/02/27 By chenyu 資料無效時，不可以刪除
# Modify.........: No.TQC-970094 09/07/09 By lilingyu 單身備件page中"數量"欄位錄入負值,增加報錯訊息
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0084 11/12/21 By lixh1 增加數量欄位小數取位 
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fia           RECORD LIKE fia_file.*,
    g_fia_t         RECORD LIKE fia_file.*,
    g_fia_o         RECORD LIKE fia_file.*,
    g_fia01_t       LIKE fia_file.fia01,
    g_fib           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fib02            LIKE fib_file.fib02,
        fib03            LIKE fib_file.fib03
                    END RECORD,
    g_fib_t         RECORD                     #程式變數 (舊值)
        fib02            LIKE fib_file.fib02,
        fib03            LIKE fib_file.fib03
                    END RECORD,
    g_fij           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fij02            LIKE fij_file.fij02,
        fij03            LIKE fij_file.fij03
                    END RECORD,
    g_fij_t         RECORD
        fij02            LIKE fij_file.fij02,
        fij03            LIKE fij_file.fij03
                    END RECORD,
    g_fjb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fjb02            LIKE fjb_file.fjb02,
        fjb03            LIKE fjb_file.fjb03,
        ima02            LIKE ima_file.ima02,
        fjb04            LIKE fjb_file.fjb04,
        fiz02            LIKE fiz_file.fiz02,
        fjb05            LIKE fjb_file.fjb05,
        fjb06            LIKE fjb_file.fjb06,
        #FUN-840068 --start---
        fjbud01          LIKE fjb_file.fjbud01,
        fjbud02          LIKE fjb_file.fjbud02,
        fjbud03          LIKE fjb_file.fjbud03,
        fjbud04          LIKE fjb_file.fjbud04,
        fjbud05          LIKE fjb_file.fjbud05,
        fjbud06          LIKE fjb_file.fjbud06,
        fjbud07          LIKE fjb_file.fjbud07,
        fjbud08          LIKE fjb_file.fjbud08,
        fjbud09          LIKE fjb_file.fjbud09,
        fjbud10          LIKE fjb_file.fjbud10,
        fjbud11          LIKE fjb_file.fjbud11,
        fjbud12          LIKE fjb_file.fjbud12,
        fjbud13          LIKE fjb_file.fjbud13,
        fjbud14          LIKE fjb_file.fjbud14,
        fjbud15          LIKE fjb_file.fjbud15
        #FUN-840068 --end--
                    END RECORD,
    g_fjb_t         RECORD
        fjb02            LIKE fjb_file.fjb02,
        fjb03            LIKE fjb_file.fjb03,
        ima02            LIKE ima_file.ima02,
        fjb04            LIKE fjb_file.fjb04,
        fiz02            LIKE fiz_file.fiz02,
        fjb05            LIKE fjb_file.fjb05,
        fjb06            LIKE fjb_file.fjb06,
        #FUN-840068 --start---
        fjbud01          LIKE fjb_file.fjbud01,
        fjbud02          LIKE fjb_file.fjbud02,
        fjbud03          LIKE fjb_file.fjbud03,
        fjbud04          LIKE fjb_file.fjbud04,
        fjbud05          LIKE fjb_file.fjbud05,
        fjbud06          LIKE fjb_file.fjbud06,
        fjbud07          LIKE fjb_file.fjbud07,
        fjbud08          LIKE fjb_file.fjbud08,
        fjbud09          LIKE fjb_file.fjbud09,
        fjbud10          LIKE fjb_file.fjbud10,
        fjbud11          LIKE fjb_file.fjbud11,
        fjbud12          LIKE fjb_file.fjbud12,
        fjbud13          LIKE fjb_file.fjbud13,
        fjbud14          LIKE fjb_file.fjbud14,
        fjbud15          LIKE fjb_file.fjbud15
        #FUN-840068 --end--
                    END RECORD,
    g_fjc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fjc02            LIKE fjc_file.fjc02,
        fjc03            LIKE fjc_file.fjc03,
        fio05            LIKE fio_file.fio05,
        fio06            LIKE fio_file.fio06,
        fiu02            LIKE fiu_file.fiu02,
        fio07            LIKE fio_file.fio07,
        fja02            LIKE fja_file.fja02,
        fio08            LIKE fio_file.fio08
                    END RECORD,
    g_fjc_t         RECORD
        fjc02            LIKE fjc_file.fjc02,
        fjc03            LIKE fjc_file.fjc03,
        fio05            LIKE fio_file.fio05,
        fio06            LIKE fio_file.fio06,
        fiu02            LIKE fiu_file.fiu02,
        fio07            LIKE fio_file.fio07,
        fja02            LIKE fja_file.fja02,
        fio08            LIKE fio_file.fio08
                    END RECORD,
   #g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_sql,g_sql1,g_sql2     VARCHAR(1000)
    g_wc,g_wc2,g_wc3,g_wc4,g_wc5,g_sql,g_sql1,g_sql2    STRING,    #TQC-630166        
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4    LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    g_fic03         LIKE fic_file.fic03,
    g_t1            LIKE type_file.chr3,                  #No.FUN-680072CHAR(3)
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
DEFINE g_fjb05_t    LIKE fjb_file.fjb05    #FUN-BB0084
 
#主程式開始
DEFINE   p_row,p_col         LIKE type_file.num5        #No.FUN-680072 SMALLINT
#FUN-540036---start
DEFINE  l_action_flag        STRING    
#FUN-540036---end
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE  g_before_input_done  LIKE type_file.num5     #No.FUN-680072 SMALLINT
DEFINE  g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE  g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03            #No.FUN-680072CHAR(72)
DEFINE  g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  g_void          LIKE type_file.chr1          #No.FUN-680072CHAR(1)
DEFINE g_argv1     LIKE fia_file.fia01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
 
# DEFINE      l_time    LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    LET g_forupd_sql = "SELECT * FROM fia_file WHERE fia01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW i100_w33 AT 2,2 WITH FORM "aem/42f/aemi100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
         OTHERWISE        
            CALL i100_q() 
      END CASE
   END IF
   #--
 
    CALL i100_menu()
 
    CLOSE WINDOW i100_w33
      CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i100_cs()
 DEFINE    l_type          LIKE type_file.chr2       #No.FUN-680072CHAR(2)
   CLEAR FORM                                      #清除畫面
   CALL g_fib.clear()
   CALL g_fij.clear()
   CALL g_fjb.clear()
   CALL g_fjc.clear()
   CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fia.* TO NULL    #No.FUN-750051
  IF g_argv1<>' ' THEN                     #FUN-7C0050
     LET g_wc=" fia01='",g_argv1,"'"       #FUN-7C0050
     LET g_wc2=" 1=1"                      #FUN-7C0050
     LET g_wc3=" 1=1"                      #FUN-7C0050
     LET g_wc4=" 1=1"                      #FUN-7C0050
     LET g_wc5=" 1=1"                      #FUN-7C0050
  ELSE
   CONSTRUCT BY NAME g_wc ON
                fia01,fia011,fia012,fia02,fia03,fia04,
                fia05,fia06 ,fia07 ,fia08,fia09,fia10,
                fia11,fia12 ,fia13 ,fia14,fia15,fia16,
                fia17,fia18 ,fia19 ,fia20,fia21,fia22,
                fia23,fia24 ,fia25 ,
                fiauser,fiagrup,fiamodu,fiadate,fiaacti,
                #FUN-840068   ---start---
                fiaud01,fiaud02,fiaud03,fiaud04,fiaud05,
                fiaud06,fiaud07,fiaud08,fiaud09,fiaud10,
                fiaud11,fiaud12,fiaud13,fiaud14,fiaud15
                #FUN-840068    ----end----
 
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(fia011)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_faj3"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia011
            NEXT FIELD fia011
         WHEN INFIELD(fia012)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.multiret_index = 2
            LET g_qryparam.form ="q_faj3"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia012
            NEXT FIELD fia012
         WHEN INFIELD(fia03)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fic"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia03
            NEXT FIELD fia03
         WHEN INFIELD(fia04)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fii"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia04
            NEXT FIELD fia04
         WHEN INFIELD(fia05)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fii"
            LET g_qryparam.multiret_index = 2
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia05
            NEXT FIELD fia05
         WHEN INFIELD(fia07)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_pmc"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia07
            NEXT FIELD fia07
         WHEN INFIELD(fia08)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_geb"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia08
            NEXT FIELD fia08
         WHEN INFIELD(fia09)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_pmc"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia09
            NEXT FIELD fia09
         WHEN INFIELD(fia10)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_gen"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia10
            NEXT FIELD fia10
         WHEN INFIELD(fia11)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_gem"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia11
            NEXT FIELD fia11
         WHEN INFIELD(fia14)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fjf"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia14
            NEXT FIELD fia14
         WHEN INFIELD(fia15)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fjg"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia15
            NEXT FIELD fia15
         WHEN INFIELD(fia16)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fjg"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia16
            NEXT FIELD fia16
         WHEN INFIELD(fia17)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fjg"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fia17
            NEXT FIELD fia17
         OTHERWISE EXIT CASE
      END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
   LET g_wc2 = " 1=1"
   CONSTRUCT g_wc2 ON fib02,fib03
        FROM s_fib[1].fib02,s_fib[1].fib03
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   LET g_wc3 = " 1=1"
   CONSTRUCT g_wc3 ON fij02,fij03
         FROM s_fij[1].fij02,s_fij[1].fij03
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   LET g_wc4 = " 1=1"
   CONSTRUCT g_wc4 ON fjb02,fjb03,fjb04,fjb05,fjb06
             #No.FUN-840068 --start--
             ,fjbud01,fjbud02,fjbud03,fjbud04,fjbud05
             ,fjbud06,fjbud07,fjbud08,fjbud09,fjbud10
             ,fjbud11,fjbud12,fjbud13,fjbud14,fjbud15
             #No.FUN-840068 ---end---
         FROM s_fjb[1].fjb02,s_fjb[1].fjb03,s_fjb[1].fjb04,
              s_fjb[1].fjb05,s_fjb[1].fjb06
              #No.FUN-840068 --start--
              ,s_fjb[1].fjbud01,s_fjb[1].fjbud02,s_fjb[1].fjbud03
              ,s_fjb[1].fjbud04,s_fjb[1].fjbud05,s_fjb[1].fjbud06
              ,s_fjb[1].fjbud07,s_fjb[1].fjbud08,s_fjb[1].fjbud09
              ,s_fjb[1].fjbud10,s_fjb[1].fjbud11,s_fjb[1].fjbud12
              ,s_fjb[1].fjbud13,s_fjb[1].fjbud14,s_fjb[1].fjbud15
              #No.FUN-840068 ---end---
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fjb03)
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.state = "c"
             #   LET g_qryparam.form ="q_ima"
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO s_fjb[1].fjb03
                NEXT FIELD fjb03
             WHEN INFIELD(fjb04)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fiz"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_fjb[1].fjb04
                NEXT FIELD fjb04
             WHEN INFIELD(fjb05)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gfe"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_fjb[1].fjb05
                NEXT FIELD fjb05
             OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   LET g_wc5 = " 1=1"
   CONSTRUCT g_wc5 ON fjc02,fjc03
         FROM s_fjc[1].fjc02,s_fjc[1].fjc03
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fjc03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fio"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_fjc[1].fjc03
                NEXT FIELD fjc03
             OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 END IF  #FUN-7C0050
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND fiauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND fiagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND fiagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fiauser', 'fiagrup')
   #End:FUN-980030
 
 
   LET g_sql  = "SELECT fia01 "
   LET g_sql1 = " FROM fia_file "
   LET g_sql2 = " WHERE ", g_wc CLIPPED
 
   IF g_wc2 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",fib_file"
      LET g_sql2= g_sql2 CLIPPED," AND fia01=fib01",
                                 " AND ",g_wc2 CLIPPED
   END IF
   IF g_wc3 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",fij_file"
      LET g_sql2= g_sql2 CLIPPED," AND fia01=fij01",
                                 " AND ",g_wc3 CLIPPED
   END IF
   IF g_wc4 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",fjb_file"
      LET g_sql2= g_sql2 CLIPPED," AND fia01=fjb01",
                                 " AND ",g_wc4 CLIPPED
   END IF
   IF g_wc5 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",fjc_file"
      LET g_sql2= g_sql2 CLIPPED," AND fia01=fjc01",
                                 " AND ",g_wc5 CLIPPED
   END IF
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED,' ORDER BY fia01'
 
   PREPARE i100_prepare FROM g_sql
   DECLARE i100_cs SCROLL CURSOR WITH HOLD FOR i100_prepare
 
   LET g_sql  = "SELECT COUNT(UNIQUE fia01) "
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED
 
   PREPARE i100_precount FROM g_sql
   DECLARE i100_count CURSOR FOR i100_precount
END FUNCTION
 
FUNCTION i100_menu()
DEFINE l_cmd  LIKE type_file.chr1000        #No.FUN-820002
   WHILE TRUE
# NO.FUN-540036--start
#     CALL i100_bp("G")
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "accessory")
            CALL i100_bp1("G")
         WHEN (l_action_flag = "user_defined_columns")
            CALL i100_bp2("G")
         WHEN (l_action_flag = "spare_part")
            CALL i100_bp3("G")
         WHEN (l_action_flag = "maintain_repair")
            CALL i100_bp4("G")
      END CASE
# NO.FUN-540036--end
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i100_copy()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i100_x()
            END IF
         WHEN "output"
            IF cl_chk_act_auth()                                           
               THEN CALL i100_out()                                    
            END IF                                                         
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "accessory"
            IF cl_chk_act_auth() THEN
               CALL i100_b1()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "user_defined_columns"
            IF cl_chk_act_auth() THEN
               CALL i100_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "spare_part"
            IF cl_chk_act_auth() THEN
               CALL i100_b3()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "maintain_repair"
            IF cl_chk_act_auth() THEN
               CALL i100_b4()
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.FUN-6B0050-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_fia.fia01 IS NOT NULL THEN
                 LET g_doc.column1 = "fia01"
                 LET g_doc.value1 = g_fia.fia01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i100_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_fib.clear()
   CALL g_fij.clear()
   CALL g_fjb.clear()
   CALL g_fjc.clear()
   INITIALIZE g_fia.* LIKE fia_file.*             #DEFAULT 設定
   LET g_fia01_t = NULL
   #預設值及將數值類變數清成零
   LET g_fia.fiauser=g_user
   LET g_fia.fiaoriu = g_user #FUN-980030
   LET g_fia.fiaorig = g_grup #FUN-980030
   LET g_fia.fiagrup=g_grup
   LET g_fia.fiadate=g_today
   LET g_fia.fiaacti='Y'              #資料有效
   LET g_fia.fia21='N'
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i100_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_fia.* TO NULL
         EXIT WHILE
      END IF
      IF g_fia.fia01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO fia_file VALUES (g_fia.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#        CALL cl_err(g_fia.fia01,SQLCA.sqlcode,1)   #No.FUN-660092
         CALL cl_err3("ins","fia_file",g_fia.fia01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
      SELECT fia01 INTO g_fia.fia01 FROM fia_file
       WHERE fia01 = g_fia.fia01
      LET g_fia01_t = g_fia.fia01        #保留舊值
      LET g_fia_t.* = g_fia.*
 
      IF g_fia.fia04 IS NOT NULL AND g_fia.fia05 IS NOT NULL THEN
         #IF cl_conf(17,12,'aem-019') THEN
            CALL i100_fia04_fia05('a')
         #END IF
      END IF
      CALL i100_b1_fill(" 1=1")                 #單身
#      CALL g_fib.clear()
#      LET g_rec_b1=0
      CALL i100_b1()                   #輸入單身-1
 
      CALL g_fij.clear()
      LET g_rec_b2=0
      CALL i100_b2()                   #輸入單身-2
 
      CALL g_fjb.clear()
      LET g_rec_b3=0
      CALL i100_b3()                   #輸入單身-3
 
      CALL g_fjc.clear()
      LET g_rec_b4=0
      CALL i100_b4()                   #輸入單身-4
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i100_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_fia.fia01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_fia.* FROM fia_file
    WHERE fia01=g_fia.fia01
   IF g_fia.fiaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_fia.fia01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_fia01_t = g_fia.fia01
   LET g_fia_o.* = g_fia.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i100_cl USING g_fia.fia01
   IF STATUS THEN
      CALL cl_err("OPEN i100_cl:", STATUS, 1)
      CLOSE i100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i100_cl INTO g_fia.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i100_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i100_show()
   WHILE TRUE
      LET g_fia01_t = g_fia.fia01
      LET g_fia.fiamodu=g_user
      LET g_fia.fiadate=g_today
      CALL i100_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_fia.*=g_fia_t.*
         CALL i100_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_fia.fia01 != g_fia01_t THEN            # 更改單號
         UPDATE fib_file SET fib01 = g_fia.fia01 WHERE fib01 = g_fia01_t
         UPDATE fij_file SET fij01 = g_fia.fia01 WHERE fij01 = g_fia01_t
         UPDATE fjb_file SET fjb01 = g_fia.fia01 WHERE fjb01 = g_fia01_t
         UPDATE fjc_file SET fjc01 = g_fia.fia01 WHERE fjc01 = g_fia01_t
      END IF
      UPDATE fia_file SET fia_file.* = g_fia.* WHERE fia01 = g_fia01_t 
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
         CALL cl_err3("upd","fia_file",g_fia.fia01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i100_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i100_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680072 VARCHAR(1)
    l_pmc03         LIKE pmc_file.pmc03,
    l_yy,l_mm       LIKE type_file.num5,    #No.FUN-680072SMALLINT
    l_fii03         LIKE fii_file.fii03
DEFINE   l_n        LIKE type_file.num5     #TQC-720052
    
    LET l_n = 0   #TQC-720052
    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
    INPUT BY NAME g_fia.fiaoriu,g_fia.fiaorig,
          g_fia.fia01,g_fia.fia011,g_fia.fia012,g_fia.fia02,
          g_fia.fia03,g_fia.fia04, g_fia.fia05, g_fia.fia06,
          g_fia.fia07,g_fia.fia08, g_fia.fia09, g_fia.fia10,
          g_fia.fia11,g_fia.fia12, g_fia.fia13, g_fia.fia14,
          g_fia.fia15,g_fia.fia16, g_fia.fia17, g_fia.fia18,
          g_fia.fia19,g_fia.fia20, g_fia.fia21, g_fia.fia22,
          g_fia.fia23,g_fia.fia24, g_fia.fia25,
          g_fia.fiauser,g_fia.fiagrup,g_fia.fiamodu,
          g_fia.fiadate,g_fia.fiaacti,
          #FUN-840068     ---start---
          g_fia.fiaud01,g_fia.fiaud02,g_fia.fiaud03,g_fia.fiaud04,
          g_fia.fiaud05,g_fia.fiaud06,g_fia.fiaud07,g_fia.fiaud08,
          g_fia.fiaud09,g_fia.fiaud10,g_fia.fiaud11,g_fia.fiaud12,
          g_fia.fiaud13,g_fia.fiaud14,g_fia.fiaud15 
          #FUN-840068     ----end----
        WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i100_set_entry(p_cmd)
           CALL i100_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
       AFTER FIELD fia01
           IF NOT cl_null(g_fia.fia01) THEN
              IF g_fia.fia01 != g_fia01_t OR g_fia01_t IS NULL THEN
                 SELECT COUNT(*) INTO g_cnt FROM fia_file
                  WHERE fia01 = g_fia.fia01
                 IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_fia.fia01,-239,0)
                    LET g_fia.fia01 = g_fia01_t
                    DISPLAY BY NAME g_fia.fia01
                    NEXT FIELD fia01
                 END IF
              END IF
           END IF
 
        AFTER FIELD fia011
           IF NOT cl_null(g_fia.fia011) THEN
              SELECT faj06 INTO g_fia.fia02 FROM faj_file
               WHERE faj02=g_fia.fia011 AND faj022 = ' '
              DISPLAY BY NAME g_fia.fia02
 
              IF cl_null(g_fia_t.fia011) OR g_fia.fia011 <> g_fia_t.fia011 THEN
                 CALL i100_fia011(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fia.fia011,g_errno,0)
                    LET g_fia.fia011 = g_fia_o.fia011
                    DISPLAY BY NAME g_fia.fia011
                    NEXT FIELD fia011
                 END IF
              END IF
           END IF
           LET g_fia_t.fia011=g_fia.fia011
 
        BEFORE FIELD fia03
           CALL i100_set_entry(p_cmd)
 
        AFTER FIELD fia03
           IF NOT cl_null(g_fia.fia03) THEN
              CALL i100_fia03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fia.fia03,g_errno,0)
                 LET g_fia.fia03 = g_fia_o.fia03
                 DISPLAY BY NAME g_fia.fia03
                 NEXT FIELD fia03
              END IF
           END IF
           CALL i100_set_no_entry(p_cmd)
 
        AFTER FIELD fia04
           IF NOT cl_null(g_fia.fia04) THEN
              CALL i100_fia04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fia.fia04,g_errno,0)
                 LET g_fia.fia04 = g_fia_o.fia04
                 DISPLAY BY NAME g_fia.fia04
                 NEXT FIELD fia04
              END IF
              IF NOT cl_null(g_fia.fia05) THEN
                 SELECT fii03 INTO l_fii03 FROM fii_file
                  WHERE fii01=g_fia.fia04
                    AND fii02=g_fia.fia05
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fia.fia04,'aem-009',0)   #No.FUN-660092
                    CALL cl_err3("sel","fii_file",g_fia.fia04,g_fia.fia05,"aem-009","","",1)  #No.FUN-660092
                    NEXT FIELD fia04
                 ELSE
                    IF cl_null(g_fia.fia25) THEN
                       LET g_fia.fia25 = l_fii03
                       DISPLAY BY NAME g_fia.fia25
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD fia05
           IF NOT cl_null(g_fia.fia05) THEN
              CALL i100_fia05(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fia.fia05,g_errno,0)
                 LET g_fia.fia05 = g_fia_o.fia05
                 DISPLAY BY NAME g_fia.fia05
                 NEXT FIELD fia05
              END IF
              IF NOT cl_null(g_fia.fia04) THEN
                 SELECT fii03 INTO l_fii03 FROM fii_file
                  WHERE fii01=g_fia.fia04
                    AND fii02=g_fia.fia05
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fia.fia04,'aem-009',0)   #No.FUN-660092
                    CALL cl_err3("sel","fii_file",g_fia.fia04,g_fia.fia05,"aem-009","","",1)  #No.FUN-660092
                    NEXT FIELD fia04
                 ELSE
                    IF cl_null(g_fia.fia25) THEN
                       LET g_fia.fia25 = l_fii03
                       DISPLAY BY NAME g_fia.fia25
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD fia06
           IF g_fic03 ='Y' THEN
              IF cl_null(g_fia.fia06) THEN NEXT FIELD fia06 END IF
           END IF
#TQC-720052.....begin
        AFTER FIELD fia07
           IF NOT cl_null(g_fia.fia07) THEN
              SELECT COUNT(*) INTO l_n FROM pmc_file
               WHERE pmc01 = g_fia.fia07 
              IF l_n = 0 THEN
                 CALL cl_err(g_fia.fia07,'aem-048',0)
                 NEXT FIELD fia07
              END IF
           END IF
 
        AFTER FIELD fia08
           IF NOT cl_null(g_fia.fia08) THEN
              SELECT COUNT(*) INTO l_n FROM geb_file
               WHERE geb01 = g_fia.fia08
              IF l_n = 0 THEN
                 CALL cl_err(g_fia.fia08,'aem-049',0)
                 NEXT FIELD fia08
              END IF
           END IF
#TQC-720052.....end
        AFTER FIELD fia09
           IF cl_null(g_fia.fia09) THEN
              DISPLAY '' TO FORMONLY.pmc03
           ELSE
              CALL i100_fia09(p_cmd)
#TQC-720052.....begin
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fia.fia09,g_errno,0) 
                 NEXT FIELD fia09
              END IF
#TQC-720052.....end
           END IF
 
        AFTER FIELD fia10
            IF NOT cl_null(g_fia.fia10) THEN
               CALL i100_fia10(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fia.fia10,g_errno,0)
                  LET g_fia.fia10 = g_fia_o.fia10
                  DISPLAY BY NAME g_fia.fia10
                  NEXT FIELD fia10
               END IF
            END IF
 
        AFTER FIELD fia11
            IF NOT cl_null(g_fia.fia11) THEN
               CALL i100_fia11(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fia.fia11,g_errno,0)
                  LET g_fia.fia11 = g_fia_o.fia11
                  DISPLAY BY NAME g_fia.fia11
                  NEXT FIELD fia11
               END IF
            END IF
 
        AFTER FIELD fia14
            IF NOT cl_null(g_fia.fia14) THEN
               CALL i100_fia14(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fia.fia14,g_errno,0)
                  LET g_fia.fia14 = g_fia_o.fia14
                  DISPLAY BY NAME g_fia.fia14
                  NEXT FIELD fia14
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.fka02
            END IF
 
        AFTER FIELD fia15
            IF NOT cl_null(g_fia.fia15) THEN
               CALL i100_fia15(p_cmd,'2')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fia.fia15,g_errno,0)
                  LET g_fia.fia15 = g_fia_o.fia15
                  DISPLAY BY NAME g_fia.fia15
                  NEXT FIELD fia15
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.fka02a
            END IF
 
        AFTER FIELD fia16
            IF NOT cl_null(g_fia.fia16) THEN
               CALL i100_fia15(p_cmd,'3')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fia.fia16,g_errno,0)
                  LET g_fia.fia16 = g_fia_o.fia16
                  DISPLAY BY NAME g_fia.fia16
                  NEXT FIELD fia16
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.fka02b
            END IF
 
        AFTER FIELD fia17
            IF NOT cl_null(g_fia.fia17) THEN
               CALL i100_fia15(p_cmd,'4')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fia.fia17,g_errno,0)
                  LET g_fia.fia17 = g_fia_o.fia17
                  DISPLAY BY NAME g_fia.fia17
                  NEXT FIELD fia17
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.fka02c
            END IF
 
        #FUN-840068     ---start---
        AFTER FIELD fiaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(fia011)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia011
                 LET g_qryparam.form ="q_faj3"
                 CALL cl_create_qry() RETURNING g_fia.fia011,g_fia.fia012
                 DISPLAY BY NAME g_fia.fia011
                 DISPLAY BY NAME g_fia.fia012
                 NEXT FIELD fia011
              WHEN INFIELD(fia03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia03
                 LET g_qryparam.form ="q_fic"
                 CALL cl_create_qry() RETURNING g_fia.fia03
                 DISPLAY BY NAME g_fia.fia03
                 NEXT FIELD fia03
              WHEN INFIELD(fia04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia04
                 LET g_qryparam.form ="q_fii"
                 CALL cl_create_qry() RETURNING g_fia.fia04,g_fia.fia05
                 DISPLAY BY NAME g_fia.fia04
                 DISPLAY BY NAME g_fia.fia05
                 NEXT FIELD fia04
              WHEN INFIELD(fia05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia04
                 LET g_qryparam.form ="q_fii"
                 CALL cl_create_qry() RETURNING g_fia.fia04,g_fia.fia05
                 DISPLAY BY NAME g_fia.fia04
                 DISPLAY BY NAME g_fia.fia05
                 NEXT FIELD fia05
              WHEN INFIELD(fia07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia07
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_fia.fia07
                 DISPLAY BY NAME g_fia.fia07
                 NEXT FIELD fia07
              WHEN INFIELD(fia08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia08
                 LET g_qryparam.form ="q_geb"
                 CALL cl_create_qry() RETURNING g_fia.fia08
                 DISPLAY BY NAME g_fia.fia08
                 NEXT FIELD fia08
              WHEN INFIELD(fia09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia09
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_fia.fia09
                 DISPLAY BY NAME g_fia.fia09
                 NEXT FIELD fia09
              WHEN INFIELD(fia10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia10
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_fia.fia10
                 DISPLAY BY NAME g_fia.fia10
                 NEXT FIELD fia10
              WHEN INFIELD(fia11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia11
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_fia.fia11
                 DISPLAY BY NAME g_fia.fia11
              WHEN INFIELD(fia14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia14
                 LET g_qryparam.form ="q_fjf"
                 LET g_qryparam.arg1 =g_plant
                 CALL cl_create_qry() RETURNING g_fia.fia14
                 DISPLAY BY NAME g_fia.fia14
                 NEXT FIELD fia14
              WHEN INFIELD(fia15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia15
                 LET g_qryparam.form ="q_fjg"
                 LET g_qryparam.arg1 = g_fia.fia14
                 LET g_qryparam.arg2 = g_plant
                 CALL cl_create_qry() RETURNING g_fia.fia15
                 DISPLAY BY NAME g_fia.fia15
                 NEXT FIELD fia15
              WHEN INFIELD(fia16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia16
                 LET g_qryparam.form ="q_fjg"
                 LET g_qryparam.arg1 = g_fia.fia14
                 LET g_qryparam.arg2 = g_plant
                 CALL cl_create_qry() RETURNING g_fia.fia16
                 DISPLAY BY NAME g_fia.fia16
                 NEXT FIELD fia16
              WHEN INFIELD(fia17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fia.fia17
                 LET g_qryparam.form ="q_fjg"
                 LET g_qryparam.arg1 = g_fia.fia14
                 LET g_qryparam.arg2 = g_plant
                 CALL cl_create_qry() RETURNING g_fia.fia17
                 DISPLAY BY NAME g_fia.fia17
                 NEXT FIELD fia17
              OTHERWISE EXIT CASE
        END CASE
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 #No.MOD-540141--end
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i100_fia011(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fia012    LIKE fia_file.fia012
   DEFINE l_fia02     LIKE fia_file.fia02
   DEFINE l_fia07     LIKE fia_file.fia07
   DEFINE l_fia08     LIKE fia_file.fia08
   DEFINE l_fia18     LIKE fia_file.fia18
   DEFINE l_fia09     LIKE fia_file.fia09
   DEFINE l_fia10     LIKE fia_file.fia10
   DEFINE l_fia11     LIKE fia_file.fia11
   DEFINE l_fia14     LIKE fia_file.fia14
   DEFINE l_faj53     LIKE faj_file.faj53
   DEFINE l_faj04     LIKE faj_file.faj04
   DEFINE l_faj05     LIKE faj_file.faj05
   DEFINE l_faj23     LIKE faj_file.faj23
   DEFINE l_faj24     LIKE faj_file.faj24
   DEFINE l_faj29     LIKE faj_file.faj29
   DEFINE l_faj33     LIKE faj_file.faj33
   DEFINE l_faj14     LIKE faj_file.faj14
   DEFINE l_faj17     LIKE faj_file.faj17
   DEFINE l_faj141    LIKE faj_file.faj141
 
   LET g_errno = ' '
 
   SELECT faj022,  faj06,  faj11,  faj12,  faj25,  faj10,
          faj19,   faj20,  faj21,  faj53,  faj04,  faj05,
          faj23,   faj24,  faj29,  faj33,  faj14,  faj17,  faj141
     INTO l_fia012,l_fia02,l_fia07,l_fia08,l_fia18,l_fia09,
          l_fia10, l_fia11,l_fia14,l_faj53,l_faj04,l_faj05,
          l_faj23, l_faj24,l_faj29,l_faj33,l_faj14,l_faj17,l_faj141
     FROM faj_file
    WHERE faj02=g_fia.fia011 AND faj022 = ' '
      AND faj021='1'  AND fajconf ='Y'
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-911'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_faj53 TO FORMONLY.faj53
     DISPLAY l_faj04 TO FORMONLY.faj04
     DISPLAY l_faj05 TO FORMONLY.faj05
     DISPLAY l_faj23 TO FORMONLY.faj23
     DISPLAY l_faj24 TO FORMONLY.faj24
     DISPLAY l_faj29 TO FORMONLY.faj29
     DISPLAY l_faj33/l_faj14  TO FORMONLY.c
     DISPLAY l_faj14/l_faj17  TO FORMONLY.d
     DISPLAY l_faj141/l_faj17 TO FORMONLY.f
  END IF
  IF p_cmd='a' AND cl_null(g_errno) THEN
     LET g_fia.fia012 = l_fia012
     LET g_fia.fia02  = l_fia02
     LET g_fia.fia07  = l_fia07
     LET g_fia.fia08  = l_fia08
     LET g_fia.fia18  = l_fia18
     LET g_fia.fia19  = l_fia18
     LET g_fia.fia09  = l_fia09
     LET g_fia.fia10  = l_fia10
     LET g_fia.fia11  = l_fia11
     IF cl_null(l_fia14) THEN LET l_fia14 = NULL END IF #MOD-840439 add
     LET g_fia.fia14  = l_fia14
     LET g_fia.fia20  = g_today
     DISPLAY BY NAME g_fia.fia012,g_fia.fia02,g_fia.fia07,g_fia.fia08,
                     g_fia.fia18 ,g_fia.fia09,g_fia.fia10,g_fia.fia11,
                     g_fia.fia14 ,g_fia.fia19,g_fia.fia20
  END IF
 
END FUNCTION
 
FUNCTION i100_fia03(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fic02 LIKE fic_file.fic02
 
   SELECT fic02,fic03 INTO l_fic02,g_fic03
     FROM fic_file WHERE fic01 = g_fia.fia03
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_fic02 TO FORMONLY.fic02
   END IF
END FUNCTION
 
FUNCTION i100_fia04(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   SELECT UNIQUE fii01 FROM fii_file WHERE fii01 = g_fia.fia04
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i100_fia05(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   SELECT UNIQUE fii02 FROM fii_file WHERE fii02 = g_fia.fia05
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i100_fia04_fia05(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fjd      RECORD LIKE fjd_file.*
 
   IF p_cmd = 'a' THEN
      DECLARE i100_fjd_cur CURSOR FOR
       SELECT * FROM fjd_file
        WHERE fjd01=g_fia.fia04
          AND fjd02=g_fia.fia05
      IF SQLCA.sqlcode THEN RETURN END IF
      FOREACH i100_fjd_cur INTO l_fjd.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach i200_fjd_cur',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          INSERT INTO fib_file VALUES(g_fia.fia01,l_fjd.fjd03,l_fjd.fjd04)
          IF SQLCA.sqlcode THEN
#            CALL cl_err('i100_fjd_cur',SQLCA.sqlcode,0)   #No.FUN-660092
             CALL cl_err3("ins","fib_file",g_fia.fia01,l_fjd.fjd03,SQLCA.sqlcode,"","i100_fjd_cur",1)  #No.FUN-660092
             EXIT FOREACH
          END IF
      END FOREACH
   END IF
 
END FUNCTION
 
FUNCTION i100_fia09(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_pmc03   LIKE pmc_file.pmc03
   DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
   LET g_errno = ' '
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
     FROM pmc_file WHERE pmc01 = g_fia.fia09
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_pmcacti = 'N'     LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'    LET g_errno = '9038'    #No.FUN-690024
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
END FUNCTION
 
FUNCTION i100_fia10(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_genacti LIKE gen_file.genacti
 
   SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
     FROM gen_file WHERE gen01 = g_fia.fia10
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
   IF cl_null(g_errno) THEN
      IF cl_null(g_fia.fia11) THEN
         LET g_fia.fia11 = l_gen03
         DISPLAY BY NAME g_fia.fia11
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_fia11(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file WHERE gem01 = g_fia.fia11
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
FUNCTION i100_fia14(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fka02   LIKE fka_file.fka02
   DEFINE l_fjfacti LIKE fjf_file.fjfacti
 
   SELECT UNIQUE fjfacti,fka02 INTO l_fjfacti,l_fka02
     FROM fjf_file LEFT OUTER JOIN fka_file ON fjf_file.fjf01=fka_file.fka01 AND fjf_file.fjf02=fka_file.fka03
    WHERE fjf01 = g_fia.fia14
      AND fjf02 = g_plant
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_fjfacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_fka02 TO FORMONLY.fka02
   END IF
END FUNCTION
 
FUNCTION i100_fia15(p_cmd,p_i)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE p_i     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fjg04   LIKE fjg_file.fjg04
   DEFINE l_fka02   LIKE fka_file.fka02
   DEFINE l_fkaacti LIKE fka_file.fkaacti
 
   CASE p_i
        WHEN '2' LET l_fjg04=g_fia.fia15
        WHEN '3' LET l_fjg04=g_fia.fia16
        WHEN '4' LET l_fjg04=g_fia.fia17
   END CASE
   SELECT UNIQUE fka02 INTO l_fka02
     FROM fjf_file,fjg_file LEFT OUTER JOIN fka_file ON fjg_file.fjg04=fka_file.fka01 AND fjg_file.fjg02=fka_file.fka03
    WHERE fjf01 = fjg01 AND fjf02 = fjg02
      AND fjg01 = g_fia.fia14
      AND fjg02 = g_plant
      AND fjg04 = l_fjg04
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_fkaacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE p_i
           WHEN '2' DISPLAY l_fka02 TO FORMONLY.fka02a
           WHEN '3' DISPLAY l_fka02 TO FORMONLY.fka02b
           WHEN '4' DISPLAY l_fka02 TO FORMONLY.fka02c
      END CASE
   END IF
END FUNCTION
 
FUNCTION i100_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_fia.* TO NULL               #No.FUN-6B0050
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_fib.clear()
   CALL g_fij.clear()
   CALL g_fjb.clear()
   CALL g_fjc.clear()
 
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i100_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_fia.* TO NULL
   ELSE
      OPEN i100_count
      FETCH i100_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i100_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i100_cs INTO g_fia.fia01
      WHEN 'P' FETCH PREVIOUS i100_cs INTO g_fia.fia01
      WHEN 'F' FETCH FIRST    i100_cs INTO g_fia.fia01
      WHEN 'L' FETCH LAST     i100_cs INTO g_fia.fia01
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT
 
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i100_cs INTO g_fia.fia01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)
      INITIALIZE g_fia.* TO NULL  #TQC-6B0105
      CLEAR FORM
      CALL g_fib.clear()
      CALL g_fij.clear()
      CALL g_fjb.clear()
      CALL g_fjc.clear()
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
   SELECT * INTO g_fia.* FROM fia_file WHERE fia01 = g_fia.fia01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
      CALL cl_err3("sel","fia_file",g_fia.fia01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
      INITIALIZE g_fia.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_fia.fiauser   #FUN-4C0069
   LET g_data_group = g_fia.fiagrup   #FUN-4C0069
   CALL i100_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i100_show()
   LET g_fia_t.* = g_fia.*                #保存單頭舊值
   DISPLAY BY NAME g_fia.fiaoriu,g_fia.fiaorig,
          g_fia.fia01,g_fia.fia011,g_fia.fia012,g_fia.fia02,
          g_fia.fia03,g_fia.fia04, g_fia.fia05, g_fia.fia06,
          g_fia.fia07,g_fia.fia08, g_fia.fia09, g_fia.fia10,
          g_fia.fia11,g_fia.fia12, g_fia.fia13, g_fia.fia14,
          g_fia.fia15,g_fia.fia16, g_fia.fia17, g_fia.fia18,
          g_fia.fia19,g_fia.fia20, g_fia.fia21, g_fia.fia22,
          g_fia.fia23,g_fia.fia24, g_fia.fia25,
          g_fia.fiauser,g_fia.fiagrup,g_fia.fiamodu,
          g_fia.fiadate,g_fia.fiaacti,
          #FUN-840068     ---start---
          g_fia.fiaud01,g_fia.fiaud02,g_fia.fiaud03,g_fia.fiaud04,
          g_fia.fiaud05,g_fia.fiaud06,g_fia.fiaud07,g_fia.fiaud08,
          g_fia.fiaud09,g_fia.fiaud10,g_fia.fiaud11,g_fia.fiaud12,
          g_fia.fiaud13,g_fia.fiaud14,g_fia.fiaud15 
          #FUN-840068     ----end----
   CALL i100_fia011('d')
   CALL i100_fia03('d')
   CALL i100_fia09('d')
   CALL i100_fia10('d')
   CALL i100_fia11('d')
   CALL i100_fia14('d')
   CALL i100_fia15('d','2')
   CALL i100_fia15('d','3')
   CALL i100_fia15('d','4')
   CALL i100_b1_fill(g_wc2)                 #單身
   CALL i100_b2_fill(g_wc3)                 #單身
   CALL i100_b3_fill(g_wc4)                 #單身
   CALL i100_b4_fill(g_wc5)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i100_r()
   IF s_shut(0) THEN RETURN END IF
   IF g_fia.fia01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_fia.* FROM fia_file WHERE fia01=g_fia.fia01
   #No.TQC-920110 add --begin
   IF g_fia.fiaacti = 'N' THEN
      CALL cl_err('','abm-950',0)
      RETURN
   END IF
   #No.TQC-920110 add --end
 
   BEGIN WORK
   OPEN i100_cl USING g_fia.fia01
   IF STATUS THEN
      CALL cl_err("OPEN i100_cl:", STATUS, 1)         
      CLOSE i100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i100_cl INTO g_fia.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i100_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "fia01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_fia.fia01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM fib_file WHERE fib01 = g_fia.fia01
      IF STATUS THEN
#        CALL cl_err('del fib:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fib_file",g_fia.fia01,"",STATUS,"","del fib:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fij_file WHERE fij01 = g_fia.fia01
      IF STATUS THEN
#        CALL cl_err('del fij:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fij_file",g_fia.fia01,"",STATUS,"","del fij:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fjb_file WHERE fjb01 = g_fia.fia01
      IF STATUS THEN
#        CALL cl_err('del fjb:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fjb_file",g_fia.fia01,"",STATUS,"","del fjb:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fjc_file WHERE fjc01 = g_fia.fia01
      IF STATUS THEN
#        CALL cl_err('del fjc:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fjc_file",g_fia.fia01,"",STATUS,"","del fjc:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fia_file WHERE fia01 = g_fia.fia01
      IF STATUS THEN
#        CALL cl_err('del fia:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fia_file",g_fia.fia01,"",STATUS,"","del fia:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_fia.* TO NULL
      CLEAR FORM
      CALL g_fib.clear()
      CALL g_fij.clear()
      CALL g_fjb.clear()
      CALL g_fjc.clear()
      OPEN i100_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i100_cs
         CLOSE i100_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i100_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i100_cs
         CLOSE i100_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i100_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i100_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i100_fetch('/')
      END IF
   END IF
   CLOSE i100_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i100_b1()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
   l_exit_sw       LIKE type_file.chr1,                                   #No.FUN-680072 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fia.fia01 IS NULL THEN RETURN END IF
   SELECT * INTO g_fia.* FROM fia_file WHERE fia01=g_fia.fia01
   IF g_fia.fiaacti ='N' THEN CALL cl_err(g_fia.fia01,'9027',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT fib02,fib03 ",
                      " FROM fib_file",
                      " WHERE fib01=? AND fib02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fib WITHOUT DEFAULTS FROM s_fib.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
 
          BEGIN WORK
          OPEN i100_cl USING g_fia.fia01
          IF STATUS THEN
             CALL cl_err("OPEN i100_cl:", STATUS, 1)
             CLOSE i100_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i100_cl INTO g_fia.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i100_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b1 >= l_ac THEN
             LET p_cmd='u'
             LET g_fib_t.* = g_fib[l_ac].*  #BACKUP
             OPEN i100_b1_cl USING g_fia.fia01,g_fib_t.fib02
             IF STATUS THEN
                CALL cl_err("OPEN i100_b1_cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i100_b1_cl INTO g_fib[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_fib_t.fib02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
          END IF
 
       BEFORE INSERT
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_fib[l_ac].* TO NULL      #900423
          LET g_fib_t.* = g_fib[l_ac].*         #新輸入資料
          NEXT FIELD fib02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO fib_file(fib01,fib02,fib03)
          VALUES(g_fia.fia01,g_fib[l_ac].fib02,g_fib[l_ac].fib03)
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_fib[l_ac].fib02,SQLCA.sqlcode,0)   #No.FUN-660092
             CALL cl_err3("ins","fib_file",g_fia.fia01,g_fib[l_ac].fib02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b1=g_rec_b1+1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             COMMIT WORK
          END IF
 
       BEFORE FIELD fib02                        #default 序號
          IF g_fib[l_ac].fib02 IS NULL OR g_fib[l_ac].fib02 = 0 THEN
             SELECT max(fib02)+1
               INTO g_fib[l_ac].fib02
               FROM fib_file
              WHERE fib01 = g_fia.fia01
             IF g_fib[l_ac].fib02 IS NULL THEN
                LET g_fib[l_ac].fib02 = 1
             END IF
          END IF
 
       AFTER FIELD fib02                        #check 序號是否重複
          IF NOT cl_null(g_fib[l_ac].fib02) THEN
             IF g_fib[l_ac].fib02 != g_fib_t.fib02 OR
                g_fib_t.fib02 IS NULL THEN
                SELECT count(*) INTO l_n FROM fib_file
                 WHERE fib01 = g_fia.fia01
                   AND fib02 = g_fib[l_ac].fib02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_fib[l_ac].fib02 = g_fib_t.fib02
                   NEXT FIELD fib02
                END IF
             END IF
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_fib_t.fib02 > 0 AND
             g_fib_t.fib02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM fib_file
              WHERE fib01 = g_fia.fia01
                AND fib02 = g_fib_t.fib02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fib_t.fib02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("del","fib_file",g_fia.fia01,g_fib_t.fib02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b1=g_rec_b1-1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             MESSAGE "Delete Ok"
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fib[l_ac].* = g_fib_t.*
             CLOSE i100_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fib[l_ac].fib02,-263,1)
             LET g_fib[l_ac].* = g_fib_t.*
          ELSE
             UPDATE fib_file SET fib02 = g_fib[l_ac].fib02,
                                 fib03 = g_fib[l_ac].fib03
              WHERE fib01=g_fia.fia01 AND fib02=g_fib_t.fib02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fib[l_ac].fib02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","fib_file",g_fia.fia01,g_fib_t.fib02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                LET g_fib[l_ac].* = g_fib_t.*
                CLOSE i100_b1_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D40030
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_fib[l_ac].* = g_fib_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_fib.deleteElement(l_ac)
                IF g_rec_b1 != 0 THEN
                   LET g_action_choice = "accessory"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i100_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D40030
          CLOSE i100_b1_cl
          COMMIT WORK
 
       ON ACTION CONTROLN
          CALL i100_b1_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fib02) AND l_ac > 1 THEN
               LET g_fib[l_ac].* = g_fib[l_ac-1].*
               NEXT FIELD fib02
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls        
         CALL cl_set_head_visible("folder01","AUTO")                       
#No.FUN-6B0029--end                   
 
   END INPUT
 
  #start FUN-5A0029
   LET g_fia.fiamodu = g_user
   LET g_fia.fiadate = g_today
   UPDATE fia_file SET fiamodu = g_fia.fiamodu,fiadate = g_fia.fiadate
    WHERE fia01 = g_fia.fia01
   DISPLAY BY NAME g_fia.fiamodu,g_fia.fiadate
  #end FUN-5A0029
 
   CLOSE i100_b1_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i100_b2()
DEFINE
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
    l_cnt           LIKE type_file.num5,                                   #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fia.fia01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fia.* FROM fia_file WHERE fia01=g_fia.fia01
    IF g_fia.fiaacti ='N' THEN CALL cl_err(g_fia.fia01,'9027',0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fij02,fij03 ",
                       "  FROM fij_file",
                       " WHERE fij01=? AND fij02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_b2_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fij WITHOUT DEFAULTS FROM s_fij.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
 
           BEGIN WORK
           OPEN i100_cl USING g_fia.fia01
           IF STATUS THEN
              CALL cl_err("OPEN i100_cl:", STATUS, 1)
              CLOSE i100_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i100_cl INTO g_fia.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i100_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_fij_t.* = g_fij[l_ac].*  #BACKUP
              OPEN i100_b2_cl USING g_fia.fia01,g_fij_t.fij02
              IF STATUS THEN
                 CALL cl_err("OPEN i100_b2_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i100_b2_cl INTO g_fij[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_fij_t.fij02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_fij[l_ac].* TO NULL
           LET g_fij_t.* = g_fij[l_ac].*         #新輸入資料
           NEXT FIELD fij02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO fij_file(fij01,fij02,fij03)
            VALUES(g_fia.fia01,g_fij[l_ac].fij02,g_fij[l_ac].fij03)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_fij[l_ac].fij02,SQLCA.sqlcode,0)   #No.FUN-660092
              CALL cl_err3("ins","fij_file",g_fia.fia01,g_fij[l_ac].fij02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              COMMIT WORK
           END IF
 
{        BEFORE FIELD fij02                        #default 序號
           IF g_fij[l_ac].fij02 IS NULL OR g_fij[l_ac].fij02 = 0 THEN
              SELECT max(fij02)+1
                INTO g_fij[l_ac].fij02
                FROM fij_file
               WHERE fij01 = g_fia.fia01
              IF g_fij[l_ac].fij02 IS NULL THEN
                 LET g_fij[l_ac].fij02 = 1
              END IF
           END IF
}
        AFTER FIELD fij02                        #check 序號是否重複
           IF NOT cl_null(g_fij[l_ac].fij02) THEN
              IF g_fij[l_ac].fij02 != g_fij_t.fij02 OR g_fij_t.fij02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM fij_file
                  WHERE fij01 = g_fia.fia01
                    AND fij02 = g_fij[l_ac].fij02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fij[l_ac].fij02 = g_fij_t.fij02
                    NEXT FIELD fij02
                 END IF
              END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_fij_t.fij02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM fij_file
               WHERE fij01 = g_fia.fia01
                 AND fij02 = g_fij_t.fij02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fij_t.fij02,SQLCA.sqlcode,0)   #No.FUN-660092
                 CALL cl_err3("del","fij_file",g_fia.fia01,g_fij_t.fij02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              MESSAGE "Delete Ok"
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fij[l_ac].* = g_fij_t.*
               CLOSE i100_b2_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fij[l_ac].fij02,-263,1)
               LET g_fij[l_ac].* = g_fij_t.*
            ELSE
               UPDATE fij_file SET fij02 = g_fij[l_ac].fij02,
                                   fij03 = g_fij[l_ac].fij03
                WHERE fij01=g_fia.fia01
                  AND fij02=g_fij_t.fij02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fij[l_ac].fij02,SQLCA.sqlcode,0)   #No.FUN-660092
                  CALL cl_err3("upd","fij_file",g_fia.fia01,g_fij_t.fij02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  LET g_fij[l_ac].* = g_fij_t.*
                  CLOSE i100_b2_cl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fij[l_ac].* = g_fij_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fij.deleteElement(l_ac)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "user_defined_columns"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i100_b2_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i100_b2_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
           CALL i100_b2_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fij02) AND l_ac > 1 THEN
               LET g_fij[l_ac].* = g_fij[l_ac-1].*
               NEXT FIELD fij02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                                           
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
#No.FUN-6B0029--end 
 
    END INPUT
 
   #start FUN-5A0029
    LET g_fia.fiamodu = g_user
    LET g_fia.fiadate = g_today
    UPDATE fia_file SET fiamodu = g_fia.fiamodu,fiadate = g_fia.fiadate
     WHERE fia01 = g_fia.fia01
    DISPLAY BY NAME g_fia.fiamodu,g_fia.fiadate
   #end FUN-5A0029
 
    CLOSE i100_b2_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i100_b3()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
   l_exit_sw       LIKE type_file.chr1,                                   #No.FUN-680072 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fia.fia01 IS NULL THEN RETURN END IF
   SELECT * INTO g_fia.* FROM fia_file WHERE fia01=g_fia.fia01
   IF g_fia.fiaacti ='N' THEN CALL cl_err(g_fia.fia01,'9027',0) RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT fjb02,fjb03,'',fjb04,'',fjb05,fjb06, ",
                      #No.FUN-840068 --start--
                      "       fjbud01,fjbud02,fjbud03,fjbud04,fjbud05,",
                      "       fjbud06,fjbud07,fjbud08,fjbud09,fjbud10,",
                      "       fjbud11,fjbud12,fjbud13,fjbud14,fjbud15 ", 
                      #No.FUN-840068 ---end---
                      " FROM fjb_file",
                      " WHERE fjb01=? AND fjb02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i100_b3_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fjb WITHOUT DEFAULTS FROM s_fjb.*
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b3 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
 
          BEGIN WORK
          OPEN i100_cl USING g_fia.fia01
          IF STATUS THEN
             CALL cl_err("OPEN i100_cl:", STATUS, 1)
             CLOSE i100_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i100_cl INTO g_fia.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i100_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b3 >= l_ac THEN
             LET p_cmd='u'
             LET g_fjb_t.* = g_fjb[l_ac].*  #BACKUP
             LET g_fjb05_t = g_fjb[l_ac].fjb05      #FUN-BB0084 
             OPEN i100_b3_cl USING g_fia.fia01,g_fjb_t.fjb02
             IF STATUS THEN
                CALL cl_err("OPEN i100_b3_cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i100_b3_cl INTO g_fjb[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_fjb_t.fjb02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                CALL i100_fjb03('d')
                SELECT fiz02 INTO g_fjb[l_ac].fiz02 FROM fiz_file
                 WHERE fiz01 = g_fjb[l_ac].fjb04
             END IF
          END IF
 
       BEFORE INSERT
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_fjb[l_ac].* TO NULL      #900423
          LET g_fjb_t.* = g_fjb[l_ac].*         #新輸入資料
          LET g_fjb05_t = g_fjb[l_ac].fjb05     #FUN-BB0084 
          LET g_fjb[l_ac].fjb06=0
          NEXT FIELD fjb02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO fjb_file(fjb01,fjb02,fjb03,fjb04,fjb05,fjb06,
                               #FUN-840068 --start--
                               fjbud01,fjbud02,fjbud03,fjbud04,fjbud05,fjbud06,
                               fjbud07,fjbud08,fjbud09,fjbud10,fjbud11,fjbud12,
                               fjbud13,fjbud14,fjbud15)
                               #FUN-840068 --end--
          VALUES(g_fia.fia01,g_fjb[l_ac].fjb02,g_fjb[l_ac].fjb03,
                 g_fjb[l_ac].fjb04,g_fjb[l_ac].fjb05,g_fjb[l_ac].fjb06,
                 #FUN-840068 --start--
                 g_fjb[l_ac].fjbud01,g_fjb[l_ac].fjbud02,g_fjb[l_ac].fjbud03,
                 g_fjb[l_ac].fjbud04,g_fjb[l_ac].fjbud05,g_fjb[l_ac].fjbud06,
                 g_fjb[l_ac].fjbud07,g_fjb[l_ac].fjbud08,g_fjb[l_ac].fjbud09,
                 g_fjb[l_ac].fjbud10,g_fjb[l_ac].fjbud11,g_fjb[l_ac].fjbud12,
                 g_fjb[l_ac].fjbud13,g_fjb[l_ac].fjbud14,g_fjb[l_ac].fjbud15)
                 #FUN-840068 --end--
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_fjb[l_ac].fjb02,SQLCA.sqlcode,0)   #No.FUN-660092
             CALL cl_err3("ins","fjb_file",g_fia.fia01,g_fjb[l_ac].fjb02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b3=g_rec_b3+1
             DISPLAY g_rec_b3 TO FORMONLY.cn4
             COMMIT WORK
          END IF
 
       BEFORE FIELD fjb02                        #default 序號
          IF g_fjb[l_ac].fjb02 IS NULL OR g_fjb[l_ac].fjb02 = 0 THEN
             SELECT max(fjb02)+1
               INTO g_fjb[l_ac].fjb02
               FROM fjb_file
              WHERE fjb01 = g_fia.fia01
             IF g_fjb[l_ac].fjb02 IS NULL THEN
                LET g_fjb[l_ac].fjb02 = 1
             END IF
          END IF
 
       AFTER FIELD fjb02                        #check 序號是否重複
          IF NOT cl_null(g_fjb[l_ac].fjb02) THEN
             IF g_fjb[l_ac].fjb02 != g_fjb_t.fjb02 OR
                g_fjb_t.fjb02 IS NULL THEN
                SELECT COUNT(*) INTO l_n FROM fjb_file
                 WHERE fjb01 = g_fia.fia01
                   AND fjb02 = g_fjb[l_ac].fjb02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_fjb[l_ac].fjb02 = g_fjb_t.fjb02
                   NEXT FIELD fjb02
                END IF
             END IF
          END IF
 
       AFTER FIELD fjb03
          IF NOT cl_null(g_fjb[l_ac].fjb03) THEN
            #FUN-AA0059 A-----------------add start--------------
             IF NOT s_chk_item_no(g_fjb[l_ac].fjb03,'') THEN
                CALL cl_err('',g_errno,1)
                LET g_fjb[l_ac].fjb03 = g_fjb_t.fjb03
                NEXT FIELD fjb03
             END IF 
            #FUN-AA0059 -----------------add end-----------------    
             CALL i100_fjb03(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fjb[l_ac].fjb03,SQLCA.sqlcode,0)
                LET g_fjb[l_ac].fjb03 = g_fjb_t.fjb03
                NEXT FIELD fjb03
             END IF
          END IF
 
       AFTER FIELD fjb04
          IF NOT cl_null(g_fjb[l_ac].fjb04) THEN
             SELECT fiz02 INTO g_fjb[l_ac].fiz02 FROM fiz_file
              WHERE fiz01 = g_fjb[l_ac].fjb04
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fjb[l_ac].fjb04,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("sel","fiz_file",g_fjb[l_ac].fjb04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                LET g_fjb[l_ac].fjb04 = g_fjb_t.fjb04
                NEXT FIELD fjb04
             END IF
          END IF
 
       AFTER FIELD fjb05
          IF NOT cl_null(g_fjb[l_ac].fjb05) THEN
             CALL i100_fjb05(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fjb[l_ac].fjb05,SQLCA.sqlcode,0)
                LET g_fjb[l_ac].fjb05 = g_fjb_t.fjb05
                NEXT FIELD fjb05
             END IF
          END IF
       #FUN-BB0084 ----------Begin-----------
          IF NOT i100_fjb06_chk() THEN
             LET g_fjb05_t = g_fjb[l_ac].fjb05
             NEXT FIELD fjb06
          END IF 
          LET g_fjb05_t = g_fjb[l_ac].fjb05  
       #FUN-BB0084 ----------End-------------
 
       AFTER FIELD fjb06
       #FUN-BB0084 --------Begin-----------
          IF NOT i100_fjb06_chk() THEN
             NEXT FIELD fjb06
          END IF
       #FUN-BB0084 --------End-------------
       #FUN-BB0084 ---------Begin----------
       #  IF g_fjb[l_ac].fjb06 < 0 THEN
       #     CALL cl_err('','aem-042',0)     #TQC-970094
       #     NEXT FIELD fjb06
       #  END IF
       #FUN-BB0084 ---------End------------
 
       #No.FUN-840068 --start--
       AFTER FIELD fjbud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fjbud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-840068 ---end---
 
       BEFORE DELETE                            #是否取消單身
          IF g_fjb_t.fjb02 > 0 AND
             g_fjb_t.fjb02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM fjb_file
              WHERE fjb01 = g_fia.fia01
                AND fjb02 = g_fjb_t.fjb02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fjb_t.fjb02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("del","fjb_file",g_fia.fia01,g_fjb_t.fjb02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b3=g_rec_b3-1
             DISPLAY g_rec_b3 TO FORMONLY.cn4
             MESSAGE "Delete Ok"
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fjb[l_ac].* = g_fjb_t.*
             CLOSE i100_b3_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fjb[l_ac].fjb02,-263,1)
             LET g_fjb[l_ac].* = g_fjb_t.*
          ELSE
             UPDATE fjb_file SET fjb02 = g_fjb[l_ac].fjb02,
                                 fjb03 = g_fjb[l_ac].fjb03,
                                 fjb04 = g_fjb[l_ac].fjb04,
                                 fjb05 = g_fjb[l_ac].fjb05,
                                 fjb06 = g_fjb[l_ac].fjb06,
                                 #FUN-840068 --start--
                                 fjbud01 = g_fjb[l_ac].fjbud01,
                                 fjbud02 = g_fjb[l_ac].fjbud02,
                                 fjbud03 = g_fjb[l_ac].fjbud03,
                                 fjbud04 = g_fjb[l_ac].fjbud04,
                                 fjbud05 = g_fjb[l_ac].fjbud05,
                                 fjbud06 = g_fjb[l_ac].fjbud06,
                                 fjbud07 = g_fjb[l_ac].fjbud07,
                                 fjbud08 = g_fjb[l_ac].fjbud08,
                                 fjbud09 = g_fjb[l_ac].fjbud09,
                                 fjbud10 = g_fjb[l_ac].fjbud10,
                                 fjbud11 = g_fjb[l_ac].fjbud11,
                                 fjbud12 = g_fjb[l_ac].fjbud12,
                                 fjbud13 = g_fjb[l_ac].fjbud13,
                                 fjbud14 = g_fjb[l_ac].fjbud14,
                                 fjbud15 = g_fjb[l_ac].fjbud15
                                 #FUN-840068 --end-- 
              WHERE fjb01=g_fia.fia01 AND fjb02=g_fjb_t.fjb02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fjb[l_ac].fjb02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","fjb_file",g_fia.fia01,g_fjb_t.fjb02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                LET g_fjb[l_ac].* = g_fjb_t.*
                CLOSE i100_b3_cl
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D40030
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_fjb[l_ac].* = g_fjb_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_fjb.deleteElement(l_ac)
                IF g_rec_b3 != 0 THEN
                   LET g_action_choice = "spare_part"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE i100_b3_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D40030
          CLOSE i100_b3_cl
          COMMIT WORK
 
       ON ACTION CONTROLN
          CALL i100_b3_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fjb02) AND l_ac > 1 THEN
               LET g_fjb[l_ac].* = g_fjb[l_ac-1].*
               NEXT FIELD fjb02
           END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fjb03)
#FUN-AA0059 --Begin--
               # CALL cl_init_qry_var()
               # LET g_qryparam.default1 = g_fjb[l_ac].fjb03
               # LET g_qryparam.form ="q_ima"
               # CALL cl_create_qry() RETURNING g_fjb[l_ac].fjb03
                CALL q_sel_ima(FALSE, "q_ima", "", g_fjb[l_ac].fjb03 , "", "", "", "" ,"",'' )  RETURNING g_fjb[l_ac].fjb03 
#FUN-AA0059 ---End--
                NEXT FIELD fjb03
             WHEN INFIELD(fjb04)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_fjb[l_ac].fjb04
                LET g_qryparam.form ="q_fiz"
                CALL cl_create_qry() RETURNING g_fjb[l_ac].fjb04
                NEXT FIELD fjb04
             WHEN INFIELD(fjb05)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_fjb[l_ac].fjb04
                LET g_qryparam.form ="q_gfe"
                CALL cl_create_qry() RETURNING g_fjb[l_ac].fjb04
                NEXT FIELD fjb05
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                                           
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
#No.FUN-6B0029--end 
 
   END INPUT
 
  #start FUN-5A0029
   LET g_fia.fiamodu = g_user
   LET g_fia.fiadate = g_today
   UPDATE fia_file SET fiamodu = g_fia.fiamodu,fiadate = g_fia.fiadate
    WHERE fia01 = g_fia.fia01
   DISPLAY BY NAME g_fia.fiamodu,g_fia.fiadate
  #end FUN-5A0029
 
   CLOSE i100_b3_cl
   COMMIT WORK
 
END FUNCTION
 
#FUN-BB0084 ---------------Begin-------------
FUNCTION i100_fjb06_chk()   
   IF g_fjb[l_ac].fjb06 < 0 THEN
      CALL cl_err('','aem-042',0) 
      RETURN FALSE 
   END IF
   IF NOT cl_null(g_fjb[l_ac].fjb06) AND NOT cl_null(g_fjb[l_ac].fjb05) THEN
      IF cl_null(g_fjb05_t) OR cl_null(g_fjb_t.fjb06) OR g_fjb05_t! = g_fjb[l_ac].fjb05
         OR g_fjb_t.fjb06! = g_fjb[l_ac].fjb06 THEN
         LET g_fjb[l_ac].fjb06 = s_digqty(g_fjb[l_ac].fjb06,g_fjb[l_ac].fjb05)
         DISPLAY BY NAME g_fjb[l_ac].fjb06
      END IF
   END IF 
   RETURN TRUE
END FUNCTION

#FUN-BB0084 ---------------End---------------
FUNCTION i100_fjb03(p_cmd)
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima25    LIKE ima_file.ima25,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima25,imaacti INTO l_ima02,l_ima25,l_imaacti
      FROM ima_file WHERE ima01 = g_fjb[l_ac].fjb03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET l_ima02 = NULL
                                   LET l_ima25 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'    LET g_errno = '9038'   #No.FUN-690022
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF p_cmd = 'a' AND cl_null(g_errno) THEN
       LET g_fjb[l_ac].fjb05 = l_ima25
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_fjb[l_ac].ima02 = l_ima02
    END IF
END FUNCTION
 
FUNCTION i100_fjb05(p_cmd)
    DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
           p_cmd      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
      FROM gfe_file WHERE gfe01 = g_fjb[l_ac].fjb05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-319'
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i100_b4()
DEFINE
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
    l_cnt           LIKE type_file.num5,                                   #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fia.fia01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fia.* FROM fia_file WHERE fia01=g_fia.fia01
    IF g_fia.fiaacti ='N' THEN CALL cl_err(g_fia.fia01,'9027',0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fjc02,fjc03,'','','','','','' ",
                       "  FROM fjc_file",
                       " WHERE fjc01=? AND fjc02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_b4_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fjc WITHOUT DEFAULTS FROM s_fjc.*
          ATTRIBUTE(COUNT=g_rec_b4,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b4 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           IF l_ac MOD 2 = 0 THEN
              CALL cl_set_comp_font_color("fjc02,fjc03,fio05,fio06,fiu02,fio07,fja02,fio08","green")
           ELSE
              CALL cl_set_comp_font_color("fjc02,fjc03,fio05,fio06,fiu02,fio07,fja02,fio08","yellow")
           END IF
           LET l_lock_sw = 'N'            #DEFAULT
 
           BEGIN WORK
           OPEN i100_cl USING g_fia.fia01
           IF STATUS THEN
              CALL cl_err("OPEN i100_cl:", STATUS, 1)
              CLOSE i100_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i100_cl INTO g_fia.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i100_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b4 >= l_ac THEN
              LET p_cmd='u'
              LET g_fjc_t.* = g_fjc[l_ac].*  #BACKUP
              OPEN i100_b4_cl USING g_fia.fia01,g_fjc_t.fjc02
              IF STATUS THEN
                 CALL cl_err("OPEN i100_b4_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i100_b4_cl INTO g_fjc[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_fjc_t.fjc02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i100_fjc03('d')
              END IF
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_fjc[l_ac].* TO NULL
           LET g_fjc_t.* = g_fjc[l_ac].*         #新輸入資料
           NEXT FIELD fjc02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO fjc_file(fjc01,fjc02,fjc03)
            VALUES(g_fia.fia01,g_fjc[l_ac].fjc02,g_fjc[l_ac].fjc03)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_fjc[l_ac].fjc02,SQLCA.sqlcode,0)   #No.FUN-660092
              CALL cl_err3("ins","fjc_file",g_fia.fia01,g_fjc[l_ac].fjc02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b4=g_rec_b4+1
              DISPLAY g_rec_b4 TO FORMONLY.cn8
              COMMIT WORK
           END IF
 
        BEFORE FIELD fjc02                        #default 序號
           IF g_fjc[l_ac].fjc02 IS NULL OR g_fjc[l_ac].fjc02 = 0 THEN
              SELECT max(fjc02)+1
                INTO g_fjc[l_ac].fjc02
                FROM fjc_file
               WHERE fjc01 = g_fia.fia01
              IF g_fjc[l_ac].fjc02 IS NULL THEN
                 LET g_fjc[l_ac].fjc02 = 1
              END IF
           END IF
 
        AFTER FIELD fjc02                        #check 序號是否重複
           IF NOT cl_null(g_fjc[l_ac].fjc02) THEN
              IF g_fjc[l_ac].fjc02 != g_fjc_t.fjc02 OR g_fjc_t.fjc02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM fjc_file
                  WHERE fjc01 = g_fia.fia01
                    AND fjc02 = g_fjc[l_ac].fjc02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fjc[l_ac].fjc02 = g_fjc_t.fjc02
                    NEXT FIELD fjc02
                 END IF
              END IF
           END IF
 
       AFTER FIELD fjc03
          IF NOT cl_null(g_fjc[l_ac].fjc03) THEN
             CALL i100_fjc03(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fjc[l_ac].fjc03,SQLCA.sqlcode,0)
                LET g_fjc[l_ac].fjc03 = g_fjc_t.fjc03
                NEXT FIELD fjc03
             END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_fjc_t.fjc02 > 0 AND g_fjc_t.fjc02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM fjc_file
               WHERE fjc01 = g_fia.fia01
                 AND fjc02 = g_fjc_t.fjc02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fjc_t.fjc02,SQLCA.sqlcode,0)   #No.FUN-660092
                 CALL cl_err3("del","fjc_file",g_fia.fia01,g_fjc_t.fjc02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b4=g_rec_b4-1
              DISPLAY g_rec_b4 TO FORMONLY.cn8
              MESSAGE "Delete Ok"
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fjc[l_ac].* = g_fjc_t.*
               CLOSE i100_b4_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fjc[l_ac].fjc02,-263,1)
               LET g_fjc[l_ac].* = g_fjc_t.*
            ELSE
               UPDATE fjc_file SET fjc02 = g_fjc[l_ac].fjc02,
                                   fjc03 = g_fjc[l_ac].fjc03
                WHERE fjc01=g_fia.fia01
                  AND fjc02=g_fjc_t.fjc02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fjc[l_ac].fjc02,SQLCA.sqlcode,0)   #No.FUN-660092
                  CALL cl_err3("upd","fjc_file",g_fia.fia01,g_fjc_t.fjc02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  LET g_fjc[l_ac].* = g_fjc_t.*
                  CLOSE i100_b4_cl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fjc[l_ac].* = g_fjc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fjc.deleteElement(l_ac)
                  IF g_rec_b4 != 0 THEN
                     LET g_action_choice = "maintain_repair"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i100_b4_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i100_b4_cl
            COMMIT WORK
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fjc03)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_fjc[l_ac].fjc03
                LET g_qryparam.form ="q_fio"
                CALL cl_create_qry() RETURNING g_fjc[l_ac].fjc03
                NEXT FIELD fjc03
             OTHERWISE EXIT CASE
          END CASE
 
        ON ACTION CONTROLN
           CALL i100_b4_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fjc02) AND l_ac > 1 THEN
               LET g_fjc[l_ac].* = g_fjc[l_ac-1].*
               NEXT FIELD fjc02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                                           
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
#No.FUN-6B0029--end 
 
    END INPUT
 
   #start FUN-5A0029
    LET g_fia.fiamodu = g_user
    LET g_fia.fiadate = g_today
    UPDATE fia_file SET fiamodu = g_fia.fiamodu,fiadate = g_fia.fiadate
     WHERE fia01 = g_fia.fia01
    DISPLAY BY NAME g_fia.fiamodu,g_fia.fiadate
   #end FUN-5A0029
 
    CLOSE i100_b4_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i100_fjc03(p_cmd)
    DEFINE l_fioacti  LIKE fio_file.fioacti,
           p_cmd      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT fio05,fio06,fiu02,fio07,fja02,fio08,fioacti
      INTO g_fjc[l_ac].fio05,g_fjc[l_ac].fio06,g_fjc[l_ac].fiu02,
           g_fjc[l_ac].fio07,g_fjc[l_ac].fja02,g_fjc[l_ac].fio08,l_fioacti
      FROM fio_file LEFT OUTER JOIN fiu_file ON fio_file.fio06 = fiu_file.fiu01 LEFT OUTER JOIN fja_file ON fio_file.fio07=fja_file.fja01
     WHERE fio01 = g_fjc[l_ac].fjc03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET g_fjc[l_ac].fio05 = NULL
                                   LET g_fjc[l_ac].fio06 = NULL
                                   LET g_fjc[l_ac].fio07 = NULL
                                   LET g_fjc[l_ac].fio08 = NULL
                                   LET g_fjc[l_ac].fiu02 = NULL
                                   LET g_fjc[l_ac].fja02 = NULL
         WHEN l_fioacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i100_b1_askkey()
   #DEFINE l_wc2           VARCHAR(200) #TQC-630166   
    DEFINE l_wc2           STRING    #TQC-630166   
 
    CONSTRUCT l_wc2 ON fib02,fib03
            FROM s_fib[1].fib02,s_fib[1].fib03
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i100_b1_fill(l_wc2)
END FUNCTION
 
FUNCTION i100_b1_fill(p_wc1)
DEFINE
   #p_wc1           VARCHAR(200) #TQC-630166     
    p_wc1           STRING    #TQC-630166     
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
    LET g_sql = "SELECT fib02,fib03",
                "  FROM fib_file",
                " WHERE fib01 ='",g_fia.fia01,"'",
                "   AND ",p_wc1 CLIPPED,
                " ORDER BY 1"
    PREPARE i100_pb1 FROM g_sql
    DECLARE fib_curs1 CURSOR FOR i100_pb1
 
    CALL g_fib.clear()
    LET l_ac = 1
    FOREACH fib_curs1 INTO g_fib[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_fib.deleteElement(l_ac)
    LET g_rec_b1 = l_ac-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i100_b2_askkey()
   #DEFINE l_wc2           VARCHAR(200) #TQC-630166    
    DEFINE l_wc2           STRING    #TQC-630166    
 
    CONSTRUCT l_wc2 ON fij02,fij03
            FROM s_fij[1].fij02,s_fij[1].fij03
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i100_b2_fill(l_wc2)
END FUNCTION
 
FUNCTION i100_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           VARCHAR(200) #TQC-630166 
    p_wc2           STRING    #TQC-630166 
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT fij02,fij03 ",
                " FROM fij_file",
                " WHERE fij01 ='",g_fia.fia01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE i100_pb2 FROM g_sql
    DECLARE fij_curs2 CURSOR FOR i100_pb2
 
    CALL g_fij.clear()
    LET g_cnt = 1
    FOREACH fij_curs2 INTO g_fij[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_fij.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION
 
FUNCTION i100_b3_askkey()
   #DEFINE l_wc2           VARCHAR(200) #TQC-630166
    DEFINE l_wc2           STRING    #TQC-630166
 
    CONSTRUCT l_wc2 ON fjb02,fjb03,fjb04,fjb05,fjb06
                       #No.FUN-840068 --start--
                       ,fjbud01,fjbud02,fjbud03,fjbud04,fjbud05
                       ,fjbud06,fjbud07,fjbud08,fjbud09,fjbud10
                       ,fjbud11,fjbud12,fjbud13,fjbud14,fjbud15
                       #No.FUN-840068 ---end---
         FROM s_fjb[1].fjb02,s_fjb[1].fjb03,s_fjb[1].fjb04,
              s_fjb[1].fjb05,s_fjb[1].fjb06
              #No.FUN-840068 --start--
              ,s_fjb[1].fjbud01,s_fjb[1].fjbud02,s_fjb[1].fjbud03
              ,s_fjb[1].fjbud04,s_fjb[1].fjbud05,s_fjb[1].fjbud06
              ,s_fjb[1].fjbud07,s_fjb[1].fjbud08,s_fjb[1].fjbud09
              ,s_fjb[1].fjbud10,s_fjb[1].fjbud11,s_fjb[1].fjbud12
              ,s_fjb[1].fjbud13,s_fjb[1].fjbud14,s_fjb[1].fjbud15
              #No.FUN-840068 ---end---
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fjb03)
#FUN-AA0059 --Begin-- 
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.state = "c"
             #   LET g_qryparam.form ="q_ima"
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO fjb03
                NEXT FIELD fjb03
             WHEN INFIELD(fjb04)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fiz"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fjb04
                NEXT FIELD fjb04
             WHEN INFIELD(fjb05)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gfe"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fjb05
                NEXT FIELD fjb05
             OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i100_b3_fill(l_wc2)
END FUNCTION
 
FUNCTION i100_b3_fill(p_wc3)
DEFINE
   #p_wc3           VARCHAR(200) #TQC-630166
    p_wc3           STRING    #TQC-630166
 
    IF cl_null(p_wc3) THEN LET p_wc3 = ' 1=1' END IF
    LET g_sql = "SELECT fjb02,fjb03,ima02,fjb04,fiz02,fjb05,fjb06, ",
                #No.FUN-840068 --start--
                "       fjbud01,fjbud02,fjbud03,fjbud04,fjbud05,",
                "       fjbud06,fjbud07,fjbud08,fjbud09,fjbud10,",
                "       fjbud11,fjbud12,fjbud13,fjbud14,fjbud15 ", 
                #No.FUN-840068 ---end---
                "  FROM fjb_file LEFT OUTER JOIN ima_file ON fjb_file.fjb03=ima_file.ima01  LEFT OUTER JOIN fiz_file ON fjb_file.fjb04 = fiz_file.fiz01",
                " WHERE fjb01 ='",g_fia.fia01,"'",
                "   AND ",p_wc3 CLIPPED,
                " ORDER BY 1"
    PREPARE i100_pb3 FROM g_sql
    DECLARE fjb_curs3 CURSOR FOR i100_pb3
 
    CALL g_fjb.clear()
    LET l_ac = 1
    FOREACH fjb_curs3 INTO g_fjb[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_ac=l_ac+1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_fjb.deleteElement(l_ac)
    LET g_rec_b3 = l_ac-1
    DISPLAY g_rec_b3 TO FORMONLY.cn6
END FUNCTION
 
FUNCTION i100_b4_askkey()
   #DEFINE l_wc2           VARCHAR(200) #TQC-630166  
    DEFINE l_wc2           STRING    #TQC-630166  
 
    CONSTRUCT l_wc2 ON fjc02,fjc03
            FROM s_fjc[1].fjc02,s_fjc[1].fjc03
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fjc03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fio"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fjc03
                NEXT FIELD fjc03
             OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i100_b4_fill(l_wc2)
END FUNCTION
 
FUNCTION i100_b4_fill(p_wc4)              #BODY FILL UP
DEFINE
   #p_wc4           VARCHAR(200) #TQC-630166
    p_wc4           STRING    #TQC-630166
 
    IF cl_null(p_wc4) THEN LET p_wc4 = ' 1=1' END IF
    LET g_sql = "SELECT fjc02,fjc03,fio05,fio06,fiu02,fio07,fja02,fio08 ",
                "  FROM fjc_file LEFT OUTER JOIN fio_file LEFT OUTER JOIN fiu_file ON fio_file.fio06=fiu_file.fiu01 LEFT OUTER JOIN fja_file ON fio_file.fio07=fja_file.fja01 ON fjc_file.fjc03=fio_file.fio01 ",
                " WHERE fjc01 ='",g_fia.fia01,"'",
                "   AND ",p_wc4 CLIPPED,
                " ORDER BY 1"
    PREPARE i100_pb4 FROM g_sql
    DECLARE fjc_curs4 CURSOR FOR i100_pb4
 
    CALL g_fjc.clear()
    LET g_cnt = 1
    FOREACH fjc_curs4 INTO g_fjc[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_fjc.deleteElement(g_cnt)
    LET g_rec_b4 = g_cnt-1
    DISPLAY g_rec_b4 TO FORMONLY.cn8
END FUNCTION
 
# NO.FUN-540036--start
FUNCTION i100_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_cmd  LIKE type_file.chr1000         #No.FUN-820002
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN    #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "accessory" THEN  #FUN-D40030 add
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fib TO s_fib.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION user_defined_columns
        LET l_action_flag = "user_defined_columns"
     EXIT DISPLAY
 
     ON ACTION spare_part
        LET l_action_flag = "spare_part"
     EXIT DISPLAY
 
     ON ACTION maintain_repair
        LET l_action_flag = "maintain_repair"
     EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     EXIT DISPLAY
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
     EXIT DISPLAY
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
     EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
     EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
#     ON ACTION accessory
#        LET g_action_choice="accessory"
#        EXIT DISPLAY
#     ON ACTION user_defined_columns
#        LET g_action_choice="user_defined_columns"
#        EXIT DISPLAY
#     ON ACTION spare_part
#     ON ACTION maintain_repair
      ON ACTION detail
         LET g_action_choice="accessory"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="accessory"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end     
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
# NO.FUN-540036--end
 
# NO.FUN-540036--start
FUNCTION i100_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN               #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "user_defined_columns" THEN  #FUN-D40030 add
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fij TO s_fij.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION accessory
        LET l_action_flag = "accessory"
     EXIT DISPLAY
 
     ON ACTION spare_part
        LET l_action_flag = "spare_part"
     EXIT DISPLAY
 
     ON ACTION maintain_repair
        LET l_action_flag = "maintain_repair"
     EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
#NO.FUN-540036--start
#     ON ACTION accessory
#        LET g_action_choice="accessory"
#        EXIT DISPLAY
#     ON ACTION user_defined_columns
#        LET g_action_choice="user_defined_columns"
#        EXIT DISPLAY
#     ON ACTION spare_part
#     ON ACTION maintain_repair
      ON ACTION detail
         LET g_action_choice="user_defined_columns"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="user_defined_columns"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
#No.FUN-6B0029--begin                                                           
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
#No.FUN-6B0029--end 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-540036-end
 
 
# NO.FUN-540036--start
FUNCTION i100_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN     #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "spare_part" THEN  #FUN-D40030 add 
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fjb TO s_fjb.* ATTRIBUTE(COUNT=g_rec_b3)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION accessory
        LET l_action_flag = "accessory"
     EXIT DISPLAY
 
     ON ACTION user_defined_columns
        LET l_action_flag = "user_defined_columns"
     EXIT DISPLAY
 
     ON ACTION maintain_repair
        LET l_action_flag = "maintain_repair"
     EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
#NO.FUN-540036--start
#     ON ACTION accessory
#        LET g_action_choice="accessory"
#        EXIT DISPLAY
#     ON ACTION user_defined_columns
#        LET g_action_choice="user_defined_columns"
#        EXIT DISPLAY
#     ON ACTION spare_part
#     ON ACTION maintain_repair
      ON ACTION detail
         LET g_action_choice="spare_part"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="spare_part"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
#No.FUN-6B0029--begin                                                           
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
#No.FUN-6B0029--end 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-540036-end
 
 
# NO.FUN-540036--start
FUNCTION i100_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN          #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "maintain_repair" THEN  #FUN-D40030 add
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fjc TO s_fjc.* ATTRIBUTE(COUNT=g_rec_b4)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
     ON ACTION accessory
        LET l_action_flag = "accessory"
     EXIT DISPLAY
 
     ON ACTION user_defined_columns
        LET l_action_flag = "user_defined_columns"
     EXIT DISPLAY
 
     ON ACTION spare_part
        LET l_action_flag = "spare_part"
     EXIT DISPLAY
 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
#NO.FUN-540036--start
#     ON ACTION accessory
#        LET g_action_choice="accessory"
#        EXIT DISPLAY
#     ON ACTION user_defined_columns
#        LET g_action_choice="user_defined_columns"
#        EXIT DISPLAY
#     ON ACTION spare_part
#        LET g_action_choice="spare_part"
#        EXIT DISPLAY
#     ON ACTION maintain_repair
      ON ACTION detail
         LET g_action_choice="maintain_repair"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="maintain_repair"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
#No.FUN-6B0029--begin                                                           
      ON ACTION controls                                                        
         CALL cl_set_head_visible("folder01","AUTO")                            
#No.FUN-6B0029--end 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-540036--end
 
#No.FUN-820002--start--
FUNCTION i100_out()
#DEFINE
#   l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
#   sr              RECORD
#       fia01       LIKE fia_file.fia01,
#       fia02       LIKE fia_file.fia02,
#       fia06       LIKE fia_file.fia06,
#       fia14       LIKE fia_file.fia14,
#       fia15       LIKE fia_file.fia15,
#       fia16       LIKE fia_file.fia16,
#       fia17       LIKE fia_file.fia17,
#       fia10       LIKE fia_file.fia10,
#       gen02       LIKE gen_file.gen02
#      END RECORD,
#   l_name          LIKE type_file.chr20,          #No.FUN-680072 VARCHAR(20)
 
#   l_za05          LIKE type_file.chr1000         #No.FUN-680072 VARCHAR(40)
DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc) AND NOT cl_null(g_fia.fia01) THEN                          
       LET g_wc = " fia01 = '",g_fia.fia01,"' "                                 
    END IF                                                                      
    IF g_wc IS NULL THEN                                                        
       CALL cl_err('','9057',0) RETURN                                          
    END IF                                                                      
    LET l_cmd = 'p_query "aemi100" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN
#   END IF
#   IF cl_null(g_wc) AND NOT cl_null(g_fia.fia01) THEN
#      LET g_wc = " fia01 = '",g_fia.fia01,"' "
#   END IF
#   IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1 " END IF
#   IF cl_null(g_wc3) THEN LET g_wc3 = " 1=1 " END IF
#   IF cl_null(g_wc4) THEN LET g_wc4 = " 1=1 " END IF
#   IF cl_null(g_wc5) THEN LET g_wc5 = " 1=1 " END IF
#   CALL cl_wait()
#   CALL cl_outnam('aemi100') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   LET g_sql="SELECT fia01,fia02,fia06,fia14,fia15,fia16,",
#             "       fia17,fia10,gen02 ",
#             g_sql1 CLIPPED,",LEFT OUTER JOIN fia_file ON fia_file.fia10 = gen_file.gen02",
#             g_sql2 CLIPPED, 
#             " ORDER BY fia01"
#   PREPARE i100_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i100_co CURSOR FOR i100_p1
 
#   START REPORT i100_rep TO l_name
 
#   FOREACH i100_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)             
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i100_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i100_rep
 
#   CLOSE i100_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i100_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
#   l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
#   sr              RECORD
#       fia01       LIKE fia_file.fia01,
#       fia02       LIKE fia_file.fia02,
#       fia06       LIKE fia_file.fia06,
#       fia14       LIKE fia_file.fia14,
#       fia15       LIKE fia_file.fia15,
#       fia16       LIKE fia_file.fia16,
#       fia17       LIKE fia_file.fia17,
#       fia10       LIKE fia_file.fia10,
#       gen02       LIKE gen_file.gen02
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.fia01
#   FORMAT
#       PAGE HEADER
#       #   PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
 
#      #    PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           PRINT g_x[5]
#           PRINT
#           PRINT g_dash[1,g_len]
#      #    PRINT COLUMN  01,g_x[11] CLIPPED,
#      #          COLUMN  52,g_x[12] CLIPPED,
#      #          COLUMN  95,g_x[13] CLIPPED,
#      #          COLUMN 131,g_x[14] CLIPPED
#      #    PRINT '------------------- ------------------------------ ------------------------------ ----------- ----------- ----------- ----------- -----------------'
#           PRINT g_x[31], g_x[32],g_x[33],
#                 g_x[34], g_x[35],g_x[36],
#                 g_x[37], g_x[38],g_x[39]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.fia01,
#                 COLUMN g_c[32],sr.fia02,
#                 COLUMN g_c[33],sr.fia06,
#                 COLUMN g_c[34],sr.fia14,
#                 COLUMN g_c[35],sr.fia15,
#                 COLUMN g_c[36],sr.fia16,
#                 COLUMN g_c[37],sr.fia17,
#                 COLUMN g_c[38],sr.fia10,
#                 COLUMN g_c[39],sr.gen02
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN 
#                 #IF g_wc[001,080] > ' ' THEN
#                 #PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                 # IF g_wc[071,140] > ' ' THEN
#                 #PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                 # IF g_wc[141,210] > ' ' THEN
#                 #PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(g_wc) #TQC-630166
#                   PRINT g_dash[1,g_len]
#           END IF
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end--
 
FUNCTION i100_x()
   IF s_shut(0) THEN RETURN END IF
   IF g_fia.fia01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_fia.* FROM fia_file
    WHERE fia01=g_fia.fia01
 
   BEGIN WORK
 
   OPEN i100_cl USING g_fia.fia01
   IF STATUS THEN
      CALL cl_err("OPEN i100_cl:", STATUS, 1)   
      CLOSE i100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i100_cl INTO g_fia.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
   CALL i100_show()
   IF cl_exp(0,0,g_fia.fiaacti) THEN                   #確認一下
       LET g_chr=g_fia.fiaacti
       IF g_fia.fiaacti='Y' THEN
           LET g_fia.fiaacti='N'
       ELSE
           LET g_fia.fiaacti='Y'
       END IF
       UPDATE fia_file
          SET fiaacti=g_fia.fiaacti, #更改有效碼
              fiamodu=g_user,
              fiadate=g_today
        WHERE fia01=g_fia.fia01
       IF SQLCA.sqlcode OR STATUS=100 THEN
           CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   
           LET g_fia.fiaacti=g_chr
       END IF
       SELECT fiaacti,fiamodu,fiadate
         INTO g_fia.fiaacti,g_fia.fiamodu,g_fia.fiadate
         FROM fia_file
        WHERE fia01=g_fia.fia01
       DISPLAY BY NAME g_fia.fiaacti,g_fia.fiamodu,g_fia.fiadate
   END IF
   CLOSE i100_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i100_copy()
DEFINE
    l_newno        LIKE fia_file.fia01,
    l_oldno        LIKE fia_file.fia01
    CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
    IF s_shut(0) THEN RETURN END IF
    IF g_fia.fia01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i100_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM fia01
        AFTER FIELD fia01
            IF l_newno IS NULL THEN
                NEXT FIELD fia01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM fia_file
             WHERE fia01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD fia01
            END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM fia_file         #單頭復制
     WHERE fia01=g_fia.fia01
      INTO TEMP y
    UPDATE y
        SET fia01=l_newno,     #新的鍵值
            fiauser=g_user,    #資料所有者
            fiagrup=g_grup,    #資料所有者所屬群
            fiadate = g_today,
            fiaacti = 'Y'
    INSERT INTO fia_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
#       CALL  cl_err(l_newno,SQLCA.sqlcode,0)  # No.FUN-660092
        CALL cl_err3("ins","fia_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
    END IF
 
    DROP TABLE x
    SELECT * FROM fib_file         #單身復制
     WHERE fib01=g_fia.fia01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    UPDATE x SET fib01=l_newno
    INSERT INTO fib_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","fib_file",g_fia.fia01,g_fib_t.fib02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM fib_file WHERE fib01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    DROP TABLE x
    SELECT * FROM fij_file         #單身復制
     WHERE fij01=g_fia.fia01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    UPDATE x SET fij01=l_newno
    INSERT INTO fij_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","fij_file",l_newno,g_fij_t.fij02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM fij_file WHERE fij01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    DROP TABLE x
    SELECT * FROM fjb_file         #單身復制
     WHERE fjb01=g_fia.fia01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    UPDATE x SET fjb01=l_newno
    INSERT INTO fjb_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","fjb_file",l_newno,g_fjb_t.fjb02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM fjb_file WHERE fjb01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    DROP TABLE x
    SELECT * FROM fjc_file         #單身復制
     WHERE fjc01=g_fia.fia01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    UPDATE x SET fjc01=l_newno
    INSERT INTO fjc_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_fia.fia01,SQLCA.sqlcode,0)   #No.FUN-660092
       CALL cl_err3("ins","fjc_file",l_newno,g_fjc_t.fjc02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
       RETURN
    END IF
    SELECT COUNT(*) INTO g_cnt FROM fjc_file WHERE fjc01=l_newno
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_fia.fia01
    SELECT fia_file.* INTO g_fia.* FROM fia_file
     WHERE fia01 = l_newno
    CALL i100_u()
    CALL i100_b1()
    CALL i100_b2()
    CALL i100_b3()
    CALL i100_b4()
    #FUN-C30027---begin
    #SELECT fia_file.* INTO g_fia.* FROM fia_file
    # WHERE fia01 = l_oldno
    #CALL i100_show()
    #FUN-C30027---end
END FUNCTION
 
FUNCTION i100_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fia01",TRUE)
    END IF
 
    CALL cl_set_comp_entry("fia06",TRUE)
 
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fia01",FALSE)
    END IF
 
    IF g_fic03 = 'N' THEN
       LET g_fia.fia06=''
       DISPLAY BY NAME g_fia.fia06
       CALL cl_set_comp_entry("fia06",FALSE)
    END IF
 
END FUNCTION
