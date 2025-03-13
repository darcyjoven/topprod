# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi003.4gl
# Descriptions...: 材料單價維護作業
# Date & Author..: Julius 02/09/04
# Modi...........: ching  031031 No.8563 單位換算
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0067 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-530236 05/03/31 By ice 單身打完第一筆到第二筆時，移會第一筆會出現-201的錯誤
# Modify         : No.MOD-530894 05/03/31 by alexlin VARCHAR->CHAR
# Modify.........: No.MOD-530524 05/04/01 By Smapmin 如果參數bgz02為'N'，在輸入此畫面時，可不用到〔版本〕的欄位.基本功能有誤
# Modify.........: No.FUN-550037 05/05/13 By saki    欄位comment顯示
# Modify.........: No.FUN-580010 05/08/02 By yoyo 憑証類報表原則修改
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/09/30 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: NO MOD-5A0004 05/10/07 By Rosayu _r()後筆數不正確
# Modify.........: NO.MOD-5B0146 05/11/25 BY yiting bgc06/bgc07 未依幣別單價小數取位(g_azi03)
# Modify.........: NO.TQC-630274 06/03/29 BY yiting 單身顯示錯誤
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/14 By jamie 1.FUNCTION i003()_q 一開始應清空g_bgc_hd.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask 
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen  本原幣取位修改
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/10 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760066 07/06/12 By chenl   1.單身無法更新。
# Modify.........:                                   2.修正報表程序錯誤。
# Modify.........: No.FUN-770033 07/06/27 By destiny 報表改為使用crystal report
# Modify.........: No.FUN-840041 08/04/10 By shiwuying cc_file 增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.CHI-860042 08/07/17 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-970224 09/07/23 By sherry 單身“原幣單價”和“本幣單價”對負數未控管
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A90048 10/09/28 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No.MOD-AC0039 10/12/06 by Dido 刪除時重新讀取有誤
# Modify.........: No.TQC-AC0130 10/12/10 by yinhy 修正複製時，填入重複資料不能退出程序的問題
# Modify.........: No:CHI-AC0006 10/12/17 By Summer 增加狀態頁簽
# Modify.........: No:CHI-B20009 11/02/14 By Summer 單身修改後要將其他月份的狀態欄位一併回寫         
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:CHI-B60093 11/06/29 By Pengu 當成本參數設定為"分倉成本"時，成本應取該料的平均
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bgc_hd        RECORD                       #單頭變數
        bgc01       LIKE bgc_file.bgc01,
        bgc02       LIKE bgc_file.bgc02,
        bgc04       LIKE bgc_file.bgc04,
        bgc05       LIKE bgc_file.bgc05,
        bgc08       LIKE bgc_file.bgc08,
        bgcacti     LIKE bgc_file.bgcacti,
        bgcuser     LIKE bgc_file.bgcuser,
        bgcgrup     LIKE bgc_file.bgcgrup,
        bgcmodu     LIKE bgc_file.bgcmodu,  #CHI-AC0006 add
        bgcdate     LIKE bgc_file.bgcdate,  #CHI-AC0006 add ,
        bgcoriu     LIKE bgc_file.bgcoriu,  #CHI-AC0006 add
        bgcorig     LIKE bgc_file.bgcorig   #CHI-AC0006 add
        END RECORD,
    g_bgc_hd_t      RECORD                       #單頭變數
        bgc01       LIKE bgc_file.bgc01,
        bgc02       LIKE bgc_file.bgc02,
        bgc04       LIKE bgc_file.bgc04,
        bgc05       LIKE bgc_file.bgc05,
        bgc08       LIKE bgc_file.bgc08,
        bgcacti     LIKE bgc_file.bgcacti,
        bgcuser     LIKE bgc_file.bgcuser,
        bgcgrup     LIKE bgc_file.bgcgrup,
        bgcmodu     LIKE bgc_file.bgcmodu,  #CHI-AC0006 add
        bgcdate     LIKE bgc_file.bgcdate,  #CHI-AC0006 add ,
        bgcoriu     LIKE bgc_file.bgcoriu,  #CHI-AC0006 add
        bgcorig     LIKE bgc_file.bgcorig   #CHI-AC0006 add
        END RECORD,
    g_bgc_hd_o      RECORD                       #單頭變數
        bgc01       LIKE bgc_file.bgc01,
        bgc02       LIKE bgc_file.bgc02,
        bgc04       LIKE bgc_file.bgc04,
        bgc05       LIKE bgc_file.bgc05,
        bgc08       LIKE bgc_file.bgc08,
        bgcacti     LIKE bgc_file.bgcacti,
        bgcuser     LIKE bgc_file.bgcuser,
        bgcgrup     LIKE bgc_file.bgcgrup,
        bgcmodu     LIKE bgc_file.bgcmodu,  #CHI-AC0006 add
        bgcdate     LIKE bgc_file.bgcdate,  #CHI-AC0006 add ,
        bgcoriu     LIKE bgc_file.bgcoriu,  #CHI-AC0006 add
        bgcorig     LIKE bgc_file.bgcorig   #CHI-AC0006 add
        END RECORD,
    g_bgc           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        bgc03       LIKE bgc_file.bgc03,
        bga05       LIKE bga_file.bga05,
        bgc06       LIKE bgc_file.bgc06,
        bgc07       LIKE bgc_file.bgc07
        END RECORD,
    g_bgc_t         RECORD                       #程式變數(舊值)
        bgc03       LIKE bgc_file.bgc03,
        bga05       LIKE bga_file.bga05,
        bgc06       LIKE bgc_file.bgc06,
        bgc07       LIKE bgc_file.bgc07
        END RECORD,
    g_wc            string,                          #WHERE CONDITION  #No.FUN-580092 HCN
    g_sql           string,                          #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,             #單身筆數   #No.FUN-680061 SMALLINT
    l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680061 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03            #No.FUN-680061 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
DEFINE   l_table        STRING                       #No.FUN-770033
DEFINE   g_str          STRING                       #No.FUN-770033
#主程式開始
MAIN
DEFINE
#       l_time    LIKE type_file.chr8     #No.FUN-6A0056
    p_row,p_col LIKE type_file.num5      #No.FUN-680061 smallint
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1)             #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
#No.FUN-770033--start--
    LET g_sql = " bgc01.bgc_file.bgc01,",                                                                                     
                " bgc02.bgc_file.bgc02,",                                                                                 
                " bgc04.bgc_file.bgc04,",                                                                                 
                " bgc05.bgc_file.bgc05,",                                                                                    
                " ima02.ima_file.ima02,",                                                                                 
                " ima021.ima_file.ima021,",                                                                                 
                " bgc08.bgc_file.bgc08,",                                                                                 
                " bgc03.bgc_file.bgc03,",                                                                             
                " bga05.bga_file.bga05,",                                                                                
                " bgc06.bgc_file.bgc06,",                                                                                
                " bgc07.bgc_file.bgc07,",              
                " t_azi03.azi_file.azi03,",      #No.FUN-770033
                " t_azi07.azi_file.azi07"        #No.FUN-770033
                                                                            
    LET l_table = cl_prt_temptable('abgi003',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
#                " VALUES(?, ?, ?, ?, ?, ?, ? , ?, ? , ?, ?)"       #No.FUN-770033                                                                  
                 " VALUES(?, ?, ?, ?, ?, ?, ? , ?, ? , ?, ? ,? ,?)" #No.FUN-770033                                                                                              
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF 
#No.FUN-770033--end--
    INITIALIZE g_bgc_hd.* to NULL
    INITIALIZE g_bgc_hd_t.* to NULL
    INITIALIZE g_bgc_hd_o.* to NULL
 
    LET p_row = 3 LET p_col = 20
    OPEN WINDOW i003_w AT p_row,p_col
        WITH FORM "abg/42f/abgi003" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL i003_menu()
    CLOSE WINDOW i003_w                          #結束畫面
      CALL  cl_used(g_prog,g_time,2)             #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i003_curs()
    CLEAR FORM #清除畫面
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INITIALIZE g_bgc_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgc01, bgc02, bgc04, bgc05,bgc08, # 螢幕上取條件
                      bgcuser,bgcgrup,bgcoriu,bgcorig,bgcmodu,bgcdate, #CHI-AC0006 add
                      bgc03, bgc06, bgc07
         FROM bgc01, bgc02, bgc04, bgc05, bgc08,
              bgcuser,bgcgrup,bgcoriu,bgcorig,bgcmodu,bgcdate, #CHI-AC0006 add
              s_bgc[1].bgc03, s_bgc[1].bgc06, s_bgc[1].bgc07
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bgc04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgc04
                WHEN INFIELD(bgc05)
          #No.FUN-A90048 --------------start -------------------------
          #          CALL cl_init_qry_var()
          #          LET g_qryparam.state = "c"
          #          LET g_qryparam.form ="q_ima"
          #          CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  
                              RETURNING  g_qryparam.multiret
          #No.FUN-A90048 ----------------end --------------------------
                    DISPLAY g_qryparam.multiret TO bgc05
                WHEN INFIELD(bgc08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgc08
            END CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
               CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT
 
    IF INT_FLAG THEN
        CALL i003_show()
        RETURN
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bgcuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bgcgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bgcgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bgcuser', 'bgcgrup')
    #End:FUN-980030
 
 
    LET g_sql = "SELECT UNIQUE bgc01, bgc02, bgc04, bgc05,bgc08 ",
                "  FROM bgc_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY bgc01"
    PREPARE i003_prepare FROM g_sql
    DECLARE i003_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i003_prepare
 
#   LET g_sql = "SELECT UNIQUE bgc01, bgc02, bgc04, bgc05,bgc08 ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE bgc01, bgc02, bgc04, bgc05,bgc08 ",  #No.TQC-720019
                "  FROM bgc_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i003_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i003_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i003_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i003_precnt FROM g_sql
    DECLARE i003_cnt CURSOR FOR i003_precnt
END FUNCTION
 
FUNCTION i003_menu()
   WHILE TRUE
      CALL i003_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i003_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i003_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i003_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i003_copy()
            END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i003_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i003_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "exporttoexcel"   #No.FUN-4B0021
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgc),'','')
           END IF
        #No.FUN-6A0003-------add--------str----
        WHEN "related_document"           #相關文件
         IF cl_chk_act_auth() THEN
            IF g_bgc_hd.bgc01 IS NOT NULL THEN
               LET g_doc.column1 = "bgc01"
               LET g_doc.column2 = "bgc02"
               LET g_doc.column3 = "bgc04"
               LET g_doc.column4 = "bgc05"
               LET g_doc.column5 = "bgc08"
               LET g_doc.value1 = g_bgc_hd.bgc01
               LET g_doc.value2 = g_bgc_hd.bgc02
               LET g_doc.value3 = g_bgc_hd.bgc04
               LET g_doc.value4 = g_bgc_hd.bgc05
               LET g_doc.value5 = g_bgc_hd.bgc08
               CALL cl_doc()
            END IF 
         END IF
        #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i003_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
     CALL g_bgc.clear()     #MOD-530524
    INITIALIZE g_bgc_hd.* TO NULL                  #單頭初始清空
    INITIALIZE g_bgc_hd_o.* TO NULL                #單頭舊值清空
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bgc_hd.bgcacti = 'Y'
        LET g_bgc_hd.bgcuser = g_user
        LET g_bgc_hd.bgcgrup = g_grup
        LET g_bgc_hd.bgcdate = g_today
        #CHI-AC0006 add --start--
        LET g_bgc_hd.bgcoriu = g_user    
        LET g_bgc_hd.bgcorig = g_grup  
        #CHI-AC0006 add --end--
        CALL i003_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
     IF cl_null(g_bgc_hd.bgc02)  OR
        cl_null(g_bgc_hd.bgc04)  OR
        cl_null(g_bgc_hd.bgc05)  OR
        cl_null(g_bgc_hd.bgc08)  THEN
        CONTINUE WHILE
     END IF
        CALL g_bgc.clear()
        LET g_rec_b=0
 #        IF cl_conf(18,10,'abg-015') THEN       #自動產生單身   #MOD-530524
         IF cl_confirm('abg-015') THEN       #自動產生單身   #MOD-530524
           CALL i003_g_b()
        END IF
        CALL i003_b()                            #輸入單身
        LET g_bgc_hd_t.* = g_bgc_hd.*            #保留舊值
        LET g_bgc_hd_o.* = g_bgc_hd.*            #保留舊值
        LET g_wc="     bgc01='",g_bgc_hd.bgc01,"' ",
                 " AND bgc02='",g_bgc_hd.bgc02,"' ",
                 " AND bgc04='",g_bgc_hd.bgc04,"' ",
                 " AND bgc05='",g_bgc_hd.bgc05,"' ",
                 " AND bgc08='",g_bgc_hd.bgc08,"' "
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理單頭欄位(bgc01, bgc02, bgc04, bgc05)INPUT
FUNCTION i003_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-680061 VARCHAR(1)
    l_n     LIKE type_file.num5     #No.FUN-680061 SMALLINT
 
    LET l_n = 0
 
    DISPLAY g_bgc_hd.bgc01, g_bgc_hd.bgc02, g_bgc_hd.bgc04,
            g_bgc_hd.bgc05, g_bgc_hd.bgc08,   #CHI-AC0006 add ,
            g_bgc_hd.bgcuser,g_bgc_hd.bgcgrup,#CHI-AC0006 add
            g_bgc_hd.bgcoriu,g_bgc_hd.bgcorig,#CHI-AC0006 add
            g_bgc_hd.bgcmodu,g_bgc_hd.bgcdate #CHI-AC0006 add
         TO bgc01, bgc02, bgc04, bgc05,bgc08, #CHI-AC0006 add ,
            bgcuser,bgcgrup,bgcoriu,bgcorig,bgcmodu,bgcdate #CHI-AC0006 add
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
    INPUT g_bgc_hd.bgc01, g_bgc_hd.bgc02, g_bgc_hd.bgc04,
          g_bgc_hd.bgc05,
          g_bgc_hd.bgc08
     FROM bgc01, bgc02, bgc04, bgc05 ,bgc08
 #MOD-530524
     BEFORE FIELD bgc01
        IF g_bgz.bgz02 = "N" THEN
           LET g_bgc_hd.bgc01 = ' '
           DISPLAY BY NAME g_bgc_hd.bgc01
           NEXT FIELD bgc02
        END IF
 
        AFTER FIELD bgc01
{
            IF NOT cl_null(g_bgc_hd.bgc01) AND g_bgz.bgz02 = 'N' THEN
               CALL cl_err('', 'abg-001', 0)
               LET g_bgc_hd.bgc01 = ' '
               DISPLAY BY NAME g_bgc_hd.bgc01
               NEXT FIELD bgc01
            END IF
}
 #END MOD-530524
            IF cl_null(g_bgc_hd.bgc01) AND g_bgz.bgz02 = 'Y' THEN
               NEXT FIELD bgc01
            END IF
 
            IF cl_null(g_bgc_hd.bgc01) THEN
               LET g_bgc_hd.bgc01 = ' '
               DISPLAY BY NAME g_bgc_hd.bgc01
            END IF
 
        AFTER FIELD bgc02
            IF cl_null(g_bgc_hd.bgc02) OR g_bgc_hd.bgc02 < 1 THEN
                   CALL cl_err('', 'afa-370', 0)
                   NEXT FIELD bgc02
            END IF
 
        AFTER FIELD bgc04
            IF NOT cl_null(g_bgc_hd.bgc04) THEN
                SELECT COUNT(*) INTO l_n
                  FROM azi_file
                 WHERE azi01 = g_bgc_hd.bgc04
                IF l_n < 1 THEN
                    CALL cl_err('', 'aap-002', 0)
                    NEXT FIELD bgc04
                END IF
            END IF
 
        AFTER FIELD bgc05
            IF NOT cl_null(g_bgc_hd.bgc05) THEN
#NO.FUN-A90048 add -----------start--------------------     
          IF NOT s_chk_item_no(g_bgc_hd.bgc05,'') THEN
             CALL cl_err('',g_errno,1)
             LET g_bgc_hd.bgc05= g_bgc_hd_t.bgc05 
             NEXT FIELD bgc05
          END IF
#NO.FUN-A90048 add ------------end --------------------   
                CALL i003_bgc05('d', g_bgc_hd.bgc05)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD bgc05
                END IF
            END IF
           IF cl_null(g_bgc_hd.bgc08) THEN
              SELECT ima44 INTO g_bgc_hd.bgc08
                FROM ima_file
               WHERE ima01=g_bgc_hd.bgc05
               DISPLAY BY NAME g_bgc_hd.bgc08
           END IF
 
        AFTER FIELD bgc08
            IF NOT cl_null(g_bgc_hd.bgc08) THEN
                CALL i003_bgc08('d', g_bgc_hd.bgc08)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD bgc08
                END IF
            END IF
 
            SELECT COUNT(*) INTO l_n   #Key 值是否重覆
              FROM bgc_file
             WHERE bgc01 = g_bgc_hd.bgc01
               AND bgc02 = g_bgc_hd.bgc02
               AND bgc04 = g_bgc_hd.bgc04
               AND bgc05 = g_bgc_hd.bgc05
               AND bgc08 = g_bgc_hd.bgc08
            IF l_n > 0 THEN
                INITIALIZE g_bgc_hd TO NULL
                DISPLAY '','' TO FORMONLY.ima02,FORMONLY.ima021
                DISPLAY g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                        g_bgc_hd.bgc04,
                        g_bgc_hd.bgc05,
                        g_bgc_hd.bgc08
                     TO bgc01, bgc02, bgc04, bgc05 ,bgc08
                CALL cl_err( g_bgc_hd.bgc01, -239, 0)
                NEXT FIELD bgc01
            END IF
 
        ON ACTION CONTROLF                       #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bgc04)
                #   CALL q_azi(10,3,g_bgc_hd.bgc04)
                #   RETURNING g_bgc_hd.bgc04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azi"
                    LET g_qryparam.default1 = g_bgc_hd.bgc04
                    CALL cl_create_qry() RETURNING g_bgc_hd.bgc04
                    DISPLAY BY NAME g_bgc_hd.bgc04
 
                WHEN INFIELD(bgc05)
                #   CALL q_ima(10,3,g_bgc_hd.bgc05)
                #   RETURNING g_bgc_hd.bgc05
                #No.FUN-A90048 ----------------sart------------------------
                #    CALL cl_init_qry_var()
                #    LET g_qryparam.form ="q_ima"
                #    LET g_qryparam.default1=g_bgc_hd.bgc05
                #    CALL cl_create_qry() RETURNING g_bgc_hd.bgc05
                     CALL q_sel_ima(FALSE, "q_ima","",g_bgc_hd.bgc05,"", "", "", "" ,"" ,'')
                                  RETURNING g_bgc_hd.bgc05
                #No.FUN-A90048 -----------------end------------------------
                    DISPLAY BY NAME g_bgc_hd.bgc05
                WHEN INFIELD(bgc08)
                #   CALL q_gfe(10,3,g_bgc_hd.bgc08)
                #   RETURNING g_bgc_hd.bgc08
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1=g_bgc_hd.bgc08
                    CALL cl_create_qry() RETURNING g_bgc_hd.bgc08
                    DISPLAY BY NAME g_bgc_hd.bgc08
            END CASE
 
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
 
#Query 查詢
FUNCTION i003_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bgc_hd.* TO NULL             #No.FUN-6A0003
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bgc.clear()
    DISPLAY '     ' TO FORMONLY.cnt
    CALL i003_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i003_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bgc TO NULL
    ELSE
        OPEN i003_cnt
        FETCH i003_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i003_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i003_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1      #處理方式 #No.FUN-680061 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i003_cs INTO g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                                             g_bgc_hd.bgc04, g_bgc_hd.bgc05,
                                             g_bgc_hd.bgc08
        WHEN 'P' FETCH PREVIOUS i003_cs INTO g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                                             g_bgc_hd.bgc04, g_bgc_hd.bgc05,
                                             g_bgc_hd.bgc08
        WHEN 'F' FETCH FIRST    i003_cs INTO g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                                             g_bgc_hd.bgc04, g_bgc_hd.bgc05,
                                             g_bgc_hd.bgc08
        WHEN 'L' FETCH LAST     i003_cs INTO g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                                             g_bgc_hd.bgc04, g_bgc_hd.bgc05,
                                             g_bgc_hd.bgc08
        WHEN '/'
         IF (NOT mi_no_ask) THEN                 #No.FUN-6A0057 g_no_ask 
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
         FETCH ABSOLUTE g_jump i003_cs INTO g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                                            g_bgc_hd.bgc04, g_bgc_hd.bgc05,
                                            g_bgc_hd.bgc08
         LET mi_no_ask = FALSE             #No.FUN-6A0057 g_no_ask 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgc_hd.bgc01, SQLCA.sqlcode, 0)
        INITIALIZE g_bgc_hd.* TO NULL  #TQC-6B0105
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
   SELECT UNIQUE bgc01, bgc02, bgc04, bgc05,bgc08
    #CHI-AC0006 add --start--
                 ,bgcuser,bgcgrup,bgcoriu,bgcorig,bgcmodu,bgcdate 
     INTO g_bgc_hd.bgc01, g_bgc_hd.bgc02, g_bgc_hd.bgc04,
          g_bgc_hd.bgc05, g_bgc_hd.bgc08, 
          g_bgc_hd.bgcuser,g_bgc_hd.bgcgrup,
          g_bgc_hd.bgcoriu,g_bgc_hd.bgcorig,
          g_bgc_hd.bgcmodu,g_bgc_hd.bgcdate 
    #CHI-AC0006 add --end--
     FROM bgc_file
    WHERE bgc01 = g_bgc_hd.bgc01
      AND bgc02 = g_bgc_hd.bgc02
      AND bgc04 = g_bgc_hd.bgc04
      AND bgc05 = g_bgc_hd.bgc05
      AND bgc08 = g_bgc_hd.bgc08
   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_bgc_hd.bgc01, SQLCA.sqlcode, 0) #FUN-660105
       CALL cl_err3("sel","bgc_file",g_bgc_hd.bgc01,g_bgc_hd.bgc02,SQLCA.sqlcode,"","",1) #FUN-660105 
       INITIALIZE g_bgc TO NULL
       RETURN
   END IF
    LET g_data_owner = g_bgc_hd.bgcuser   #FUN-4C0067
    LET g_data_group = g_bgc_hd.bgcgrup   #FUN-4C0067
    CALL i003_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i003_show()
 
   #LET g_bgc_hd.* = g_bgc_hd.*                  #保存單頭舊值 #CHI-AC0006 mark
    LET g_bgc_hd_t.* = g_bgc_hd.*                #保存單頭舊值 #CHI-AC0006
    DISPLAY BY NAME g_bgc_hd.bgc01,              #顯示單頭值
                    g_bgc_hd.bgc02,
                    g_bgc_hd.bgc04,
                    g_bgc_hd.bgc05,
                    g_bgc_hd.bgc08, #CHI-AC0006 add ,
                   #CHI-AC0006 add --start--
                    g_bgc_hd.bgcuser,
                    g_bgc_hd.bgcgrup,
                    g_bgc_hd.bgcoriu,
                    g_bgc_hd.bgcorig,
                    g_bgc_hd.bgcmodu,
                    g_bgc_hd.bgcdate
                   #CHI-AC0006 add --end-- 
 
    CALL i003_bgc05('d', g_bgc_hd.bgc05)
 
    CALL i003_b_fill(g_wc) #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i003_r()
DEFINE
    l_chr LIKE type_file.chr1    #No.FUN-680061 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF
 
    IF g_bgc_hd.bgc01 IS NULL THEN
        CALL cl_err('', -400, 0)
        RETURN
    END IF
    CALL i003_show()
    IF cl_delh(0,0) THEN                         #詢問是否取消資料
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bgc01"            #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bgc02"            #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bgc04"            #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bgc05"            #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "bgc08"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bgc_hd.bgc01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bgc_hd.bgc02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bgc_hd.bgc04      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_bgc_hd.bgc05      #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_bgc_hd.bgc08      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                      #No.FUN-9B0098 10/02/24
        DELETE FROM bgc_file
         WHERE bgc01 = g_bgc_hd.bgc01
           AND bgc02 = g_bgc_hd.bgc02
           AND bgc04 = g_bgc_hd.bgc04
           AND bgc05 = g_bgc_hd.bgc05
           AND bgc08 = g_bgc_hd.bgc08
        IF STATUS             THEN
#           CALL cl_err(g_bgc_hd.bgc01,SQLCA.sqlcode,0)  #FUN-660105
            CALL cl_err3("del","bgc_file",g_bgc_hd.bgc01,g_bgc_hd.bgc02,SQLCA.sqlcode,"","",1) #FUN-660105
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i003_pre_x                  #No.TQC-720019
            PREPARE i003_pre_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i003_pre_x2                 #No.TQC-720019
            #MOD-5A0004 end
 
            CALL g_bgc.clear()
 #MOD-530524
            LET g_sql = "SELECT UNIQUE bgc01, bgc02, bgc04, bgc05,bgc08 ",
                        "  FROM bgc_file ",
                        " WHERE ", g_wc CLIPPED,      #MOD-AC0039
                        " INTO TEMP y " 
            DROP TABLE y
            PREPARE i003_pre_y FROM g_sql
            EXECUTE i003_pre_y
            LET g_sql = "SELECT COUNT(*) FROM y"
            PREPARE i003_precnt2 FROM g_sql
            DECLARE i003_cnt2 CURSOR FOR i003_precnt2
            OPEN i003_cnt2
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i003_cs
               CLOSE i003_cnt2  
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i003_cnt2 INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i003_cs
               CLOSE i003_cnt2 
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            #OPEN i003_cnt
            #FETCH i003_cnt INTO g_row_count
 #END MOD-530524
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i003_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i003_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE                  #No.FUN-6A0057 g_no_ask 
               CALL i003_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#處理單身欄位(bgc03, bgc06, bgc07)輸入
FUNCTION i003_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT 
    l_n             LIKE type_file.num5,    #檢查重複用 #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否 #No.FUN-680061 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態   #No.FUN-680061 VARCHAR(1)
    l_bgz03         LIKE bgz_file.bgz03,    #抓取參數設定
    l_ima53         LIKE ima_file.ima53,    #料件主檔之最近單價
    l_ima54         LIKE ima_file.ima54,    #料件主檔之主供應商
    l_ima109        LIKE ima_file.ima109,   #料件基本資料之材料類別
    l_ccc23a        LIKE ccc_file.ccc23a,   #材料成本之最近成本
    l_pmh12         LIKE pmh_file.pmh12,    #計價原幣
    l_bgc06         LIKE bgc_file.bgc06,    #儲存未經計算的bgc06值
    l_bgb05         LIKE bgb_file.bgb05,    #材料類別對應的調幅
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-680061 SMALLINT
 
    LET g_action_choice = ""
    IF g_bgc_hd.bgc01 IS NULL THEN RETURN END IF
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT bgc03, '',bgc06, bgc07 FROM bgc_file ",
        "  WHERE bgc01 = ? AND bgc02 = ? AND bgc04 = ? AND bgc05 = ? ",
        "   AND bgc08 = ? AND bgc03 = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i003_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bgc WITHOUT DEFAULTS FROM s_bgc.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                  #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_bgc_t.* = g_bgc[l_ac].*    #BACKUP
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#                LET g_before_input_done = FALSE
#                CALL i003_set_entry_b(p_cmd)
#                CALL i003_set_no_entry_b(p_cmd)
#                LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
                OPEN i003_bcl USING g_bgc_hd.bgc01,g_bgc_hd.bgc02,
                                    g_bgc_hd.bgc04,g_bgc_hd.bgc05,g_bgc_hd.bgc08,g_bgc_t.bgc03
                IF STATUS THEN
                   CALL cl_err("OPEN i003_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i003_bcl INTO g_bgc[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bgc_t.bgc03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL s_bga05(g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                                g_bgc[l_ac].bgc03, g_bgc_hd.bgc04 )
                   RETURNING g_bgc[l_ac].bga05
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bgc[l_ac].* TO NULL
                LET g_bgc[l_ac].bgc06=0
                LET g_bgc[l_ac].bgc07=0
            LET g_bgc_t.* = g_bgc[l_ac].*        #新輸入資料
#NO.MOD-590329 MARK
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i003_set_entry_b(p_cmd)
#            CALL i003_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO bgc_file(bgc01,bgc02,bgc03,bgc04,bgc05,bgc06,bgc07, #No.MOD-470041
                                 bgc08,bgcacti,bgcuser,bgcgrup,bgcmodu,bgcdate,bgcoriu,bgcorig)
                 VALUES(g_bgc_hd.bgc01,g_bgc_hd.bgc02,g_bgc[l_ac].bgc03,
                        g_bgc_hd.bgc04,g_bgc_hd.bgc05,g_bgc[l_ac].bgc06,
                        g_bgc[l_ac].bgc07,g_bgc_hd.bgc08,g_bgc_hd.bgcacti,
                        g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bgc[l_ac].bgc03,SQLCA.sqlcode,0) #FUN-660105
                CALL cl_err3("ins","bgc_file",g_bgc_hd.bgc01,g_bgc_hd.bgc02,SQLCA.sqlcode,"","",1) #FUN-660105
                CANCEL INSERT
            ELSE
               #CHI-B20009 add --start--
               UPDATE bgc_file
                  SET bgcuser = g_user,
                      bgcgrup = g_grup,
                      bgcmodu = '',
                      bgcdate = g_today
                WHERE bgc01 = g_bgc_hd.bgc01
                  AND bgc02 = g_bgc_hd.bgc02
                  AND bgc04 = g_bgc_hd.bgc04
                  AND bgc05 = g_bgc_hd.bgc05
                  AND bgc08 = g_bgc_hd.bgc08
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","bgc_file",g_bgc[l_ac].bgc03,g_bgc[l_ac].bgc06,SQLCA.sqlcode,"","",1) 
                   CANCEL INSERT
               ELSE
               #CHI-B20009 add --end--
                   MESSAGE 'INSERT O.K'
 #MOD-530524
                   COMMIT WORK
                   SELECT COUNT(*) INTO g_rec_b FROM bgc_file
                          WHERE bgc01 = g_bgc_hd.bgc01
                            AND bgc02 = g_bgc_hd.bgc02
                            AND bgc04 = g_bgc_hd.bgc04
                            AND bgc05 = g_bgc_hd.bgc05
                            AND bgc08 = g_bgc_hd.bgc08
 
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   #CHI-B20009 add --start--
                   SELECT bgcuser,bgcgrup,bgcmodu,bgcdate 
                     INTO g_bgc_hd.bgcuser,g_bgc_hd.bgcgrup,g_bgc_hd.bgcmodu,g_bgc_hd.bgcdate
                     FROM bgc_file
                    WHERE bgc01 = g_bgc_hd.bgc01
                      AND bgc02 = g_bgc_hd.bgc02
                      AND bgc04 = g_bgc_hd.bgc04
                      AND bgc05 = g_bgc_hd.bgc05
                      AND bgc08 = g_bgc_hd.bgc08
                   DISPLAY g_bgc_hd.bgcuser,g_bgc_hd.bgcgrup,g_bgc_hd.bgcmodu,g_bgc_hd.bgcdate
                        TO bgcuser,bgcgrup,bgcmodu,bgcdate 
                   #CHI-B20009 add --end--
                #LET g_rec_b=g_rec_b+1
                #DISPLAY g_rec_b TO FORMONLY.cn2
                #COMMIT WORK
 #END MOD-530524
               END IF #CHI-B20009 add
            END IF
 
        AFTER FIELD bgc03
            IF NOT cl_null(g_bgc[l_ac].bgc03) THEN
               IF  g_bgc[l_ac].bgc03 < 1 OR
	           g_bgc[l_ac].bgc03 > 12 THEN
	           NEXT FIELD bgc03
               END IF
               #bgc03 的欄位合理性(key 值重複, IS NULL)判斷
               IF NOT cl_null(g_bgc[l_ac].bgc03) THEN #unique index key 是否重複
                   IF g_bgc[l_ac].bgc03 != g_bgc_t.bgc03
                   OR cl_null(g_bgc_t.bgc03) THEN
                       SELECT COUNT(*) INTO l_n
                         FROM bgc_file
                        WHERE bgc01 = g_bgc_hd.bgc01
                          AND bgc02 = g_bgc_hd.bgc02
                          AND bgc04 = g_bgc_hd.bgc04
                          AND bgc05 = g_bgc_hd.bgc05
                          AND bgc08 = g_bgc_hd.bgc08
                          AND bgc03 = g_bgc[l_ac].bgc03
                       IF l_n>0 THEN
                           CALL cl_err(g_bgc[l_ac].bgc03, -239, 0)
                           NEXT FIELD bgc03
                       END IF
                   END IF
                   LET g_bgc[l_ac].bga05 = s_bga05(g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                                                 g_bgc[l_ac].bgc03, g_bgc_hd.bgc04)
               END IF
            END IF
   
        #TQC-970224---Begin 
        AFTER FIELD bgc06
           IF g_bgc[l_ac].bgc06 < 0 THEN 
              CALL cl_err(g_bgc[l_ac].bgc06,'aap-505',0)
              NEXT FIELD bgc06
           END IF
 
        AFTER FIELD bgc07
           IF g_bgc[l_ac].bgc07 < 0 THEN 
              CALL cl_err(g_bgc[l_ac].bgc07,'aap-505',0)
              NEXT FIELD bgc07
           END IF
        #TQC-970224---End
 
        BEFORE FIELD bgc06
            IF cl_null(g_bgc[l_ac].bgc06) OR g_bgc[l_ac].bgc06 = 0  THEN     #No:CHI-B60093 modify
               CALL i003_bgc06(g_bgc_hd.bgc01,g_bgc_hd.bgc02,g_bgc[l_ac].bgc03,
                         g_bgc_hd.bgc04,g_bgc_hd.bgc05,g_bgc[l_ac].bga05)
                  RETURNING g_bgc[l_ac].bgc06,g_bgc[l_ac].bgc07
            END IF
            DISPLAY BY NAME g_bgc[l_ac].bgc06,g_bgc[l_ac].bgc07         #No.TQC-760066
 
        BEFORE FIELD bgc07
            LET g_bgc[l_ac].bgc07 = g_bgc[l_ac].bga05 * g_bgc[l_ac].bgc06
            DISPLAY BY NAME g_bgc[l_ac].bgc07                              #No.TQC-760066
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bgc_t.bgc03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bgc_file             #刪除該筆單身資料
                 WHERE bgc01 = g_bgc_hd.bgc01
                   AND bgc02 = g_bgc_hd.bgc02
                   AND bgc04 = g_bgc_hd.bgc04
                   AND bgc05 = g_bgc_hd.bgc05
                   AND bgc08 = g_bgc_hd.bgc08
                   AND bgc03 = g_bgc_t.bgc03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bgc_t.bgc03,SQLCA.sqlcode,0) #FUN-660105
                    CALL cl_err3("del","bgc_file",g_bgc_hd.bgc01,g_bgc_t.bgc03,SQLCA.sqlcode,"","",1) #FUN-660105
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
               LET g_bgc[l_ac].* = g_bgc_t.*
               CLOSE i003_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgc[l_ac].bgc03,-263,1)
               LET g_bgc[l_ac].* = g_bgc_t.*
            ELSE
               UPDATE bgc_file
                  SET bgc03 = g_bgc[l_ac].bgc03,
                      bgc06 = g_bgc[l_ac].bgc06,
                      bgc07 = g_bgc[l_ac].bgc07
                WHERE CURRENT OF i003_bcl
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bgc[l_ac].bgc06, SQLCA.sqlcode, 0) #FUN-660105
                   CALL cl_err3("upd","bgc_file",g_bgc[l_ac].bgc03,g_bgc[l_ac].bgc06,SQLCA.sqlcode,"","",1) #FUN-660105
                   LET g_bgc[l_ac].* = g_bgc_t.*
                   ROLLBACK WORK
               ELSE
                  #CHI-B20009 add --start--
                  UPDATE bgc_file
                     SET bgcmodu = g_user,
                         bgcdate = g_today
                   WHERE bgc01 = g_bgc_hd.bgc01
                     AND bgc02 = g_bgc_hd.bgc02
                     AND bgc04 = g_bgc_hd.bgc04
                     AND bgc05 = g_bgc_hd.bgc05
                     AND bgc08 = g_bgc_hd.bgc08
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","bgc_file",g_bgc[l_ac].bgc03,g_bgc[l_ac].bgc06,SQLCA.sqlcode,"","",1) 
                      LET g_bgc[l_ac].* = g_bgc_t.*
                      ROLLBACK WORK
                  ELSE
                  #CHI-B20009 add --end--
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                     #CHI-B20009 add --start--
                     SELECT bgcmodu,bgcdate 
                       INTO g_bgc_hd.bgcmodu,g_bgc_hd.bgcdate
                       FROM bgc_file
                      WHERE bgc01 = g_bgc_hd.bgc01
                        AND bgc02 = g_bgc_hd.bgc02
                        AND bgc04 = g_bgc_hd.bgc04
                        AND bgc05 = g_bgc_hd.bgc05
                        AND bgc08 = g_bgc_hd.bgc08
                     DISPLAY g_bgc_hd.bgcmodu,g_bgc_hd.bgcdate 
                          TO bgcmodu,bgcdate 
                     #CHI-B20009 add --end--
                  END IF #CHI-B20009 add
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bgc[l_ac].* = g_bgc_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i003_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac       #FUN-D30032 add 
            CLOSE i003_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i003_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(bgc03) AND l_ac > 1 THEN
                LET g_bgc[l_ac].* = g_bgc[l_ac-1].*
                NEXT FIELD bgc03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0033 --START
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0033 --END
 
        END INPUT
 
    CLOSE i003_bcl
    COMMIT WORK
    CALL i003_delall()
END FUNCTION
 
FUNCTION i003_delall()
    SELECT COUNT(*)
      INTO g_cnt
      FROM bgc_file
     WHERE bgc01 = g_bgc_hd.bgc01
       AND bgc02 = g_bgc_hd.bgc02
       AND bgc04 = g_bgc_hd.bgc04
       AND bgc05 = g_bgc_hd.bgc05
       AND bgc08 = g_bgc_hd.bgc08
    IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料
        CALL cl_getmsg('9044',g_lang) RETURNING g_msg
        ERROR g_msg CLIPPED
        DELETE FROM bgc_file
         WHERE bgc01 = g_bgc_hd.bgc01
           AND bgc02 = g_bgc_hd.bgc02
           AND bgc04 = g_bgc_hd.bgc04
           AND bgc05 = g_bgc_hd.bgc05
           AND bgc08 = g_bgc_hd.bgc08
    END IF
END FUNCTION
 
#單身重查
FUNCTION i003_b_askkey()
DEFINE
    l_wc2  LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON bgc03, bgc06, bgc07
         FROM s_bgc[1].bgc03, s_bgc[1].bgc06, s_bgc[1].bgc07
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i003_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i003_b_fill(p_wc2)            #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000,   #No.FUN-680061 VARCHAR(200) 
    l_cnt    LIKE type_file.num5       #No.FUN-680061 SMALLINT
 
    LET g_sql =
        "SELECT bgc03, '',bgc06, bgc07",
        "  FROM bgc_file",
        " WHERE bgc01 ='", g_bgc_hd.bgc01, "' ",
        "   AND bgc02 ='", g_bgc_hd.bgc02, "' ",
        "   AND bgc04 ='", g_bgc_hd.bgc04, "' ",
        "   AND bgc05 ='", g_bgc_hd.bgc05, "' ",
        "   AND bgc08 ='", g_bgc_hd.bgc08, "' ",
	"   AND ", p_wc2 CLIPPED,
        " ORDER BY bgc03"
    PREPARE i003_pb
       FROM g_sql
    DECLARE i003_bcs                             #SCROLL CURSOR
     CURSOR FOR i003_pb
 
    CALL g_bgc.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH i003_bcs INTO g_bgc[g_cnt].*         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL s_bga05(g_bgc_hd.bgc01, g_bgc_hd.bgc02,
                     g_bgc[g_cnt].bgc03, g_bgc_hd.bgc04)
        RETURNING g_bgc[g_cnt].bga05
        IF cl_null(g_bgc[g_cnt].bga05) THEN
           LET g_bgc[g_cnt].bga05 = 1
        END IF
        LET g_cnt = g_cnt + 1
       #IF g_cnt > g_bgc_arrno THEN
       #    CALL cl_err('',9035,0)
       #    EXIT FOREACH
       #END IF
    END FOREACH
    CALL g_bgc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
#單身顯示
FUNCTION i003_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_bgc TO s_bgc.* ATTRIBUTE(COUNT=g_rec_b)
   DISPLAY ARRAY g_bgc TO s_bgc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #NO.TQC-630274
      BEFORE DISPLAY
 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION first
         CALL i003_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION previous
         CALL i003_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION jump
         CALL i003_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION next
         CALL i003_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION last
         CALL i003_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                 #No: MOD-530236
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0033 --START
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0033 --END 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#整批複製
FUNCTION i003_copy()
DEFINE
    old_ver         LIKE bgc_file.bgc01,        #原版本       #FUN-680061 VARCHAR(10)
    oyy             LIKE bgc_file.bgc02,        #原年度       #FUN-680061 VARCHAR(04)
    new_ver         LIKE bgc_file.bgc01,        #新版本       #FUN-680061 VARCHAR(10)
    nyy             LIKE bgc_file.bgc02,        #新年度       #FUN-680061 VARCHAR(04)
    l_i             LIKE type_file.num10,       #拷貝筆數     #FUN-680061 INTEGER
    l_bgc           RECORD     LIKE bgc_file.*, #複製用buffer 
    l_bgb05	        LIKE bgb_file.bgb05     #材料調幅     
    IF cl_null(g_bgc_hd.bgc01) AND
       cl_null(g_bgc_hd.bgc02) THEN
          CALL cl_err('',-400,0)
          RETURN
    END IF
    OPEN WINDOW i003_c_w AT 12,24 WITH FORM "abg/42f/abgi003_c"
           ATTRIBUTE(STYLE = g_win_style)
     CALL cl_ui_init()    #MOD-530524
    IF STATUS THEN
        CALL cl_err('open window i003_c_w:',STATUS,0)
        RETURN
    END IF
 WHILE TRUE
    LET old_ver = g_bgc_hd.bgc01
    LET oyy = g_bgc_hd.bgc02
    LET new_ver = NULL
    LET nyy = NULL
 
    INPUT BY NAME old_ver, oyy, new_ver, nyy
        WITHOUT DEFAULTS
 
        AFTER FIELD old_ver
           IF NOT cl_null(old_ver) AND g_bgz.bgz02 = 'N' THEN
              CALL cl_err('', 'abg-001', 0)
              LET old_ver = ' '
              DISPLAY BY NAME old_ver
              NEXT FIELD old_ver
           END IF
           IF cl_null(old_ver) AND g_bgz.bgz02 = 'Y' THEN
              NEXT FIELD old_ver
           END IF
           IF cl_null(old_ver) THEN
              LET old_ver = ' '
              DISPLAY BY NAME old_ver
           END IF
 
        AFTER FIELD oyy
            IF cl_null(oyy) OR oyy<0 THEN NEXT FIELD oyy END IF
 
        AFTER FIELD new_ver
           IF NOT cl_null(new_ver) AND g_bgz.bgz02 = 'N' THEN
              CALL cl_err('', 'abg-001', 0)
              LET old_ver = ' '
              DISPLAY BY NAME new_ver
              NEXT FIELD new_ver
           END IF
           IF cl_null(new_ver) AND g_bgz.bgz02 = 'Y' THEN
              NEXT FIELD new_ver
           END IF
           IF cl_null(new_ver) THEN
              LET new_ver = ' '
              DISPLAY BY NAME new_ver
           END IF
 
        AFTER FIELD nyy
            IF cl_null(nyy) THEN NEXT FIELD nyy END IF
 
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
    IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW i003_c_w
        RETURN
    END IF
    IF new_ver IS NULL OR nyy IS NULL THEN
       CONTINUE WHILE
    END IF
    EXIT WHILE
 END WHILE
    CLOSE WINDOW i003_c_w
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
    BEGIN WORK
    LET g_success='Y'
    DECLARE i003_c CURSOR FOR
        SELECT *
          FROM bgc_file
         WHERE bgc01 = old_ver
           AND bgc02 = oyy
           AND bgc04 = g_bgc_hd.bgc04
           AND bgc05 = g_bgc_hd.bgc05
           AND bgc08 = g_bgc_hd.bgc08
    LET l_i = 0
    FOREACH i003_c INTO l_bgc.*
        LET l_i = l_i+1
        LET l_bgc.bgc01 = new_ver
        LET l_bgc.bgc02 = nyy
 
        CALL s_bga05(l_bgc.bgc01   , l_bgc.bgc02   ,
                     l_bgc.bgc03   , l_bgc.bgc04    )
        RETURNING g_bgc[l_ac].bga05
	LET l_bgb05 = 0				 #取出新的調幅
	SELECT bgb05 INTO l_bgb05
	  FROM bgb_file, ima_file
	 WHERE bgb01 = new_ver
	   AND bgb02 = nyy
	   AND bgb03 = l_bgc.bgc03
	   AND bgb04 = ima109
        IF cl_null(l_bgb05) THEN LET l_bgb05=0 END IF
	LET l_bgc.bgc06 = l_bgc.bgc06 * ( 1 + l_bgb05/ 100)

        #CHI-AC0006 add --start--
        LET l_bgc.bgcuser = g_user 
        LET l_bgc.bgcgrup = g_grup 
        LET l_bgc.bgcmodu = NULL 
        LET l_bgc.bgcdate = g_today 
        LET l_bgc.bgcacti = 'Y'
        #CHI-AC0006 add --end--
 
        LET l_bgc.bgcoriu = g_user      #No.FUN-980030 10/01/04
        LET l_bgc.bgcorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO bgc_file VALUES(l_bgc.*)
        IF STATUS THEN
#           CALL cl_err('ins bgc:',STATUS,1) #FUN-660105
            CALL cl_err3("ins","bgc_file",l_bgc.bgc01,l_bgc.bgc02,STATUS,"","ins bgc:",1) #FUN-660105
            LET g_success='N'
            EXIT FOREACH  #No.TQC-AC0130 add
        END IF
    END FOREACH
    IF g_success='Y' THEN
        COMMIT WORK
        #FUN-C30027---begin
        LET g_bgc_hd.bgc01 = new_ver
        LET g_bgc_hd.bgc02 = nyy
        LET g_wc = '1=1'
        CALL i003_show()          
        #FUN-C30027---end  
        MESSAGE l_i, ' rows copied!'
    ELSE
        ROLLBACK WORK
        MESSAGE 'rollback work!'
    END IF
END FUNCTION
 
#製作簡表
FUNCTION i003_out()
DEFINE
    l_i LIKE type_file.num5,      #No.FUN-680061 SMALLINT
    sr RECORD
        bgc01       LIKE bgc_file.bgc01,
        bgc02       LIKE bgc_file.bgc02,
        bgc04       LIKE bgc_file.bgc04,
        bgc05       LIKE bgc_file.bgc05,
        bgc08       LIKE bgc_file.bgc08,
        bgc03       LIKE bgc_file.bgc03,
        bgc06       LIKE bgc_file.bgc06,
        bgc07       LIKE bgc_file.bgc07
        END RECORD,
    l_name LIKE type_file.chr20,   #No.FUN-680061 VARCHAR(20)
    l_za05 LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(40)
#No.FUN-770033--start--
DEFINE l_bga05 LIKE bga_file.bga05
DEFINE  l_ima02 LIKE ima_file.ima02
DEFINE  l_ima021 LIKE ima_file.ima021
DEFINE l_sql    STRING
#No.FUN-770033--end--
    IF cl_null(g_wc) THEN
	CALL cl_err('', 9057, 0)
	RETURN
    END IF
    CALL cl_wait()
#   CALL cl_outnam('abgi003') RETURNING l_name    #No.FUN-770033
    CALL cl_del_data(l_table)                     #No.FUN-770033
    SELECT zo02
      INTO g_company
      FROM zo_file
     WHERE zo01 = g_lang
    LET g_sql="SELECT bgc01, bgc02, bgc04, bgc05,bgc08, ",
              "       bgc03, bgc06, bgc07  ",
              "  FROM bgc_file",
              " WHERE 1=1 AND ", g_wc CLIPPED
    PREPARE i003_p1 FROM g_sql                   # RUNTIME 編譯
       
    DECLARE i003_co CURSOR FOR i003_p1
#   START REPORT i003_rep TO l_name              #No.FUN-770033
 
    FOREACH i003_co INTO sr.*
    IF SQLCA.sqlcode THEN                                                                                                       
       CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                      
       EXIT FOREACH                                                                                                                 
    END IF
#No.FUN-770033--start--  
    SELECT ima02, ima021 INTO l_ima02, l_ima021                                                                     
              FROM ima_file                                                                                                         
             WHERE ima01 = sr.bgc05 
    CALL s_bga05(sr.bgc01,sr.bgc02,sr.bgc03,sr.bgc04)                                                                       
            RETURNING l_bga05                                                                                                       
            SELECT azi07 INTO t_azi07 FROM azi_file                                                                                 
               WHERE azi01=sr.bgc04                                                                                                 
            IF SQLCA.sqlcode THEN                                                                                                   
               LET t_azi07=3                                                                                                        
            END IF                                                                                                                  
            SELECT azi03 INTO t_azi03 FROM azi_file                                                                                 
               WHERE azi01=sr.bgc04                                                                                                 
            IF SQLCA.sqlcode THEN                                                                                                   
               LET t_azi03=3                                                                                                        
            END IF
        EXECUTE insert_prep USING
                sr.bgc01,sr.bgc02,sr.bgc04,sr.bgc05,l_ima02,l_ima021,
                sr.bgc08,sr.bgc03,l_bga05,sr.bgc06,sr.bgc07,t_azi03,
                t_azi07                                            
#No.FUN-770033--end--
#       OUTPUT TO REPORT i003_rep(sr.*)                 #No.FUN-770033
    END FOREACH
#No.FUN-770033--start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    IF g_zz05 = 'Y' THEN                                                                                   
       CALL cl_wcchp(g_wc,'bgc01, bgc02, bgc04, bgc05,bgc08,bgc03,bgc06,bgc07')                                      
       RETURNING g_wc                                                                                     
       LET g_str = g_wc                                                                                     
    END IF 
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str=g_str,";",g_azi03      
#No.FUN-770033--end--    
#   FINISH REPORT i003_rep                               #No.FUN-770033
 
    CLOSE i003_co                        
    ERROR ""                  
    CALL cl_prt_cs3('abgi003','abgi003',l_sql,g_str)     #No.FUN-770033
#   CALL cl_prt(l_name,' ','1',g_len)                    #No.FUN-770033
END FUNCTION
#No.FUN-770033--start--
{REPORT i003_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1)
    l_i             LIKE type_file.num5,   #No.FUN-680061 SMALLINT
    l_bga05         LIKE bga_file.bga05,
    l_ima RECORD
	ima02	    LIKE ima_file.ima02,
	ima021	    LIKE ima_file.ima021
	END RECORD,
    sr RECORD
        bgc01       LIKE bgc_file.bgc01,
        bgc02       LIKE bgc_file.bgc02,
        bgc04       LIKE bgc_file.bgc04,
        bgc05       LIKE bgc_file.bgc05,
        bgc08       LIKE bgc_file.bgc08,
        bgc03       LIKE bgc_file.bgc03,
        bgc06       LIKE bgc_file.bgc06,
        bgc07       LIKE bgc_file.bgc07
        END RECORD
 
    OUTPUT
        TOP MARGIN g_top_margin
        LEFT MARGIN g_left_margin
        BOTTOM MARGIN g_bottom_margin
        PAGE LENGTH g_page_line
 
    ORDER BY sr.bgc01, sr.bgc02, sr.bgc04, sr.bgc05, sr.bgc03
 
    FORMAT
        PAGE HEADER
#No.FUN-580010--start
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 ,g_company
            LET g_pageno = g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
#No.FUN-580010--end
 
        BEFORE GROUP OF sr.bgc05
            SKIP TO TOP OF PAGE
            SELECT ima02, ima021 INTO l_ima.ima02, l_ima.ima021
	      FROM ima_file
             WHERE ima01 = sr.bgc05
#No.FUN-580010--start
            PRINT COLUMN 01, g_x[11] CLIPPED, COLUMN 07, sr.bgc01 CLIPPED,
	          COLUMN 23, g_x[12] CLIPPED, COLUMN 29, sr.bgc02 CLIPPED,
		  COLUMN 45, g_x[13] CLIPPED, COLUMN 51, sr.bgc04 CLIPPED
           #PRINT COLUMN 01, g_x[14] CLIPPED,COLUMN 07,sr.bgc01 CLIPPED         #No.TQC-760066   mark
            PRINT COLUMN 01, g_x[14] CLIPPED,COLUMN 07,sr.bgc05 CLIPPED         #No.TQC-760066
	    PRINT COLUMN 01, l_ima.ima02
            PRINT COLUMN 01, l_ima.ima021
            PRINT COLUMN 01, g_x[19] CLIPPED, COLUMN 07, sr.bgc08 CLIPPED
            PRINT g_dash2[1, g_len]
            PRINTX name= H1 g_x[31],g_x[32],g_x[33],g_x[34]
            PRINT g_dash1
#No.FUN-580010--end
 
        ON EVERY ROW
            CALL s_bga05(sr.bgc01,sr.bgc02,sr.bgc03,sr.bgc04)
            RETURNING l_bga05
            SELECT azi07 INTO t_azi07 FROM azi_file
               WHERE azi01=sr.bgc04
            IF SQLCA.sqlcode THEN
               LET t_azi07=3
            END IF
            SELECT azi03 INTO t_azi03 FROM azi_file
               WHERE azi01=sr.bgc04
            IF SQLCA.sqlcode THEN
               LET t_azi03=3
            END IF
 
#No.FUN-580010--start
            PRINTX name=D1
                  COLUMN g_c[31],sr.bgc03 CLIPPED,
                  COLUMN g_c[32],cl_numfor(l_bga05,32,t_azi03),
                  COLUMN g_c[33],cl_numfor(sr.bgc06,33,t_azi07),
                  COLUMN g_c[34],cl_numfor(sr.bgc07,34,g_azi03)
#No.FUN-580010--end
        ON LAST ROW
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT '(abgi003)', COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT 'abgi003', COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770033--end--
 
FUNCTION i003_bgc05(p_cmd,l_bgc05)           #顯示對應的品名及規格
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_bgc05   LIKE bgc_file.bgc05,
           p_cmd     LIKE type_file.chr1     #No.FUN-680061 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02, ima021 INTO l_ima02, l_ima021
      FROM ima_file
     WHERE ima01 = l_bgc05
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
                                  LET l_ima02 = NULL
                                  LET l_ima021= NULL
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
        DISPLAY l_ima02, l_ima021 TO FORMONLY.ima02, FORMONLY.ima021
    END IF
END FUNCTION
 
FUNCTION i003_bgc08(p_cmd,p_key)
 DEFINE l_gfeacti LIKE gfe_file.gfeacti,
        l_ima25   LIKE ima_file.ima25  ,
        l_ima01   LIKE ima_file.ima01  ,
        p_key     LIKE bgc_file.bgc08,
        l_fac     LIKE pml_file.pml09,  #NO.FUN-680061 DEC(16,8)
        p_cmd     LIKE type_file.chr1   #No.FUN-680061 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti
    FROM gfe_file  WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                                 LET l_gfeacti = NULL
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
END FUNCTION
 
#依參數取得單價預設值
FUNCTION i003_bgc06(p_bgc01,p_bgc02,p_bgc03,p_bgc04,p_bgc05,p_bga05)
  DEFINE p_bgc01    LIKE bgc_file.bgc01
  DEFINE p_bgc02    LIKE bgc_file.bgc02
  DEFINE p_bgc03    LIKE bgc_file.bgc03
  DEFINE p_bgc04    LIKE bgc_file.bgc04
  DEFINE p_bgc05    LIKE bgc_file.bgc05
  DEFINE p_bga05    LIKE bga_file.bga05
  DEFINE l_ima53    LIKE ima_file.ima53
  DEFINE l_ima54    LIKE ima_file.ima54
  DEFINE l_ima109   LIKE ima_file.ima109
  DEFINE l_ccc23a   LIKE ccc_file.ccc23a
  DEFINE l_pmh12    LIKE pmh_file.pmh12
  DEFINE l_bgb05    LIKE bgb_file.bgb05
  DEFINE l_bgc06    LIKE bgc_file.bgc06
  DEFINE l_bgc07    LIKE bgc_file.bgc07
# DEFINE l_azi04    LIKE azi_file.azi04 #NO.CHI-6A0004
  DEFINE l_ima25    LIKE ima_file.ima25
  DEFINE l_fac      LIKE pml_file.pml09 #No.FUN-680061 DEC(16,8)
  CASE WHEN g_bgz.bgz03 = '1'
            SELECT ima53 INTO l_ima53 FROM ima_file
             WHERE ima01 = p_bgc05
            IF cl_null(l_ima53) THEN LET l_ima53 = 0 END IF
            LET l_bgc07 = l_ima53
            LET l_bgc06 = l_ima53 / p_bga05
       WHEN g_bgz.bgz03 = '2'
            LET l_ccc23a=''
           #-------------------No:CHI-B60093 modify
           #DECLARE ccc_ym CURSOR FOR
           #  SELECT ccc23a FROM ccc_file
           #   WHERE ccc01 = p_bgc05
           #  #  AND ccc02 = p_bgc02
           #  #  AND ccc03 = p_bgc03
           #     AND ccc07='1'        #No.FUN-840041
           #   ORDER BY ccc02 DESC, ccc03 DESC
           #FOREACH ccc_ym INTO l_ccc23a
           #     EXIT FOREACH
           #END FOREACH
            SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  
            CALL i003_get_ccc23('1',p_bgc05) RETURNING l_ccc23a
           #-------------------No:CHI-B60093 end

            IF cl_null(l_ccc23a) THEN
              #-------------------No:CHI-B60093 modify
              #DECLARE cca_ym CURSOR FOR
              #   SELECT cca12a FROM cca_file
              #    WHERE cca01 = p_bgc05
              #    ORDER BY cca02 DESC, cca03 DESC
              #FOREACH cca_ym INTO l_ccc23a
              #  EXIT FOREACH
              #END FOREACH
               CALL i003_get_ccc23('2',p_bgc05) RETURNING l_ccc23a
              #-------------------No:CHI-B60093 end
            END IF
            IF cl_null(l_ccc23a) THEN LET l_ccc23a = 0 END IF
            LET l_ima25=''
            SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=p_bgc05
            CALL s_umfchk(p_bgc05,l_ima25,g_bgc_hd.bgc08)
            RETURNING g_i,l_fac
            IF g_i = 1 THEN LET l_fac = 1 END IF
            LET l_bgc07 = l_ccc23a*l_fac
            LET l_bgc06 = (l_ccc23a/p_bga05)*l_fac
       WHEN g_bgz.bgz03 = '3'
            SELECT ima54 INTO l_ima54 FROM ima_file
             WHERE ima01 = p_bgc05
            SELECT pmh12 INTO l_pmh12 FROM pmh_file
             WHERE pmh01 = p_bgc05
               AND pmh02 = l_ima54
               AND pmh05 = '0'
               AND pmh13 = p_bgc04
               AND pmh21 = " "                            #CHI-860042                                                               
               AND pmh22 = '1'                            #CHI-860042
               AND pmh23 = ' '                            #No.CHI-960033
               AND pmhacti = 'Y'                                           #CHI-910021
            IF SQLCA.SQLCODE THEN        #無主供應商資料, 則取出第一筆
               DECLARE i003_c3_c CURSOR FOR
                   SELECT pmh12 FROM pmh_file
                    WHERE pmh01 = p_bgc05 AND pmh05 = '0'
                      AND pmh13 = p_bgc04
                      AND pmh21 = " "                     #CHI-860042                                                               
                      AND pmh22 = '1'                     #CHI-860042
                      AND pmh23 = ' '                     #No.CHI-960033
                      AND pmhacti = 'Y'                                           #CHI-910021
               OPEN i003_c3_c
               FETCH i003_c3_c INTO l_pmh12
               CLOSE i003_c3_c
            END IF
            IF cl_null(l_pmh12) THEN LET l_pmh12 = 0 END IF
             #LET l_bgc06 = l_pmh12   #MOD-530524
             LET l_bgc07 = l_pmh12    #MOD-530524
             LET l_bgc06 = l_pmh12/p_bga05    #MOD-530524
 
  END CASE
 
  SELECT ima109 INTO l_ima109 FROM ima_file
   WHERE ima01 = p_bgc05
 
  SELECT bgb05 INTO l_bgb05 FROM bgb_file
   WHERE bgb01 = p_bgc01
     AND bgb02 = p_bgc02
     AND bgb03 = p_bgc03
     AND bgb04 = l_ima109
  IF cl_null(l_bgb05) THEN LET l_bgb05 = 0 END IF
  LET l_bgc06 = l_bgc06 * ( 1 + l_bgb05/100)
# SELECT azi04 INTO l_azi04 FROM azi_file           #NO.CHI-6A0004
  SELECT azi04 INTO t_azi04 FROM azi_file           #NO.CHI-6A0004
   WHERE azi01 = p_bgc04
# IF cl_null(l_azi04) THEN LET l_azi04 = 0 END IF   #NO.CHI-6A0004
  IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF   #NO.CHI-6A0004
 
 #LET l_bgc06 = cl_digcut(l_bgc06,l_azi04)
 #LET l_bgc07 = cl_digcut(l_bgc06*p_bga05,g_azi04)
 #NO.MOD-5B0146 START---
 LET l_bgc06 = cl_digcut(l_bgc06,g_azi03)
 LET l_bgc07 = cl_digcut(l_bgc06*p_bga05,g_azi03)
 #NO.MOD-5B0146 END----
 
  RETURN l_bgc06,l_bgc07
 
END FUNCTION
 
#-----------------------No:CHI-B60093 add----------------------
FUNCTION i003_get_ccc23(p_flag,p_ccc01)
   DEFINE p_ccc01      LIKE ccc_file.ccc01
   DEFINE p_flag       LIKE type_file.chr1
   DEFINE l_chr        LIKE type_file.chr1
   DEFINE l_ccc23a     LIKE ccc_file.ccc23a
   DEFINE l_ccc23a_sum LIKE ccc_file.ccc23a
   DEFINE l_ccc02      LIKE ccc_file.ccc02
   DEFINE l_ccc03      LIKE ccc_file.ccc03
   DEFINE l_ccc02_t    LIKE ccc_file.ccc02
   DEFINE l_ccc03_t    LIKE ccc_file.ccc03
   DEFINE l_cnt        LIKE type_file.num5

   LET l_ccc23a = 0 
   LET l_ccc23a_sum = 0 
   LET l_cnt = 0     
   LET l_ccc02_t = NULL 
   LET l_ccc03_t = NULL 
   LET l_chr = 'N'
   IF p_flag = '1' THEN 
      DECLARE ccc_ym CURSOR FOR
        SELECT ccc02,ccc03,ccc23a FROM ccc_file
         WHERE ccc01 = p_ccc01
           AND ccc07 = g_ccz.ccz28
         ORDER BY ccc02 DESC, ccc03 DESC
      IF g_ccz.ccz28 MATCHES "[12]" THEN
      #成本參數設定月加權平均
         FOREACH ccc_ym INTO l_ccc02,l_ccc03,l_ccc23a
            LET l_ccc23a_sum = l_ccc23a
            LET l_cnt = l_cnt + 1
            LET l_chr = 'Y'
            EXIT FOREACH
         END FOREACH
      ELSE
         FOREACH ccc_ym INTO l_ccc02,l_ccc03,l_ccc23a
            IF NOT cl_null(l_ccc02_t) AND NOT cl_null(l_ccc03_t) 
               AND (l_ccc02 *12+ l_ccc03) <> (l_ccc02_t*12+l_ccc03_t) THEN
               EXIT FOREACH
            ELSE
               LET l_ccc23a_sum = l_ccc23a_sum + l_ccc23a
               LET l_cnt = l_cnt + 1
               LET l_ccc02_t = l_ccc02 
               LET l_ccc03_t = l_ccc03 
               LET l_chr = 'Y'
            END IF
         END FOREACH
      END IF 
   ELSE
      DECLARE cca_ym CURSOR FOR
         SELECT cca02,cca03,cca12a FROM cca_file
          WHERE cca01 = p_ccc01
           AND cca06 = g_ccz.ccz28
          ORDER BY cca02 DESC, cca03 DESC
      IF g_ccz.ccz28 MATCHES "[12]" THEN
      #成本參數設定月加權平均
         FOREACH cca_ym INTO l_ccc02,l_ccc03,l_ccc23a
            LET l_ccc23a_sum = l_ccc23a
            LET l_cnt = l_cnt + 1
            LET l_chr = 'Y'
            EXIT FOREACH
         END FOREACH
      ELSE
         FOREACH cca_ym INTO l_ccc02,l_ccc03,l_ccc23a
            IF NOT cl_null(l_ccc02_t) AND NOT cl_null(l_ccc03_t) 
               AND (l_ccc02 *12+ l_ccc03) <> (l_ccc02_t*12+l_ccc03_t) THEN
               EXIT FOREACH
            ELSE
               LET l_ccc23a_sum = l_ccc23a_sum + l_ccc23a
               LET l_cnt = l_cnt + 1
               LET l_ccc02_t = l_ccc02 
               LET l_ccc03_t = l_ccc03 
               LET l_chr = 'Y'
            END IF
         END FOREACH
      END IF
   END IF
   IF l_cnt = 0 THEN LET l_cnt = 1 END IF
   LET l_ccc23a_sum = l_ccc23a_sum / l_cnt
   IF l_chr = 'N' THEN
      RETURN NULL
   ELSE
      RETURN l_ccc23a_sum
   END IF

END FUNCTION
#-----------------------No:CHI-B60093 add----------------------
#自動產生單身
FUNCTION i003_g_b()
  DEFINE sr RECORD
            bga03 LIKE bga_file.bga03,
            bga05 LIKE bga_file.bga05
         END RECORD
  DEFINE l_bgc RECORD LIKE bgc_file.*
  DEFINE l_sql  LIKe type_file.chr1000 #FUN-680061 CHAR (1300)  
 
   IF g_bgz.bgz02 = 'N' THEN   #MOD-530524
      SELECT COUNT(*) INTO g_cnt FROM bga_file   #MOD-530524
      WHERE bga01 = ' ' AND bga02 = g_bgc_hd.bgc02   #MOD-530524
        AND bga04 = g_bgc_hd.bgc04 AND bgaacti = 'Y'   #MOD-530524
   ELSE   #MOD-530524
     SELECT COUNT(*) INTO g_cnt FROM bga_file
     WHERE bga01 = g_bgc_hd.bgc01 AND bga02 = g_bgc_hd.bgc02
       AND bga04 = g_bgc_hd.bgc04 AND bgaacti = 'Y'
   END IF   #MOD-530524
  IF g_cnt = 0 THEN
      CALL cl_err('','apm-204',1)   #MOD-530524
     RETURN
  END IF
 #MOD-530524
  IF g_bgz.bgz02 = 'N' THEN
     LET l_sql ="SELECT bga03,bga05 FROM bga_file ",
                "WHERE bga01 = ' ' AND bga02 = '",g_bgc_hd.bgc02 CLIPPED,
                "' AND bga04 = '",g_bgc_hd.bgc04,"' AND bgaacti = 'Y'"
  ELSE
     LET l_sql ="SELECT bga03,bga05 FROM bga_file ",
                "WHERE bga02 = '",g_bgc_hd.bgc02,"' AND bga04 = '",
                g_bgc_hd.bgc04,"' AND bgaacti = 'Y' AND bga01 = '" ,
                g_bgc_hd.bgc01,"'"
  END IF
  PREPARE bga_prepare FROM l_sql
  DECLARE bga_cs CURSOR FOR bga_prepare
{
  DECLARE bga_cs CURSOR FOR
    SELECT bga03,bga05 FROM bga_file
     WHERE bga01 = g_bgc_hd.bgc01 AND bga02 = g_bgc_hd.bgc02
       AND bga04 = g_bgc_hd.bgc04 AND bgaacti = 'Y'
}
 #END MOD-530524
  FOREACH bga_cs INTO sr.*
     LET l_bgc.bgc01   = g_bgc_hd.bgc01
     LET l_bgc.bgc02   = g_bgc_hd.bgc02
     LET l_bgc.bgc03   = sr.bga03            #月份
     LET l_bgc.bgc04   = g_bgc_hd.bgc04
     LET l_bgc.bgc05   = g_bgc_hd.bgc05
     LET l_bgc.bgc08   = g_bgc_hd.bgc08
     CALL i003_bgc06(l_bgc.bgc01,l_bgc.bgc02,l_bgc.bgc03,l_bgc.bgc04,
                     l_bgc.bgc05,sr.bga05)
     RETURNING l_bgc.bgc06,l_bgc.bgc07
     LET l_bgc.bgcacti = 'Y'
     LET l_bgc.bgcuser = g_user
     LET l_bgc.bgcgrup = g_grup
     LET l_bgc.bgcdate = g_today
     LET l_bgc.bgcoriu = g_user      #No.FUN-980030 10/01/04
     LET l_bgc.bgcorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO bgc_file VALUES (l_bgc.*)
     IF STATUS THEN
#       CALL cl_err('ins bgc fail',STATUS,1) #FUN-660105
        CALL cl_err3("ins","bgc_file",l_bgc.bgc01,l_bgc.bgc02,STATUS,"","ins bgc fail",1) #FUN-660105
        EXIT FOREACH
     END IF
  END FOREACH
  CALL i003_b_fill(' 1=1')
END FUNCTION
 
#NO.MOD-590329 MARK
 #NO.MOD-580078
#FUNCTION i003_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bgc03,bgc05",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i003_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bgc03,bgc05",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#NO.MOD-590329
#Patch....NO.TQC-610035 <> #
