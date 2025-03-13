# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct100.4gl
# Descriptions...: 庫存成本月統計資料維護作業
# Date & Author..: 95/10/18 By Roger
# Modify.........: 03/05/17 By Jiunn (No.7267)
#                  新增 V.聯產品成本
# Modify.........: No.A102 03/12/22 Danny   增加for先進先出報表
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.FUN-5A0182 05/11/01 By Sarah 按下"出庫明細"跳出的視窗,沒有做多語言的控制
# Modify.........: No.TQC-610051 06/02/10 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-650001 06/05/23 By Sarah 增加"入庫細項"PAGE顯示採購入庫/委外入庫/生產入庫/雜項入庫/調撥入庫欄位
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690068 06/09/15 By Sarah 增加ccc81(本月訂單數量),ccc82(本月訂單成本)兩個欄位
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0075 06/10/30 By xumin g_no_ask轉mi_no_ask
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤
# Modify.........: No.FUN-6B0079 06/12/01 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7B0161 07/11/20 By Carol 調整列印欄位的資料來源由ccc91,ccc92,ccc23取得
# Modify.........: No.FUN-7C0043 07/12/19 By Sunyanchun    橾老報表改成p_query 
# Modify.........: No.FUN-7C0101 08/01/10 By Zhangyajun 成本改善增加ccc07(成本計算類別),ccc08(類別編號)和各種制費
# Modify.........: No.FUN-7C0028 08/03/21 By Sarah 串axcr003,axcr010要增加傳ccc07過去
# Modify.........: No.FUN-830140 08/03/28 By Zhangyajun 傳參增加參數
# Modify.........: No.FUN-840202 08/05/07 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.TQC-870024 08/07/16 By lutingting將單號為TQC-810037由21區過單到31區 傳參數引號修改
# Modify.........: No.MOD-8B0060 08/11/14 By Pengu "更改"action應該要可以作權限控管
# Modify.........: No.MOD-8C0189 08/12/18 By claire 調整語法,以免於ifx區會執行錯誤
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No:TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No:CHI-9C0025 09/12/25 By jan ccc08開窗資料修改
# Modify.........: No.FUN-9C0073 10/01/13 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-980045 10/03/09 By kim 銷退成本視參數設定列入庫成本
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模组table重新分类
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.TQC-B50043 11/05/10 By yinhy 去掉更改功能
# Modify.........: No.MOD-B50112 11/05/20 By vampire 串asmq202時少了單引號
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-C90076 12/12/06 By xujing 添加axcq460串入需要接收的參數
# Modify.........: No.TQC-D40037 13/04/17 By xujing 增加axct100中ccc07的選項6:移動加權平均成本
# Modify.........: No.FUN-D50082 13/05/23 By Alberti 增加入庫細項頁籤除平均欄位外，其餘皆可查詢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ccc        RECORD LIKE ccc_file.*,
       g_ccc_t      RECORD LIKE ccc_file.*,
       g_ccc01_t    LIKE ccc_file.ccc01,
       g_ccc02_t    LIKE ccc_file.ccc02,
       g_ccc03_t    LIKE ccc_file.ccc03,
       g_ccc07_t    LIKE ccc_file.ccc07,         #No.FUN-7C0101
       g_ccc08_t    LIKE ccc_file.ccc08,         #No.FUN-7C0101
       g_wc,g_sql   STRING,                      #No.FUN-580092 HCN
       g_ima        RECORD LIKE ima_file.*
DEFINE g_forupd_sql STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_i          LIKE type_file.num5          #count/index for any purpose        #No.FUN-680122 SMALLINT
#DEFINE g_msg        LIKE type_file.chr1000      #TQC-610051 mark        #No.FUN-680122CHAR(72)
DEFINE   g_msg           STRING  #MOD-8C0189 modify LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(300) #TQC-610051
DEFINE t_wc         LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)   #TQC-610051
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680122 SMALLINT
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680122 SMALLINT    #No.FUN-6A0075
#FUN-C90076---add---str---
DEFINE g_argv3      STRING
DEFINE g_argv4      LIKE type_file.chr100
DEFINE g_argv5      LIKE type_file.num5
DEFINE g_argv6      LIKE type_file.num5
#FUN-C90076---add---end---
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
  #FUN-C90076---add---str
    LET g_argv3 = ARG_VAL(3)   #g_wc
    LET g_argv4 = ARG_VAL(4)   #ACTION
    LET g_argv5 = ARG_VAL(5)   #年度
    LET g_argv6 = ARG_VAL(6)   #期別
  #FUN-C90076---add---end
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_ccc.* TO NULL
    INITIALIZE g_ccc_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM ccc_file WHERE ccc01 = ? AND ccc02 = ? AND ccc03 = ? AND ccc07 = ? AND ccc08 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t100_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW t100_w AT p_row,p_col
         WITH FORM "axc/42f/axct100" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
      LET g_action_choice=""
    #FUN-C90076---add---str
    IF NOT cl_null(g_argv4) THEN
       CALL t100_q()
    END IF
    #FUN-C90076---add---end
    CALL t100_menu()
 
    CLOSE WINDOW t100_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t100_cs()
DEFINE l_n LIKE type_file.num5
DEFINE l_tmp LIKE type_file.chr1
DEFINE l_ccc07 LIKE ccc_file.ccc07   #No.FUN-7C0101
    CLEAR FORM
   INITIALIZE g_ccc.* TO NULL    #No.FUN-750051
   #FUN-C90076---add---str---
   IF cl_null(g_action_choice) AND NOT cl_null(g_argv4) THEN
      LET g_wc = " 1=1"
      IF NOT cl_null(g_argv3) THEN
         LET g_wc = g_wc," AND ccc01='",g_argv3 CLIPPED,"'"
      END IF
      IF NOT cl_null(g_argv5) THEN
         LET g_wc = g_wc," AND ccc02=",g_argv5
      END IF
      IF NOT cl_null(g_argv6) THEN
         LET g_wc = g_wc," AND ccc03=",g_argv6
      END IF
   ELSE
   #FUN-C90076---add---end---
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ccc01, ccc04, ccc02, ccc03, ccc07,ccc08,              #No.FUN-7C0101 add ccc07,ccc08
        ccc11, ccc12a, ccc12b, ccc12c, ccc12d, ccc12e, ccc12f,ccc12g,ccc12h,ccc12,
        ccc21, ccc22a, ccc22b, ccc22c, ccc22d, ccc22e, ccc22f,ccc22g,ccc22h,ccc22,
        ccc25, ccc26a, ccc26b, ccc26c, ccc26d, ccc26e, ccc26f,ccc26g,ccc26h,ccc26,
        ccc27, ccc28a, ccc28b, ccc28c, ccc28d, ccc28e, ccc28f,ccc28g,ccc28h,ccc28,
               ccc23a, ccc23b, ccc23c, ccc23d, ccc23e, ccc23f,ccc23g,ccc23h,ccc23,
        ccc91, ccc92a, ccc92b, ccc92c, ccc92d, ccc92e, ccc92f,ccc92g,ccc92h,ccc92,      #No.FUN-7C0101 add
        ccc31, ccc32,  ccc41,  ccc42,  ccc43,  ccc44,
        ccc51, ccc52,  ccc61,  ccc62,  ccc63,  
        ccc81, ccc82,  #FUN-690068 add
        ccc71, ccc72,  ccc93,
#FUN-D50082 
        ccc211,ccc22a1,ccc22b1,ccc22c1,ccc22d1,ccc22e1,ccc22f1,ccc22g1,ccc22h1,
        ccc212,ccc22a2,ccc22b2,ccc22c2,ccc22d2,ccc22e2,ccc22f2,ccc22g2,ccc22h2,
        ccc213,ccc22a3,ccc22b3,ccc22c3,ccc22d3,ccc22e3,ccc22f3,ccc22g3,ccc22h3,
        ccc214,ccc22a4,ccc22b4,ccc22c4,ccc22d4,ccc22e4,ccc22f4,ccc22g4,ccc22h4,
        ccc215,ccc22a5,ccc22b5,ccc22c5,ccc22d5,ccc22e5,ccc22f5,ccc22g5,ccc22h5,
        ccc216,ccc22a6,ccc22b6,ccc22c6,ccc22d6,ccc22e6,ccc22f6,ccc22g6,ccc22h6,
        ccc221,ccc222,ccc223,ccc224,ccc225,ccc226,      
#FUN-D50082 
        cccud01,cccud02,cccud03,cccud04,cccud05,
        cccud06,cccud07,cccud08,cccud09,cccud10,
        cccud11,cccud12,cccud13,cccud14,cccud15
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        
        AFTER FIELD ccc07
              LET l_ccc07 = get_fldbuf(ccc07)
        ON ACTION controlp
           CASE
              WHEN INFIELD(ccc01) #料件編號
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.state= "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO ccc01
                 NEXT FIELD ccc01
              WHEN INFIELD(ccc08)                                               
                 IF l_ccc07 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                    LET g_qryparam.state= "c"                                
                 CASE l_ccc07                                               
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_imd09"  #CHI-9C0025                           
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                     
                 DISPLAY  g_qryparam.multiret TO ccc08                                   
                 NEXT FIELD ccc08                                               
                 END IF                                                         
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
 
        ON ACTION qbe_select
           CALL cl_qbe_select() 
        ON ACTION qbe_save
	   CALL cl_qbe_save()
    END CONSTRUCT
    END IF                      #FUN-C90076
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cccuser', 'cccgrup') #FUN-980030
 
    LET g_sql="SELECT ccc01,ccc02,ccc03,ccc07,ccc08 FROM ccc_file ", # 組合出 SQL 指令#No.FUN-7C0101 add ccc07,ccc08
        " WHERE ",g_wc CLIPPED, " ORDER BY ccc01,ccc02,ccc03,ccc07,ccc08"
    PREPARE t100_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t100_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t100_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ccc_file WHERE ",g_wc CLIPPED
    PREPARE t100_precount FROM g_sql
    DECLARE t100_count CURSOR FOR t100_precount
END FUNCTION
 
FUNCTION t100_menu()
    DEFINE l_cmd  LIKE type_file.chr1000                     #No.FUN-7C0043---add---
    DEFINE l_bdate,l_edate	LIKE type_file.dat           #No.FUN-680122DATE
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_sma.sma43 != '1' THEN 
               CALL cl_set_act_visible("eom_bal_cost",FALSE)
            END IF
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t100_a() 
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t100_q() 
            END IF
#       ON ACTION TLF異動查詢
        ON ACTION qry_tlf_data
            CALL s_azm(g_ccc.ccc02,g_ccc.ccc03) RETURNING g_chr,l_bdate,l_edate
            #LET g_msg="asmq202 ",g_ccc.ccc01," ",l_bdate," ",l_edate              #MOD-B50112 mark
             LET g_msg="asmq202 '",g_ccc.ccc01,"' '",l_bdate,"' '",l_edate,"'"     #MOD-B50112 add
            CALL cl_cmdrun(g_msg)
#       ON ACTION 在製成本
        ON ACTION wip_cost
            LET g_msg="axct400 '@' ",g_ccc.ccc02," ",g_ccc.ccc03," ",g_ccc.ccc01," ",g_ccc.ccc07     #TQC-970003
            CALL cl_cmdrun_wait(g_msg)   #FUN-660216 add
#       ON ACTION 本月入庫明細
        ON ACTION stock_in
            LET t_wc=' ima01="',g_ccc.ccc01,'"'
            LET g_msg = "axcr001 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                        " 'Y' ' ' '1' ", 
                       " '",t_wc,"' '",g_ccc.ccc02,"' '",g_ccc.ccc03,"' '1'"," '",g_rep_user,"' '",g_rep_clas,"' '",g_template,"' '",g_ccc.ccc07,"'" #FUN-830140
            CALL cl_cmdrun(g_msg)
#       ON ACTION 入庫統計
        ON ACTION stock_statistics
            LET t_wc=' ima01="',g_ccc.ccc01,'"'
            LET g_msg = "axcr010 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                        " 'Y' ' ' '1' ", 
                        " '",t_wc,"' '",g_ccc.ccc02,"' '",g_ccc.ccc03,"' '",g_ccc.ccc07,"' 'Y' "   #FUN-7C0028 add g_ccc.ccc07
            CALL cl_cmdrun(g_msg)
#       ON ACTION 出庫明細
        ON ACTION stock_out
           OPEN WINDOW r003_w2 AT 16,5 WITH 1 ROWS,70 COLUMNS 
          #PROMPT "1.工單領用 2.雜項領用 3.其他調整 4.銷售出庫 5.重工領用: "
           CALL cl_getmsg('axc-206',g_lang) RETURNING g_msg
           PROMPT g_msg CLIPPED FOR CHAR g_chr
           CLOSE WINDOW r003_w2
           IF INT_FLAG THEN LET INT_FLAG=0 LET g_chr='1' END IF
           IF g_sma.sma43 = '1' THEN
            LET t_wc=' ima01="',g_ccc.ccc01,'"'
            LET g_msg = "gxcr003 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                        " 'Y' ' ' '1' ", 
                        "'",t_wc,"' '",g_ccc.ccc02,"' '",g_ccc.ccc03,"' '",g_chr,"' "
           ELSE
            LET t_wc=" ima01='",g_ccc.ccc01,"'"
 
            LET g_msg = 'axcr003 "',g_today,'" "',g_user,'" "',g_lang,'" ',
                        ' "Y" " " "1" ', 
                        '"',t_wc,'" "',g_ccc.ccc02,'" "',g_ccc.ccc03,'" "',g_ccc.ccc07,'" "',g_chr,'" '   #FUN-7C0028 add g_ccc.ccc07
           END IF
           CALL cl_cmdrun(g_msg)
#       ON ACTION 領出差異
        ON ACTION issue_diff
            LET t_wc=' ima01="',g_ccc.ccc01,'"'
            LET g_msg = "axcr020 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                        " 'Y' ' ' '1' ", 
                         "'",t_wc,"' '",g_ccc.ccc02,"' '",g_ccc.ccc03,"' '3' 'Y'" ," '",g_rep_user,"' '",g_rep_clas,"' '",g_template,"' '",g_ccc.ccc07,"'" #FUN-830140
            CALL cl_cmdrun(g_msg)
#       ON ACTION 拆件式工單成本查詢
        ON ACTION ex_wip_cost
            LET g_msg="axct600 '@' ",g_ccc.ccc02," ",g_ccc.ccc03," ",g_ccc.ccc01," ",g_ccc.ccc07," ",g_ccc.ccc08
            CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
#       ON ACTION 月底結存明細
        ON ACTION eom_bal_cost 
            IF g_sma.sma43 = '1' THEN
            LET t_wc=' ima01="',g_ccc.ccc01,'"'
            LET g_msg = "gxcr100 '",g_today,"' '",g_user,"' '",g_lang,"' ",
                        " 'Y' ' ' '1' ", 
                         "'",t_wc,"' '",g_ccc.ccc02,"' '",g_ccc.ccc03,"'"," '",g_rep_user,"' '",g_rep_clas,"' '",g_template,"' '",g_ccc.ccc07,"'" #FUN-830140
               CALL cl_cmdrun(g_msg)
            END IF
#       ON ACTION 聯產品成本查詢
        ON ACTION jp_cost
            LET g_msg="axcq450 '",g_ccc.ccc01,"' ",
                                  g_ccc.ccc02," ",
                                  g_ccc.ccc03," '' '1'"
                                  ," '",g_ccc.ccc07,"' '",g_ccc.ccc08,"'"   #No.FUN-7C0101 add
            CALL cl_cmdrun(g_msg)
        ON ACTION next 
            CALL t100_fetch('N') 
        ON ACTION previous 
            CALL t100_fetch('P')
       #No.TQC-B50043  --Begin  
       #ON ACTION modify 
       #    LET g_action_choice="modify"      #No.MOD-8B0060 add
       #    IF cl_chk_act_auth() THEN
       #       CALL t100_u() 
       #    END IF 
        ON ACTION output 
            LET g_action_choice="output" 
            IF cl_chk_act_auth() THEN
               CALL t100_out()  
            END IF
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t100_fetch('/')
        ON ACTION first
            CALL t100_fetch('F')
        ON ACTION last
            CALL t100_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU        #no.MOD-860078
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_ccc.ccc01 IS NOT NULL THEN
                 LET g_doc.column1 = "ccc01"
                 LET g_doc.value1 = g_ccc.ccc01
                 CALL cl_doc()
              END IF
           END IF
        -- for Windows close event trapped
        #darcy:2023/03/10 add s---
        on action fast_excel
            let g_action_choice = "fast_excel"
            if cl_chk_act_auth() then
                if g_ccc.ccc02 is not null and  g_ccc.ccc03 is not null then
                    call t100_fast_excel()
                end if
            end if
        #darcy:2023/03/10 add e---
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t100_cs
END FUNCTION
 
FUNCTION g_ccc_zero()
        LET g_ccc.ccc11=0
        LET g_ccc.ccc12=0
        LET g_ccc.ccc12a=0
        LET g_ccc.ccc12b=0
        LET g_ccc.ccc12c=0
        LET g_ccc.ccc12d=0
        LET g_ccc.ccc12e=0
        LET g_ccc.ccc12f=0    #No.FUN-7C0101
        LET g_ccc.ccc12g=0    #No.FUN-7C0101
        LET g_ccc.ccc12h=0    #No.FUN-7C0101
        LET g_ccc.ccc21=0
        LET g_ccc.ccc22=0
        LET g_ccc.ccc22a=0
        LET g_ccc.ccc22b=0
        LET g_ccc.ccc22c=0
        LET g_ccc.ccc22d=0
        LET g_ccc.ccc22e=0
        LET g_ccc.ccc22f=0    #No.FUN-7C0101
        LET g_ccc.ccc22g=0    #No.FUN-7C0101
        LET g_ccc.ccc22h=0    #No.FUN-7C0101
        LET g_ccc.ccc25=0
        LET g_ccc.ccc26=0
        LET g_ccc.ccc26a=0
        LET g_ccc.ccc26b=0
        LET g_ccc.ccc26c=0
        LET g_ccc.ccc26d=0
        LET g_ccc.ccc26e=0
        LET g_ccc.ccc26f=0    #No.FUN-7C0101
        LET g_ccc.ccc26g=0    #No.FUN-7C0101
        LET g_ccc.ccc26h=0    #No.FUN-7C0101
        LET g_ccc.ccc27=0
        LET g_ccc.ccc28=0
        LET g_ccc.ccc28a=0
        LET g_ccc.ccc28b=0
        LET g_ccc.ccc28c=0
        LET g_ccc.ccc28d=0
        LET g_ccc.ccc28e=0
        LET g_ccc.ccc28f=0    #No.FUN-7C0101
        LET g_ccc.ccc28g=0    #No.FUN-7C0101
        LET g_ccc.ccc28h=0    #No.FUN-7C0101
        LET g_ccc.ccc23=0
        LET g_ccc.ccc23a=0
        LET g_ccc.ccc23b=0
        LET g_ccc.ccc23c=0
        LET g_ccc.ccc23d=0
        LET g_ccc.ccc23e=0
        LET g_ccc.ccc23f=0    #No.FUN-7C0101
        LET g_ccc.ccc23g=0    #No.FUN-7C0101
        LET g_ccc.ccc23h=0    #No.FUN-7C0101
        LET g_ccc.ccc31=0
        LET g_ccc.ccc32=0
        LET g_ccc.ccc41=0
        LET g_ccc.ccc42=0
        LET g_ccc.ccc43=0
        LET g_ccc.ccc44=0
        LET g_ccc.ccc51=0
        LET g_ccc.ccc52=0
        LET g_ccc.ccc61=0
        LET g_ccc.ccc62=0
        LET g_ccc.ccc63=0
        LET g_ccc.ccc81=0    #FUN-690068 add
        LET g_ccc.ccc82=0    #FUN-690068 add
        LET g_ccc.ccc82a=0   #FUN-690068 add
        LET g_ccc.ccc82b=0   #FUN-690068 add
        LET g_ccc.ccc82c=0   #FUN-690068 add
        LET g_ccc.ccc82d=0   #FUN-690068 add
        LET g_ccc.ccc82e=0   #FUN-690068 add
        LET g_ccc.ccc82f=0    #No.FUN-7C0101
        LET g_ccc.ccc82g=0    #No.FUN-7C0101
        LET g_ccc.ccc82h=0    #No.FUN-7C0101
        LET g_ccc.ccc71=0
        LET g_ccc.ccc72=0
        LET g_ccc.ccc91=0
        LET g_ccc.ccc92=0
        LET g_ccc.ccc92a=0
        LET g_ccc.ccc92b=0
        LET g_ccc.ccc92c=0
        LET g_ccc.ccc92d=0
        LET g_ccc.ccc92e=0
        LET g_ccc.ccc92f=0    #No.FUN-7C0101
        LET g_ccc.ccc92g=0    #No.FUN-7C0101
        LET g_ccc.ccc92h=0    #No.FUN-7C0101
        LET g_ccc.ccc93=0
END FUNCTION
 
FUNCTION t100_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ccc.* LIKE ccc_file.*
    CALL g_ccc_zero()
    LET g_ccc.ccc02=g_ccc_t.ccc02
    LET g_ccc.ccc03=g_ccc_t.ccc03
    LET g_ccc.ccc07=g_ccc_t.ccc07         #No.FUN-7C0101
    LET g_ccc.ccc08=g_ccc_t.ccc08         #No.FUN-7C0101
    LET g_ccc01_t = NULL
    LET g_ccc02_t = NULL
    LET g_ccc03_t = NULL
    LET g_ccc07_t = NULL         #No.FUN-7C0101
    LET g_ccc08_t = NULL         #No.FUN-7C0101
    LET g_ccc_t.*=g_ccc.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ccc.ccc07 = g_ccz.ccz28         #No.FUN-7C0101
        LET g_ccc.ccc08 = ' '
        CALL t100_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ccc.ccc01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_ccc.cccoriu = g_user      #No.FUN-980030 10/01/04
        LET g_ccc.cccorig = g_grup      #No.FUN-980030 10/01/04
        LET g_ccc.ccclegal = g_legal    #FUN-A50075
        INSERT INTO ccc_file VALUES(g_ccc.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ccc_file",g_ccc.ccc01,g_ccc.ccc02,SQLCA.sqlcode,"","ins ccc:",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_ccc_t.* = g_ccc.*                # 保存上筆資料
            SELECT ccc01,ccc02,ccc03 INTO g_ccc.ccc01,g_ccc.ccc02,g_ccc.ccc03,g_ccc.ccc07,g_ccc.ccc08 FROM ccc_file
                WHERE ccc01 = g_ccc.ccc01
                  AND ccc02 = g_ccc.ccc02 AND ccc03 = g_ccc.ccc03
                  AND ccc07 = g_ccc.ccc07 AND ccc08 = g_ccc.ccc08    #No.FUN-7C0101
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t100_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n1            LIKE type_file.num5,          #CHI-9C0025
        l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    INPUT BY NAME
        g_ccc.ccc01, g_ccc.ccc04, g_ccc.ccc02, g_ccc.ccc03,     #No.FUN-7C0101 
        g_ccc.ccc07, g_ccc.ccc08,                               #No.FUN-7C0101
        g_ccc.ccc11, g_ccc.ccc12a, g_ccc.ccc12b, g_ccc.ccc12c,
                     g_ccc.ccc12d, g_ccc.ccc12e, g_ccc.ccc12f,
                     g_ccc.ccc12g, g_ccc.ccc12h, g_ccc.ccc12,     #No.FUN-7C0101  
        g_ccc.ccc21, g_ccc.ccc22a, g_ccc.ccc22b, g_ccc.ccc22c,
                     g_ccc.ccc22d, g_ccc.ccc22e, g_ccc.ccc22f,
                     g_ccc.ccc22g, g_ccc.ccc22h, g_ccc.ccc22,     #No.FUN-7C0101
        g_ccc.ccc25, g_ccc.ccc26a, g_ccc.ccc26b, g_ccc.ccc26c,
                     g_ccc.ccc26d, g_ccc.ccc26e, g_ccc.ccc26f,
                     g_ccc.ccc26g, g_ccc.ccc26h, g_ccc.ccc26,     #No.FUN-7C0101
        g_ccc.ccc27, g_ccc.ccc28a, g_ccc.ccc28b, g_ccc.ccc28c,
                     g_ccc.ccc28d, g_ccc.ccc28e, g_ccc.ccc28f,
                     g_ccc.ccc28g, g_ccc.ccc28h, g_ccc.ccc28,     #No.FUN-7C0101
                     g_ccc.ccc23a, g_ccc.ccc23b, g_ccc.ccc23c,
                     g_ccc.ccc23d, g_ccc.ccc23e, g_ccc.ccc23f,
                     g_ccc.ccc23g, g_ccc.ccc23h, g_ccc.ccc23,     #No.FUN-7C0101
        g_ccc.ccc91, g_ccc.ccc92a, g_ccc.ccc92b, g_ccc.ccc92c,    #No.FUN-7C0101                                                                  
                     g_ccc.ccc92d, g_ccc.ccc92e, g_ccc.ccc92f,    #No.FUN-7C0101                                                                  
                     g_ccc.ccc92g, g_ccc.ccc92h, g_ccc.ccc92,     #No.FUN-7C0101
        g_ccc.ccc31, g_ccc.ccc32,
        g_ccc.ccc41, g_ccc.ccc42,  g_ccc.ccc43,  g_ccc.ccc44,
        g_ccc.ccc51, g_ccc.ccc52,  g_ccc.ccc61,  g_ccc.ccc62, g_ccc.ccc63,
        g_ccc.ccc81, g_ccc.ccc82,  #FUN-690068 add
        g_ccc.ccc71, g_ccc.ccc72,  g_ccc.ccc93,
        g_ccc.cccud01,g_ccc.cccud02,g_ccc.cccud03,g_ccc.cccud04,
        g_ccc.cccud05,g_ccc.cccud06,g_ccc.cccud07,g_ccc.cccud08,
        g_ccc.cccud09,g_ccc.cccud10,g_ccc.cccud11,g_ccc.cccud12,
        g_ccc.cccud13,g_ccc.cccud14,g_ccc.cccud15
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t100_set_entry(p_cmd)
          CALL t100_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        AFTER FIELD ccc01
          IF g_ccc.ccc01 IS NOT NULL THEN 
            #FUN-AA0059 --------------------------add start------------------------
            IF NOT s_chk_item_no(g_ccc.ccc01,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ccc01
            END IF 
            #FUN-AA0059 --------------------------add end------------------- 
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccc.ccc01
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",g_ccc.ccc01,"",STATUS,"","sel ima:",1)  #No.FUN-660127
               NEXT FIELD ccc01
            END IF
            DISPLAY BY NAME g_ima.ima02,g_ima.ima25
          END IF
 
        AFTER FIELD ccc03
          IF g_ccc.ccc03 IS NOT NULL THEN 
             IF g_ccc.ccc03 < 1 OR g_ccc.ccc03 > 13 THEN NEXT FIELD ccc03 END IF  #No.FUN-7C0101
          END IF
        AFTER FIELD ccc07
          IF g_ccc.ccc07 IS NOT NULL THEN 
#            IF g_ccc.ccc07 NOT MATCHES '[12345]' THEN     #TQC-D40037 mark
             IF g_ccc.ccc07 NOT MATCHES '[123456]' THEN    #TQC-D40037 add
                NEXT FIELD ccc07
             END IF
#              IF g_ccc.ccc07 MATCHES'[12]' THEN           #TQC-D40037 mark
               IF g_ccc.ccc07 MATCHES'[126]' THEN          #TQC-D40037 add
                  CALL cl_set_comp_entry("ccc08",FALSE)
                  LET g_ccc.ccc08 = ' '
               ELSE 
                  CALL cl_set_comp_entry("ccc08",TRUE)
               END IF
          END IF
 
        AFTER FIELD ccc08
          IF NOT cl_null(g_ccc.ccc08) THEN
             IF p_cmd = "a" OR                    
              (p_cmd = "u" AND 
               (g_ccc.ccc01 != g_ccc01_t OR g_ccc.ccc02 != g_ccc02_t OR 
                g_ccc.ccc03 != g_ccc03_t OR
                g_ccc.ccc07 != g_ccc07_t OR g_ccc.ccc08 != g_ccc08_t)) THEN
               
                CASE g_ccc.ccc07
                 WHEN 4
                  SELECT pja02 FROM pja_file WHERE pja01 = g_ccc.ccc08
                                               AND pjaclose='N'     #FUN-960038
                  IF SQLCA.sqlcode!=0 THEN
                     CALL cl_err3('sel','pja_file',g_ccc.ccc08,'',SQLCA.sqlcode,'','',1)
                     NEXT FIELD ccc08
                  END IF
                 WHEN 5
                   LET l_n1 = 0 #CHI-9C0025
                   SELECT count(*) INTO l_n1 FROM imd_file WHERE imd09 = g_ccc.ccc08 #CHI-9C0025
                      AND imdacti = 'Y'  #CHI-9C0025
                   IF l_n1 = 0 THEN  #CHI-9C0025
                     CALL cl_err3('sel','imd_file',g_ccc.ccc08,'',SQLCA.sqlcode,'','',1) #CHI-9C0025
                     NEXT FIELD ccc08                                           
                   END IF
                 OTHERWISE EXIT CASE
                END CASE 
               END IF
           ELSE 
              LET g_ccc.ccc08=' ' 
           END IF
           SELECT count(*) INTO l_n FROM ccc_file                                                                              
                    WHERE ccc01 = g_ccc.ccc01                                                                                       
                      AND ccc02 = g_ccc.ccc02 AND ccc03 = g_ccc.ccc03                                                               
                      AND ccc07 = g_ccc.ccc07 AND ccc08 = g_ccc.ccc08                                                               
                IF l_n > 0 THEN                                                                                                     
                    CALL cl_err('count:',-239,0)                                                                                    
                    NEXT FIELD ccc01                                                                                                
                END IF
        AFTER FIELD
        ccc11, ccc12a, ccc12b, ccc12c, ccc12d, ccc12e, ccc12f,ccc12g,ccc12h,ccc12,   #No.FUN-7C0101 add
        ccc21, ccc22a, ccc22b, ccc22c, ccc22d, ccc22e, ccc22f,ccc22g,ccc22h,ccc22,
        ccc25, ccc26a, ccc26b, ccc26c, ccc26d, ccc26e, ccc26f,ccc26g,ccc26h,ccc26,
        ccc27, ccc28a, ccc28b, ccc28c, ccc28d, ccc28e, ccc28f,ccc28g,ccc28h,ccc28,
               ccc23a, ccc23b, ccc23c, ccc23d, ccc23e, ccc23f,ccc23g,ccc23h,ccc23
            CALL t100_sum()
 
        AFTER FIELD
        ccc31, ccc32, ccc41, ccc42, ccc43, ccc44,
        ccc51, ccc52, ccc61, ccc62, ccc63, ccc81, ccc82, ccc71, ccc72, ccc93,  #FUN-690068 add ccc81,ccc82
        ccc91, ccc92a,ccc92b,ccc92c,ccc92d,ccc92e,ccc92f,ccc92g,ccc92h,ccc92   #No.FUN-7C0101 add
            CALL t100_sum()
 
        AFTER FIELD cccud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cccud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ccc01
            END IF
            CALL t100_sum()
        ON ACTION controlp
            CASE
               WHEN INFIELD(ccc01) #料件編號
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_ccc.ccc01
#                 CALL cl_create_qry() RETURNING g_ccc.ccc01
                  CALL q_sel_ima(FALSE, "q_ima","",g_ccc.ccc01,"","","","","",'' ) 
                     RETURNING g_ccc.ccc01  
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME g_ccc.ccc01
                  NEXT FIELD ccc01
              WHEN INFIELD(ccc08)   
                 IF g_ccc.ccc07 MATCHES '[45]' THEN    
                    CALL cl_init_qry_var()          
                 CASE g_ccc.ccc07                  
                    WHEN '4'                                         
                      LET g_qryparam.form = "q_pja"                   
                    WHEN '5'
                      LET g_qryparam.form = "q_imd09" #CHI-9C0025
                    OTHERWISE EXIT CASE
                 END CASE   
                 LET g_qryparam.default1 =g_ccc.ccc08
                 CALL cl_create_qry() RETURNING g_ccc.ccc08              
                 DISPLAY BY NAME g_ccc.ccc08
                 NEXT FIELD ccc08
                 END IF
             OTHERWISE EXIT CASE
            END CASE
    
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON KEY(F1) 
           NEXT FIELD ccc11
 
        ON KEY(F2) 
           NEXT FIELD ccc25
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
    
    END INPUT
END FUNCTION
 
FUNCTION t100_sum()
#DEFINE qty      LIKE ima_file.ima26        #No.FUN-680122DEC(15,3)#FUN-A20044
DEFINE qty      LIKE type_file.num15_3        #No.FUN-680122DEC(15,3)#FUN-A20044
 
LET g_ccc.ccc23a=0 LET g_ccc.ccc23b=0 LET g_ccc.ccc23c=0 LET g_ccc.ccc23d=0
LET g_ccc.ccc23e=0 LET g_ccc.ccc23f=0 LET g_ccc.ccc23g=0 LET g_ccc.ccc23h=0     #No.FUN-7C0101
 
LET qty=(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc25+g_ccc.ccc27)
IF qty != 0 THEN
   LET g_ccc.ccc23a=(g_ccc.ccc12a+g_ccc.ccc22a+g_ccc.ccc26a+g_ccc.ccc28a)/qty
   LET g_ccc.ccc23b=(g_ccc.ccc12b+g_ccc.ccc22b+g_ccc.ccc26b+g_ccc.ccc28b)/qty
   LET g_ccc.ccc23c=(g_ccc.ccc12c+g_ccc.ccc22c+g_ccc.ccc26c+g_ccc.ccc28c)/qty
   LET g_ccc.ccc23d=(g_ccc.ccc12d+g_ccc.ccc22d+g_ccc.ccc26d+g_ccc.ccc28d)/qty
   LET g_ccc.ccc23e=(g_ccc.ccc12e+g_ccc.ccc22e+g_ccc.ccc26e+g_ccc.ccc28e)/qty
   LET g_ccc.ccc23f=(g_ccc.ccc12f+g_ccc.ccc22f+g_ccc.ccc26f+g_ccc.ccc28f)/qty   #No.FUN-7C0101
   LET g_ccc.ccc23g=(g_ccc.ccc12g+g_ccc.ccc22g+g_ccc.ccc26g+g_ccc.ccc28g)/qty   #No.FUN-7C0101
   LET g_ccc.ccc23h=(g_ccc.ccc12h+g_ccc.ccc22h+g_ccc.ccc26h+g_ccc.ccc28h)/qty   #No.FUN-7C0101
END IF
 
LET g_ccc.ccc12=g_ccc.ccc12a+g_ccc.ccc12b+g_ccc.ccc12c+g_ccc.ccc12d+g_ccc.ccc12e+g_ccc.ccc12f+g_ccc.ccc12g+g_ccc.ccc12h   #No.FUN-7C0101 add
LET g_ccc.ccc22=g_ccc.ccc22a+g_ccc.ccc22b+g_ccc.ccc22c+g_ccc.ccc22d+g_ccc.ccc22e+g_ccc.ccc22f+g_ccc.ccc22g+g_ccc.ccc22h   #No.FUN-7C0101 add
LET g_ccc.ccc26=g_ccc.ccc26a+g_ccc.ccc26b+g_ccc.ccc26c+g_ccc.ccc26d+g_ccc.ccc26e+g_ccc.ccc26f+g_ccc.ccc26g+g_ccc.ccc26h   #No.FUN-7C0101 add
LET g_ccc.ccc28=g_ccc.ccc28a+g_ccc.ccc28b+g_ccc.ccc28c+g_ccc.ccc28d+g_ccc.ccc28e+g_ccc.ccc28f+g_ccc.ccc28g+g_ccc.ccc28h   #No.FUN-7C0101 add
LET g_ccc.ccc23=g_ccc.ccc23a+g_ccc.ccc23b+g_ccc.ccc23c+g_ccc.ccc23d+g_ccc.ccc23e+g_ccc.ccc23f+g_ccc.ccc23g+g_ccc.ccc23h   #No.FUN-7C0101 add
 
LET g_ccc.ccc32=g_ccc.ccc31*g_ccc.ccc23
LET g_ccc.ccc42=g_ccc.ccc41*g_ccc.ccc23
 
LET g_ccc.ccc52=g_ccc.ccc51*g_ccc.ccc23
LET g_ccc.ccc62=g_ccc.ccc61*g_ccc.ccc23
LET g_ccc.ccc82=g_ccc.ccc81*g_ccc.ccc23   #FUN-690068 add
LET g_ccc.ccc72=g_ccc.ccc71*g_ccc.ccc23
LET g_ccc.ccc91=g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc25+g_ccc.ccc27+
                g_ccc.ccc31+g_ccc.ccc41+g_ccc.ccc51+g_ccc.ccc61+g_ccc.ccc71+
                g_ccc.ccc81    #FUN-690068 add
LET g_ccc.ccc92a=g_ccc.ccc91*g_ccc.ccc23a
LET g_ccc.ccc92b=g_ccc.ccc91*g_ccc.ccc23b
LET g_ccc.ccc92c=g_ccc.ccc91*g_ccc.ccc23c
LET g_ccc.ccc92d=g_ccc.ccc91*g_ccc.ccc23d
LET g_ccc.ccc92e=g_ccc.ccc91*g_ccc.ccc23e
LET g_ccc.ccc92f=g_ccc.ccc91*g_ccc.ccc23f   #No.FUN-7C0101
LET g_ccc.ccc92g=g_ccc.ccc91*g_ccc.ccc23g   #No.FUN-7C0101
LET g_ccc.ccc92h=g_ccc.ccc91*g_ccc.ccc23h   #No.FUN-7C0101
LET g_ccc.ccc92=g_ccc.ccc12+g_ccc.ccc22+g_ccc.ccc26+g_ccc.ccc28+
                g_ccc.ccc32+g_ccc.ccc42+g_ccc.ccc52+g_ccc.ccc62+g_ccc.ccc72+
                g_ccc.ccc82+   #FUN-690068 add
                g_ccc.ccc93
CALL t100_show()
END FUNCTION
 
FUNCTION t100_u_cost()
    LET g_ccc.ccc22=g_ccc.ccc22a+g_ccc.ccc22b+g_ccc.ccc22c+g_ccc.ccc22d+
                    g_ccc.ccc22e+g_ccc.ccc22f+g_ccc.ccc22g+g_ccc.ccc22h        #No.FUN-7C0101
    DISPLAY BY NAME g_ccc.ccc22
END FUNCTION
 
FUNCTION t100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t100_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " Searching! " 
    OPEN t100_count
    FETCH t100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t100_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_ccc.* TO NULL
    ELSE
        CALL t100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t100_fetch(p_flccc)
    DEFINE
        p_flccc          LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
    CASE p_flccc
        WHEN 'N' FETCH NEXT     t100_cs INTO g_ccc.ccc01,g_ccc.ccc02,g_ccc.ccc03,g_ccc.ccc07,g_ccc.ccc08
        WHEN 'P' FETCH PREVIOUS t100_cs INTO g_ccc.ccc01,g_ccc.ccc02,g_ccc.ccc03,g_ccc.ccc07,g_ccc.ccc08
        WHEN 'F' FETCH FIRST    t100_cs INTO g_ccc.ccc01,g_ccc.ccc02,g_ccc.ccc03,g_ccc.ccc07,g_ccc.ccc08
        WHEN 'L' FETCH LAST     t100_cs INTO g_ccc.ccc01,g_ccc.ccc02,g_ccc.ccc03,g_ccc.ccc07,g_ccc.ccc08
        WHEN '/'
            IF (NOT mi_no_ask) THEN  #No.FUN-6A0075
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t100_cs INTO g_ccc.ccc01,g_ccc.ccc02,g_ccc.ccc03,g_ccc.ccc07,g_ccc.ccc08
            LET mi_no_ask = FALSE  #No.FUN-6A0075
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccc.ccc01,SQLCA.sqlcode,0)
        INITIALIZE g_ccc.* TO NULL         #No.FUN-6B0079  add
        RETURN
    ELSE
       CASE p_flccc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ccc.* FROM ccc_file            # 重讀DB,因TEMP有不被更新特性
       WHERE  ccc01 = g_ccc.ccc01 AND ccc02 = g_ccc.ccc02 AND ccc03 = g_ccc.ccc03 AND ccc07 = g_ccc.ccc07 AND ccc08 = g_ccc.ccc08
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ccc_file",g_ccc.ccc01,g_ccc.ccc02,SQLCA.sqlcode,"","ins ccc:",1)  #No.FUN-660127
        INITIALIZE g_ccc.* TO NULL         #No.FUN-6B0079  add
    ELSE
        CALL t100_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t100_show()
    DEFINE u_cost1,u_cost2,u_cost3,u_cost4,u_cost5       LIKE ccc_file.ccc12        #No.FUN-680122DEC(20,6) #FUN-4C0005
    DEFINE u2_cost1,u2_cost2,u2_cost3,u2_cost4,u2_cost5,u2_cost6  LIKE ccc_file.ccc12        #No.FUN-680122DEC(20,6) #FUN-650001 add  #CHI-980045
 
    LET g_ccc_t.* = g_ccc.*
    DISPLAY BY NAME
        g_ccc.ccc01, g_ccc.ccc02,  g_ccc.ccc03,  g_ccc.ccc04,
        g_ccc.ccc07, g_ccc.ccc08,                                #No.FUN-7C0101 add
        g_ccc.ccc11, g_ccc.ccc12a, g_ccc.ccc12b, g_ccc.ccc12c,
                     g_ccc.ccc12d, g_ccc.ccc12e, g_ccc.ccc12f,
                     g_ccc.ccc12g, g_ccc.ccc12h, g_ccc.ccc12,     #No.FUN-7C0101 add
        g_ccc.ccc21, g_ccc.ccc22a, g_ccc.ccc22b, g_ccc.ccc22c,
                     g_ccc.ccc22d, g_ccc.ccc22e, g_ccc.ccc22f,
                     g_ccc.ccc22g, g_ccc.ccc22h, g_ccc.ccc22,     #No.FUN-7C0101 add
        g_ccc.ccc25, g_ccc.ccc26a, g_ccc.ccc26b, g_ccc.ccc26c,
                     g_ccc.ccc26d, g_ccc.ccc26e, g_ccc.ccc26f,   
                     g_ccc.ccc26g, g_ccc.ccc26h, g_ccc.ccc26,     #No.FUN-7C0101 add
        g_ccc.ccc27, g_ccc.ccc28a, g_ccc.ccc28b, g_ccc.ccc28c,
                     g_ccc.ccc28d, g_ccc.ccc28e, g_ccc.ccc28f,
                     g_ccc.ccc28g, g_ccc.ccc28h, g_ccc.ccc28,     #No.FUN-7C0101 add
                     g_ccc.ccc23a, g_ccc.ccc23b, g_ccc.ccc23c,
                     g_ccc.ccc23d, g_ccc.ccc23e, g_ccc.ccc23f,
                     g_ccc.ccc23g, g_ccc.ccc23h, g_ccc.ccc23,     #No.FUN-7C0101 add
        g_ccc.ccc31, g_ccc.ccc32, 
        g_ccc.ccc41, g_ccc.ccc42,  g_ccc.ccc43,  g_ccc.ccc44,
        g_ccc.ccc51, g_ccc.ccc52,  g_ccc.ccc61,  g_ccc.ccc62, g_ccc.ccc63,
        g_ccc.ccc81, g_ccc.ccc82,  #FUN-690068 add
        g_ccc.ccc71, g_ccc.ccc72,  g_ccc.ccc93,
        g_ccc.ccc91, g_ccc.ccc92a, g_ccc.ccc92b, g_ccc.ccc92c,
        g_ccc.ccc92d,g_ccc.ccc92e, g_ccc.ccc92f, g_ccc.ccc92g,
        g_ccc.ccc92h,g_ccc.ccc92,                                 #No.FUN-7C0101 add
        g_ccc.ccc211,g_ccc.ccc22a1,g_ccc.ccc22b1,g_ccc.ccc22c1,
                     g_ccc.ccc22d1,g_ccc.ccc22e1,g_ccc.ccc22f1,
                     g_ccc.ccc22g1,g_ccc.ccc22h1,g_ccc.ccc221,    #No.FUN-7C0101
        g_ccc.ccc212,g_ccc.ccc22a2,g_ccc.ccc22b2,g_ccc.ccc22c2,
                     g_ccc.ccc22d2,g_ccc.ccc22e2,g_ccc.ccc22f2,
                     g_ccc.ccc22g2,g_ccc.ccc22h2,g_ccc.ccc222,    #No.FUN-7C0101
        g_ccc.ccc213,g_ccc.ccc22a3,g_ccc.ccc22b3,g_ccc.ccc22c3,
                     g_ccc.ccc22d3,g_ccc.ccc22e3,g_ccc.ccc22f3,
                     g_ccc.ccc22g3,g_ccc.ccc22h3,g_ccc.ccc223,    #No.FUN-7C0101
        g_ccc.ccc214,g_ccc.ccc22a4,g_ccc.ccc22b4,g_ccc.ccc22c4,
                     g_ccc.ccc22d4,g_ccc.ccc22e4,g_ccc.ccc22f4,
                     g_ccc.ccc22g4,g_ccc.ccc22h4,g_ccc.ccc224,    #No.FUN-7C0101
        g_ccc.ccc215,g_ccc.ccc22a5,g_ccc.ccc22b5,g_ccc.ccc22c5,
                     g_ccc.ccc22d5,g_ccc.ccc22e5,g_ccc.ccc22f5,
                     g_ccc.ccc22g5,g_ccc.ccc22h5,g_ccc.ccc225,     #No.FUN-7C0101
        #CHI-980045(S)
        g_ccc.ccc216,g_ccc.ccc22a6,g_ccc.ccc22b6,g_ccc.ccc22c6,
                     g_ccc.ccc22d6,g_ccc.ccc22e6,g_ccc.ccc22f6,
                     g_ccc.ccc22g6,g_ccc.ccc22h6,g_ccc.ccc226,
        #CHI-980045(E)
        g_ccc.cccuser, g_ccc.cccdate, g_ccc.ccctime,
        g_ccc.cccud01,g_ccc.cccud02,g_ccc.cccud03,g_ccc.cccud04,
        g_ccc.cccud05,g_ccc.cccud06,g_ccc.cccud07,g_ccc.cccud08,
        g_ccc.cccud09,g_ccc.cccud10,g_ccc.cccud11,g_ccc.cccud12,
        g_ccc.cccud13,g_ccc.cccud14,g_ccc.cccud15
        
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccc.ccc01
    DISPLAY BY NAME g_ima.ima25,g_ima.ima02
    LET u_cost1=0 LET u_cost2=0 LET u_cost3=0 LET u_cost4=0 LET u_cost5=0
    IF g_ccc.ccc11 != 0 THEN LET u_cost1 = g_ccc.ccc12/g_ccc.ccc11 END IF
    IF g_ccc.ccc21 != 0 THEN LET u_cost2 = g_ccc.ccc22/g_ccc.ccc21 END IF
    IF g_ccc.ccc25 != 0 THEN LET u_cost3 = g_ccc.ccc26/g_ccc.ccc25 END IF
    IF g_ccc.ccc27 != 0 THEN LET u_cost4 = g_ccc.ccc28/g_ccc.ccc27 END IF
    IF g_ccc.ccc91 != 0 THEN LET u_cost5 = g_ccc.ccc92/g_ccc.ccc91 END IF
    DISPLAY BY NAME u_cost1,u_cost2,u_cost3,u_cost4,u_cost5
    LET u2_cost1=0 LET u2_cost2=0 LET u2_cost3=0 LET u2_cost4=0 LET u2_cost5=0
    LET u2_cost6=0  #CHI-980045
    IF g_ccc.ccc211 != 0 THEN LET u2_cost1 = g_ccc.ccc221/g_ccc.ccc211 END IF
    IF g_ccc.ccc212 != 0 THEN LET u2_cost2 = g_ccc.ccc222/g_ccc.ccc212 END IF
    IF g_ccc.ccc213 != 0 THEN LET u2_cost3 = g_ccc.ccc223/g_ccc.ccc213 END IF
    IF g_ccc.ccc214 != 0 THEN LET u2_cost4 = g_ccc.ccc224/g_ccc.ccc214 END IF
    IF g_ccc.ccc215 != 0 THEN LET u2_cost5 = g_ccc.ccc225/g_ccc.ccc215 END IF
    IF g_ccc.ccc216 != 0 THEN LET u2_cost6 = g_ccc.ccc226/g_ccc.ccc216 END IF  #CHI-980045
    DISPLAY BY NAME u2_cost1,u2_cost2,u2_cost3,u2_cost4,u2_cost5,u2_cost6   #CHI-980045
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
#No.TQC-B50043  --Begin #去掉更改功能 
#FUNCTION t100_u()
#    IF g_ccc.ccc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#    MESSAGE ""
#    CALL cl_opmsg('u')
#    LET g_ccc01_t = g_ccc.ccc01
#    LET g_ccc02_t = g_ccc.ccc02
#    LET g_ccc03_t = g_ccc.ccc03
#    LET g_ccc07_t = g_ccc.ccc07    #No.FUN-7C0101
#    LET g_ccc08_t = g_ccc.ccc08    #No.FUN-7C0101   
#    BEGIN WORK
# 
#    OPEN t100_cl USING g_ccc.ccc01,g_ccc.ccc02,g_ccc.ccc03,g_ccc.ccc07,g_ccc.ccc08
#    IF STATUS THEN
#       CALL cl_err("OPEN t100_cl:", STATUS, 1)
#       CLOSE t100_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH t100_cl INTO g_ccc.*               # 對DB鎖定
#    IF SQLCA.sqlcode THEN
#        CALL cl_err('',SQLCA.sqlcode,0)
#        RETURN
#    END IF
#    CALL t100_show()                          # 顯示最新資料
#    WHILE TRUE
#        CALL t100_i("u")                      # 欄位更改
#        IF INT_FLAG THEN
#            LET INT_FLAG = 0
#            LET g_ccc.*=g_ccc_t.*
#            CALL t100_show()
#            CALL cl_err('',9001,0)
#            EXIT WHILE
#        END IF
#        UPDATE ccc_file SET ccc_file.* = g_ccc.*    # 更新DB
#            WHERE ccc01 = g_ccc_t.ccc01 AND ccc02 = g_ccc_t.ccc02 AND ccc03 = g_ccc_t.ccc03 AND ccc07 = g_ccc_t.ccc07 AND ccc08 = g_ccc_t.ccc08             # COLAUTH?
#        IF SQLCA.sqlcode THEN
#            CALL cl_err3("upd","ccc_file",g_ccc01_t,g_ccc02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
#            CONTINUE WHILE
#        END IF
#        EXIT WHILE
#    END WHILE
#    CLOSE t100_cl
#    COMMIT WORK
#END FUNCTION
#No.TQC-B50043  --End #去掉更改功能 
 
FUNCTION t100_r()
    IF g_ccc.ccc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t100_cl USING g_ccc.ccc01,g_ccc.ccc02,g_ccc.ccc03,g_ccc.ccc07,g_ccc.ccc08
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_ccc.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccc.ccc01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t100_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ccc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ccc.ccc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ccc_file WHERE ccc01 = g_ccc.ccc01
                              AND ccc02 = g_ccc.ccc02 AND ccc03 = g_ccc.ccc03
                              AND ccc07 = g_ccc.ccc07 AND ccc08 = g_ccc.ccc08   #No.FUN-7C0101
       CLEAR FORM
       OPEN t100_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t100_cs
          CLOSE t100_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t100_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t100_cs
          CLOSE t100_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t100_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t100_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE     #No.FUN-6A0075
          CALL t100_fetch('/')
       END IF
    END IF
    CLOSE t100_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t100_out()
    DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc) AND NOT cl_null(g_ccc.ccc01)                               
       AND NOT cl_null(g_ccc.ccc02) AND NOT cl_null(g_ccc.ccc03) THEN           
       LET g_wc = " ccc01 = '",g_ccc.ccc01,"' AND ccc02 = '",g_ccc.ccc02,       
                  "' AND ccc03 = '",g_ccc.ccc03,"'"
                  ," AND ccc07 = '",g_ccc.ccc07,"'"," AND ccc08 = '",g_ccc.ccc08,"'"       #No.FUN-7C0101 add                             
    END IF                                                                      
    IF g_wc IS NULL THEN CALL cl_err('','9057',0)  RETURN END IF                
    LET l_cmd = 'p_query "axct100" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)
 
END FUNCTION
 
FUNCTION t100_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccc01,ccc02,ccc03,ccc07,ccc08",TRUE)    #No.FUN-7C0101 
  END IF
END FUNCTION
 
FUNCTION t100_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccc01,ccc02,ccc03,ccc07,ccc08",FALSE)    #No.FUN-7C0101 
  END IF
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND                                                                                     
     (NOT g_before_input_done) THEN                                                                                                 
#    IF g_ccc.ccc07 MATCHES'[12]' THEN    #TQC-D40037 mark                                                                                            
     IF g_ccc.ccc07 MATCHES'[126]' THEN   #TQC-D40037 add
        CALL cl_set_comp_entry("ccc08",FALSE)                                                                                       
     ELSE                                                                                                                           
        CALL cl_set_comp_entry("ccc08",TRUE)                                                                                        
     END IF                                                                                                                         
  END IF                                                                                                                            
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/13

#darcy:2023/03/10 s---
function t100_fast_excel()
    define l_sql  string
    define table_name string
    define err like type_file.chr1
    define file string
    define title string

    let table_name = g_prog||FGL_GETPID() CLIPPED
    let l_sql = " create table ",table_name, " as ",
                " select ccc01,ima02,ima021,ccc23a,ccc23b,ccc23c,ccc23d,ccc23e from ccc_file, ima_file ",
                "  where ccc02 = ",g_ccc.ccc02," and ccc03 = ",g_ccc.ccc03," and ima01 = ccc01 "

    prepare t100_fast_p from l_sql
    execute t100_fast_p
    if status then
        call cl_err('exe t100_fast_excel',status,1)
        return
    end if

    let title = "料件编号,品名,规格,本月平均单价-材料,本月平均单价-人工,本月平均单价-制费,本月平均单价-加工,本月平均单价-其他"

    call cs_darcy_set_title(table_name,title,"料工费"||g_ccc.ccc02||g_ccc.ccc03) returning err
    call cs_darcy_excel(table_name,g_prog) returning file,err

    let l_sql = " drop table ",table_name

    prepare t100_fast_d from l_sql
    execute t100_fast_d

end function
#darcy:2023/03/10 e---
