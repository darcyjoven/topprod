# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asrt340.4gl
# Descriptions...: 期末盤點量與發料量差異調整作業
# Date & Author..: 06/02/17 By kim
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-670103 06/08/01 By kim GP3.5 利潤中心
# Modify.........: No.TQC-680030 06/08/11 By pengu 不按查詢,直接按單身,依然可以修改單身
# Modify.........: No.FUN-680130 06/09/15 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0166 06/11/10 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0194 06/12/28 By day 單身insert個數不符
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.MOD-8B0086 08/11/10 By chenyu 工單沒有取替代時，讓sfs27=sfa27
# Modify.........: No.TQC-940105 09/05/08 By mike DISPLAY BY NAME g_sro03欄位在畫面中不存在/復制sro03開窗選資料畫面不顯示  
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/17 By sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0007 10/11/02 By houlia 倉庫權限使用控管修改
# Modify.........: No.TQC-AC0293 10/12/30 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 新增EasyFlow整合功能影響INSERT INTO sfp_flie
# Modify.........: No:MOD-B70205 11/07/22 By Vampire (1) AFTER FIELD gem01 應為 NEXT FIELD gem01，DISPLAY gem02c
#                                                    (2) FUNCTION t340_h()在CLOSE WINDOW t340b_w()前面要多一句LET INT_FLAG=0 
# Modify.........: No.FUN-B70074 11/07/25 By lixh1 新增行業別TABLE
# Modify.........: No.MOD-BB0251 11/11/22 By yinhy s_check_no傳參錯誤
# Modify.........: No:FUN-BB0086 12/01/05 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-BB0084 12/01/05 By lixh1 增加數量欄位小數取位
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70014 12/08/28 By suncx 新增sfs014
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_sro01         LIKE sro_file.sro01,   #盤點日期
    g_sro01_t       LIKE sro_file.sro01,   #盤點日期(舊值)
    g_sro03         LIKE sro_file.sro03,   #倉
    g_sro03_t       LIKE sro_file.sro03,   
    g_sro04         LIKE sro_file.sro04,   #儲
    g_sro04_t       LIKE sro_file.sro04,   #儲
    g_sro05         LIKE sro_file.sro05,   #批
    g_sro05_t       LIKE sro_file.sro05,   #批
    g_sro09         LIKE sro_file.sro09,   
    g_sro10         LIKE sro_file.sro10,
    g_sro11         LIKE sro_file.sro11,
    g_sro           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sro02       LIKE sro_file.sro02,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        sro06       LIKE sro_file.sro06,
        sro07       LIKE sro_file.sro07,
        sro08       LIKE sro_file.sro08,
        sro12       LIKE sro_file.sro12,
        sro13       LIKE sro_file.sro13
                    END RECORD,
    g_sro_t         RECORD                 #程式變數 (舊值)
        sro02       LIKE sro_file.sro02,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        sro06       LIKE sro_file.sro06,
        sro07       LIKE sro_file.sro07,
        sro08       LIKE sro_file.sro08,
        sro12       LIKE sro_file.sro12,
        sro13       LIKE sro_file.sro13
                    END RECORD,
    g_wc,g_sql,g_wc2    STRING,  #No.FUN-580092 HCN
    g_show          LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,   #單身筆數 #No.FUN-680130 SMALLINT               
    g_flag          LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1) 
    g_ss            LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1) 
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT #No.FUN-680130 SMALLINT               
    g_argv1         LIKE sro_file.sro01,
    g_void          LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1) 
    g_t1            LIKE oay_file.oayslip, #No.FUN-680130 VARCHAR(5) 
    tm              RECORD
                    slip1 LIKE sfp_file.sfp01,
                    slip2 LIKE sfp_file.sfp01,
                    date1 LIKE sfp_file.sfp03,#No.FUN-680130 DATE
                    gem01 LIKE gem_file.gem01 #FUN-670103
                    END RECORD,
    tm1             RECORD
                    date1 LIKE type_file.dat,   #No.FUN-680130 DATE
                    wc STRING
                    END RECORD,                 
    b_sro           RECORD LIKE sro_file.*,
    b_sfs           RECORD LIKE sfs_file.*
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE b_sfsi       RECORD LIKE sfsi_file.*    #FUN-B70074
 
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt        LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE   g_msg        LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE   g_curs_index LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE   g_costcenter LIKE gem_file.gem10 #FUN-670103
DEFINE   g_sro06_t    LIKE sro_file.sro06    #No.FUN-BB0086

 
MAIN
#DEFINE                                      #No.FUN-6B0014
#       l_time    LIKE type_file.chr8        #No.FUN-6B0014
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
   LET g_argv1 =ARG_VAL(1)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW t340_w AT p_row,p_col
     WITH FORM "asr/42f/asrt340"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL t340_q()
   END IF
   CALL t340_menu()
 
   CLOSE WINDOW t340_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
         RETURNING g_time    #No.FUN-6B0014
 
END MAIN
 
#QBE 查詢資料
FUNCTION t340_cs()
DEFINE l_sql STRING
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " sro01 = '",g_argv1,"'"
    ELSE
       CLEAR FORM                         #清除畫面
       CALL g_sro.clear()
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sro01 TO NULL    #No.FUN-750051
   INITIALIZE g_sro03 TO NULL    #No.FUN-750051
   INITIALIZE g_sro04 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc ON sro01,sro03,sro04,sro05,sro09,sro10,sro11,
                         sro02,sro06,sro07,sro08,sro12,sro13
          FROM sro01,sro03,sro04,sro05,sro09,sro10,sro11,s_sro[1].sro02,
               s_sro[1].sro06,s_sro[1].sro07,s_sro[1].sro08,s_sro[1].sro12,
               s_sro[1].sro13
               
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(sro03)
#FUN-AB0007  --modify
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_imd1"
#               LET g_qryparam.state ="c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
#FUN-AB0007  --end
                DISPLAY g_qryparam.multiret TO sro03
                NEXT FIELD sro03
            WHEN INFIELD(sro02)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form  ="q_ima"
#              LET g_qryparam.state ="c"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO sro02
               NEXT FIELD sro02
            WHEN INFIELD(sro06)
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_gef"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sro06
               NEXT FIELD sro06
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT DISTINCT sro01,sro03,sro04,sro05,sro09,sro10,sro11 FROM sro_file ",
               " WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY sro01"
    PREPARE t340_prepare FROM g_sql      #預備一下
    DECLARE t340_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t340_prepare
 
    DROP TABLE t340_cnttmp
    LET l_sql=l_sql," INTO TEMP t340_cnttmp"
    
    PREPARE t340_cnttmp_pre FROM l_sql
    EXECUTE t340_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM t340_cnttmp"
    
    PREPARE t340_precount FROM g_sql
    DECLARE t340_count CURSOR FOR t340_precount
 
    IF NOT cl_null(g_argv1) THEN
       LET g_sro01=g_argv1
    END IF
 
    CALL t340_show()
END FUNCTION
 
FUNCTION t340_menu()
 
   WHILE TRUE
      CALL t340_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_argv1) THEN
                  CALL t340_a()
               END IF
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t340_q()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t340_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t340_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
               CALL t340_y()
               IF g_sro11 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_sro11,"","","",g_void,"")
            END IF
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN
               CALL t340_z()
               IF g_sro11 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_sro11,"","","",g_void,"")
            END IF
         WHEN "gen_wb"
            IF cl_chk_act_auth() THEN
               CALL t340_g()
            END IF
         WHEN "data_query"
            IF cl_chk_act_auth() THEN
               CALL t340_h()
            END IF
         WHEN "gen_data"
            IF cl_chk_act_auth() THEN
               CALL t340_j()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t340_x()                #CHI-D20010
               CALL t340_x(1)                #CHI-D20010
               IF g_sro11 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_sro11,"","","",g_void,"")
            END IF
         #CHI-D20010---add--str
         WHEN "undo_void"            #取消作廢
            IF cl_chk_act_auth() THEN
               CALL t340_x(2)                
               IF g_sro11 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_sro11,"","","",g_void,"")
            END IF
         #CHI-D20010---add--end
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_sro),'','')
             END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t340_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_sro.clear()
   LET g_sro01_t  = NULL
   LET g_sro03_t  = NULL
   LET g_sro04_t  = NULL
   LET g_sro05_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t340_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_sro01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b=0                   #No.FUN-680064
      IF g_ss='N' THEN
         CALL g_sro.clear()
      ELSE
         CALL t340_b_fill('1=1')            #單身
      END IF
 
      CALL t340_b()                      #輸入單身
 
      LET g_sro01_t = g_sro01
      LET g_sro03_t = g_sro03
      LET g_sro04_t = g_sro04
      LET g_sro05_t = g_sro05
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t340_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-680130 VARCHAR(1)                 
    l_cnt           LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    LET g_ss='Y'
 
   #LET g_sro01=MDY(MONTH(g_today)+1,1,YEAR(g_today)) -1
    LET g_sro01=t340_GETLASTDAY(MDY(MONTH(g_today),1,YEAR(g_today)))
    LET g_sro11='N'
    DISPLAY g_sro11 TO sro11
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT g_sro01,g_sro03,g_sro04,g_sro05 WITHOUT DEFAULTS
        FROM sro01,sro03,sro04,sro05
 
       AFTER FIELD sro01
          IF g_sro01_t IS NULL OR (g_sro01<>g_sro01_t) THEN
             LET g_sro09=YEAR(g_sro01)
             LET g_sro10=MONTH(g_sro01)
             DISPLAY g_sro09 TO sro09
             DISPLAY g_sro10 TO sro10
          END IF
 
       AFTER FIELD sro03
          IF NOT cl_null(g_sro03) THEN
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM imd_file WHERE imd01=g_sro03
                                                        AND imdacti='Y'
             IF l_cnt=0 OR SQLCA.sqlcode THEN
                CALL cl_err('',100,1)
                LET g_sro03=g_sro03_t
                NEXT FIELD sro03
             END IF   
#FUN-AB0007  --modify
             IF NOT s_chk_ware(g_sro03) THEN
                NEXT FIELD sro03
             END IF
#FUN-AB0007  --end                              
          END IF
 
       AFTER INPUT
          IF cl_null(g_sro04) THEN 
             LET g_sro04=' '
             DISPLAY BY NAME g_sro04
          END IF
          IF cl_null(g_sro05) THEN 
             LET g_sro05=' ' 
             DISPLAY BY NAME g_sro05
          END IF
       
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(sro03)
#FUN-AB0007  --modify            
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_imd1"
#               CALL cl_create_qry() RETURNING g_sro03
                CALL q_imd_1(FALSE,TRUE,"","","","","") RETURNING g_sro03
#FUN-AB0007  --end
               #DISPLAY BY NAME g_sro03   #TQC-940105  
                DISPLAY g_sro03 TO sro03  #TQC-940105    
                NEXT FIELD sro03
          END CASE
 
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      #MOD-860081------add-----str---
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       
       ON ACTION about         
          CALL cl_about()      
       
       ON ACTION controlg      
          CALL cl_cmdask()     
       
       ON ACTION help          
          CALL cl_show_help()  
      #MOD-860081------add-----end---
 
    END INPUT
 
END FUNCTION
 
FUNCTION t340_q()
   LET g_sro01 = ''
   LET g_sro03 = ''
   LET g_sro04 = ''
   LET g_sro05 = ''
   LET g_sro09 = ''
   LET g_sro10 = ''
   LET g_sro11 = ''
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_sro01,g_sro03,g_sro04,g_sro05,g_sro09,g_sro10 TO NULL  #No.FUN-6A0166
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_sro.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL t340_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_sro01,g_sro03,g_sro04,g_sro05,g_sro09,g_sro10 TO NULL
      RETURN
   END IF
 
   OPEN t340_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_sro01,g_sro03,g_sro04,g_sro05,g_sro09,g_sro10 TO NULL
   ELSE
      OPEN t340_count
      FETCH t340_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t340_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t340_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式    #No.FUN-680130 VARCHAR(1)              
   l_abso          LIKE type_file.num10   #絕對的筆數  #No.FUN-680130 INTEGER
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     t340_bcs INTO g_sro01,g_sro03,g_sro04,
                                             g_sro05,g_sro09,g_sro10,g_sro11
       WHEN 'P' FETCH PREVIOUS t340_bcs INTO g_sro01,g_sro03,g_sro04,
                                             g_sro05,g_sro09,g_sro10,g_sro11
       WHEN 'F' FETCH FIRST    t340_bcs INTO g_sro01,g_sro03,g_sro04,
                                             g_sro05,g_sro09,g_sro10,g_sro11
       WHEN 'L' FETCH LAST     t340_bcs INTO g_sro01,g_sro03,g_sro04,
                                             g_sro05,g_sro09,g_sro10,g_sro11
       WHEN '/'
          CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
          PROMPT g_msg CLIPPED,': ' FOR l_abso
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
#                CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
          END PROMPT
          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          FETCH ABSOLUTE l_abso t340_bcs INTO g_sro01,g_sro03,g_sro04,
                                              g_sro05,g_sro09,g_sro10,g_sro11
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_sro01,SQLCA.sqlcode,0)
      INITIALIZE g_sro01 TO NULL  #TQC-6B0105
      INITIALIZE g_sro03 TO NULL  #TQC-6B0105
      INITIALIZE g_sro04 TO NULL  #TQC-6B0105
      INITIALIZE g_sro05 TO NULL  #TQC-6B0105
      INITIALIZE g_sro09 TO NULL  #TQC-6B0105
      INITIALIZE g_sro10 TO NULL  #TQC-6B0105
      INITIALIZE g_sro11 TO NULL  #TQC-6B0105
   ELSE
      CALL t340_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t340_show()
 
   DISPLAY g_sro01 TO sro01
   DISPLAY g_sro03 TO sro03
   DISPLAY g_sro04 TO sro04
   DISPLAY g_sro05 TO sro05
   DISPLAY g_sro09 TO sro09
   DISPLAY g_sro10 TO sro10
   DISPLAY g_sro11 TO sro11
 
   CASE g_sro11
        WHEN 'Y'   LET g_void = ''
        WHEN 'N'   LET g_void = ''
        WHEN 'X'   LET g_void = 'Y'
   END CASE
   #圖形顯示
   CALL cl_set_field_pic(g_sro11,"","","",g_void,"")
 
   CALL t340_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t340_b()
DEFINE
   l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT  #No.FUN-680130 SMALLINT
   l_n             LIKE type_file.num5,        #檢查重複用         #No.FUN-680130 SMALLINT
   l_lock_sw       LIKE type_file.chr1,        #單身鎖住否         #No.FUN-680130 VARCHAR(1) 
   p_cmd           LIKE type_file.chr1,        #處理狀態           #No.FUN-680130 VARCHAR(1) 
   l_allow_insert  LIKE type_file.num5,        #可新增否           #No.FUN-680130 SMALLINT
   l_allow_delete  LIKE type_file.num5,        #可刪除否           #No.FUN-680130 SMALLINT
   l_cnt           LIKE type_file.num10                            #No.FUN-680130 INTEGER
 
   LET g_action_choice = ""
 
  #---------No.TQC-680030 add
   IF (g_sro01 IS NULL) OR (g_sro03 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  #---------No.TQC-680030 end
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   SELECT sro01,sro03,sro04,sro05,sro09,sro10,sro11 INTO 
          g_sro01,g_sro03,g_sro04,g_sro05,g_sro09,g_sro10,g_sro11 FROM sro_file
      WHERE sro01=g_sro01
        AND sro03=g_sro03
        AND sro04=g_sro04
        AND sro05=g_sro05
 
   IF g_sro11 = 'Y' THEN CALL cl_err('','mfg0175',1) RETURN END IF
   IF g_sro11 = 'X'   THEN CALL cl_err('','9024',1) RETURN END IF
 
   LET g_forupd_sql = "SELECT sro02,'','',sro06,sro07,sro08,sro12,sro13 FROM sro_file",
                      "  WHERE sro01 = ? AND sro02= ? AND sro03 = ?",
                      "   AND sro04 = ? AND sro05 = ? FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t340_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_sro.clear() END IF
 
   INPUT ARRAY g_sro WITHOUT DEFAULTS FROM s_sro.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_sro06_t = NULL   #No.FUN-BB0086
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_sro_t.* = g_sro[l_ac].*  #BACKUP
            LET g_sro06_t = g_sro[l_ac].sro06   #No.FUN-BB0086
            BEGIN WORK
            OPEN t340_bcl USING g_sro01,g_sro[l_ac].sro02,g_sro03,g_sro04,g_sro05
            IF STATUS THEN
               CALL cl_err("OPEN t340_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t340_bcl INTO g_sro[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN t340_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL t340_set_sro02(g_sro[l_ac].sro02) RETURNING g_sro[l_ac].ima02,
                                                                   g_sro[l_ac].ima021
                  LET g_sro_t.*=g_sro[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_sro[l_ac].* TO NULL            #900423
         LET g_sro_t.* = g_sro[l_ac].*               #新輸入資料
         LET g_sro[l_ac].sro07=0
         LET g_sro[l_ac].sro08=0
         LET g_sro[l_ac].sro12=0
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD sro02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP2
            INITIALIZE g_sro[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_sro[l_ac].* TO s_sro.*
            CALL g_sro.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
            #CANCEL INSERT
         END IF
         INSERT INTO sro_file(sro01,sro02,sro03,sro04,sro05,sro06,sro07,sro08,sro09,sro10,
                              sro11,sro12,sro13,sro14,sro15,sro16,sro17,sro18,sro19,sro20)
              VALUES(g_sro01,g_sro[l_ac].sro02,g_sro03,g_sro04,g_sro05,
                     g_sro[l_ac].sro06,g_sro[l_ac].sro07,g_sro[l_ac].sro08,
                     g_sro09,g_sro10,g_sro11,g_sro[l_ac].sro12,g_sro[l_ac].sro13,
                     0,0,0,0,0,0,0)   #No.TQC-6C0194
#                    0,0,0,0,0,0)     #No.TQC-6C0194
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_sro[l_ac].sro02,SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("ins","sro_file",g_sro01,g_sro[l_ac].sro02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD sro02                         # check data 是否重複
         IF NOT cl_null(g_sro[l_ac].sro02) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_sro[l_ac].sro02,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_sro[l_ac].sro02= g_sro_t.sro02
               NEXT FIELD sro02
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            IF g_sro[l_ac].sro02 != g_sro_t.sro02 OR g_sro_t.sro02 IS NULL THEN
               SELECT ima25 INTO g_sro[l_ac].sro06 FROM ima_file 
                     WHERE ima01=g_sro[l_ac].sro02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('',100,1)   #No.FUN-660138
                  CALL cl_err3("sel","ima_file",g_sro[l_ac].sro02,"",100,"","",1)  #No.FUN-660138
                  LET g_sro[l_ac].sro06=null
                  DISPLAY BY NAME g_sro[l_ac].sro06
                  NEXT FIELD sro06
               END IF
               DISPLAY BY NAME g_sro[l_ac].sro06
               SELECT COUNT(*) INTO l_n FROM sro_file
                  WHERE sro01 = g_sro01
                    AND sro02 = g_sro[l_ac].sro02
                    AND sro03 = g_sro03
                    AND sro04 = g_sro04
                    AND sro05 = g_sro05
               IF (l_n > 0) OR (SQLCA.sqlcode) THEN
                  CALL cl_err(g_sro[l_ac].sro02,-239,0)
                  LET g_sro[l_ac].sro02 = g_sro_t.sro02
                  LET g_sro[l_ac].ima02 = g_sro_t.ima02
                  LET g_sro[l_ac].ima021= g_sro_t.ima021
                  LET g_sro[l_ac].sro06 = g_sro_t.sro06
                  DISPLAY BY NAME g_sro[l_ac].sro02,
                                  g_sro[l_ac].ima02,
                                  g_sro[l_ac].ima021,
                                  g_sro[l_ac].sro06
                  NEXT FIELD sro02
               END IF
               CALL t340_set_sro02(g_sro[l_ac].sro02) RETURNING g_sro[l_ac].ima02,
                                                                g_sro[l_ac].ima021
               DISPLAY BY NAME g_sro[l_ac].sro02,
                               g_sro[l_ac].ima02,
                               g_sro[l_ac].ima021
            END IF
         ELSE
            LET g_sro[l_ac].sro06 = null
            LET g_sro[l_ac].ima02 = null
            LET g_sro[l_ac].ima021= null
            DISPLAY BY NAME g_sro[l_ac].ima02,g_sro[l_ac].ima021
         END IF
 
      AFTER FIELD sro06
         IF NOT cl_null(g_sro[l_ac].sro06) THEN
            IF g_sro_t.sro06 IS NULL OR (g_sro_t.sro06 != g_sro[l_ac].sro06) THEN
               SELECT COUNT(*) INTO l_cnt FROM gfe_file WHERE
                   gfe01=g_sro[l_ac].sro06
               IF l_cnt=0 OR SQLCA.sqlcode THEN
                  CALL cl_err('',100,1)
                  NEXT FIELD sro06
               END IF    
            END IF
            #No.FUN-BB0086--add--begin--
            LET g_sro[l_ac].sro12 = s_digqty(g_sro[l_ac].sro12,g_sro[l_ac].sro06)
            DISPLAY BY NAME g_sro[l_ac].sro12
            IF NOT t340_sro08_check() THEN 
               LET g_sro06_t = g_sro[l_ac].sro06
               NEXT FIELD sro08 
            END IF
            LET g_sro06_t = g_sro[l_ac].sro06
            #No.FUN-BB0086--add--end--
         END IF
 
      AFTER FIELD sro08
         IF NOT t340_sro08_check() THEN NEXT FIELD sro08 END IF   #No.FUN-BB0086
         #No.FUN-BB0086--mark--begin--
         #IF NOT cl_null(g_sro[l_ac].sro08) THEN
         #   IF g_sro[l_ac].sro08<0 THEN
         #      NEXT FIELD sro08
         #   END IF
         #   LET g_sro[l_ac].sro12=g_sro[l_ac].sro08-g_sro[l_ac].sro07
         #   DISPLAY BY NAME g_sro[l_ac].sro12
         #END IF
         #No.FUN-BB0086--mark--end--

      #No.FUN-BB0086--add--begin--
      AFTER FIELD sro12
         LET g_sro[l_ac].sro12 = s_digqty(g_sro[l_ac].sro12,g_sro[l_ac].sro06)
         DISPLAY BY NAME g_sro[l_ac].sro12
      #No.FUN-BB0086--add--end--
 
      BEFORE DELETE                            #是否取消單身
         IF g_sro_t.sro02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM sro_file WHERE sro01 = g_sro01
                                   AND sro02 = g_sro_t.sro02
                                   AND sro03 = g_sro03
                                   AND sro04 = g_sro04
                                   AND sro05 = g_sro05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_sro_t.sro02,SQLCA.sqlcode,0)   #No.FUN-660138
               CALL cl_err3("del","sro_file",g_sro01,g_sro_t.sro02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_sro[l_ac].* = g_sro_t.*
            CLOSE t340_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_sro[l_ac].sro02,-263,1)
            LET g_sro[l_ac].* = g_sro_t.*
         ELSE
            UPDATE sro_file SET sro02 = g_sro[l_ac].sro02,
                                sro06 = g_sro[l_ac].sro06,
                                sro07 = g_sro[l_ac].sro07,
                                sro08 = g_sro[l_ac].sro08,
                                sro12 = g_sro[l_ac].sro12
                                 WHERE sro01 = g_sro01
                                   AND sro02 = g_sro_t.sro02
                                   AND sro03 = g_sro03
                                   AND sro04 = g_sro04
                                   AND sro05 = g_sro05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_sro[l_ac].sro02,SQLCA.sqlcode,0)   #No.FUN-660138
               CALL cl_err3("upd","sro_file",g_sro01,g_sro_t.sro02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
               LET g_sro[l_ac].* = g_sro_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac           #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_sro[l_ac].* = g_sro_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_sro.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE t340_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D40030 add
         CLOSE t340_bcl
         COMMIT WORK
         #CKP2
          CALL g_sro.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sro02)
#FUN-AA0059---------mod------------str-----------------
#              CALL cl_init_qry_var()
#              LET g_qryparam.form  ="q_ima"
#              CALL cl_create_qry() RETURNING g_sro[l_ac].sro02
               CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                  RETURNING g_sro[l_ac].sro02  
#FUN-AA0059---------mod------------end-----------------
               DISPLAY BY NAME g_sro[l_ac].sro02
               NEXT FIELD sro02
            WHEN INFIELD(sro06)
               CALL cl_init_qry_var()
               LET g_qryparam.form  ="q_gef"
               CALL cl_create_qry() RETURNING g_sro[l_ac].sro06
               DISPLAY BY NAME g_sro[l_ac].sro06
               NEXT FIELD sro06
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(sro02) AND l_ac > 1 THEN
            LET g_sro[l_ac].* = g_sro[l_ac-1].*
            LET g_sro[l_ac].sro02=null
            NEXT FIELD sro02
         END IF
 
      ON ACTION CONTROLZ
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
   END INPUT
 
   CLOSE t340_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t340_b_fill(p_wc)                     #BODY FILL UP
DEFINE
   p_wc            LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(200)
 
   LET g_sql = "SELECT sro02,'','',sro06,sro07,sro08,sro12,sro13",
               " FROM sro_file ",
               " WHERE sro01 = '",g_sro01,"'",
               "   AND sro03 = '",g_sro03,"'",
               "   AND sro04 = '",g_sro04,"'",
               "   AND sro05 = '",g_sro05,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY sro02"
   PREPARE t340_prepare2 FROM g_sql       #預備一下
   DECLARE sro_cs CURSOR FOR t340_prepare2
 
   CALL g_sro.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH sro_cs INTO g_sro[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL t340_set_sro02(g_sro[g_cnt].sro02) RETURNING 
                                          g_sro[g_cnt].ima02,g_sro[g_cnt].ima021
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_sro.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t340_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sro TO s_sro.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL t340_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t340_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t340_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t340_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t340_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0018
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #@ON ACTION 資料擷取
      ON ACTION gen_data
         LET g_action_choice="gen_data"
         EXIT DISPLAY
 
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      #@ON ACTION 產生領退料單
      ON ACTION gen_wb
         LET g_action_choice="gen_wb"
         EXIT DISPLAY
 
      #@ON ACTION 分攤資料查詢
      ON ACTION data_query
         LET g_action_choice="data_query"
         EXIT DISPLAY
 
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #CHI-D20010---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---add--end

#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t340_copy()
DEFINE
   l_n                LIKE type_file.num5,   #No.FUN-680130 SMALLINT 
   l_cnt              LIKE type_file.num10,  #No.FUN-680130 INTEGER 
   l_newno1,l_oldno1  LIKE sro_file.sro01,
   l_newno2,l_oldno2  LIKE sro_file.sro03,
   l_newno3,l_oldno3  LIKE sro_file.sro04,
   l_newno4,l_oldno4  LIKE sro_file.sro05
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_sro01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   DISPLAY " " TO sro01
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT l_newno1,l_newno2,l_newno3,l_newno4 FROM sro01,sro03,sro04,sro05
 
       AFTER FIELD sro01
          DISPLAY YEAR(g_sro01) TO sro09
          DISPLAY MONTH(g_sro01) TO sro10
 
       AFTER FIELD sro03
          IF NOT cl_null(l_newno2) THEN
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM imd_file WHERE imd01=l_newno2
                                                        AND imdacti='Y'
             IF l_cnt=0 OR SQLCA.sqlcode THEN
                CALL cl_err('',100,1)
                NEXT FIELD sro03
             END IF                                           
          END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         
         IF cl_null(l_newno3) THEN
            LET l_newno3=' '
            DISPLAY l_newno3 TO sro04
         END IF
         
         IF cl_null(l_newno4) THEN
            LET l_newno4=' '
            DISPLAY l_newno4 TO sro05
         END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(sro03)
#FUN-AB0007  --modify
#               CALL cl_init_qry_var()
#               LET g_qryparam.form  ="q_imd1"
#               CALL cl_create_qry() RETURNING g_sro03
                CALL q_imd_1(FALSE,TRUE,"","","","","") RETURNING g_sro03
#FUN-AB0007  --end
               #DISPLAY BY NAME g_sro03     #TQC-940105 
                LET l_newno2=g_sro03        #TQC-940105   
                DISPLAY l_newno2 TO sro03   #TQC-940105   
                NEXT FIELD sro03
          END CASE
 
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
      LET INT_FLAG = 0
      DISPLAY g_sro01 TO sro01
      DISPLAY g_sro03 TO sro03
      DISPLAY g_sro04 TO sro04
      DISPLAY g_sro05 TO sro05
      DISPLAY g_sro09 TO sro09
      DISPLAY g_sro10 TO sro10
      RETURN
   END IF
 
   DROP TABLE t340_x
 
   SELECT * FROM sro_file             #單身複製
    WHERE sro01 = g_sro01
     INTO TEMP t340_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660138
      CALL cl_err3("sel","sro_file",g_sro01,"",SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660138
      RETURN
   END IF
 
   UPDATE t340_x SET sro01=l_newno1,
                     sro03=l_newno2,
                     sro04=l_newno3,
                     sro05=l_newno4,
                     sro08=0,
                     sro09=YEAR(l_newno1),
                     sro10=MONTH(l_newno1),
                     sro11='N',
                     sro12=0,
                     sro13=null
 
   INSERT INTO sro_file SELECT * FROM t340_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno1 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660138
      CALL cl_err3("ins","sro_file","","",SQLCA.sqlcode,"",g_msg,1)  #No.FUN-660138
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_sro01=l_newno1
      LET g_sro03=l_newno2
      LET g_sro04=l_newno3
      LET g_sro05=l_newno4
      LET g_sro09=YEAR(l_newno1)
      LET g_sro10=MONTH(l_newno1)
      CALL t340_show()
   END IF
 
END FUNCTION
 
FUNCTION t340_set_sro02(p_sro02)
DEFINE p_sro02 LIKE sro_file.sro02,
       l_ima02 LIKE ima_file.ima02,
       l_ima021 LIKE ima_file.ima021
 
   SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01=p_sro02
   IF SQLCA.sqlcode THEN
      LET l_ima02=null
      LET l_ima021=null
   END IF
   RETURN l_ima02,l_ima021
END FUNCTION
 
#FUNCTION t340_x() #作廢&取消作廢                     #CHI-D20010
FUNCTION t340_x(p_type) #作廢&取消作廢                #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF (g_sro01 IS NULL) OR (g_sro03 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_sro11='X' THEN RETURN END IF
   ELSE
      IF g_sro11<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   SELECT sro01,sro03,sro04,sro05,sro09,sro10,sro11 INTO 
          g_sro01,g_sro03,g_sro04,g_sro05,g_sro09,g_sro10,g_sro11 FROM sro_file
    WHERE sro01=g_sro01
      AND sro03=g_sro03
      AND sro04=g_sro04
      AND sro05=g_sro05
 
   IF g_sro11 = 'Y' THEN
      CALL cl_err('sro11=Y','9023',1)
      RETURN
   END IF

   #IF cl_void(0,0,g_sro11) THEN             #CHI-D20010
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
      #IF g_sro11 ='N' THEN                                            #CHI-D20010
      IF p_type = 1 THEN                                               #CHI-D20010
          LET g_sro11='X'
      ELSE
          LET g_sro11='N'
      END IF
      UPDATE sro_file                
         SET sro11=g_sro11
       WHERE sro01=g_sro01
         AND sro03=g_sro03
         AND sro04=g_sro04
         AND sro05=g_sro05
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err('upd sro','9050',1)   #No.FUN-660138
         CALL cl_err3("upd","sro_file",g_sro01,g_sro03,"9050","","upd sro",1)  #No.FUN-660138
         RETURN
      ELSE
         DISPLAY g_sro11 TO sro11
      END IF                                
   END IF    
END FUNCTION
 
FUNCTION t340_y() #確認
   IF s_shut(0) THEN RETURN END IF
   IF (g_sro01 IS NULL) OR (g_sro03 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------------ add ------------ begin
   IF g_sro11 = 'Y' THEN
      CALL cl_err('sro11=Y','9023',1)
      RETURN
   END IF

   IF g_sro11 = 'X' THEN
      CALL cl_err('','9024',1)
      RETURN
   END IF
   IF NOT cl_confirm('aap-222') THEN RETURN END IF
#CHI-C30107 ------------ add ------------ end
   SELECT sro01,sro03,sro04,sro05,sro09,sro10,sro11 INTO 
          g_sro01,g_sro03,g_sro04,g_sro05,g_sro09,g_sro10,g_sro11 FROM sro_file
    WHERE sro01=g_sro01
      AND sro03=g_sro03
      AND sro04=g_sro04
      AND sro05=g_sro05
 
   IF g_sro11 = 'Y' THEN
      CALL cl_err('sro11=Y','9023',1)
      RETURN
   END IF
 
   IF g_sro11 = 'X' THEN
      CALL cl_err('','9024',1)
      RETURN
   END IF
   
#  IF NOT cl_confirm('aap-222') THEN RETURN END IF #CHI-C30107 mark
   
   UPDATE sro_file SET sro11='Y' WHERE sro01=g_sro01
                                   AND sro03=g_sro03
                                   AND sro04=g_sro04
                                   AND sro05=g_sro05
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('upd sro','9050',1)   #No.FUN-660138
      CALL cl_err3("upd","sro_file",g_sro01,g_sro03,"9050","","upd sro",1)  #No.FUN-660138
      RETURN
   ELSE
      LET g_sro11='Y'
      DISPLAY g_sro11 TO sro11
   END IF                                
END FUNCTION
 
FUNCTION t340_z() #取消確認
DEFINE l_cnt LIKE type_file.num10   #No.FUN-680130 INTEGER
   IF s_shut(0) THEN RETURN END IF
   IF (g_sro01 IS NULL) OR (g_sro03 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT sro01,sro03,sro04,sro05,sro09,sro10,sro11 INTO 
          g_sro01,g_sro03,g_sro04,g_sro05,g_sro09,g_sro10,g_sro11 FROM sro_file
    WHERE sro01=g_sro01
      AND sro03=g_sro03
      AND sro04=g_sro04
      AND sro05=g_sro05
 
   IF g_sro11='N' THEN RETURN END IF
 
   IF g_sro11 = 'X' THEN
      CALL cl_err('','9024',1)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM sro_file
                                  WHERE sro01=g_sro01
                                    AND sro03=g_sro03
                                    AND sro04=g_sro04
                                    AND sro05=g_sro05
                                    AND (sro13 IS NOT NULL OR sro13<>' ')
   IF l_cnt>0 THEN
      CALL cl_err('','asr-024',1)
      RETURN
   END IF                                    
   IF NOT cl_confirm('aim-304') THEN RETURN END IF
   UPDATE sro_file SET sro11='N' WHERE sro01=g_sro01
                                   AND sro03=g_sro03
                                   AND sro04=g_sro04
                                   AND sro05=g_sro05   
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('upd sro','9050',1)   #No.FUN-660138
      CALL cl_err3("upd","sro_file",g_sro01,g_sro03,"9050","","upd sro",1)  #No.FUN-660138
      RETURN
   ELSE
      LET g_sro11='N'
      DISPLAY g_sro11 TO sro11
   END IF                                
END FUNCTION
 
FUNCTION t340_g()
DEFINE l_cnt,l_count      LIKE type_file.num10,  #No.FUN-680130 INTEGER 
       li_result          LIKE type_file.num5,   #No.FUN-680130 SMALLINT 
       l_where,l_sql      STRING,
       l_bmb01            LIKE bmb_file.bmb01,
       l_bmb03            LIKE bmb_file.bmb03,
       l_qpa              LIKE bmb_file.bmb06,
       l_diff,l_sub,l_tot LIKE sro_file.sro12,  #差異量 #每個主件的總入庫量 #每個元件的所有主件的總入庫量
       l_sfp RECORD       LIKE sfp_file.*
DEFINE l_t1               LIKE type_file.chr1,      #TQC-AC0293
       l_smy73            LIKE smy_file.smy73       #TQC-AC0293
 
   IF s_shut(0) THEN RETURN END IF
   IF (g_sro01 IS NULL) OR (g_sro03 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   IF g_sro11='N' THEN 
      CALL cl_err('','mfg3550',1)
      RETURN 
   END IF
 
   IF g_sro11 = 'X' THEN
      CALL cl_err('','9024',1)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM sro_file
                                  WHERE sro01=g_sro01
                                    AND sro03=g_sro03
                                    AND sro04=g_sro04
                                    AND sro05=g_sro05
                                    AND (sro13 IS NOT NULL OR sro13<>' ')
   IF l_cnt>0 THEN
      CALL cl_err('','asr-025',1)
      RETURN
   END IF                                    
 
   OPEN WINDOW t340a_w AT 2,2 WITH FORM "asr/42f/asrt340a" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
         
   CALL cl_ui_locale("asrt340a")
 
   LET tm.slip1=null
   LET tm.slip2=null
   LET tm.date1=g_today
   LET tm.gem01=g_grup #FUN-670103
   
   INPUT tm.slip1,tm.slip2,tm.date1,tm.gem01  #FUN-670103
     WITHOUT DEFAULTS FROM slip1,slip2,date1,gem01  #FUN-670103
   
     AFTER FIELD slip1
        IF NOT cl_null(tm.slip1) THEN
           #CALL s_check_no("asf",tm.slip1,tm.slip1,"",   #MOD-BB0251
           CALL s_check_no("asf",tm.slip1,tm.slip1,"3",   #MOD-BB0251
                           "sfp_file","sfp01","")
           RETURNING li_result,tm.slip1
              DISPLAY BY NAME tm.slip1
           IF (NOT li_result) THEN
               CALL cl_err('','afa-095',1)
               NEXT FIELD slip1
            END IF
           #TQC-AC0293 ---------------add start----------
            LET l_t1 = s_get_doc_no(tm.slip1)
            SELECT smy73 INTO l_smy73 FROM smy_file
             WHERE smyslip = l_t1
            IF l_smy73 = 'Y' THEN
               CALL cl_err('','asf-874',0)
               NEXT FIELD slip1
            END IF
           #TQC-AC0293 ---------------add end-------------
        END IF
        
     AFTER FIELD slip2
        IF NOT cl_null(tm.slip2) THEN
           #CALL s_check_no("asf",tm.slip2,tm.slip2,"",  #MOD-BB0251
           CALL s_check_no("asf",tm.slip2,tm.slip2,"3",   #MOD-BB0251
                           "sfp_file","sfp01","")
           RETURNING li_result,tm.slip2
              DISPLAY BY NAME tm.slip2
           IF (NOT li_result) THEN
               CALL cl_err('','afa-095',1)
               NEXT FIELD slip2
           END IF
          #TQC-AC0293 ---------------add start----------
            LET l_t1 = s_get_doc_no(tm.slip2)
            SELECT smy73 INTO l_smy73 FROM smy_file
             WHERE smyslip = l_t1
            IF l_smy73 = 'Y' THEN
               CALL cl_err('','asf-874',0)
               NEXT FIELD slip2
            END IF
           #TQC-AC0293 ---------------add end-------------
        END IF
        
     #FUN-670103...............begin
     AFTER FIELD gem01
        IF NOT s_costcenter_chk(tm.gem01) THEN
          #NEXT FIELD srg930                                #MOD-B70205 mark
           NEXT FIELD gem01                                 #MOD-B70205 add
        ELSE
          #DISPLAY s_costcenter_desc(tm.gem01) TO gem02     #MOD-B70205 mark
           DISPLAY s_costcenter_desc(tm.gem01) TO gem02c    #MOD-B70205 add
        END IF
     #FUN-670103...............end
 
     AFTER INPUT
        IF NOT INT_FLAG THEN
           CALL s_auto_assign_no("asf",tm.slip1,tm.date1,"",
                                 "sfp_file","sfp01","","","")
              RETURNING li_result,tm.slip1
           IF (NOT li_result) THEN
              CALL cl_err('slip1','afa-095',1)
              CONTINUE INPUT
           END IF
           CALL s_auto_assign_no("asf",tm.slip2,tm.date1,"",
                                 "sfp_file","sfp01","","","")
              RETURNING li_result,tm.slip2
           IF (NOT li_result) THEN
              CALL cl_err('slip2','afa-095',1)
              CONTINUE INPUT
           END IF
        END IF
 
     ON ACTION controlp
        CASE 
           WHEN INFIELD(slip1)
              LET g_t1=s_get_doc_no(tm.slip1)
              LET g_sql = " (smy73 <> 'Y' OR smy73 IS NULL )"                   #TQC-AC0293
              CALL smy_qry_set_par_where(g_sql)                                 #TQC-AC0293 
             #CALL q_smy( FALSE, TRUE,g_t1,'asf','3') RETURNING g_t1 #領/發料   #TQC-670008
              CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1 #領/發料   #TQC-670008
              LET tm.slip1 = g_t1
              DISPLAY BY NAME tm.slip1
              NEXT FIELD slip1
           WHEN INFIELD(slip2)           
              LET g_t1=s_get_doc_no(tm.slip2)
              LET g_sql = " (smy73 <> 'Y' OR smy73 IS NULL )"                   #TQC-AC0293
              CALL smy_qry_set_par_where(g_sql)                                 #TQC-AC0293
             #CALL q_smy( FALSE, TRUE,g_t1,'asf','4') RETURNING g_t1 #退料  #TQC-670008
              CALL q_smy( FALSE, TRUE,g_t1,'ASF','4') RETURNING g_t1 #退料  #TQC-670008
              LET tm.slip2 = g_t1
              DISPLAY BY NAME tm.slip2
              NEXT FIELD slip2
           #FUN-670103...............begin
           WHEN INFIELD(gem01)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem4"
              CALL cl_create_qry() RETURNING tm.gem01 #FUN-670103
              DISPLAY BY NAME tm.gem01
              NEXT FIELD gem01
           #FUN-670103...............end 
        END CASE
           
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
      LET INT_FLAG = 0
      CLOSE WINDOW t340a_w
      RETURN
   ELSE
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW t340a_w
         RETURN
      END IF
   END IF
 
   LET g_success='Y'
   BEGIN WORK
   LET l_where=" WHERE ima01=bmb01",
               "   AND bmb29=ima910",
               "   AND bmb03=sro02",
               "   AND sro01='",g_sro01,"'",
               "   AND sro03='",g_sro03,"'",
               "   AND sro04='",g_sro04,"'",
               "   AND sro05='",g_sro05,"'",
               "   AND (bmb04 <=sro01 OR bmb04 IS NULL )",
               "   AND (bmb05 > sro01 OR bmb05 IS NULL )"
   LET l_sql="SELECT COUNT(*) FROM sro_file,bmb_file,ima_file",
             l_where,"   AND sro12 < 0"
   PREPARE t340a_cur1_cnt_pre FROM l_sql  #產生領料單
   DECLARE t340a_cur1_cnt CURSOR FOR t340a_cur1_cnt_pre
   OPEN t340a_cur1_cnt
   FETCH t340a_cur1_cnt INTO l_cnt
   IF SQLCA.sqlcode THEN
      LET l_cnt=0
   END IF
   IF l_cnt>0 THEN
      #產生領料單頭
      INITIALIZE l_sfp.* TO NULL
      LET l_sfp.sfp01=tm.slip1
      LET l_sfp.sfp02=g_today
      LET l_sfp.sfp03=tm.date1
      LET l_sfp.sfp04='N'
      LET l_sfp.sfpconf='N' #FUN-660106
      LET l_sfp.sfp05='N'
      LET l_sfp.sfp06='C'
      #FUN-AB0001--add---str---
      LET l_sfp.sfpmksg = g_smy.smyapr #是否簽核
      LET l_sfp.sfp15 = '0'            #簽核狀況
      LET l_sfp.sfp16 = g_user         #申請人 
      #FUN-AB0001--add---end---
      LET l_sfp.sfpuser=g_user
      LET g_data_plant = g_plant #FUN-980030
      LET l_sfp.sfpgrup=g_grup
      LET l_sfp.sfpmodu=''
      LET l_sfp.sfpdate=g_today
      LET l_sfp.sfp07=tm.gem01 #FUN-670103
 
      LET l_sfp.sfpplant=g_plant #FUN-980008 add
      LET l_sfp.sfplegal=g_legal #FUN-980008 add
 
      LET l_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04
      LET l_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO sfp_file VALUES (l_sfp.*)
      IF SQLCA.sqlcode THEN
#        CALL cl_err('ins sfs',SQLCA.sqlcode,1)   #No.FUN-660138
         CALL cl_err3("ins","sfp_file",l_sfp.sfp01,l_sfp.sfp02,SQLCA.sqlcode,"","ins sfs",1)  #No.FUN-660138
         LET g_success='N'
      END IF
 
      #產生領料單身
      DROP TABLE t340_tmptbl
      LET l_sql="SELECT bmb01,bmb03,(bmb06/bmb07) as QPA,",
                "(sro12*-1) as DIFF,sro12 as SUB,sro12 AS TOT",
                " FROM sro_file,bmb_file,ima_file",l_where,
                " AND sro12<0",
                " INTO TEMP t340_tmptbl"
      PREPARE t340_tmptbl_pre FROM l_sql
      EXECUTE t340_tmptbl_pre
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err('crt tmptbl',SQLCA.sqlcode,1)
         RETURN
      END IF
      
      DECLARE t340_acc_img CURSOR FOR SELECT DISTINCT bmb01,bmb03,QPA FROM t340_tmptbl 
      FOREACH t340_acc_img INTO l_bmb01,l_bmb03,l_qpa
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('t340_acc_img',SQLCA.sqlcode,1)
            RETURN
         END IF
         LET l_sub=t340_g0(l_bmb01,l_qpa,'1')
         UPDATE t340_tmptbl SET SUB=l_sub WHERE bmb01=l_bmb01 
                                            AND bmb03=l_bmb03
      END FOREACH
      
      DECLARE t340_acc_tot CURSOR FOR SELECT DISTINCT bmb03 FROM t340_tmptbl 
      FOREACH t340_acc_tot INTO l_bmb03
         SELECT SUM(SUB) INTO l_tot FROM t340_tmptbl WHERE bmb03=l_bmb03
         UPDATE t340_tmptbl SET TOT=l_tot WHERE bmb03=l_bmb03
      END FOREACH
 
      #如果總庫存-總領用<0 則 不考慮領用,重計總庫存
      #begin
      DECLARE t340_acc_img2 CURSOR FOR 
                          SELECT DISTINCT bmb01,bmb03,QPA FROM t340_tmptbl 
                                                               WHERE TOT<0
      FOREACH t340_acc_img2 INTO l_bmb01,l_bmb03,l_qpa
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('t340_acc_img2',SQLCA.sqlcode,1)   
            RETURN
         END IF
         LET l_sub=t340_g0(l_bmb01,l_qpa,'2')
         UPDATE t340_tmptbl SET SUB=l_sub WHERE bmb01=l_bmb01 
                                            AND bmb03=l_bmb03
      END FOREACH
 
      DECLARE t340_acc_tot2 CURSOR FOR SELECT DISTINCT bmb03 FROM t340_tmptbl
                                                               WHERE TOT<0
      FOREACH t340_acc_tot2 INTO l_bmb03
         SELECT SUM(SUB) INTO l_tot FROM t340_tmptbl WHERE bmb03=l_bmb03
         UPDATE t340_tmptbl SET TOT=l_tot WHERE bmb03=l_bmb03
      END FOREACH
      #end
 
      LET g_costcenter=s_costcenter(tm.gem01) #FUN-670103
      LET l_count=0
      DECLARE t340a_cur1 CURSOR FOR SELECT * FROM sro_file
                                       WHERE sro01=g_sro01
                                         AND sro03=g_sro03
                                         AND sro04=g_sro04
                                         AND sro05=g_sro05
      FOREACH t340a_cur1 INTO b_sro.*
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('',SQLCA.sqlcode,1)   
         END IF
         IF g_success='N' THEN
            EXIT FOREACH
         END IF
         DECLARE t340a_cur2 CURSOR FOR SELECT bmb01,SUB,TOT 
                                            FROM t340_tmptbl
                                           WHERE bmb03=b_sro.sro02
                                              ORDER BY bmb01
         FOREACH t340a_cur2 INTO l_bmb01,l_sub,l_tot
            IF l_sub<=0 THEN
               CONTINUE FOREACH
            END IF
            LET l_count=l_count+1
            CALL t340_g1(tm.slip1,l_count,l_bmb01,l_sub,l_tot)
         END FOREACH
      END FOREACH                                         
 
      #如果沒有新增任何單身資料的話就刪除單頭
      IF l_count=0 THEN
         DELETE FROM sfp_file WHERE sfp01=tm.slip1
      END IF
   END IF 
 
   LET l_sql="SELECT COUNT(*) FROM sro_file,bmb_file,ima_file",
             l_where,"   AND sro12 > 0"
   PREPARE t340a_cur2_cnt_pre FROM l_sql #產生退料單
   DECLARE t340a_cur2_cnt CURSOR FOR t340a_cur2_cnt_pre
   OPEN t340a_cur2_cnt
   FETCH t340a_cur2_cnt INTO l_cnt
   IF SQLCA.sqlcode THEN
      LET l_cnt=0
   END IF
   IF (l_cnt>0) AND (g_success='Y') THEN
      #產生退料單頭
      INITIALIZE l_sfp.* TO NULL
      LET l_sfp.sfp01=tm.slip2
      LET l_sfp.sfp02=g_today
      LET l_sfp.sfp03=tm.date1
      LET l_sfp.sfp04='N'
      LET l_sfp.sfpconf='N' #FUN-660106
      LET l_sfp.sfp05='N'
      LET l_sfp.sfp06='B'
      #FUN-AB0001--add---str---
      LET l_sfp.sfpmksg = g_smy.smyapr #是否簽核
      LET l_sfp.sfp15 = '0'            #簽核狀況
      LET l_sfp.sfp16 = g_user         #申請人 
      #FUN-AB0001--add---end---
      LET l_sfp.sfpuser=g_user
      LET l_sfp.sfpgrup=g_grup
      LET l_sfp.sfpmodu=''
      LET l_sfp.sfpdate=g_today
      LET l_sfp.sfp07=tm.gem01 #FUN-670103
      LET l_sfp.sfpplant=g_plant #FUN-980008 add
      LET l_sfp.sfplegal=g_legal #FUN-980008 add
      INSERT INTO sfp_file VALUES (l_sfp.*)
      IF SQLCA.sqlcode THEN
#        CALL cl_err('ins sfs',SQLCA.sqlcode,1)   #No.FUN-660138
         CALL cl_err3("ins","sfp_file",l_sfp.sfp01,l_sfp.sfp02,SQLCA.sqlcode,"","ins sfs",1)  #No.FUN-660138
         LET g_success='N'
      END IF
      
      #產生退料單身
      DROP TABLE t340_tmptbl
      LET l_sql="SELECT bmb01,bmb03,(bmb06/bmb07) as QPA,",
                "sro12 as DIFF,sro12 as SUB,sro12 AS TOT",
                " FROM sro_file,bmb_file,ima_file",l_where,
                " AND sro12>0",
                " INTO TEMP t340_tmptbl"
      PREPARE t340_tmptbl_pre2 FROM l_sql
      EXECUTE t340_tmptbl_pre2
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err('crt tmptbl',SQLCA.sqlcode,1)
         RETURN
      END IF
      
      DECLARE t340_acc_img3 CURSOR FOR SELECT bmb01,bmb03,QPA FROM t340_tmptbl 
                                      GROUP BY bmb01,bmb03
      FOREACH t340_acc_img3 INTO l_bmb01,l_bmb03,l_qpa
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('t340_acc_img',SQLCA.sqlcode,1)
            RETURN
         END IF
         LET l_sub=t340_g0(l_bmb01,l_qpa,'1')
         UPDATE t340_tmptbl SET SUB=l_sub WHERE bmb01=l_bmb01 
                                            AND bmb03=l_bmb03
      END FOREACH
      
      DECLARE t340_acc_tot3 CURSOR FOR SELECT bmb03 FROM t340_tmptbl 
                                      GROUP BY bmb03
      FOREACH t340_acc_tot3 INTO l_bmb03
         SELECT SUM(SUB) INTO l_tot FROM t340_tmptbl WHERE bmb03=l_bmb03
         UPDATE t340_tmptbl SET TOT=l_tot WHERE bmb03=l_bmb03
      END FOREACH
 
      #如果總庫存-總領用<0 則 不考慮領用,重計總庫存
      #begin
      DECLARE t340_acc_img4 CURSOR FOR 
                          SELECT DISTINCT bmb01,bmb03,QPA FROM t340_tmptbl 
                                                               WHERE TOT<0
      FOREACH t340_acc_img4 INTO l_bmb01,l_bmb03,l_qpa
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('t340_acc_img2',SQLCA.sqlcode,1)   
            RETURN
         END IF
         LET l_sub=t340_g0(l_bmb01,l_qpa,'2')
         UPDATE t340_tmptbl SET SUB=l_sub WHERE bmb01=l_bmb01 
                                            AND bmb03=l_bmb03
      END FOREACH
 
      DECLARE t340_acc_tot4 CURSOR FOR SELECT DISTINCT bmb03 FROM t340_tmptbl
                                                               WHERE TOT<0
      FOREACH t340_acc_tot4 INTO l_bmb03
         SELECT SUM(SUB) INTO l_tot FROM t340_tmptbl WHERE bmb03=l_bmb03
         UPDATE t340_tmptbl SET TOT=l_tot WHERE bmb03=l_bmb03
      END FOREACH
      #end
      
      LET l_count=0
      DECLARE t340a_cur3 CURSOR FOR SELECT * FROM sro_file
                                       WHERE sro01=g_sro01
                                         AND sro03=g_sro03
                                         AND sro04=g_sro04
                                         AND sro05=g_sro05
      FOREACH t340a_cur3 INTO b_sro.*
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('',SQLCA.sqlcode,1)   
         END IF
         IF g_success='N' THEN
            EXIT FOREACH
         END IF
         DECLARE t340a_cur4 CURSOR FOR SELECT bmb01,SUB,TOT 
                                            FROM t340_tmptbl
                                           WHERE bmb03=b_sro.sro02
                                              ORDER BY bmb01
         FOREACH t340a_cur4 INTO l_bmb01,l_sub,l_tot
            IF l_sub<=0 THEN
               CONTINUE FOREACH
            END IF
            LET l_count=l_count+1
            CALL t340_g1(tm.slip2,l_count,l_bmb01,l_sub,l_tot)
         END FOREACH
      END FOREACH                                         
      #如果沒有新增任何單身資料的話就刪除單頭
      IF l_count=0 THEN
         DELETE FROM sfp_file WHERE sfp01=tm.slip2
      END IF
   END IF
        
   IF l_count=0 THEN
      LET g_success='N'
      CALL cl_err('','aco-058',1)
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','asr-026',1)
      CLOSE WINDOW t340a_w
      CALL t340_b_fill('1=1')
   ELSE
      ROLLBACK WORK
      CLOSE WINDOW t340a_w
   END IF
END FUNCTION
 
FUNCTION t340_g0(p_bmb01,p_qpa,p_opt)
DEFINE p_bmb01 LIKE bmb_file.bmb01,
       p_qpa   LIKE bmb_file.bmb06,
       p_opt   LIKE type_file.chr1,   #1:考慮領用量 ; 2:不考慮領用量#No.FUN-680130 VARCHAR(1)   
       t_sfv09,t_sfv09_2 LIKE sfv_file.sfv09,
       t_sfe16_1,t_sfe16_2 LIKE sfe_file.sfe16,
       sdate,edate LIKE type_file.dat,     #No.FUN-680130 DATE
       l_sql STRING
   
   LET sdate=MDY(MONTH(g_sro01),1,YEAR(g_sro01))
   LET edate=t340_GETLASTDAY(g_sro01)
 
{   
#工單的部分先不考慮 #TQC-630064
   #計算t_sfv09_1(領料料號的主件的總入庫量 for 工單入庫)
   LET l_sql="SELECT SUM(sfv09) FROM ",
             " sfv_file,sfu_file ",
             " WHERE sfv04='",p_bmb01,"'",
             "   AND sfu01=sfv01 AND sfu00='1' AND sfupost='Y' ",
             "   AND sfu02>='",sdate,"' AND sfu02<='",edate,"'"
   PREPARE t340a_sfv1_pre FROM l_sql
   DECLARE t340a_sfv1 CURSOR FOR t340a_sfv1_pre
   OPEN t340a_sfv1
   FETCH t340a_sfv1 INTO t_sfv09_1
   IF SQLCA.sqlcode OR cl_null(t_sfv09_1) THEN
      LET t_sfv09_1=0
   END IF
}   
   #計算t_sfv09_2(領料料號的主件的總入庫量 for 重複性生產入庫)
   LET l_sql="SELECT SUM(sfv09) FROM ",
             " sfv_file,sfu_file ",
             " WHERE sfv11='",p_bmb01,"'",
             "   AND sfu01=sfv01 AND sfu00='3' AND sfupost='Y' ",
             "   AND sfu02>='",sdate,"' AND sfu02<='",edate,"'"
   PREPARE t340a_sfv2_pre FROM l_sql
   DECLARE t340a_sfv2 CURSOR FOR t340a_sfv2_pre
   OPEN t340a_sfv2
   FETCH t340a_sfv2 INTO t_sfv09_2
   IF SQLCA.sqlcode OR cl_null(t_sfv09_2) THEN
      LET t_sfv09_2=0
   END IF
   
   LET t_sfe16_1=0
   LET t_sfe16_2=0
   IF p_opt="1" THEN
      #計算領料料號的主件總領用量t_sfe16_1
      LET l_sql="SELECT SUM(sfe16*sfe31) FROM sfp_file,sfe_file ",
                " WHERE sfp01=sfe02 AND sfp06 IN ('A','C')",
                "   AND sfe01='",p_bmb01,"'",
                "   AND sfp04='Y' ",
                "   AND sfp03>='",sdate,"' AND sfp03<='",edate,"'"
      PREPARE t340a_sfv3_pre FROM l_sql
      DECLARE t340a_sfv3 CURSOR FOR t340a_sfv3_pre
      OPEN t340a_sfv3
      FETCH t340a_sfv3 INTO t_sfe16_1
      IF SQLCA.sqlcode OR cl_null(t_sfe16_1) THEN
         LET t_sfe16_1=0
      END IF
 
      #計算領料料號的主件總領用量t_sfe16_2
      LET l_sql="SELECT SUM(sfe16*sfe31) FROM sfp_file,sfe_file ",
                " WHERE sfp01=sfe02 AND sfp06='B'",
                "   AND sfe01='",p_bmb01,"'",
                "   AND sfp04='Y' ",
                "   AND sfp03>='",sdate,"' AND sfp03<='",edate,"'"
      PREPARE t340a_sfv4_pre FROM l_sql
      DECLARE t340a_sfv4 CURSOR FOR t340a_sfv4_pre
      OPEN t340a_sfv4
      FETCH t340a_sfv4 INTO t_sfe16_2
      IF SQLCA.sqlcode OR cl_null(t_sfe16_2) THEN
         LET t_sfe16_2=0
      END IF
   END IF
   LET t_sfv09=p_qpa*t_sfv09_2-(t_sfe16_1-t_sfe16_2)
  #若總庫存為負
   IF (p_opt='2') AND ((t_sfv09<0) OR cl_null(t_sfv09)) THEN 
     LET t_sfv09=0
   END IF
   RETURN t_sfv09
END FUNCTION
 
FUNCTION t340_g1(p_sfp01,p_count,p_bmb01,p_sub,p_tot)
DEFINE p_count LIKE type_file.num10,  #No.FUN-680130 INTEGER 
       p_sfp01 LIKE sfp_file.sfp01,
       l_srp   RECORD LIKE srp_file.*,
       p_bmb01 LIKE bmb_file.bmb01,
       p_bmb03 LIKE bmb_file.bmb03,
       l_sro12 LIKE sro_file.sro12,
       p_sub   LIKE sro_file.sro12, #每個主件的總入庫量
       p_tot   LIKE sro_file.sro12, #每個元件的所有主件的總入庫量
       l_sfp07 LIKE sfp_file.sfp07, #FUN-CB0087 製造部門
       l_sfp16 LIKE sfp_file.sfp16  #FUN-CB0087 申請人
 
   INITIALIZE b_sfs.* TO NULL
   
   LET l_sro12=b_sro.sro12
   IF l_sro12<0 THEN
      LET l_sro12=l_sro12*-1
   END IF
   LET b_sfs.sfs01 = p_sfp01
   LET b_sfs.sfs02 = p_count
   LET b_sfs.sfs03 = p_bmb01      #工單/成品料號
   LET b_sfs.sfs04 = b_sro.sro02  #發料料號
   LET b_sfs.sfs05 = l_sro12*(p_sub/p_tot)  #已領/退料量=差異量*此原料占其成品入庫的比率
   LET b_sfs.sfs06 = b_sro.sro06  #發料單位
   LET b_sfs.sfs05 = s_digqty(b_sfs.sfs05,b_sfs.sfs06)   #FUN-BB0084
   LET b_sfs.sfs07 = b_sro.sro03  #倉庫
   LET b_sfs.sfs08 = b_sro.sro04  #儲位
   LET b_sfs.sfs09 = b_sro.sro05  #批號
   LET b_sfs.sfs10 = ' '          #作業序號
   LET b_sfs.sfs26 = NULL         #替代碼
  #LET b_sfs.sfs27 = NULL         #被替代料號   #No.MOD-8B0086 mark
   LET b_sfs.sfs27 = b_sfs.sfs04  #被替代料號   #No.MOD-8B0086 add
   LET b_sfs.sfs28 = NULL         #替代率
   LET b_sfs.sfs930= g_costcenter  #FUN-670103
   IF g_sma.sma115 = 'Y' THEN
      CALL t340_set_du_by_origin() #多單位設定
   END IF
   LET b_sfs.sfsplant=g_plant #FUN-980008 add
   LET b_sfs.sfslegal=g_legal #FUN-980008 add
   LET b_sfs.sfs012 = '' #FUN-A60027 add
   LET b_sfs.sfs013 = 0 #FUN-A60027 add
   LET b_sfs.sfs014 = ' '  #FUN-C70014 add
   
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      SELECT sfp07,sfp16 INTO l_sfp07,l_sfp16 FROM sfp_file WHERE sfp01 = p_sfp01
      CALL s_reason_code(b_sfs.sfs01,b_sfs.sfs03,'',b_sfs.sfs04,b_sfs.sfs07,l_sfp16,l_sfp07) RETURNING b_sfs.sfs37
      IF cl_null(b_sfs.sfs37) THEN 
         CALL cl_err('','aim-425',1) 
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #FUN-CB0087---add---end--
   INSERT INTO sfs_file VALUES (b_sfs.*)
   IF SQLCA.sqlcode THEN
#     CALL cl_err('ins sfs',SQLCA.sqlcode,1)   #No.FUN-660138
      CALL cl_err3("ins","sfs_file",b_sfs.sfs01,b_sfs.sfs02,SQLCA.sqlcode,"","ins sfs",1)  #No.FUN-660138
      LET g_success='N'
      RETURN
 #FUN-B70074 ---------------Begin--------------------
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE b_sfsi.* TO NULL
         LET b_sfsi.sfsi01 = b_sfs.sfs01
         LET b_sfsi.sfsi02 = b_sfs.sfs02
         IF NOT s_ins_sfsi(b_sfsi.*,b_sfs.sfsplant) THEN
            LET g_success='N'
            RETURN
         END IF
      END IF
 #FUN-B70074 ---------------End----------------------
   END IF
   
   INITIALIZE l_srp.* TO NULL
   LET l_srp.srp01=b_sro.sro01
   LET l_srp.srp02=b_sro.sro02
   LET l_srp.srp03=b_sro.sro03
   LET l_srp.srp04=b_sro.sro04
   LET l_srp.srp05=b_sro.sro05
   LET l_srp.srp06=b_sro.sro06
   LET l_srp.srp07=b_sro.sro07
   LET l_srp.srp08=b_sro.sro08
   LET l_srp.srp09=b_sro.sro09
   LET l_srp.srp10=b_sro.sro10
   LET l_srp.srp11=b_sro.sro11
   LET l_srp.srp12=b_sro.sro12
   LET l_srp.srp13=p_sfp01
   LET l_srp.srp14=b_sfs.sfs02
   LET l_srp.srp15=b_sfs.sfs03
   LET l_srp.srp16=b_sfs.sfs05
   LET l_srp.srp16 = s_digqty(l_srp.srp16,l_srp.srp06)   #No.FUN-BB0086
   INSERT INTO srp_file VALUES (l_srp.*)
   IF SQLCA.sqlcode THEN
#     CALL cl_err('ins srp',SQLCA.sqlcode,1)   #No.FUN-660138
      CALL cl_err3("ins","srp_file",l_srp.srp01,l_srp.srp02,SQLCA.sqlcode,"","ins srp",1)  #No.FUN-660138
      LET g_success='N'
      RETURN
   END IF
   
   UPDATE sro_file SET sro13=p_sfp01
                                WHERE sro01=b_sro.sro01
                                  AND sro02=b_sro.sro02
                                  AND sro03=b_sro.sro03
                                  AND sro04=b_sro.sro04
                                  AND sro05=b_sro.sro05
   IF (SQLCA.sqlcode) OR (SQLCA.sqlerrd[3]=0) THEN
#     CALL cl_err('upd sro',SQLCA.sqlcode,1) #FUN-660138
      CALL cl_err3("upd","sro_file",b_sro.sro01,b_sro.sro02,SQLCA.sqlcode,"","upd sro",1) #FUN-660138
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t340_set_du_by_origin()
  DEFINE l_ima55    LIKE ima_file.ima55,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_factor   LIKE sfs_file.sfs31    #No.FUN-680130 DECIMAL(16,8)
 
      SELECT ima55,ima906,ima907,ima908
        INTO l_ima55,l_ima906,l_ima907,l_ima908
        FROM ima_file WHERE ima01 = b_sfs.sfs04
 
       LET b_sfs.sfs30 = b_sfs.sfs06
       CALL s_umfchk(b_sfs.sfs04,b_sfs.sfs06,l_ima55)
            RETURNING g_errno,l_factor
       LET b_sfs.sfs31 = l_factor
       LET b_sfs.sfs32 = b_sfs.sfs05 / l_factor
       LET b_sfs.sfs32 = s_digqty(b_sfs.sfs32,b_sfs.sfs30)   #FUN-BB0084
 
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET b_sfs.sfs33 = NULL
          LET b_sfs.sfs34 = NULL
          LET b_sfs.sfs35 = NULL
       ELSE
          LET b_sfs.sfs33 = l_ima907
          CALL s_du_umfchk(b_sfs.sfs04,'','','',l_ima55,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET b_sfs.sfs34 = l_factor
          LET b_sfs.sfs35 = 0
       END IF
END FUNCTION
 
FUNCTION t340_j()
   DEFINE l_sql         STRING
   DEFINE l_count,l_cnt LIKE type_file.num10   #No.FUN-680130 INTEGER
   DEFINE l_sro11       LIKE sro_file.sro11
   DEFINE l_srn RECORD  LIKE srn_file.*
   DEFINE l_sro RECORD  LIKE sro_file.*
   
   OPEN WINDOW t340c_w AT 2,2 WITH FORM "asr/42f/asrt340c" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
         
   CALL cl_ui_locale("asrt340c")
   LET tm1.date1=t340_GETLASTDAY(g_today)
   INPUT tm1.date1 WITHOUT DEFAULTS FROM date1
     AFTER INPUT
        IF cl_null(tm1.date1) OR tm1.date1=0 THEN
           CONTINUE INPUT
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
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW t340c_w
      RETURN
   END IF
   
   CONSTRUCT tm1.wc ON srn03 FROM ware
 
      ON ACTION controlp  
         CASE 
            WHEN INFIELD(ware)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_imd1"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ware
               NEXT FIELD ware 
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
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW t340c_w
      RETURN
   END IF
   IF cl_null(tm1.wc) THEN
      LET tm1.wc=" 1=1"
   END IF
   LET g_success='Y'
   BEGIN WORK
   LET l_sql="SELECT * FROM srn_file WHERE ",tm1.wc
   IF (NOT cl_null(tm1.date1)) AND (tm1.date1>0) THEN
      LET l_sql=l_sql," AND srn01='",tm1.date1,"'"      
   END IF
   LET l_sql=l_sql," AND (srn08-srn07)<>0"
   PREPARE t340c_cur_pre FROM l_sql
   DECLARE t340c_cur CURSOR FOR t340c_cur_pre
   LET l_count=0
   FOREACH t340c_cur INTO l_srn.*
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT sro11 INTO l_sro11 FROM sro_file WHERE sro01=l_srn.srn01
                                                AND sro02=l_srn.srn02
                                                AND sro03=l_srn.srn03
                                                AND sro04=l_srn.srn04
                                                AND sro05=l_srn.srn05
      IF SQLCA.sqlcode THEN
         LET l_sro11=''
      END IF
      CASE l_sro11
         WHEN "N"
            DELETE FROM sro_file WHERE sro01=l_srn.srn01
                                   AND sro02=l_srn.srn02
                                   AND sro03=l_srn.srn03
                                   AND sro04=l_srn.srn04
                                   AND sro05=l_srn.srn05
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CONTINUE FOREACH
            END IF                       
         WHEN "Y"
            CONTINUE FOREACH
         OTHERWISE
            EXIT CASE
      END CASE
      IF cl_null(l_srn.srn09) THEN
        LET l_srn.srn09=0
      END IF
      IF cl_null(l_srn.srn10) THEN
        LET l_srn.srn10=0
      END IF
      LET l_sro.sro01=l_srn.srn01
      LET l_sro.sro02=l_srn.srn02
      LET l_sro.sro03=l_srn.srn03
      LET l_sro.sro04=l_srn.srn04
      LET l_sro.sro05=l_srn.srn05
      LET l_sro.sro06=l_srn.srn06
      LET l_sro.sro07=l_srn.srn07
      LET l_sro.sro08=l_srn.srn08
      LET l_sro.sro09=l_srn.srn09
      LET l_sro.sro10=l_srn.srn10
      LET l_sro.sro11='N'
      LET l_sro.sro12=l_sro.sro08-l_sro.sro07
 
      LET l_sro.sro15=l_srn.srn15
      LET l_sro.sro16=l_srn.srn16
      LET l_sro.sro17=l_srn.srn17
      LET l_sro.sro18=l_srn.srn18
      LET l_sro.sro19=l_srn.srn19
      LET l_sro.sro20=l_srn.srn20
      INSERT INTO sro_file VALUES (l_sro.*)
      IF SQLCA.sqlcode THEN
         LET g_success='N'
#        CALL cl_err('ins sro',SQLCA.sqlcode,1)   #No.FUN-660138
         CALL cl_err3("ins","sro_file",l_sro.sro01,l_sro.sro02,SQLCA.sqlcode,"","ins sro",1)  #No.FUN-660138
         EXIT FOREACH
      END IF
      LET l_count=l_count+1
   END FOREACH
   IF g_success='Y' THEN
      COMMIT WORK
      IF l_count>0 THEN
         CALL cl_err(l_count,'asr-026',1)
      ELSE
         CALL cl_err('','mfg9328',1)
      END IF
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE WINDOW t340c_w
END FUNCTION
 
FUNCTION t340_h() #分攤資料查詢
DEFINE l_srp DYNAMIC ARRAY OF RECORD 
        srp02       LIKE srp_file.srp02,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        srp06       LIKE srp_file.srp06,
        srp07       LIKE srp_file.srp07,
        srp08       LIKE srp_file.srp08,
        srp12       LIKE srp_file.srp12,
        srp13       LIKE srp_file.srp13,
        srp14       LIKE srp_file.srp14,
        srp15       LIKE srp_file.srp15,
        srp16       LIKE srp_file.srp16
                    END RECORD
   IF cl_null(g_sro01) OR cl_null(g_sro03) THEN
      RETURN
   END IF    
   OPEN WINDOW t340b_w AT 2,2 WITH FORM "asr/42f/asrt340b" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
         
   CALL cl_ui_locale("asrt340b")
   CALL l_srp.clear()
   LET g_cnt = 1
   DECLARE t340_h_cur CURSOR FOR SELECT srp02,'','',srp06,srp07,
                                 srp08,srp12,srp13,srp14,srp15,
                                 srp16 FROM srp_file 
                                             WHERE srp01=g_sro01
                                               AND srp03=g_sro03
                                               AND srp04=g_sro04
                                               AND srp05=g_sro05
 
   FOREACH t340_h_cur INTO l_srp[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL t340_set_sro02(l_srp[g_cnt].srp02) RETURNING 
                                  l_srp[g_cnt].ima02,
                                  l_srp[g_cnt].ima021
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL l_srp.deleteElement(g_cnt)
   DISPLAY ARRAY l_srp TO s_srp.* ATTRIBUTE(COUNT=g_cnt-1,UNBUFFERED)
#      BEFORE DISPLAY
#         EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY 
   
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
   
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
   
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
   END DISPLAY
   LET INT_FLAG=0            #MOD-B70205 add
   CLOSE WINDOW t340b_w   
END FUNCTION
 
FUNCTION t340_GETLASTDAY(p_date)
DEFINE p_date LIKE type_file.dat    #No.FUN-680130 DATE
   IF p_date IS NULL OR p_date=0 THEN
      RETURN 0
   END IF
   IF MONTH(p_date)=12 THEN
      RETURN MDY(1,1,YEAR(p_date)+1)-1
   ELSE
      RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
   END IF
END FUNCTION

#No.FUN-BB0086--add--begin--
FUNCTION t340_sro08_check()
   IF NOT cl_null(g_sro[l_ac].sro08) AND NOT cl_null(g_sro[l_ac].sro06) THEN
      IF cl_null(g_sro_t.sro08) OR cl_null(g_sro06_t) OR g_sro_t.sro08 != g_sro[l_ac].sro08 OR g_sro06_t != g_sro[l_ac].sro06 THEN
         LET g_sro[l_ac].sro08=s_digqty(g_sro[l_ac].sro08,g_sro[l_ac].sro06)
         DISPLAY BY NAME g_sro[l_ac].sro08
      END IF
   END IF
   
   IF NOT cl_null(g_sro[l_ac].sro08) THEN
      IF g_sro[l_ac].sro08<0 THEN
         RETURN FALSE 
      END IF
      LET g_sro[l_ac].sro12=g_sro[l_ac].sro08-g_sro[l_ac].sro07
      DISPLAY BY NAME g_sro[l_ac].sro12
   END IF    
   RETURN TRUE 
END FUNCTION
#No.FUN-BB0086--add--end--
