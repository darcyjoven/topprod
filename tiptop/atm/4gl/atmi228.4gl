# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi228.4gl 
# Descriptions...: 客戶定價維護作業
# Date & Author..: Rayven 06/01/09
# Modify.........: NO.TQC-630072 06/03/07 By Melody 指定單據編號、執行功能(g_argv2)
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.FUN-620024 06/03/23 By Rayven 新增欄位tqo03
# Modify.........: No.TQC-640084 06/04/13 By Rayven 將允許新增的條件從開立變為審核
# Modify.........: No.TQC-650028 06/05/10 By Rayven 取消對渠道的判定限制
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3
# Modify.........: No.TQC-680115 06/08/23 By Sarah 若項次更改會有錯誤訊息
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690025 06/09/20 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740162 07/04/21 By cehnl   客戶編號欄位不再控管該客戶是否已審核。
# Modify.........: No.TQC-740316 07/04/26 By Judy 單身一個訂價編號對應一個客戶編號，不可以重復
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7B0118 07/11/21 By wujie   atmi228的狀態碼取消“申請”狀態，相應作調整 
#                                                    單身輸入多個訂價編號時,若輸入的訂價編號的產品已存在于其他訂價編號中,會被擋掉，應該去除此限制
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0010 08/02/16 By Carrier 資料中心功能
# Modify.........: FUN-830090 08/03/26 By Carrier 修改s_axmi221_carry的參數
# Modify.........: No.FUN-840068 08/04/17 By TSD.Achick 自定欄位功能修改
# Modify.........: No.TQC-850030 09/05/26 By wujie 缺少狀態頁簽 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-990069 09/10/12 By baofei 增加子公司可新增資料的檢查 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-7C0010
 
DEFINE
    g_tqo_hd        RECORD                       #單頭變數
        tqo01       LIKE tqo_file.tqo01,
        tqoacti     LIKE tqo_file.tqoacti,
        tqouser     LIKE tqo_file.tqouser,
        tqogrup     LIKE tqo_file.tqogrup,
        tqomodu     LIKE tqo_file.tqomodu,
        tqodate     LIKE tqo_file.tqodate
        END RECORD,
    g_tqo_hd_t      RECORD                       #單頭變數
        tqo01       LIKE tqo_file.tqo01,
        tqoacti     LIKE tqo_file.tqoacti,
        tqouser     LIKE tqo_file.tqouser,
        tqogrup     LIKE tqo_file.tqogrup,
        tqomodu     LIKE tqo_file.tqomodu,
        tqodate     LIKE tqo_file.tqodate
        END RECORD,
    g_tqo_hd_o      RECORD                       #單頭變數
        tqo01       LIKE tqo_file.tqo01,
        tqoacti     LIKE tqo_file.tqoacti,
        tqouser     LIKE tqo_file.tqouser,
        tqogrup     LIKE tqo_file.tqogrup,
        tqomodu     LIKE tqo_file.tqomodu,
        tqodate     LIKE tqo_file.tqodate
        END RECORD,
    g_tqo           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        tqo03       LIKE tqo_file.tqo03,         #No.FUN-620024
        tqo02       LIKE tqo_file.tqo02,
        tqm02       LIKE tqm_file.tqm02,
        tqm03       LIKE tqm_file.tqm03,
        tqa02       LIKE tqa_file.tqa02,
        tqo04       LIKE tqo_file.tqo04          #No.FUN-7C0010
        #FUN-840068 --start---
       ,tqoud01 LIKE tqo_file.tqoud01,
        tqoud02 LIKE tqo_file.tqoud02,
        tqoud03 LIKE tqo_file.tqoud03,
        tqoud04 LIKE tqo_file.tqoud04,
        tqoud05 LIKE tqo_file.tqoud05,
        tqoud06 LIKE tqo_file.tqoud06,
        tqoud07 LIKE tqo_file.tqoud07,
        tqoud08 LIKE tqo_file.tqoud08,
        tqoud09 LIKE tqo_file.tqoud09,
        tqoud10 LIKE tqo_file.tqoud10,
        tqoud11 LIKE tqo_file.tqoud11,
        tqoud12 LIKE tqo_file.tqoud12,
        tqoud13 LIKE tqo_file.tqoud13,
        tqoud14 LIKE tqo_file.tqoud14,
        tqoud15 LIKE tqo_file.tqoud15
        #FUN-840068 --end--
        END RECORD,
    g_tqo_t         RECORD                       #程式變數(舊值)
        tqo03       LIKE tqo_file.tqo03,         #No.FUN-620024
        tqo02       LIKE tqo_file.tqo02,
        tqm02       LIKE tqm_file.tqm02,
        tqm03       LIKE tqm_file.tqm03,
        tqa02       LIKE tqa_file.tqa02,
        tqo04       LIKE tqo_file.tqo04          #No.FUN-7C0010
        #FUN-840068 --start---
       ,tqoud01 LIKE tqo_file.tqoud01,
        tqoud02 LIKE tqo_file.tqoud02,
        tqoud03 LIKE tqo_file.tqoud03,
        tqoud04 LIKE tqo_file.tqoud04,
        tqoud05 LIKE tqo_file.tqoud05,
        tqoud06 LIKE tqo_file.tqoud06,
        tqoud07 LIKE tqo_file.tqoud07,
        tqoud08 LIKE tqo_file.tqoud08,
        tqoud09 LIKE tqo_file.tqoud09,
        tqoud10 LIKE tqo_file.tqoud10,
        tqoud11 LIKE tqo_file.tqoud11,
        tqoud12 LIKE tqo_file.tqoud12,
        tqoud13 LIKE tqo_file.tqoud13,
        tqoud14 LIKE tqo_file.tqoud14,
        tqoud15 LIKE tqo_file.tqoud15
        #FUN-840068 --end--
        END RECORD,
    g_wc            STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN
    g_sql           STRING,   
    g_sql1          STRING,     #TQC-740316
    g_rec_b         LIKE type_file.num5,         #單身筆數              #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT   #No.FUN-680120 SMALLINT
 
#No.FUN-7C0010  --Begin
DEFINE g_gev04        LIKE gev_file.gev04
DEFINE g_tqox         DYNAMIC ARRAY OF RECORD
                      sel      LIKE type_file.chr1,
                      tqo01    LIKE tqo_file.tqo01,
                      tqo02    LIKE tqo_file.tqo02
                      END RECORD 
#No.FUN-7C0010  --End  
 
DEFINE   g_argv1    LIKE tqo_file.tqo01
DEFINE   g_before_input_done LIKE type_file.num5                        #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL                       
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_cnt          LIKE type_file.num10                            #No.FUN-680120 INTEGER
DEFINE   g_chr          LIKE type_file.chr1                             #No.FUN-680120 VARCHAR(1)
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose                        #No.FUN-680120 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000                          #No.FUN-680120 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10                            #No.FUN-680120 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT   #No.FUN-6A0072
DEFINE g_argv2  STRING              #No.TQC-630072
 
#主程式開始
MAIN
DEFINE
#       l_time    LIKE type_file.chr8              #No.FUN-6B0014
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
                                                                                
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("ATM")) THEN                                               
       EXIT PROGRAM                                                             
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2) #No.TQC-630072
     
    INITIALIZE g_tqo_hd.* to NULL
    INITIALIZE g_tqo_hd_t.* to NULL
    INITIALIZE g_tqo_hd_o.* to NULL
 
    LET g_forupd_sql = "SELECT tqo01,tqoacti,tqouser,tqogrup,tqomodu,tqodate FROM tqo_file WHERE tqo01 = ? FOR UPDATE"                                                           
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i228_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 20
    OPEN WINDOW i228_w AT p_row,p_col
        WITH FORM "atm/42f/atmi228" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()         
 
 
   #No.TQC-630072 --start--
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i228_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i228_a()
            END IF
         OTHERWISE
            SELECT COUNT(*) INTO l_cnt FROM tqo_file                                 
             WHERE tqo01=g_argv1                                                     
            IF l_cnt=0 THEN                                                          
               CALL i228_a()                                                         
            ELSE                                                                     
               CALL i228_q()                                                         
            END IF                                                                   
      END CASE
   END IF
   #No.TQC-630072 ---end---
 
    LET g_action_choice = ""                                              
    CALL i228_menu()  
    CLOSE WINDOW i228_w                         #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
#QBE 查詢資料
FUNCTION i228_curs()
    CLEAR FORM #清除畫面
    IF g_argv1 IS NULL OR g_argv1 = " " THEN
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tqo_hd.* TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON tqo01, # 螢幕上取條件
                         tqouser,tqogrup,tqomodu,tqodate,tqoacti,   #No.TQC-850030
#                        tqo02        #No.FUN-620024
                         tqo03,tqo02, #No.FUN-620024
                         tqo04        #No.FUN-7C0010
                        #No.FUN-840068 --start--
                        ,tqoud01,tqoud02,tqoud03,tqoud04,tqoud05
                        ,tqoud06,tqoud07,tqoud08,tqoud09,tqoud10
                        ,tqoud11,tqoud12,tqoud13,tqoud14,tqoud15
                        #No.FUN-840068 ---end---
            FROM tqo01,tqouser,tqogrup,tqomodu,tqodate,tqoacti,     #No.TQC-850030
#                s_tqo[1].tqo02                 #No.FUN-620024
                 s_tqo[1].tqo03,s_tqo[1].tqo02, #No.FUN-620024
                 s_tqo[1].tqo04                 #No.FUN-7C0010
                 #No.FUN-840068 --start--
                 ,s_tqo[1].tqoud01,s_tqo[1].tqoud02,s_tqo[1].tqoud03,s_tqo[1].tqoud04,s_tqo[1].tqoud05
                 ,s_tqo[1].tqoud06,s_tqo[1].tqoud07,s_tqo[1].tqoud08,s_tqo[1].tqoud09,s_tqo[1].tqoud10
                 ,s_tqo[1].tqoud11,s_tqo[1].tqoud12,s_tqo[1].tqoud13,s_tqo[1].tqoud14,s_tqo[1].tqoud15
                 #No.FUN-840068 ---end---
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(tqo01)
                    CALL cl_init_qry_var()    
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ2"                              
                    CALL cl_create_qry() RETURNING g_qryparam.multiret       
                    DISPLAY g_qryparam.multiret TO tqo01
                WHEN INFIELD(tqo02)
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqm"                                
                    CALL cl_create_qry() RETURNING g_qryparam.multiret       
                    DISPLAY g_qryparam.multiret TO tqo02
                WHEN INFIELD(tqo04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azp"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tqo04
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
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    END CONSTRUCT   
 
    IF INT_FLAG THEN 
        CALL i228_show()
        RETURN
    END IF
    ELSE                                                                        
      LET g_wc = "tqo01  = '",g_argv1,"'"                                       
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND tqouser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND tqogrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND tqogrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqouser', 'tqogrup')
    #End:FUN-980030
 
 
    LET g_sql = "SELECT UNIQUE tqo01,tqouser,tqomodu,tqoacti,tqogrup,tqodate ",    #No.TQC-850030
                "  FROM tqo_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY tqo01"
    PREPARE i228_prepare FROM g_sql
    DECLARE i228_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i228_prepare
 
#   LET g_sql = "SELECT UNIQUE tqo01 ",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE tqo01 ",  #No.TQC-720019
                "  FROM tqo_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i228_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i228_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i228_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i228_precnt FROM g_sql
    DECLARE i228_cnt CURSOR FOR i228_precnt
END FUNCTION
 
FUNCTION i228_menu()
   WHILE TRUE
      CALL i228_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i228_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i228_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i228_r()
           END IF
        WHEN "invalid"                                                                                                             
           IF cl_chk_act_auth() THEN                                                                                               
              CALL i228_x()                                                                                                        
           END IF 
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i228_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        #No.FUN-7C0010  --Begin
        WHEN "carry"
           IF cl_chk_act_auth() THEN
              CALL ui.Interface.refresh()
              CALL i228_carry()
              ERROR ""
           END IF
 
        WHEN "download"
           IF cl_chk_act_auth() THEN
              CALL i228_download()
           END IF
           
        WHEN "qry_carry_history"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_tqo_hd.tqo01) THEN  #No.FUN-830090
                 #IF NOT cl_null(g_tqo.tqo04) THEN
                 #   SELECT gev04 INTO g_gev04 FROM gev_file
                 #    WHERE gev01 = '4' AND gev02 = g_tqo.tqo04
                 #ELSE      #歷史資料,即沒有tqo04的值
                     SELECT gev04 INTO g_gev04 FROM gev_file
                      WHERE gev01 = '4' AND gev02 = g_plant
                 #END IF
                  IF NOT cl_null(g_gev04) THEN
                     LET g_sql='aooq604 "',g_gev04,'" "4" "',g_prog,'" "',g_tqo_hd.tqo01,'"'
                     CALL cl_cmdrun(g_sql)
                  END IF
               ELSE
                  CALL cl_err('',-400,0)
               END IF
           END IF
        #No.FUN-7C0010  --End
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "exporttoexcel"   
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tqo),'','')
           END IF
        #No.FUN-6B0043-------add--------str----
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_tqo_hd.tqo01 IS NOT NULL THEN
                LET g_doc.column1 = "tqo01"
                LET g_doc.value1 = g_tqo_hd.tqo01
                CALL cl_doc()
              END IF
        END IF
        #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i228_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_tqo.clear()     
    INITIALIZE g_tqo_hd.* TO NULL                  #單頭初始清空
    INITIALIZE g_tqo_hd_o.* TO NULL                #單頭舊值清空
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tqo_hd.tqoacti = 'Y'
        LET g_tqo_hd.tqouser = g_user
        LET g_tqo_hd.tqogrup = g_grup
        LET g_tqo_hd.tqodate = g_today
#FUN-990069---begin
        IF NOT s_dc_ud_flag('4',g_plant,g_plant,'a') THEN                                                                           
           CALL cl_err('','aoo-078',1)                                                                                         
           RETURN                                                                                                                        
        END IF            
#FUN-990069---end
      #No.TQC-630072 --start--
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_tqo_hd.tqo01 = g_argv1
      #No.FUN-620024  --start--
         DISPLAY g_tqo_hd.tqo01 TO tqo01
         CALL i228_tqo01('d', g_tqo_hd.tqo01)
         CALL i228_b()
         LET g_argv1 = NULL
         LET g_argv2 = NULL
      ELSE
         CALL i228_i("a")
         IF INT_FLAG THEN                         
             LET INT_FLAG = 0
             CALL cl_err('',9001,0)
             EXIT WHILE
         END IF
         CALL g_tqo.clear()
         LET g_rec_b=0
         CALL i228_b()                            #輸入單身
         LET g_tqo_hd_t.* = g_tqo_hd.*            #保留舊值
         LET g_tqo_hd_o.* = g_tqo_hd.*            #保留舊值
         LET g_wc="     tqo01='",g_tqo_hd.tqo01,"' "
      #No.FUN-620024  --end--
      END IF
      #No.TQC-630072 ---end---
 
#No.FUN-620024  --start--
#       CALL i228_i("a")                         #輸入單頭
#       IF INT_FLAG THEN                         
#           LET INT_FLAG = 0
#           CALL cl_err('',9001,0)
#           EXIT WHILE
#       END IF
#
#       CALL g_tqo.clear()
#       LET g_rec_b=0
#       CALL i228_b()                            #輸入單身
#       LET g_tqo_hd_t.* = g_tqo_hd.*            #保留舊值
#       LET g_tqo_hd_o.* = g_tqo_hd.*            #保留舊值
#       LET g_wc="     tqo01='",g_tqo_hd.tqo01,"' "
#No.FUN-620024  --end--
      EXIT WHILE
    END WHILE
END FUNCTION
 
#處理單頭欄位(tqo01)INPUT
FUNCTION i228_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
    l_n     LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    LET l_n = 0
 
    DISPLAY g_tqo_hd.tqo01,g_tqo_hd.tqouser,g_tqo_hd.tqogrup,g_tqo_hd.tqomodu,g_tqo_hd.tqodate,g_tqo_hd.tqoacti   #No.TQC-850030
         TO tqo01,tqouser,tqogrup,tqomodu,tqodate,tqoacti    #No.TQC-850030 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031      
    INPUT g_tqo_hd.tqo01
      WITHOUT DEFAULTS  
      FROM tqo01
 
        AFTER FIELD tqo01
            IF NOT cl_null(g_argv1) THEN                                           
               IF g_tqo_hd.tqo01 !=g_argv1 THEN                                       
                  LET g_tqo_hd.tqo01=g_argv1                                          
                  DISPLAY BY NAME g_tqo_hd.tqo01                                      
                  NEXT FIELD tqo01                                                 
               END IF                                                              
            END IF
            IF NOT cl_null(g_tqo_hd.tqo01) THEN
                CALL i228_tqo01('d', g_tqo_hd.tqo01)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD tqo01
                END IF
            END IF
 
            SELECT COUNT(*) INTO l_n   #Key 值是否重覆
              FROM tqo_file
             WHERE tqo01 = g_tqo_hd.tqo01
            IF l_n > 0 THEN
                INITIALIZE g_tqo_hd TO NULL
                DISPLAY '' TO FORMONLY.occ02
                DISPLAY g_tqo_hd.tqo01
                     TO tqo01
                CALL cl_err( g_tqo_hd.tqo01, -239, 0)
                NEXT FIELD tqo01
            END IF
 
        ON ACTION CONTROLF                       #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(tqo01)
                   CALL cl_init_qry_var()    
                   LET g_qryparam.form ="q_occ2"                              
                   LET g_qryparam.default1 = g_tqo_hd.tqo01
                   CALL cl_create_qry() RETURNING g_tqo_hd.tqo01
                   DISPLAY BY NAME g_tqo_hd.tqo01
            END CASE
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help() 
 
  #  INSERT INTO tqo_file(tqoacti,tqouser,tqogrup,tqomodu,tqodate)
  #       VALUES(g_tqo_hd.tqoacti,g_user,g_grup,'',g_today)
               
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i228_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tqo_hd TO NULL                 #No.FUN-6B0043
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_tqo.clear() 
    DISPLAY '     ' TO FORMONLY.cnt
    CALL i228_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i228_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
       #INITIALIZE g_tqo TO NULL                 #No.FUN-6B0043 mark 
        INITIALIZE g_tqo_hd TO NULL              #No.FUN-6B0043 mod
    ELSE
        OPEN i228_cnt
        FETCH i228_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL i228_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i228_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1       #處理方式        #No.FUN-680120 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i228_cs INTO g_tqo_hd.tqo01,g_tqo_hd.tqouser,g_tqo_hd.tqomodu,g_tqo_hd.tqoacti,g_tqo_hd.tqogrup,g_tqo_hd.tqodate      #No.TQC-850030
        WHEN 'P' FETCH PREVIOUS i228_cs INTO g_tqo_hd.tqo01,g_tqo_hd.tqouser,g_tqo_hd.tqomodu,g_tqo_hd.tqoacti,g_tqo_hd.tqogrup,g_tqo_hd.tqodate      #No.TQC-850030
        WHEN 'F' FETCH FIRST    i228_cs INTO g_tqo_hd.tqo01,g_tqo_hd.tqouser,g_tqo_hd.tqomodu,g_tqo_hd.tqoacti,g_tqo_hd.tqogrup,g_tqo_hd.tqodate      #No.TQC-850030
        WHEN 'L' FETCH LAST     i228_cs INTO g_tqo_hd.tqo01,g_tqo_hd.tqouser,g_tqo_hd.tqomodu,g_tqo_hd.tqoacti,g_tqo_hd.tqogrup,g_tqo_hd.tqodate      #No.TQC-850030
        WHEN '/'
         IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0       #add for prompt bug
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
         FETCH ABSOLUTE g_jump i228_cs INTO g_tqo_hd.tqo01,g_tqo_hd.tqouser,g_tqo_hd.tqomodu,g_tqo_hd.tqoacti,g_tqo_hd.tqogrup,g_tqo_hd.tqodate      #No.TQC-850030
         LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqo_hd.tqo01, SQLCA.sqlcode, 0)
        INITIALIZE g_tqo_hd.* TO NULL  #TQC-6B0105
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
   SELECT UNIQUE tqo01 INTO g_tqo_hd.tqo01
     FROM tqo_file
    WHERE tqo01 = g_tqo_hd.tqo01
   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_tqo_hd.tqo01, SQLCA.sqlcode, 0)  #No.FUN-660104 MARK
       CALL cl_err3("sel","tqo_file",g_tqo_hd.tqo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
       INITIALIZE g_tqo TO NULL
       RETURN
   END IF
    LET g_data_owner = g_tqo_hd.tqouser   
    LET g_data_group = g_tqo_hd.tqogrup   
    CALL i228_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i228_show()
 
    LET g_tqo_hd_t.* = g_tqo_hd.*                     #保存單頭舊值
    LET g_tqo_hd_o.* = g_tqo_hd.*        
    DISPLAY BY NAME g_tqo_hd.tqo01                    #顯示單頭值
                    ,g_tqo_hd.tqouser,g_tqo_hd.tqogrup,g_tqo_hd.tqomodu,g_tqo_hd.tqodate,g_tqo_hd.tqoacti   #No.TQC-850030                   #顯示單頭值
 
    CALL i228_tqo01('q', g_tqo_hd.tqo01)
 
    CALL i228_b_fill(g_wc) #單身
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i228_x() 
#DEFINE l_occ1004    LIKE occ_file.occ1004  #No.TQC-640084
                                                                                                                                    
   IF s_shut(0) THEN                                                                                                                
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF g_tqo_hd.tqo01 IS NULL THEN                                                                                                      
      CALL cl_err("",-400,0)                                                                                                        
      RETURN                                                                                                                        
   END IF                                                                                                                           
 
#No.TQC-640084  --start--
#   SELECT occ1004 INTO l_occ1004
#     FROM occ_file
#    WHERE occ01 = g_tqo_hd.tqo01
#   IF l_occ1004 <> '1' THEN
#      CALL cl_err(g_tqo_hd.tqo01,'atm-046',1)
#      RETURN
#   END IF 
#No.TQC-640084  --end--
                                                                                                                                    
   BEGIN WORK                                                                                                                       
                                                                                                                                    
   OPEN i228_cl USING g_tqo_hd.tqo01                                                                                                
   IF STATUS THEN                                                                                                                   
      CALL cl_err("OPEN i228_cl:", STATUS, 1)                                                                                       
      CLOSE i228_cl                                                                                                                 
      ROLLBACK WORK                                                                                                                 
      RETURN                                                                                                                        
   END IF       
 
   FETCH i228_cl INTO g_tqo_hd.*            # 鎖住將被更改或取消的資料                                                              
   IF SQLCA.sqlcode THEN                                                                                                            
      CALL cl_err(g_tqo_hd.tqo01,SQLCA.sqlcode,0)          #資料被他人LOCK                                                             
      ROLLBACK WORK                                                                                                                 
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   LET g_success = 'Y'                                                                                                              
                                                                                                                                    
   CALL i228_show()                                                                                                                 
                                                                                                                                    
   IF cl_exp(0,0,g_tqo_hd.tqoacti) THEN                   #確認一下                                                                    
      LET g_chr=g_tqo_hd.tqoacti                                                                                                       
      IF g_tqo_hd.tqoacti='Y' THEN                                                                                                     
         LET g_tqo_hd.tqoacti='N'                                                                                                      
      ELSE                                                                                                                          
         LET g_tqo_hd.tqoacti='Y'                                                                                                      
      END IF                                                                                                                        
                                                                                                                                    
      UPDATE tqo_file SET tqoacti=g_tqo_hd.tqoacti,                                                                                    
                          tqomodu=g_user,                                                                                           
                          tqodate=g_today
       WHERE tqo01=g_tqo_hd.tqo01                                                                                                      
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                   
#        CALL cl_err(g_tqo_hd.tqo01,SQLCA.sqlcode,0)  #No.FUN-660104 MARK
         CALL cl_err3("upd","tqo_file",g_tqo_hd.tqo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104   
         LET g_tqo_hd.tqoacti=g_chr                                                                                                    
      END IF                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   CLOSE i228_cl                                                                                                                    
                                                                                                                                    
   IF g_success = 'Y' THEN                                                                                                          
      COMMIT WORK                                                                                                                   
      CALL cl_flow_notify(g_tqo_hd.tqo01,'V')                                                                                          
   ELSE                                                                                                                             
      ROLLBACK WORK                                                                                                                 
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION 
 
FUNCTION i228_r()
DEFINE
    l_chr LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
#DEFINE l_occ1004    LIKE occ_file.occ1004  #No.TQC-640084
 
    IF s_shut(0) THEN RETURN END IF         
 
    IF g_tqo_hd.tqo01 IS NULL THEN 
        CALL cl_err('', -400, 0)
        RETURN
    END IF
 
    SELECT tqo01,tqoacti,tqouser,tqogrup,tqomodu,tqodate
      INTO g_tqo_hd.tqo01,g_tqo_hd.tqoacti,g_tqo_hd.tqouser,g_tqo_hd.tqogrup,g_tqo_hd.tqomodu,g_tqo_hd.tqodate
      FROM tqo_file                                                                                              
     WHERE tqo01=g_tqo_hd.tqo01                                                                                                      
    IF g_tqo_hd.tqoacti ='N' THEN    #檢查資料是否為無效                                                                                
       CALL cl_err(g_tqo_hd.tqo01,'mfg1000',0)                                                                                          
       RETURN                                                                                                                        
    END IF                
                                
#No.TQC-640084  --start--                                                                           
#    SELECT occ1004 INTO l_occ1004
#      FROM occ_file
#     WHERE occ01 = g_tqo_hd.tqo01
#    IF l_occ1004 <> '1' THEN
#       CALL cl_err(g_tqo_hd.tqo01,'atm-046',1)
#       RETURN
#    END IF 
#No.TQC-640084  --end--
 
    BEGIN WORK
 
    OPEN i228_cl USING g_tqo_hd.tqo01                                                                                                
    IF STATUS THEN                                                                                                                   
       CALL cl_err("OPEN i228_cl:", STATUS, 1)                                                                                       
       CLOSE i228_cl                                                                                                                 
       ROLLBACK WORK                                                                                                                 
       RETURN                                                                                                                        
    END IF
 
    FETCH i228_cl INTO g_tqo_hd.*            # 鎖住將被更改或取消的資料                                                              
    IF SQLCA.sqlcode THEN                                                                                                            
       CALL cl_err(g_tqo_hd.tqo01,SQLCA.sqlcode,0)      #資料被他人LOCK                                                             
       ROLLBACK WORK                                                                                                                 
       RETURN                                                                                                                        
    END IF         
 
    CALL i228_show()
 
    IF cl_delh(0,0) THEN                         #詢問是否取消資料
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tqo01"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tqo_hd.tqo01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                      #No.FUN-9B0098 10/02/24
        DELETE FROM tqo_file 
         WHERE tqo01 = g_tqo_hd.tqo01
        IF STATUS THEN
#          CALL cl_err(g_tqo_hd.tqo01,SQLCA.sqlcode,0)  #No.FUN-660104 MARK
           CALL cl_err3("del","tqo_file",g_tqo_hd.tqo01,"",STATUS,"","",1)  #No.FUN-660104
        ELSE 
            CLEAR FORM
       
            DROP TABLE x
#           EXECUTE i228_pre_x                  #No.TQC-720019
            PREPARE i228_pre_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i228_pre_x2                 #No.TQC-720019
 
            CALL g_tqo.clear()
 
            LET g_sql = "SELECT UNIQUE tqo01 ",
                        "  FROM tqo_file ",
                        " INTO TEMP y "
            DROP TABLE y
            PREPARE i228_pre_y FROM g_sql
            EXECUTE i228_pre_y
            LET g_sql = "SELECT COUNT(*) FROM y"
            PREPARE i228_precnt2 FROM g_sql
            DECLARE i228_cnt2 CURSOR FOR i228_precnt2
            OPEN i228_cnt2
            #FUN-B50064-add-start--
            IF STATUS THEN
               CLOSE i228_cs
               CLOSE i228_cnt2
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            FETCH i228_cnt2 INTO g_row_count
            #FUN-B50064-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i228_cs
               CLOSE i228_cnt2
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50064-add-end-- 
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i228_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i228_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE   #No.FUN-6A0072
               CALL i228_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK 
END FUNCTION
 
#處理單身欄位(tqo02)輸入
FUNCTION i228_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680120 SMALLINT
DEFINE l_occ1004    LIKE occ_file.occ1004
 
    LET g_action_choice = ""
    IF g_tqo_hd.tqo01 IS NULL THEN RETURN END IF
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_tqo_hd.tqo01 IS NULL THEN                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
                                                                                        
    SELECT UNIQUE tqo01,tqoacti,tqouser,tqogrup,tqomodu,tqodate
      INTO g_tqo_hd.tqo01,g_tqo_hd.tqoacti,g_tqo_hd.tqouser,g_tqo_hd.tqogrup,g_tqo_hd.tqomodu,g_tqo_hd.tqodate
      FROM tqo_file                                                                                              
     WHERE tqo01=g_tqo_hd.tqo01                                                                                                      
                                                                                                                                    
    IF g_tqo_hd.tqoacti ='N' THEN    #檢查資料是否為無效                                                                               
       CALL cl_err(g_tqo_hd.tqo01,'mfg1000',0)                                                                                         
       RETURN                                                                                                                       
    END IF   
    SELECT occ1004 INTO l_occ1004
      FROM occ_file
     WHERE occ01 = g_tqo_hd.tqo01
#   IF l_occ1004 <> '1' THEN  #No.TQC-640084
#      CALL cl_err(g_tqo_hd.tqo01,'atm-046',1)  #No.TQC-640084
#   IF l_occ1004 <> '3' THEN  #No.FUN-690025
    IF l_occ1004 <> '1' THEN  #No.TQC-640084    #No.FUN-690025
       CALL cl_err(g_tqo_hd.tqo01,'9029',1)     #No.TQC-640084
       RETURN  
    END IF 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
#       "SELECT tqo02,'','','' ",        #No.FUN-620024
        "SELECT tqo03,tqo02,'','','',tqo04 ",  #No.FUN-620024  #No.FUN-7C0010
        "  FROM tqo_file ",  
#       " WHERE tqo01 = ? AND tqo02 = ? FOR UPDATE"  #No.FUN-620024
        " WHERE tqo01 = ? AND tqo03 = ? FOR UPDATE"  #No.FUN-620024
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i228_bcl CURSOR FROM g_forupd_sql                  # LOCK CURSOR
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tqo WITHOUT DEFAULTS FROM s_tqo.*
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
                LET g_tqo_t.* = g_tqo[l_ac].*    #BACKUP
 
#       	OPEN i228_bcl USING g_tqo_hd.tqo01,g_tqo_t.tqo02  #No.FUN-620024
                OPEN i228_bcl USING g_tqo_hd.tqo01,g_tqo_t.tqo03  #No.FUN-620024
                IF STATUS THEN
                   CALL cl_err("OPEN i228_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i228_bcl INTO g_tqo[l_ac].* 
                   IF SQLCA.sqlcode THEN
#                      CALL cl_err(g_tqo_t.tqo02,SQLCA.sqlcode,1) #No.FUN-620024
                       CALL cl_err(g_tqo_t.tqo03,SQLCA.sqlcode,1) #No.FUN-620024
                       LET l_lock_sw = "Y"
                   ELSE                 
#FUN-990069---begin                                                                                                                 
                   IF NOT s_dc_ud_flag('4',g_tqo[l_ac].tqo04,g_plant,'u') THEN                                                             
                      CALL cl_err(g_tqo[l_ac].tqo04,'aoo-045',0)                                                                           
                      CALL cl_set_comp_entry("tqo03,tqo04",FALSE)                                                                          
                   END IF                                                                                                                  
#FUN-990069---end                                                                                             
                      CALL i228_tqo02('d')                                                                                          
                      IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        LET g_tqo[l_ac].tqo02 = g_tqo_t.tqo02
                        DISPLAY BY NAME g_tqo[l_ac].tqo02
                        NEXT FIELD tqo02
                      END IF
                   END IF
                END IF
                CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT 
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tqo[l_ac].* TO NULL
            LET g_tqo_t.* = g_tqo[l_ac].*        #新輸入資料
            LET g_tqo[l_ac].tqo04 = g_plant      #No.FUN-7C0010
#FUN-990069---begin                                                                                                                 
            IF NOT s_dc_ud_flag('4',g_tqo[l_ac].tqo04,g_plant,'a') THEN                                                                           
                CALL cl_err(g_tqo[l_ac].tqo04,'aoo-078',1)                                                                                         
                CANCEL INSERT
            END IF                                                                                                                           
#FUN-990069---end  
            CALL cl_show_fld_cont()
#           NEXT FIELD tqo02   #No.FUN-620024 
            NEXT FIELD tqo03   #No.FUN-620024 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tqo_file(tqo01,tqoacti,tqouser,tqogrup,tqomodu,tqodate,
#                                tqo02,tqooriu,tqoorig)        #No.FUN-620024
                                 tqo04,        #No.FUN-7C0010
                                 tqo03,tqo02   #No.FUN-620024
                                  #FUN-840068 --start--
                                 ,tqoud01,tqoud02,tqoud03,
                                  tqoud04,tqoud05,tqoud06,
                                  tqoud07,tqoud08,tqoud09,
                                  tqoud10,tqoud11,tqoud12,
                                  tqoud13,tqoud14,tqoud15)
                                  #FUN-840068 --end--
                 VALUES(g_tqo_hd.tqo01,g_tqo_hd.tqoacti,g_tqo_hd.tqouser,g_tqo_hd.tqogrup,'',g_today,
#                       g_tqo[l_ac].tqo02, g_user, g_grup)     #No.FUN-620024      #No.FUN-980030 10/01/04  insert columns oriu, orig
                        g_tqo[l_ac].tqo04,     #No.FUN-7C0010
                        g_tqo[l_ac].tqo03,g_tqo[l_ac].tqo02    #No.FUN-620024
                       #FUN-840068 --start--
                       ,g_tqo[l_ac].tqoud01,
                        g_tqo[l_ac].tqoud02,
                        g_tqo[l_ac].tqoud03,
                        g_tqo[l_ac].tqoud04,
                        g_tqo[l_ac].tqoud05,
                        g_tqo[l_ac].tqoud06,
                        g_tqo[l_ac].tqoud07,
                        g_tqo[l_ac].tqoud08,
                        g_tqo[l_ac].tqoud09,
                        g_tqo[l_ac].tqoud10,
                        g_tqo[l_ac].tqoud11,
                        g_tqo[l_ac].tqoud12,
                        g_tqo[l_ac].tqoud13,
                        g_tqo[l_ac].tqoud14,
                        g_tqo[l_ac].tqoud15)
                       #FUN-840068 --end--
 
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_tqo[l_ac].tqo02,SQLCA.sqlcode,0) #No.FUN-620024
#               CALL cl_err(g_tqo[l_ac].tqo03,SQLCA.sqlcode,0) #No.FUN-620024 #No.FUN-660104 MARK
                CALL cl_err3("ins","tqo_file",g_tqo[l_ac].tqo02,g_tqo[l_ac].tqo03,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
 
                COMMIT WORK   
                SELECT COUNT(*) INTO g_rec_b FROM tqo_file
                       WHERE tqo01 = g_tqo_hd.tqo01
 
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
        AFTER FIELD tqo02
            IF NOT cl_null(g_tqo[l_ac].tqo02) THEN
               IF (g_tqo[l_ac].tqo02 != g_tqo_t.tqo02 OR                                                                                 
                   g_tqo_t.tqo02 IS NULL) THEN 
                  SELECT COUNT(*) INTO l_n   #Key 值是否重覆
                    FROM tqo_file
                   WHERE tqo01 = g_tqo_hd.tqo01 AND
                         tqo02 = g_tqo[l_ac].tqo02
                  IF l_n > 0 THEN
#                    INITIALIZE g_tqo[l_ac] TO NULL    #No.FUN-620024
                     DISPLAY '','','' TO FORMONLY.tqm02,FORMONLY.tqm03,FORMONLY.tqa02
                     DISPLAY g_tqo[l_ac].tqo02
                          TO tqo02
                     CALL cl_err( g_tqo[l_ac].tqo02, -239, 0)
                     NEXT FIELD tqo02
                  ELSE
                     CALL i228_tqo02('d')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
             #           LET g_tqo[l_ac].tqo02 = g_tqo_t.tqo02
             #           DISPLAY BY NAME g_tqo[l_ac].tqo02
                        NEXT FIELD tqo02
                     END IF
                  END IF
               END IF
            END IF
 
        #No.FUN-620024  --start--
        BEFORE FIELD tqo03               
            IF g_tqo[l_ac].tqo03 IS NULL OR g_tqo[l_ac].tqo03 = 0 THEN          
                SELECT max(tqo03)+1                                             
                  INTO g_tqo[l_ac].tqo03                                       
                  FROM tqo_file                                                
                 WHERE tqo01 = g_tqo_hd.tqo01                                 
                IF g_tqo[l_ac].tqo03 IS NULL THEN                               
                    LET g_tqo[l_ac].tqo03 = 1                                   
                END IF                                                          
            END IF
 
        AFTER FIELD tqo03     
            IF NOT g_tqo[l_ac].tqo03 IS NULL THEN                               
               IF g_tqo[l_ac].tqo03 != g_tqo_t.tqo03 OR                         
                  g_tqo_t.tqo03 IS NULL THEN                                    
                   SELECT count(*) INTO l_n FROM tqo_file                       
                       WHERE tqo01 = g_tqo_hd.tqo01 AND                            
                             tqo03 = g_tqo[l_ac].tqo03                          
                   IF l_n > 0 THEN                                              
                       CALL cl_err('',-239,0)                                   
                       LET g_tqo[l_ac].tqo03 = g_tqo_t.tqo03                    
                       NEXT FIELD tqo03                                         
                   END IF                                                       
               END IF                                                           
            END IF 
        #No.FUN-620024  --end--
 
        #No.FUN-840068 --start--
        AFTER FIELD tqoud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqoud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
 
        BEFORE DELETE                            #是否取消單身
#           IF NOT cl_null(g_tqo_t.tqo02) THEN   #No.FUN-620024
            IF g_tqo_t.tqo03 > 0 AND             #No.FUN-620024                               
               g_tqo_t.tqo03 IS NOT NULL THEN    #No.FUN-620024
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
#FUN-990069---begin                                                                                                                 
               IF NOT s_dc_ud_flag('4',g_tqo_t.tqo04,g_plant,'r') THEN                                                             
                  CALL cl_err(g_tqo[l_ac].tqo04,'aoo-044',0)                                                                           
                  CANCEL DELETE 
               END IF                                                                                                                  
#FUN-990069---end                
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM tqo_file             #刪除該筆單身資料
                WHERE tqo01 = g_tqo_hd.tqo01
#                 AND tqo02 = g_tqo_t.tqo02     #No.FUN-620024
                  AND tqo03 = g_tqo_t.tqo03     #No.FUN-620024
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_tqo_t.tqo02,SQLCA.sqlcode,0)  #No.FUN-620024
#                  CALL cl_err(g_tqo_t.tqo03,SQLCA.sqlcode,0)  #No.FUN-620024 #No.FUN-660104 MARK
                   CALL cl_err3("del","tqo_file",g_tqo_t.tqo02,g_tqo_t.tqo03,SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
               LET g_tqo[l_ac].* = g_tqo_t.*
               CLOSE i228_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
#              CALL cl_err(g_tqo[l_ac].tqo02,-263,1)  #No.FUN-620024
               CALL cl_err(g_tqo[l_ac].tqo03,-263,1)  #No.FUN-620024
               LET g_tqo[l_ac].* = g_tqo_t.*
            ELSE
               UPDATE tqo_file
                  SET tqo03 = g_tqo[l_ac].tqo03,      #No.FUN-620024
                      tqo04 = g_tqo[l_ac].tqo04,      #No.FUN-7C0010
                      tqo02 = g_tqo[l_ac].tqo02       #No.FUN-620024
                      #FUN-840068 --start--
                     ,tqoud01 = g_tqo[l_ac].tqoud01,
                      tqoud02 = g_tqo[l_ac].tqoud02,
                      tqoud03 = g_tqo[l_ac].tqoud03,
                      tqoud04 = g_tqo[l_ac].tqoud04,
                      tqoud05 = g_tqo[l_ac].tqoud05,
                      tqoud06 = g_tqo[l_ac].tqoud06,
                      tqoud07 = g_tqo[l_ac].tqoud07,
                      tqoud08 = g_tqo[l_ac].tqoud08,
                      tqoud09 = g_tqo[l_ac].tqoud09,
                      tqoud10 = g_tqo[l_ac].tqoud10,
                      tqoud11 = g_tqo[l_ac].tqoud11,
                      tqoud12 = g_tqo[l_ac].tqoud12,
                      tqoud13 = g_tqo[l_ac].tqoud13,
                      tqoud14 = g_tqo[l_ac].tqoud14,
                      tqoud15 = g_tqo[l_ac].tqoud15
                      #FUN-840068 --end-- 
#                 SET tqo02 = g_tqo[l_ac].tqo02       #No.FUN-620024
                WHERE tqo01 = g_tqo_hd.tqo01
#                 AND tqo02 = g_tqo_t.tqo02           #No.FUN-620024
                 #AND tqo02 = g_tqo_t.tqo03           #No.FUN-620024   #TQC-680115 mark
                  AND tqo03 = g_tqo_t.tqo03           #No.FUN-620024   #TQC-680115 
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_tqo[l_ac].tqo02, SQLCA.sqlcode, 0)  #No.FUN-620024
#                 CALL cl_err(g_tqo[l_ac].tqo03, SQLCA.sqlcode, 0)  #No.FUN-620024 #No.FUN-660104 MARK
                  CALL cl_err3("upd","tqo_file",g_tqo_t.tqo02,g_tqo_t.tqo03,SQLCA.sqlcode,"","",1)  #No.FUN-660104
                  LET g_tqo[l_ac].* = g_tqo_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK 
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30033 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tqo[l_ac].* = g_tqo_t.*
               #FUN-D30033--add--begin--
               ELSE
                  CALL g_tqo.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end----
               END IF
               CLOSE i228_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30033 add
            CLOSE i228_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP                                                                                                           
           CASE                                                                                                                      
              WHEN INFIELD(tqo02)                                                                                 
                 CALL cl_init_qry_var()                                                                                              
                 LET g_qryparam.form = "q_tqm"                                                                                       
                 LET g_qryparam.default1 = g_tqo[l_ac].tqo02                                                                         
                 CALL cl_create_qry() RETURNING g_tqo[l_ac].tqo02                                                                    
                 DISPLAY g_tqo[l_ac].tqo02 TO tqo02                                                                                  
                 NEXT FIELD tqo02                                                                                                    
              OTHERWISE EXIT CASE                                                                                                    
           END CASE 
 
        ON ACTION CONTROLN
            CALL i228_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
#           IF INFIELD(tqo02) AND l_ac > 1 THEN  #No.FUN-620024
            IF INFIELD(tqo03) AND l_ac > 1 THEN  #No.FUN-620024
                LET g_tqo[l_ac].* = g_tqo[l_ac-1].*
#               NEXT FIELD tqo02                 #No.FUN-620024
                NEXT FIELD tqo03                 #No.FUN-620024
            END IF
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END          
        END INPUT
 
#    LET g_tqo_hd.tqomodu = g_user                                                  
#    LET g_tqo_hd.tqodate = g_today                                                 
#    UPDATE tqo_file SET tqomodu = g_tqo_hd.tqomodu,tqodate = g_tqo_hd.tqodate         
#     WHERE tqo01 = g_tqo_hd.tqo01                                                  
#    DISPLAY BY NAME g_tqo_hd.tqomodu,g_tqo_hd.tqodate 
 
    CLOSE i228_bcl
    COMMIT WORK 
END FUNCTION
 
#單身重查
FUNCTION i228_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
#   CONSTRUCT l_wc2 ON tqo02                 #No.FUN-620024
#        FROM s_tqo[1].tqo02                 #No.FUN-620024
    CONSTRUCT l_wc2 ON tqo03,tqo02           #No.FUN-620024
         FROM s_tqo[1].tqo03,s_tqo[1].tqo02  #No.FUN-620024  #No.FUN-7C0010
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
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
    CALL i228_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i228_b_fill(p_wc2)                      #BODY FILL UP
DEFINE 
    p_wc2    LIKE type_file.chr1000,      #No.FUN-680120 VARCHAR(200)
    l_cnt    LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    LET g_sql =
#       "SELECT tqo02, tqm02, tqm03, tqa02",        #No.FUN-620024
#       "SELECT tqo03,tqo02, tqm02, tqm03, tqa02",  #No.FUN-620024  #No.TQC-640084
#       "SELECT tqo03,tqo02, tqm02, tqm03",         #No.TQC-640084  #No.FUN-7C0010
        "SELECT tqo03,tqo02, tqm02, tqm03, tqo04 ", #No.TQC-640084  #No.FUN-7C0010
        #No.FUN-840068 --start--
        "      ,tqoud01,tqoud02,tqoud03,tqoud04,tqoud05,",
        "       tqoud06,tqoud07,tqoud08,tqoud09,tqoud10,",
        "       tqoud11,tqoud12,tqoud13,tqoud14,tqoud15 ", 
        #No.FUN-840068 ---end---
#       "  FROM tqo_file, OUTER tqm_file, OUTER tqa_file",  #No.TQC-640084
        "  FROM tqo_file, OUTER tqm_file",          #No.TQC-640084
        " WHERE tqo01 ='", g_tqo_hd.tqo01, "' ",
        "   AND tqo_file.tqo02 = tqm_file.tqm01 ",
#       "   AND tqm03 = tqa_file.tqa01 ",   #No.TQC-640084
#       "   AND tqa_file.tqa03 = '19'",     #No.TQC-640084
	"   AND ", p_wc2 CLIPPED,
#       " ORDER BY tqo02"  #No.FUN-620024
        " ORDER BY tqo03"  #No.FUN-620024
    PREPARE i228_pb 
       FROM g_sql
    DECLARE i228_bcs                             #SCROLL CURSOR
     CURSOR FOR i228_pb
 
    CALL g_tqo.clear()
    LET g_rec_b=0
    LET g_cnt = 1
#   FOREACH i228_bcs INTO g_tqo[g_cnt].*         #單身 ARRAY 填充  #No.TQC-640084
    FOREACH i228_bcs INTO g_tqo[g_cnt].tqo03,g_tqo[g_cnt].tqo02,   #No.TQC-640084
                          g_tqo[g_cnt].tqm02,g_tqo[g_cnt].tqm03,   #No.TQC-640084
                          g_tqo[g_cnt].tqo04                       #No.FUN-7C0010
                          #FUN-840068 --start--
                         ,g_tqo[g_cnt].tqoud01,
                          g_tqo[g_cnt].tqoud02,
                          g_tqo[g_cnt].tqoud03,
                          g_tqo[g_cnt].tqoud04,
                          g_tqo[g_cnt].tqoud05,
                          g_tqo[g_cnt].tqoud06,
                          g_tqo[g_cnt].tqoud07,
                          g_tqo[g_cnt].tqoud08,
                          g_tqo[g_cnt].tqoud09,
                          g_tqo[g_cnt].tqoud10,
                          g_tqo[g_cnt].tqoud11,
                          g_tqo[g_cnt].tqoud12,
                          g_tqo[g_cnt].tqoud13,
                          g_tqo[g_cnt].tqoud14,
                          g_tqo[g_cnt].tqoud15
                          #FUN-840068 --end--
 
 
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        #TQC-630107---add---
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
        #TQC-630107---end---
    END FOREACH
    #No.TQC-640084  --start--
    FOR l_cnt = 1 TO g_cnt-1
        SELECT tqa02 INTO g_tqo[l_cnt].tqa02
          FROM tqa_file
         WHERE tqa01 = g_tqo[l_cnt].tqm03
           AND tqa03 = '19'
    END FOR
    #No.TQC-640084  --end-- 
    CALL g_tqo.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
#單身顯示
FUNCTION i228_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tqo TO s_tqo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
#NO.FUN-6B0031--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION invalid                                                                                                             
         LET g_action_choice="invalid"                                                                                              
         EXIT DISPLAY
      ON ACTION first 
         CALL i228_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                  
           EXIT DISPLAY              
 
      ON ACTION previous
         CALL i228_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
           EXIT DISPLAY                
 
      ON ACTION jump 
         CALL i228_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY               
           EXIT DISPLAY              
 
      ON ACTION next
         CALL i228_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY               
           EXIT DISPLAY              
 
      ON ACTION last 
         CALL i228_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY               
           EXIT DISPLAY              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      #No.FUN-7C0010  --Begin
      ON ACTION carry
         LET g_action_choice = "carry"
         EXIT DISPLAY
 
      ON ACTION download
         LET g_action_choice = "download"
         EXIT DISPLAY
 
      ON ACTION qry_carry_history
         LET g_action_choice = "qry_carry_history"
         EXIT DISPLAY
      #No.FUN-7C0010  --End  
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()    
 
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
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i228_tqo01(p_cmd,l_tqo01)      
    DEFINE l_occ02   LIKE occ_file.occ02,
           l_tqo01   LIKE tqo_file.tqo01,
           l_occ1004 LIKE occ_file.occ1004,
           l_occacti LIKE type_file.chr1,            #No.FUN-680120 VARCHAR(1)
           p_cmd     LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT occ02,occacti,occ1004 INTO l_occ02,l_occacti,l_occ1004
      FROM occ_file
     WHERE occ01 = l_tqo01
    
    IF p_cmd = 'd' THEN
       CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2732'
                                     LET l_occ02 = NULL
            WHEN l_occacti = 'N'     LET g_errno = '9028' 
                                     LET l_occ02 = NULL  
         #FUN-690023------mod-------
         #  WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'
            WHEN l_occacti ='H'             LET g_errno = '9038'
                                            LET l_occ02 = NULL
         #FUN-690023------mod-------
#           WHEN l_occ1004 <> '1'    LET g_errno = 'atm-239'
#           WHEN l_occ1004 <> '3'    LET g_errno = '9029' #No.FUN-690025
           #WHEN l_occ1004 <> '1'    LET g_errno = '9029' #No.FUN-690025   #No.TQC-740162 mark
           #                         LET l_occ02 = NULL                    #No.TQC-740162 mark
            WHEN l_occ1004 = '3'     LET g_errno = 'atm-079' 
                                     LET l_occ02 = NULL                    
#           WHEN l_occ1004 IS NULL   LET g_errno = 'atm-239'  #No.FUN-690025
           #WHEN l_occ1004 IS NULL   LET g_errno = '9029'     #No.FUN-690025  #No.TQC-740162 mark
           #                         LET l_occ02 = NULL                       #No.TQC-740162 mark
            OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
    IF cl_null(g_errno) OR p_cmd='d' OR p_cmd='q' THEN
        DISPLAY l_occ02 TO FORMONLY.occ02
    END IF
END FUNCTION
 
FUNCTION i228_tqo02(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
  DEFINE l_tqmacti LIKE tqm_file.tqmacti,
         l_n1      LIKE type_file.num5,  #TQC-740316
         l_tqo02   LIKE tqo_file.tqo02,  #TQC-740316 
         l_tqm04   LIKE tqm_file.tqm04
 
  LET g_errno = " "
 
#No.TQC-650028  --start--
# SELECT tqm02,tqm03,tqa02,tqmacti,tqm04 
#    INTO g_tqo[l_ac].tqm02,g_tqo[l_ac].tqm03,g_tqo[l_ac].tqa02,l_tqmacti,l_tqm04                                                                   
#    FROM tqm_file,tqa_file                                                                                                       
#   WHERE tqm01 = g_tqo[l_ac].tqo02
#     AND tqa01 = tqm03
#     AND tqa03 = '19'
  SELECT tqm02,tqm03,tqmacti,tqm04 
     INTO g_tqo[l_ac].tqm02,g_tqo[l_ac].tqm03,l_tqmacti,l_tqm04                                                                   
     FROM tqm_file
    WHERE tqm01 = g_tqo[l_ac].tqo02
#TQC-740316.....begin                                                           
#No.TQC-7B0118 --begin
#    LET g_sql1 = "SELECT tqo02 FROM tqo_file",                                  
#                 " WHERE tqo01 = '",g_tqo_hd.tqo01,"'"                          
#    PREPARE i228_prepare3 FROM g_sql1                                           
#    DECLARE i228_bcs1 CURSOR FOR i228_prepare3                                  
#    FOREACH i228_bcs1 INTO l_tqo02                                              
#      SELECT COUNT(*) INTO l_n1 FROM tqn_file A,tqn_file B                        
#       WHERE A.tqn01 = l_tqo02 AND B.tqn01 = g_tqo[l_ac].tqo02                    
#         AND A.tqn03 = B.tqn03                                                    
#         AND A.tqn01 != B.tqn01
#    END FOREACH                                                                   
#No.TQC-7B0118 --end
#TQC-740316
#No.TQC-650028  --end--
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3013'
                                 LET g_tqo[l_ac].tqm02 = NULL
                                 LET g_tqo[l_ac].tqm03 = NULL
                                 LET g_tqo[l_ac].tqa02 = NULL
       WHEN l_tqmacti = 'N'      LET g_errno = '9028'
                                 LET g_tqo[l_ac].tqm02 = NULL
                                 LET g_tqo[l_ac].tqm03 = NULL
                                 LET g_tqo[l_ac].tqa02 = NULL
#      WHEN l_tqm04 <> '2'       LET g_errno = '9029'
       WHEN l_tqm04 <> '1'       LET g_errno = '9029'   #No.TQC-7B0118
                                 LET g_tqo[l_ac].tqm02 = NULL
                                 LET g_tqo[l_ac].tqm03 = NULL
                                 LET g_tqo[l_ac].tqa02 = NULL
       WHEN l_tqm04 IS NULL      LET g_errno = '9029'
                                 LET g_tqo[l_ac].tqm02 = NULL
                                 LET g_tqo[l_ac].tqm03 = NULL
                                 LET g_tqo[l_ac].tqa02 = NULL
#TQC-740316.....begin                                                           
#      WHEN l_n1 > 0             LET g_errno = 'atm-564'        #No.TQC-7B0118                
#TQC-740316.....end
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd='d' THEN
      #No.TQC-650028  --start--
      SELECT tqa02 INTO g_tqo[l_ac].tqa02
        FROM tqa_file
       WHERE tqa01 = g_tqo[l_ac].tqm03
         AND tqa03 = '19'
      #No.TQC-650028  --end--
      DISPLAY g_tqo[l_ac].tqm02,g_tqo[l_ac].tqm03,g_tqo[l_ac].tqa02
           TO FORMONLY.tqm02,FORMONLY.tqm03,FORMONLY.tqa02
  END IF
 
END FUNCTION
 
#No.FUN-7C0010  --Begin
FUNCTION i228_carry()
   DEFINE l_i       LIKE type_file.num10
   DEFINE l_j       LIKE type_file.num10
 
   IF cl_null(g_tqo_hd.tqo01) THEN   #No.FUN-830090
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #No.FUN-830090  --Begin
   #input data center
   LET g_gev04 = NULL
 
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file 
    WHERE gev01 = '4' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
   IF cl_null(g_gev04) THEN RETURN END IF
   #No.FUN-830090  --End  
 
   #開窗選擇拋轉的db清單
   CALL s_dc_sel_db(g_gev04,'4')
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   CALL g_tqox.clear()
   FOR l_i = 1 TO g_tqo.getLength()
       LET g_tqox[l_i].sel   = 'Y'
       LET g_tqox[l_i].tqo01 = g_tqo_hd.tqo01
       LET g_tqox[l_i].tqo02 = g_tqo[l_i].tqo02
   END FOR
 
   CALL s_showmsg_init()
   CALL s_axmi221_price_carry_1(g_tqo_hd.tqo01,g_tqox,g_azp,g_gev04,'0')  #No.FUN-830090
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION i228_download()
  DEFINE l_path       LIKE ze_file.ze03
 
    IF cl_null(g_tqo_hd.tqo01) THEN   #No.FUN-830090
       CALL cl_err('',-400,0)
       RETURN
    END IF
    CALL s_dc_download_path() RETURNING l_path
    IF cl_null(l_path) THEN RETURN END IF
 
    CALL i228_download_files(l_path)
 
END FUNCTION
 
FUNCTION i228_download_files(p_path)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_tempdir         LIKE type_file.chr50
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5
 
   LET l_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(l_tempdir)
   IF l_n>0 THEN
      IF l_tempdir[l_n,l_n]='/' THEN
         LET l_tempdir[l_n,l_n]=' '
      END IF
   END IF
   LET l_n=LENGTH(p_path)
   IF l_n>0 THEN
      IF p_path[l_n,l_n]='/' THEN
         LET p_path[l_n,l_n]=' '
      END IF
   END IF
 
   LET l_upload_file = l_tempdir CLIPPED,'/atmi228_tqo_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/atmi228_tqo_file_4.txt"
 
   LET g_sql = "SELECT * FROM tqo_file WHERE ",g_wc
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
 
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
END FUNCTION
 
#No.FUN-7C0010  --End
