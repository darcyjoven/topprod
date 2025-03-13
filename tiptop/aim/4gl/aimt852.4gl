# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimt852.4gl
# Descriptions...: 複盤點維護作業－多單位現有庫存
# Date & Author..: 05/07/15 By Carrier
# Modify.........: No.FUN-5B0137 05/11/28 By kim 增加 參考單位 ima906='3' 時 同 ima906='2' 時 處理
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/28 By Carrier 會計科目加帳套
# Modify.........: No.FUN-6B0019 07/05/04 By rainy 改成單檔多欄
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改程序內有'(+)'的語法
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-930122 09/04/09 By xiaofeizhu 新增欄位底稿類別
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0061 10/10/22 By houlia 倉庫權限使用控管修改
# Modify.........: No.FUN-AA0059 10/11/02 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-BB0086 11/12/15 By tanxc 增加數量欄位小數取位 
# Modify.........: No.MOD-CB0268 12/11/28 By zhangll 程式會用到g_pia08變數，但卻未給g_pia08值,直接導致盤點過帳后多tlff,imgg異常
# Modify.........: No.FUN-CB0087 12/12/18 By xianghui 庫存單據理由碼改善
# Modify.........: No.TQC-D20042 13/02/25 By xianghui 理由碼改善問題
# Modify.........: No.TQC-D20047 13/02/27 By xianghui 理由碼改善問題
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  #FUN-6B0019 begin
    #g_piaa              RECORD LIKE piaa_file.*,
    #g_piaa_t            RECORD LIKE piaa_file.*,
    #g_piaa_o            RECORD LIKE piaa_file.*,
    #g_piaa01_t          LIKE piaa_file.piaa01,
    #g_piaa09_t          LIKE piaa_file.piaa01,
 
    g_piaa   DYNAMIC  ARRAY  OF RECORD 
                piaa01     LIKE  piaa_file.piaa01,
                piaa09     LIKE  piaa_file.piaa09,
                piaa02     LIKE  piaa_file.piaa02,
                ima02      LIKE  ima_file.ima02,
                piaa03     LIKE  piaa_file.piaa03,
                piaa04     LIKE  piaa_file.piaa04,
                piaa05     LIKE  piaa_file.piaa05,
                piaa06     LIKE  piaa_file.piaa06,
                piaa07     LIKE  piaa_file.piaa07,
                qty1       LIKE  piaa_file.piaa30,
                peo1       LIKE  piaa_file.piaa34,
                gen02_1    LIKE  gen_file.gen02,
                tagdate1   LIKE  piaa_file.piaa35,
                qty        LIKE  piaa_file.piaa30,
                peo        LIKE  piaa_file.piaa34,
                gen02_2    LIKE  gen_file.gen02,
                tagdate    LIKE  piaa_file.piaa35,
                piaa931    LIKE  piaa_file.piaa931,    #FUN-930122
                piaa70     LIKE  piaa_file.piaa70,     #FUN-CB0087
                azf03      LIKE  azf_file.azf03        #FUN-CB0087
              END RECORD,
    g_piaa_t  RECORD 
                piaa01     LIKE  piaa_file.piaa01,
                piaa09     LIKE  piaa_file.piaa09,
                piaa02     LIKE  piaa_file.piaa02,
                ima02      LIKE  ima_file.ima02,
                piaa03     LIKE  piaa_file.piaa03,
                piaa04     LIKE  piaa_file.piaa04,
                piaa05     LIKE  piaa_file.piaa05,
                piaa06     LIKE  piaa_file.piaa06,
                piaa07     LIKE  piaa_file.piaa07,
                qty1       LIKE  piaa_file.piaa30,
                peo1       LIKE  piaa_file.piaa34,
                gen02_1    LIKE  gen_file.gen02,
                tagdate1   LIKE  piaa_file.piaa35,
                qty        LIKE  piaa_file.piaa30,
                peo        LIKE  piaa_file.piaa34,
                gen02_2    LIKE  gen_file.gen02,
                tagdate    LIKE  piaa_file.piaa35,
                piaa931    LIKE  piaa_file.piaa931,    #FUN-930122
                piaa70     LIKE  piaa_file.piaa70,     #FUN-CB0087
                azf03      LIKE  azf_file.azf03        #FUN-CB0087
              END RECORD,
    g_piaa_o  RECORD 
                piaa01     LIKE  piaa_file.piaa01,
                piaa09     LIKE  piaa_file.piaa09,
                piaa02     LIKE  piaa_file.piaa02,
                ima02      LIKE  ima_file.ima02,
                piaa03     LIKE  piaa_file.piaa03,
                piaa04     LIKE  piaa_file.piaa04,
                piaa05     LIKE  piaa_file.piaa05,
                piaa06     LIKE  piaa_file.piaa06,
                piaa07     LIKE  piaa_file.piaa07,
                qty1       LIKE  piaa_file.piaa30,
                peo1       LIKE  piaa_file.piaa34,
                gen02_1    LIKE  gen_file.gen02,
                tagdate1   LIKE  piaa_file.piaa35,
                qty        LIKE  piaa_file.piaa30,
                peo        LIKE  piaa_file.piaa34,
                gen02_2    LIKE  gen_file.gen02,
                tagdate    LIKE  piaa_file.piaa35,
                piaa931    LIKE  piaa_file.piaa931,    #FUN-930122
                piaa70     LIKE  piaa_file.piaa70,     #FUN-CB0087
                azf03      LIKE  azf_file.azf03        #FUN-CB0087
              END RECORD,
    g_piaa08             LIKE piaa_file.piaa08,    
    g_piaa10             LIKE piaa_file.piaa10,    
    g_piaa16             LIKE piaa_file.piaa16,    
    g_piaa19             LIKE piaa_file.piaa19,    
    g_piaa66             LIKE piaa_file.piaa66,
    g_piaa67             LIKE piaa_file.piaa67,
    g_piaa68             LIKE piaa_file.piaa68,
    g_piaa930            LIKE piaa_file.piaa930,
  #FUN-6B0019 end
  #FUN-6B0019 remark begin
    #g_peo,g_peo2        LIKE piaa_file.piaa64,
    #g_peo_t,g_peo_o     LIKE piaa_file.piaa64,
    #g_tagdate           LIKE piaa_file.piaa65,
    #g_tagdate_o         LIKE piaa_file.piaa65,
    #g_tagdate_t         LIKE piaa_file.piaa65,
  #FUN-6B0019 remark end
    g_wc,g_sql          string,                 #No.FUN-580092 HCN
    #g_qty               LIKE piaa_file.piaa50, #FUN-6B0019 remark
    g_argv1             LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_argv2             LIKE piaa_file.piaa01,
    g_t1                LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_ima25             LIKE ima_file.ima25
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT

#FUN-6B0019 begin
  DEFINE  l_ac     LIKE type_file.num5,
          l_ac_t   LIKE type_file.num5,
          g_rec_b  LIKE type_file.num5,
          g_wc2    STRING
#FUN-6B0019 end
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    IF g_argv1 = '1' THEN 
       LET g_prog='aimt852'
    ELSE 
       LET g_prog='aimt853'
    END IF
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
 #FUN-6B0019 begin
    #INITIALIZE g_piaa.* TO NULL
    INITIALIZE g_piaa_t.* TO NULL
    INITIALIZE g_piaa_o.* TO NULL
 
    #LET g_forupd_sql = "SELECT * FROM piaa_file WHERE piaa01 = ? AND piaa09 = ? FOR UPDATE "
    #DECLARE t852_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    CALL g_piaa.CLEAR()
 #FUN-6B0019 end
 
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW t852_w AT p_row,p_col WITH FORM "aim/42f/aimt852" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    #2004/06/02共用程式時呼叫
    CALL cl_set_locale_frm_name("aimt852")
    CALL cl_ui_init()

    IF g_aza.aza115 ='Y' THEN                    #FUN-CB0087
       CALL cl_set_comp_required('piaa70',TRUE)  #FUN-CB0087
    END IF                                       #FUN-CB0087
 
    IF g_sma.sma115 IS NULL OR g_sma.sma115='N' THEN                            
       CALL cl_err('','asm-383',1)                                              
       EXIT PROGRAM                                                             
    END IF                                                                      
    IF NOT cl_null(g_argv2) THEN                                                
       CALL t852_q()                                                            
    END IF 
 
    WHILE TRUE
       LET g_action_choice=""
       CALL t852_menu()
       IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t852_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
#FUN-6B0019 remark begin
###FUNCTION t852_cs()
###    CLEAR FORM
###    IF NOT cl_null(g_argv2) THEN
###       LET g_wc=" piaa01='",g_argv2,"'"
###    ELSE
###       INITIALIZE g_piaa.* TO NULL    #FUN-640213 add
###       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
###           piaa01, piaa09, piaa02, piaa03, piaa04, piaa05, piaa06, piaa07
###              #No.FUN-580031 --start--     HCN
###              BEFORE CONSTRUCT
###                 CALL cl_qbe_init()
###              #No.FUN-580031 --end--       HCN
###           ON ACTION CONTROLP
###              CASE
###                 WHEN INFIELD(piaa02) #查詢料件編號
###                    CALL cl_init_qry_var()
###                    LET g_qryparam.form = "q_ima"
###                    LET g_qryparam.state = 'c'
###                    CALL cl_create_qry() RETURNING g_qryparam.multiret
###                    DISPLAY g_qryparam.multiret TO piaa02
###                    NEXT FIELD piaa02
###                 WHEN INFIELD(piaa03) #倉庫
###                    CALL cl_init_qry_var()
###                    LET g_qryparam.form = "q_imd"
###                    LET g_qryparam.state = 'c'
###                     LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
###                    CALL cl_create_qry() RETURNING g_qryparam.multiret
###                    DISPLAY g_qryparam.multiret TO piaa03
###                    NEXT FIELD piaa03
###                 WHEN INFIELD(piaa04) #儲位
###                    CALL cl_init_qry_var()
###                    LET g_qryparam.form = "q_ime"
###                    LET g_qryparam.state = 'c'
###                    CALL cl_create_qry() RETURNING g_qryparam.multiret
###                    DISPLAY g_qryparam.multiret TO piaa04
###                    NEXT FIELD piaa04
###                 WHEN INFIELD(piaa05) #批號
###                    CALL cl_init_qry_var()
###                    LET g_qryparam.form = "q_img1"
###                    LET g_qryparam.state = 'c'
###                    CALL cl_create_qry() RETURNING g_qryparam.multiret
###                    DISPLAY g_qryparam.multiret TO piaa05
###                    NEXT FIELD piaa05
###                 WHEN INFIELD(piaa07) #會計科目
###                    CALL cl_init_qry_var()
###                    LET g_qryparam.form = "q_aag"
###                    LET g_qryparam.state = 'c'
###                    CALL cl_create_qry() RETURNING g_qryparam.multiret
###                    DISPLAY g_qryparam.multiret TO piaa07
###                    NEXT FIELD piaa07
###                 WHEN INFIELD(piaa09) #庫存單位
###                    CALL cl_init_qry_var()
###                    LET g_qryparam.form = "q_gfe"
###                    LET g_qryparam.state = 'c'
###                    CALL cl_create_qry() RETURNING g_qryparam.multiret
###                    DISPLAY g_qryparam.multiret TO piaa09
###                    NEXT FIELD piaa09
###                 WHEN INFIELD(peo) #複盤人員
###                    CALL cl_init_qry_var()
###                    LET g_qryparam.form = "q_gen"
###                    LET g_qryparam.state = 'c'
###                    CALL cl_create_qry() RETURNING g_qryparam.multiret
###                    DISPLAY g_qryparam.multiret TO peo
###       	         CALL t852_peo('d','2',g_peo)
###                    NEXT FIELD peo  
###                 OTHERWISE EXIT CASE
###              END CASE
###
###           ON IDLE g_idle_seconds
###              CALL cl_on_idle()
###              CONTINUE CONSTRUCT
### 
###            ON ACTION about         #MOD-4C0121
###               CALL cl_about()      #MOD-4C0121
### 
###            ON ACTION help          #MOD-4C0121
###               CALL cl_show_help()  #MOD-4C0121
### 
###            ON ACTION controlg      #MOD-4C0121
###               CALL cl_cmdask()     #MOD-4C0121
### 
###		#No.FUN-580031 --start--     HCN
###                 ON ACTION qbe_select
###         	   CALL cl_qbe_select() 
###                 ON ACTION qbe_save
###		   CALL cl_qbe_save()
###		#No.FUN-580031 --end--       HCN
###       END CONSTRUCT
###    END IF
###    IF INT_FLAG THEN RETURN END IF
###
###    LET g_sql="SELECT piaa01,piaa09 FROM piaa_file ", # 組合出 SQL 指令
###              " WHERE ",g_wc CLIPPED,
###              " ORDER BY piaa01"
###    PREPARE t852_prepare FROM g_sql           # RUNTIME 編譯
###    DECLARE t852_cs                         # SCROLL CURSOR
###        SCROLL CURSOR WITH HOLD FOR t852_prepare
###    LET g_sql=
###        "SELECT COUNT(*) FROM piaa_file WHERE ",g_wc CLIPPED
###    PREPARE t852_precount FROM g_sql
###    DECLARE t852_count CURSOR FOR t852_precount
###END FUNCTION
#FUN-6B0019 remark end
 
FUNCTION t852_menu()
  #FUN-6B0019 begin
    ###MENU ""
 
    ###    BEFORE MENU
    ###       CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    ###   #COMMAND "quick_input" 
    ###    ON ACTION quick_input
    ###       LET g_action_choice="quick_input" #FUN-5B0137 
    ###       IF cl_chk_act_auth() THEN
    ###          CALL t852_a()
    ###       END IF
    ###    ON ACTION query 
    ###       LET g_action_choice="query" 
    ###       IF cl_chk_act_auth() THEN
    ###            CALL t852_q()
    ###       END IF
    ###    ON ACTION next 
    ###       CALL t852_fetch('N') 
    ###    ON ACTION previous 
    ###       CALL t852_fetch('P')
    ###    ON ACTION modify 
    ###       LET g_action_choice="modify"
    ###       IF cl_chk_act_auth() THEN
    ###           CALL t852_u()
    ###       END IF
    ###    ON ACTION help 
    ###       CALL cl_show_help()
    ###    ON ACTION locale
    ###       CALL cl_dynamic_locale()
    ###       CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    ###    ON ACTION exit
    ###       LET g_action_choice = "exit"
    ###       EXIT MENU
 
    ###    ON ACTION jump
    ###       CALL t852_fetch('/')
    ###    ON ACTION first
    ###       CALL t852_fetch('F')
    ###    ON ACTION last
    ###       CALL t852_fetch('L')
 
    ###    ON ACTION CONTROLG
    ###       CALL cl_cmdask()
    ###    ON IDLE g_idle_seconds
    ###       CALL cl_on_idle()
 
    ###     ON ACTION about         #MOD-4C0121
    ###        CALL cl_about()      #MOD-4C0121
    ###
    ###       LET g_action_choice = "exit"
    ###       CONTINUE MENU
 
    ###    #No.FUN-680046-------add--------str----
    ###    ON ACTION related_document             #相關文件"                        
    ###     LET g_action_choice="related_document"           
    ###        IF cl_chk_act_auth() THEN                     
    ###           IF g_piaa.piaa01 IS NOT NULL THEN            
    ###              LET g_doc.column1 = "piaa01"               
    ###              LET g_doc.column2 = "piaa09"               
    ###              LET g_doc.value1 = g_piaa.piaa01            
    ###              LET g_doc.value2 = g_piaa.piaa09            
    ###              CALL cl_doc()                             
    ###           END IF                                        
    ###        END IF                                           
    ###     #No.FUN-680046-------add--------end----        
    ###    -- for Windows close event trapped
    ###    COMMAND KEY(INTERRUPT)
    ###         LET INT_FLAG=FALSE 		#MOD-570244	mars
    ###       LET g_action_choice = "exit"
    ###       EXIT MENU
 
    ###END MENU
    ###CLOSE t852_cs
 
  WHILE TRUE
    CALL t852_bp("G")
    CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t852_q()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t852_b()
           ELSE
              LET g_action_choice = NULL
           END IF
 
        WHEN "related_document"  
           IF cl_chk_act_auth() AND l_ac != 0 THEN 
              IF g_piaa[l_ac].piaa01 IS NOT NULL THEN
                 LET g_doc.column1 = "piaa01"
                 LET g_doc.value1 = g_piaa[l_ac].piaa01
                 CALL cl_doc()
              END IF
           END IF
        WHEN "exporttoexcel"   
           IF cl_chk_act_auth() THEN
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_piaa),'','')
           END IF
        WHEN "exit"
            EXIT WHILE
    END CASE
  END WHILE
 #FUN-6B0019 end
END FUNCTION
 
#FUN-6B0019 begin
FUNCTION  t852_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
     RETURN
  END IF
 
  LET g_action_choice = " "
 
  CALL cl_set_act_visible("accept,cancel", FALSE)
  DISPLAY ARRAY g_piaa TO s_piaa.* ATTRIBUTE(COUNT=g_rec_b)
 
     BEFORE ROW
        LET l_ac = ARR_CURR()
        CALL cl_show_fld_cont()      
 
     ON ACTION query
        LET g_action_choice="query"
        EXIT DISPLAY
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
 
     ON ACTION detail
        LET g_action_choice = "detail"
        LET l_ac = 1   #FUN-AA0059
        EXIT DISPLAY
 
     ON ACTION accept
        LET g_action_choice="detail"
        LET l_ac = ARR_CURR()
        EXIT DISPLAY
 
     ON ACTION controlg
        CALL cl_cmdask()
     ON ACTION help
        CALL cl_show_help()
     ON ACTION related_document
        LET g_action_choice = "related_document"
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
     ON ACTION about        
        CALL cl_about()
     ON ACTION exporttoexcel   
        LET g_action_choice = "exporttoexcel"
        EXIT DISPLAY
     ON ACTION exit
        LET g_action_choice = "exit"
        EXIT DISPLAY
     ON ACTION cancel
        LET g_action_choice = "exit"
        EXIT DISPLAY
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE) 
END FUNCTION
 
#FUN-6B0019 begin
FUNCTION t852_peo_show()
  DEFINE l_piaa  RECORD LIKE piaa_file.*
   SELECT * INTO l_piaa.*  FROM piaa_file
    WHERE piaa01 = g_piaa[l_ac].piaa01
      AND piaa09 = g_piaa[l_ac].piaa09
   IF g_argv1 = '1' THEN
     LET g_piaa[l_ac].qty1     = l_piaa.piaa30
     LET g_piaa[l_ac].peo1     = l_piaa.piaa34
     LET g_piaa[l_ac].tagdate1 = l_piaa.piaa35
     LET g_piaa[l_ac].qty      = l_piaa.piaa50
     LET g_piaa[l_ac].peo      = l_piaa.piaa54
     LET g_piaa[l_ac].tagdate  = l_piaa.piaa55
   ELSE
     LET g_piaa[l_ac].qty1     = l_piaa.piaa40
     LET g_piaa[l_ac].peo1     = l_piaa.piaa44
     LET g_piaa[l_ac].tagdate1 = l_piaa.piaa45
     LET g_piaa[l_ac].qty      = l_piaa.piaa60
     LET g_piaa[l_ac].peo      = l_piaa.piaa64
     LET g_piaa[l_ac].tagdate  = l_piaa.piaa65
   END IF
  #peo,gen02
   SELECT gen02  INTO  g_piaa[l_ac].gen02_1
     FROM gen_file
    WHERE gen01  =  g_piaa[l_ac].peo1
   SELECT gen02  INTO  g_piaa[l_ac].gen02_2
     FROM gen_file
    WHERE gen01  =  g_piaa[l_ac].peo
END FUNCTION
#FUN-6B0019 end
 
 
#FUN-6B0019 begin
FUNCTION t852_b_fill(p_wc2)
#  DEFINE p_wc2  LIKE type_file.chr1000
  DEFINE p_wc2  STRING     #NO.FUN-910082
  DEFINE l_pia  RECORD LIKE pia_file.*
 
 
  IF g_argv1 = '1' THEN
     LET g_sql= "SELECT piaa01,piaa09,piaa02,ima02,",
                "       piaa03,piaa04,piaa05,piaa06,piaa07, ",
                "       piaa30,piaa34,e.gen02,piaa35, ",
                "       piaa50,piaa54,g.gen02,piaa55,piaa931,piaa70,azf03  ",        #FUN-930122 Add piaa931 #FUN-CB0087 add piaa70,azf03
#               "  FROM piaa_file,ima_file,gen_file e,gen_file g",      #No.TQC-780054
                "  FROM piaa_file,OUTER ima_file,OUTER gen_file e,OUTER gen_file g",#No.TQC-780054
                "        ,OUTER azf_file f ",    #FUN-CB0087
#               " WHERE piaa02 = ima01(+) ",                            #No.TQC-780054
#               "    AND piaa_file.piaa34 = e.gen01 ",                         #No.TQC-780054
#               "    AND piaa_file.piaa54 = g.gen01 ",                         #No.TQC-780054
                " WHERE piaa_file.piaa02=ima_file.ima01 ",                      #No.TQC-780054
                "    AND piaa_file.piaa34 = e.gen01 ",                            #No.TQC-780054
                "    AND piaa_file.piaa54 = g.gen01 ",                            #No.TQC-780054
                "    AND piaa_file.piaa70 = f.azf01 ",                                 #FUN-CB0087
                "    AND ", p_wc2 CLIPPED,
                "  ORDER BY piaa01,piaa09"
  ELSE
     LET g_sql= "SELECT piaa01,piaa09,piaa02,ima02,",
                "       piaa03,piaa04,piaa05,piaa06,piaa07, ",
                "       piaa40,piaa44,e.gen02,piaa45, ",
                "       piaa60,piaa64,g.gen02,piaa65,piaa931,piaa70,azf03  ",        #FUN-930122 Add piaa931 #FUN-CB0087 add piaa70,azf03
#               "  FROM piaa_file,ima_file,gen_file e,gen_file g ",     #No.TQC-780054
                "  FROM piaa_file,OUTER ima_file,OUTER gen_file e,OUTER gen_file g",#No.TQC-780054 
                "        ,OUTER azf_file f ",    #FUN-CB0087
#               " WHERE piaa02 = ima01(+) ",                            #No.TQC-780054
#               "    AND piaa_file.piaa44 =e.gen01 ",                          #No.TQC-780054
#               "    AND piaa_file.piaa64 =g.gen01 ",                          #No.TQC-780054
                " WHERE piaa_file.piaa02=ima_file.ima01 ",                      #No.TQC-780054
                "    AND piaa_file.piaa44 =e.gen01 ",                             #No.TQC-780054
                "    AND piaa_file.piaa64 =g.gen01 ",                             #No.TQC-780054
                "    AND piaa_file.piaa70 = f.azf01 ",                                 #FUN-CB0087
                "   AND ", p_wc2 CLIPPED,
                "  ORDER BY piaa01,piaa09"
  END IF
  PREPARE t852_prepare FROM g_sql
  DECLARE t852_curs CURSOR FOR t852_prepare
        
 
   CALL g_piaa.clear()
   LET g_cnt = 1
   FOREACH t852_curs INTO g_piaa[g_cnt].*  #單身 ARRAY 填充
      IF STATUS THEN
          CALL cl_err('FOREACH:',STATUS,1)
          EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
      END IF
   END FOREACH
   CALL g_piaa.deleteElement(g_cnt)
   IF STATUS THEN CALL cl_err('FOREACH:',STATUS,1) END IF
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
 
END FUNCTION
#FUN-6B0019 end
 
#FUN-6B0019 remark begin
####快速輸入     
###FUNCTION t852_a()
### DEFINE l_sum          LIKE pia_file.pia30
###
###    IF s_shut(0) THEN RETURN END IF
###    MESSAGE ""
###    #CLEAR FORM                                      # 清螢墓欄位內容
###    #INITIALIZE g_piaa.* LIKE piaa_file.*
###    LET g_piaa01_t = NULL
###    LET g_piaa_t.piaa01 = NULL
###    LET g_peo_o = NULL
###    LET g_tagdate_o = NULL
###    LET g_tagdate = g_tagdate_t
###    CALL cl_opmsg('a')
###    WHILE TRUE
###        SELECT COUNT(*) INTO g_cnt FROM piaa_file                               
###         WHERE piaa01=g_piaa.piaa01                                             
###        IF g_cnt >0 THEN                                                        
###           DECLARE sel_piaa_cur CURSOR FOR                                      
###            SELECT piaa09 FROM piaa_file                                        
###             WHERE piaa01=g_piaa.piaa01                                         
###           FOREACH sel_piaa_cur INTO g_piaa.piaa09                              
###              IF SQLCA.sqlcode THEN                                             
###                 CALL cl_err('foreach',SQLCA.sqlcode,1)                         
###                 EXIT FOREACH                                                   
###              END IF                                                            
###              CLEAR FORM 
###              #FUN-5B0137...............begin
###              SELECT piaa_file.* INTO g_piaa.* FROM piaa_file
###                WHERE piaa01=g_piaa.piaa01 AND piaa09=g_piaa.piaa09
###              CALL t852_show()
###              #FUN-5B0137...............end
###              CALL t852_i("a")                            # 各欄位輸入
###              IF INT_FLAG THEN                            # 若按了DEL鍵
###                 LET INT_FLAG = 0
###                 CLEAR FORM
###                 INITIALIZE g_piaa.* TO NULL
###                 LET g_qty     = NULL
###                 LET g_peo     = NULL
###                 LET g_tagdate = NULL
###                 EXIT WHILE
###              END IF
###              IF g_piaa.piaa01 IS NULL OR g_piaa.piaa09 IS NULL THEN # KEY 不可空白
###                 CONTINUE WHILE
###              END IF
###              IF g_piaa.piaa03 IS NULL THEN LET g_piaa.piaa03 = ' ' END IF
###              IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04 = ' ' END IF
###              IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05 = ' ' END IF
###              LET l_sum=0
###              IF g_argv1 = '1' THEN 
###                 LET g_piaa.piaa50 = g_qty
###                 LET g_piaa.piaa51 = g_user
###                 LET g_piaa.piaa52 = g_today
###                 LET g_piaa.piaa53 = TIME  
###                 LET g_piaa.piaa54 = g_peo
###                 LET g_piaa.piaa55 = g_tagdate
###              ELSE 
###                 LET g_piaa.piaa60 = g_qty
###                 LET g_piaa.piaa61 = g_user
###                 LET g_piaa.piaa62 = g_today
###                 LET g_piaa.piaa63 = TIME
###                 LET g_piaa.piaa64 = g_peo
###                 LET g_piaa.piaa65 = g_tagdate
###              END IF
###              UPDATE piaa_file SET piaa_file.* = g_piaa.*    # 更新DB
###             # WHERE piaa01 = g_piaa.piaa01 AND piaa09 = g_piaa.piaa09               # COLAUTH? #FUN-5B0137
###               WHERE piaa01=g_piaa.piaa01 AND piaa09=g_piaa.piaa09   # COLAUTH? #FUN-5B0137
###              IF SQLCA.sqlcode THEN
####                CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
###                 CALL cl_err3("upd","piaa_file",g_piaa_t.piaa01,g_piaa.piaa09,SQLCA.sqlcode,"","",1)   #NO.FUN-640266
###                 CONTINUE WHILE
###              END IF
###              IF cl_null(g_argv2) THEN
###                 IF g_argv1 = '1' THEN 
###                    SELECT SUM(piaa50*piaa10) INTO l_sum FROM piaa_file
###                     WHERE piaa01=g_piaa.piaa01                               
###                       AND piaa02=g_piaa.piaa02                               
###                       AND piaa03=g_piaa.piaa03                               
###                       AND piaa04=g_piaa.piaa04                               
###                       AND piaa05=g_piaa.piaa05
###                       AND piaa50 IS NOT NULL
###                       AND piaa10 IS NOT NULL
###                    IF cl_null(l_sum) THEN LET l_sum=0 END IF
###                    UPDATE pia_file SET pia50=l_sum,
###                     pia54=g_piaa.piaa54,pia55=g_piaa.piaa55   #FUN-5B0137
###                     WHERE pia01=g_piaa.piaa01                               
###                       AND pia02=g_piaa.piaa02                               
###                       AND pia03=g_piaa.piaa03                               
###                       AND pia04=g_piaa.piaa04                               
###                       AND pia05=g_piaa.piaa05
###                 ELSE
###                    SELECT SUM(piaa60*piaa10) INTO l_sum FROM piaa_file
###                     WHERE piaa01=g_piaa.piaa01                               
###                       AND piaa02=g_piaa.piaa02                               
###                       AND piaa03=g_piaa.piaa03                               
###                       AND piaa04=g_piaa.piaa04                               
###                       AND piaa05=g_piaa.piaa05
###                       AND piaa60 IS NOT NULL
###                       AND piaa10 IS NOT NULL
###                    IF cl_null(l_sum) THEN LET l_sum=0 END IF
###                    UPDATE pia_file SET pia60=l_sum,
###                     pia64=g_piaa.piaa64,pia65=g_piaa.piaa65   #FUN-5B0137
###                     WHERE pia01=g_piaa.piaa01                               
###                       AND pia02=g_piaa.piaa02                               
###                       AND pia03=g_piaa.piaa03                               
###                       AND pia04=g_piaa.piaa04                               
###                       AND pia05=g_piaa.piaa05
###                 END IF
###                 IF SQLCA.sqlcode THEN                                       
####                   CALL cl_err('update pia',SQLCA.sqlcode,1)                
###                    CALL cl_err3("upd","pia_file",g_piaa.piaa01,g_piaa.piaa02,
###                                  SQLCA.sqlcode,"","update pia",1)   #NO.FUN-640266 #No.FUN-660156
###                 END IF 
###              END IF
###              LET g_piaa_t.* = g_piaa.*                # 保存上筆資料
###              LET g_piaa_o.* = g_piaa.*                # 保存上筆資料
###              LET g_tagdate_t = g_tagdate
###              LET g_peo_t     = g_peo
###              CLEAR FORM                                      # 清螢墓欄位內容
###           END FOREACH
###           CLEAR FORM                                      # 清螢墓欄位內容
###           INITIALIZE g_piaa.* TO NULL
###           INITIALIZE g_piaa_o.* TO NULL
###           LET g_qty = ' '
###           LET g_peo = ' '
###           LET g_tagdate = ' '
###          #start FUN-5A0199
###          #LET g_piaa.piaa01 = g_piaa_t.piaa01[1,3],'-',
###          #                    g_piaa_t.piaa01[5,10] + 1 USING '&&&&&&'
###           LET g_piaa.piaa01 = g_piaa_t.piaa01[1,g_doc_len],'-',
###                               g_piaa_t.piaa01[g_no_sp,g_no_ep] + 1 USING '&&&&&&'
###          #end FUN-5A0199
###        ELSE
###          #start FUN-5A0199
###          #LET g_piaa.piaa01 = g_piaa_t.piaa01[1,3],'-',
###          #                    g_piaa_t.piaa01[5,10] + 1 using '&&&&&&'
###           LET g_piaa.piaa01 = g_piaa_t.piaa01[1,g_doc_len],'-',
###                               g_piaa_t.piaa01[g_no_sp,g_no_ep] + 1 using '&&&&&&'
###          #end FUN-5A0199
###           CLEAR FORM                                  # 清螢墓欄位內容
###           CALL t852_i("a")                            # 各欄位輸入
###           IF INT_FLAG THEN                            # 若按了DEL鍵
###              LET INT_FLAG = 0
###              CLEAR FORM
###              INITIALIZE g_piaa.* TO NULL
###              LET g_qty     = NULL
###              LET g_peo     = NULL
###              LET g_tagdate = NULL
###              EXIT WHILE
###           END IF
###           IF g_piaa.piaa01 IS NULL OR g_piaa.piaa09 IS NULL THEN # KEY 不可空白
###              CONTINUE WHILE
###           END IF
###           IF g_piaa.piaa03 IS NULL THEN LET g_piaa.piaa03 = ' ' END IF
###           IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04 = ' ' END IF
###           IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05 = ' ' END IF
###           LET l_sum=0
###           IF g_argv1 = '1' THEN 
###              LET g_piaa.piaa50 = g_qty
###              LET g_piaa.piaa51 = g_user
###              LET g_piaa.piaa52 = g_today
###              LET g_piaa.piaa53 = TIME  
###              LET g_piaa.piaa54 = g_peo
###              LET g_piaa.piaa55 = g_tagdate
###           ELSE 
###              LET g_piaa.piaa60 = g_qty
###              LET g_piaa.piaa61 = g_user
###              LET g_piaa.piaa62 = g_today
###              LET g_piaa.piaa63 = TIME
###              LET g_piaa.piaa64 = g_peo
###              LET g_piaa.piaa65 = g_tagdate
###           END IF
###           UPDATE piaa_file SET piaa_file.* = g_piaa.*    # 更新DB
###            WHERE piaa01 = g_piaa.piaa01 AND piaa09 = g_piaa.piaa09               # COLAUTH?
###           IF SQLCA.sqlcode THEN
####             CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
###              CALL cl_err3("upd","piaa_file",g_piaa_t.piaa01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
###              CONTINUE WHILE
###           END IF
###           IF cl_null(g_argv2) THEN
###              IF g_argv1 = '1' THEN 
###                 SELECT SUM(piaa50*piaa10) INTO l_sum FROM piaa_file
###                  WHERE piaa01=g_piaa.piaa01                               
###                    AND piaa02=g_piaa.piaa02                               
###                    AND piaa03=g_piaa.piaa03                               
###                    AND piaa04=g_piaa.piaa04                               
###                    AND piaa05=g_piaa.piaa05
###                    AND piaa50 IS NOT NULL
###                    AND piaa10 IS NOT NULL
###                 IF cl_null(l_sum) THEN LET l_sum=0 END IF
###                 UPDATE pia_file SET pia50=l_sum,
###                  pia54=g_piaa.piaa54,pia55=g_piaa.piaa55   #FUN-5B0137                          
###                  WHERE pia01=g_piaa.piaa01                               
###                    AND pia02=g_piaa.piaa02                               
###                    AND pia03=g_piaa.piaa03                               
###                    AND pia04=g_piaa.piaa04                               
###                    AND pia05=g_piaa.piaa05
###              ELSE
###                 SELECT SUM(piaa60*piaa10) INTO l_sum FROM piaa_file
###                  WHERE piaa01=g_piaa.piaa01                               
###                    AND piaa02=g_piaa.piaa02                               
###                    AND piaa03=g_piaa.piaa03                               
###                    AND piaa04=g_piaa.piaa04                               
###                    AND piaa05=g_piaa.piaa05
###                    AND piaa60 IS NOT NULL
###                    AND piaa10 IS NOT NULL
###                 IF cl_null(l_sum) THEN LET l_sum=0 END IF
###                 UPDATE pia_file SET pia60=l_sum,                          
###                  pia64=g_piaa.piaa64,pia65=g_piaa.piaa65   #FUN-5B0137                          
###                  WHERE pia01=g_piaa.piaa01                               
###                    AND pia02=g_piaa.piaa02                               
###                    AND pia03=g_piaa.piaa03                               
###                    AND pia04=g_piaa.piaa04                               
###                    AND pia05=g_piaa.piaa05
###              END IF
###              IF SQLCA.sqlcode THEN                                       
####                CALL cl_err('update pia',SQLCA.sqlcode,1)                
###                 CALL cl_err3("upd","pia_file",g_piaa.piaa01,g_piaa.piaa02,SQLCA.sqlcode,
###                              "","update pia",1)   #NO.FUN-640266
###              END IF 
###           END IF
###           LET g_piaa_t.* = g_piaa.*                # 保存上筆資料
###           LET g_piaa_o.* = g_piaa.*                # 保存上筆資料
###           LET g_tagdate_t = g_tagdate
###           LET g_peo_t     = g_peo
###           CLEAR FORM                                      # 清螢墓欄位內容
###           INITIALIZE g_piaa.* TO NULL
###           INITIALIZE g_piaa_o.* TO NULL
###           LET g_qty = ' '
###           LET g_peo = ' '
###           LET g_tagdate = ' '
###        END IF
###    END WHILE
###END FUNCTION
###
###FUNCTION t852_i(p_cmd)
###    DEFINE
###        p_cmd           LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
###        l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
###	l_ime09         LIKE ime_file.ime09,
###        l_mesg,l_str    LIKE ze_file.ze03,     #No.FUN-690026 VARCHAR(80)
###        l_n             LIKE type_file.num5    #No.FUN-690026 SMALLINT
###
###    
###    INPUT g_piaa.piaa01,g_piaa.piaa09,g_piaa.piaa02,g_piaa.piaa03,
###          g_piaa.piaa04,g_piaa.piaa05,g_piaa.piaa06,g_piaa.piaa07,
###          g_qty,g_peo,g_tagdate
###          WITHOUT DEFAULTS 
###     FROM piaa01,piaa09,piaa02,piaa03,
###          piaa04,piaa05,piaa06,piaa07,
###          qty,peo,tagdate 
### 
###        BEFORE INPUT
###           LET g_before_input_done = FALSE
###           CALL t852_set_entry(p_cmd)
###           CALL t852_set_no_entry(p_cmd)
###           LET g_before_input_done = TRUE
###
###        AFTER FIELD piaa01 
###           IF NOT cl_null(g_piaa.piaa01) THEN
###              SELECT COUNT(*) INTO g_cnt FROM piaa_file                         
###               WHERE piaa01=g_piaa.piaa01                                       
###              IF g_cnt=0 THEN                                                   
###                 CALL cl_err(g_piaa.piaa01,'mfg0114',0)                         
###                 NEXT FIELD piaa01                                              
###              END IF
###           END IF
###
###        BEFORE FIELD piaa09
###           CALL t852_set_entry(p_cmd)
###
###        AFTER FIELD piaa09 
###           IF g_piaa_o.piaa09 IS NULL OR (g_piaa.piaa09 !=g_piaa_o.piaa09) THEN
###              CALL t852_unit('a') 
###              IF NOT cl_null(g_errno) THEN
###                 CALL cl_err(g_piaa.piaa09,g_errno,0)
###                 LET g_piaa.piaa09 = g_piaa_o.piaa09
###                 DISPLAY BY NAME g_piaa.piaa09
###                 NEXT FIELD piaa09
###              END IF
###              IF g_sma.sma12 = 'Y' THEN 
###                 CALL s_umfchk(g_piaa.piaa02,g_ima25,g_piaa.piaa09)
###                      RETURNING g_cnt,g_piaa.piaa10
###                 IF g_cnt THEN 
###                    CALL cl_err('','mfg3075',0)
###                    LET g_piaa.piaa09 = g_piaa_o.piaa09
###                    DISPLAY BY NAME g_piaa.piaa09
###                    NEXT FIELD piaa09
###                 END IF
###              ELSE
###                 LET g_piaa.piaa10 = 1
###              END IF
###           END IF
###           CALL t852_piaa01('d')
###           IF NOT cl_null(g_errno)  THEN 
###              CALL cl_err(g_piaa.piaa01,'mfg0114',1)
###              NEXT FIELD piaa01
###           END IF
###           IF g_piaa.piaa19 ='Y' THEN 
###              CALL cl_err(g_piaa.piaa01,'mfg0132',1) 
###              EXIT INPUT
###           END IF
###           LET g_piaa_o.piaa02 = g_piaa.piaa02
###           IF g_peo IS NULL OR g_peo =' ' THEN 
###              LET g_peo  = g_peo_t
###              DISPLAY BY NAME g_peo
###           END IF
###           IF g_tagdate IS NULL OR g_tagdate =' ' THEN 
###              LET g_tagdate = g_today 
###              DISPLAY g_tagdate TO FORMONLY.tagdate
###           END IF
###           LET g_piaa_o.piaa09 = g_piaa.piaa09
###           CALL t852_set_no_entry(p_cmd)
###
###        BEFORE FIELD piaa02
###	   IF g_sma.sma60 = 'Y' THEN	# 若須分段輸入
###	      CALL s_inp5(7,23,g_piaa.piaa02) RETURNING g_piaa.piaa02
###	      DISPLAY BY NAME g_piaa.piaa02 
###              IF INT_FLAG THEN 
###                 LET INT_FLAG = 0 
###              END IF
###      	   END IF
###           #顯示舊值
###           IF g_piaa_t.piaa02 IS NOT NULL AND g_piaa_t.piaa02 != ' ' THEN 
###              CALL cl_getmsg('mfg6194',g_lang) RETURNING l_mesg
###              LET l_mesg = l_mesg clipped,g_piaa_t.piaa02
###              ERROR l_mesg 
###           END IF
###
###        AFTER FIELD piaa02      #料件編號
###           IF NOT cl_null(g_piaa.piaa02) THEN 
###              IF g_piaa_o.piaa02 IS NULL OR 
###                (g_piaa_o.piaa02 != g_piaa.piaa02) THEN
###                 CALL t852_piaa02('a')
###                 IF NOT cl_null(g_errno)  THEN 
###                    CALL cl_err(g_piaa.piaa02,g_errno,1)
###                    LET g_piaa.piaa02 = g_piaa_o.piaa02
###                    DISPLAY BY NAME g_piaa.piaa02 
###                    NEXT FIELD piaa02
###                 END IF
###              END IF
###	      #使用者為單倉時，只須檢查盤點資料檔中是否有此料號
###	      IF g_sma.sma12 = 'N' THEN
###	         SELECT COUNT(*) INTO l_n FROM piaa_file
###                  WHERE piaa02=g_piaa.piaa02 
###	         IF l_n IS NOT NULL AND l_n > 0 THEN
###	            CALL cl_err(g_piaa.piaa02,'mfg6084',1)
###                    LET g_piaa.piaa02 = g_piaa_o.piaa02
###                    DISPLAY BY NAME g_piaa.piaa02 
###                    NEXT FIELD piaa02
###                 END IF
###              END IF
###              IF g_piaa_t.piaa02 != g_piaa.piaa02 THEN
###                 CALL cl_getmsg('mfg6190',g_lang) RETURNING l_str
###                 IF NOT cl_prompt(0,0,l_str) THEN
###                    NEXT FIELD piaa02 
###                 END IF
###              END IF
###              LET g_piaa_o.piaa02 = g_piaa.piaa02
###           END IF
###
###        BEFORE FIELD piaa03 
###           #顯示舊值
###           IF g_piaa_t.piaa03 IS NOT NULL AND g_piaa_t.piaa03 != ' ' THEN
###              CALL cl_getmsg('mfg6195',g_lang) RETURNING l_mesg
###              LET l_mesg = l_mesg clipped,g_piaa_t.piaa03
###              ERROR l_mesg 
###           END IF
###
###        AFTER FIELD piaa03 
###{&}        IF NOT cl_null(g_piaa.piaa03) THEN 
###              #---->依系統參數的設定,檢查倉庫的使用
###              IF NOT s_stkchk(g_piaa.piaa03,'A') THEN 
###                 CALL cl_err(g_piaa.piaa03,'mfg6076',1)    
###                 LET g_piaa.piaa03 = g_piaa_o.piaa03
###                 DISPLAY BY NAME g_piaa.piaa03 
###                 NEXT FIELD piaa03
###              END IF
###              IF g_piaa_t.piaa03 != g_piaa.piaa03 THEN
###                 CALL cl_getmsg('mfg6191',g_lang) RETURNING l_str
###                 IF NOT cl_prompt(0,0,l_str) THEN
###                    NEXT FIELD piaa03 
###                 END IF
###              END IF
###              LET g_piaa_o.piaa03 = g_piaa.piaa03
###           END IF
###                   
###        BEFORE FIELD piaa04  #儲位
###           #顯示舊值
###           IF g_piaa_t.piaa04 IS NOT NULL AND g_piaa_t.piaa04 != ' ' THEN
###              CALL cl_getmsg('mfg6196',g_lang) RETURNING l_mesg
###              LET l_mesg = l_mesg clipped,g_piaa_t.piaa04
###              ERROR l_mesg 
###           END IF
###
###        AFTER FIELD piaa04  #儲位
###           IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04 = ' ' END IF
###           IF g_piaa.piaa04 IS NOT NULL AND g_piaa.piaa04 != ' ' THEN
###              #---->檢查料件儲位的使用
###              CALL s_prechk(g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04)
###                   RETURNING g_cnt,g_chr  
###              IF NOT g_cnt THEN
###                 CALL cl_err(g_piaa.piaa04,'mfg1102',1)
###                 LET g_piaa.piaa04 = g_piaa_o.piaa04
###                 DISPLAY BY NAME g_piaa.piaa04 
###                 NEXT FIELD piaa04
###              END IF
###           END IF
###           IF g_piaa_t.piaa04 != g_piaa.piaa04 THEN
###              CALL cl_getmsg('mfg6192',g_lang) RETURNING l_str
###              IF NOT cl_prompt(0,0,l_str) THEN
###                 NEXT FIELD piaa04 
###              END IF
###           END IF
###           LET g_piaa_o.piaa04 = g_piaa.piaa04
###
###        BEFORE FIELD piaa05  
###           #顯示舊值
###           IF g_piaa_t.piaa05 IS NOT NULL AND g_piaa_t.piaa05 != ' ' THEN 
###              CALL cl_getmsg('mfg6197',g_lang) RETURNING l_mesg
###              LET l_mesg = l_mesg clipped,g_piaa_t.piaa05
###              ERROR l_mesg 
###           END IF
###
###        AFTER FIELD piaa05  #批號
###           IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05 = ' ' END IF
###           #---->資料是否重複檢查
###           IF (g_piaa_t.piaa02 != g_piaa.piaa02) OR 
###              (g_piaa_t.piaa03 != g_piaa.piaa03) OR 
###              (g_piaa_t.piaa04 != g_piaa.piaa04) OR 
###              (g_piaa_t.piaa05 != g_piaa.piaa05) THEN
###    	      SELECT COUNT(*) INTO l_n
###    	        FROM piaa_file
###    	       WHERE piaa02=g_piaa.piaa02 AND piaa03=g_piaa.piaa03
###    	         AND piaa04=g_piaa.piaa04 AND piaa05=g_piaa.piaa05
###    	         AND piaa09=g_piaa.piaa09
###    	  	IF l_n IS NOT NULL AND l_n > 0 THEN
###    	          CALL cl_err(g_piaa.piaa05,'mfg6084',1)
###                  LET g_piaa.piaa05 = g_piaa_o.piaa05
###                  DISPLAY BY NAME g_piaa.piaa05 
###                  NEXT FIELD piaa03
###              END IF
###           END IF
###           IF g_piaa_t.piaa05 != g_piaa.piaa05 THEN 
###              CALL cl_getmsg('mfg6193',g_lang) RETURNING l_str
###              IF NOT cl_prompt(0,0,l_str) THEN
###                 NEXT FIELD piaa05 
###              END IF
###           END IF
###           LET g_piaa_o.piaa05 = g_piaa.piaa05
###
###        AFTER FIELD piaa07  
###           IF g_piaa.piaa07 IS NOT NULL THEN
###              IF g_sma.sma03='Y' THEN
###                 IF NOT s_actchk3(g_piaa.piaa07,g_aza.aza81) THEN  #No.FUN-730033
###                    CALL cl_err(g_piaa.piaa07,'mfg0018',0)
###                    NEXT FIELD piaa07 
###                 END IF
###              END IF
###           END IF
###            
###        AFTER FIELD qty
###           IF g_qty IS NULL OR g_qty = ' ' OR g_qty < 0 THEN 
###              NEXT FIELD qty
###           END IF 
###
###       AFTER FIELD peo    
###           IF g_peo IS NOT NULL AND g_peo !=' ' THEN   
###              CALL t852_peo('a','2',g_peo)
###              IF NOT cl_null(g_errno) THEN 
###                 CALL cl_err(g_peo,g_errno,0)
###                 LET g_peo = g_peo_o
###                 DISPLAY g_peo TO FORMONLY.peo
###                 NEXT FIELD peo  
###               END IF
###           END IF  
###           IF g_peo IS NOT NULL THEN LET g_peo_o = g_peo END IF
###                   
###       AFTER FIELD tagdate #盤點日期 
###           IF g_tagdate IS NULL OR g_tagdate = ' ' THEN
###	      LET g_tagdate = g_today
###              DISPLAY g_tagdate TO FORMONLY.tagdate 
###           END IF
###           IF g_tagdate IS NOT NULL THEN 
###              LET g_tagdate_o = g_tagdate 
###           END IF
###			
###       AFTER INPUT
###          IF g_piaa.piaa03 IS NULL THEN LET g_piaa.piaa03 = ' ' END IF
###          IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04 = ' ' END IF
###          IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05 = ' ' END IF
###          LET l_flag='N'
###          IF INT_FLAG THEN EXIT INPUT  END IF
###          IF g_piaa.piaa02 IS NULL OR g_piaa.piaa02 = ' ' THEN
###             LET l_flag='Y'
###             DISPLAY BY NAME g_piaa.piaa02 
###          END IF    
###          IF l_flag='Y' THEN
###             CALL cl_err('','9033',0)
###             NEXT FIELD piaa02
###          END IF
###
###        ON ACTION CONTROLP
###           CASE
###              WHEN INFIELD(piaa02) #查詢料件編號
###                   CALL cl_init_qry_var()
###                   LET g_qryparam.form = "q_ima"
###                   LET g_qryparam.default1 = g_piaa.piaa02
###                   CALL cl_create_qry() RETURNING g_piaa.piaa02
###                   DISPLAY BY NAME g_piaa.piaa02 
###                   CALL t852_piaa02('a')
###                   NEXT FIELD piaa02
###              WHEN INFIELD(piaa03) #倉庫
###                   CALL cl_init_qry_var()
###                   LET g_qryparam.form = "q_imd"
###                   LET g_qryparam.default1 = g_piaa.piaa03
###                    LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
###                   CALL cl_create_qry() RETURNING g_piaa.piaa03
###                   DISPLAY BY NAME g_piaa.piaa03 
###                   NEXT FIELD piaa03
###              WHEN INFIELD(piaa04) #儲位
###                   CALL cl_init_qry_var()
###                   LET g_qryparam.form = "q_ime"
###                   LET g_qryparam.default1 = g_piaa.piaa04
###                    LET g_qryparam.arg1     = g_piaa.piaa03 #倉庫編號 #MOD-4A0063
###                    LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
###                   CALL cl_create_qry() RETURNING g_piaa.piaa04
###                   DISPLAY BY NAME g_piaa.piaa04 
###                   NEXT FIELD piaa04
###              WHEN INFIELD(piaa05) #批號
###                   CALL cl_init_qry_var()
###                   LET g_qryparam.form = "q_img1"
###                   LET g_qryparam.default1 = g_piaa.piaa05
###                   CALL cl_create_qry() RETURNING g_piaa.piaa05
###                   DISPLAY BY NAME g_piaa.piaa05 
###                   NEXT FIELD piaa05
###              WHEN INFIELD(piaa07) #會計科目
###                   CALL cl_init_qry_var()
###                   LET g_qryparam.form = "q_aag"
###                   LET g_qryparam.default1 = g_piaa.piaa07
###                   LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
###                   CALL cl_create_qry() RETURNING g_piaa.piaa07
###                   DISPLAY BY NAME g_piaa.piaa07 
###                   NEXT FIELD piaa07
###              WHEN INFIELD(piaa09) #庫存單位
###                   CALL cl_init_qry_var()
###                   LET g_qryparam.form = "q_gfe"
###                   LET g_qryparam.default1 = g_piaa.piaa09
###                   CALL cl_create_qry() RETURNING g_piaa.piaa09
###                   DISPLAY BY NAME g_piaa.piaa09 
###                   NEXT FIELD piaa09
###              WHEN INFIELD(peo) #複盤人員
###                   CALL cl_init_qry_var()
###                   LET g_qryparam.form = "q_gen"
###                   LET g_qryparam.default1 = g_peo
###                   CALL cl_create_qry() RETURNING g_peo
###                   DISPLAY g_peo TO FORMONLY.peo 
###       	           CALL t852_peo('d','2',g_peo)
###                   NEXT FIELD peo  
###              OTHERWISE EXIT CASE
###           END CASE
###
###        ON ACTION mntn_unit
###           CALL cl_cmdrun("aooi101 ")
###  
###        ON ACTION mntn_unit_conv
###           CALL cl_cmdrun("aooi102 ")
###  
###        ON ACTION mntn_item_unit_conv
###           CALL cl_cmdrun("aooi103")
###  
###        ON ACTION def_imf
###           CALL cl_init_qry_var()
###           LET g_qryparam.form     = "q_imf"
###           LET g_qryparam.default1 = g_piaa.piaa03
###           LET g_qryparam.default2 = g_piaa.piaa04
###           LET g_qryparam.arg1     = g_piaa.piaa02
###           LET g_qryparam.arg2     = "A"
###           IF g_qryparam.arg2 != 'A' THEN
###              LET g_qryparam.where=g_qryparam.where CLIPPED,
###                  " AND ime04 matches'",g_qryparam.arg2,"' "
###           END IF
###           CALL cl_create_qry() RETURNING g_piaa.piaa03,g_piaa.piaa04
###           DISPLAY BY NAME g_piaa.piaa03,g_piaa.piaa04
###           NEXT FIELD piaa03
###  
###  
###        ON ACTION CONTROLZ
###           CALL cl_show_req_fields()
###
###        ON ACTION CONTROLG
###           CALL cl_cmdask()
###
###        ON ACTION CONTROLF                        # 欄位說明
###          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
###          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
###          
###    END INPUT
###END FUNCTION
#FUN-6B0019 remark end
   
FUNCTION t852_piaa01(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima906     LIKE ima_file.ima906,
           l_imaacti    LIKE ima_file.imaacti
    DEFINE l_piaa   RECORD   LIKE piaa_file.*    #FUN-6B0019
 
    LET g_errno = ' '
  
  #FUN-6B0019 begin
    #SELECT piaa_file.*, ima02,ima25,imaacti,ima906 
    #  INTO g_piaa.*, l_ima02,g_ima25,l_imaacti,l_ima906 
    #  FROM piaa_file, OUTER ima_file
    # WHERE piaa01 = g_piaa.piaa01 AND piaa_file.piaa02 = ima_file.ima01
    #   AND piaa09 = g_piaa.piaa09
    SELECT piaa_file.*, ima02,ima25,imaacti,ima906 
      INTO l_piaa.*, l_ima02,g_ima25,l_imaacti,l_ima906 
      FROM piaa_file, OUTER ima_file
     WHERE piaa01 = g_piaa[l_ac].piaa01 AND piaa_file.piaa02 = ima_file.ima01
       AND piaa09 = g_piaa[l_ac].piaa09
  #FUN-6B0019 end
    
    LET g_piaa[l_ac].piaa02 = l_piaa.piaa02 
    LET g_piaa[l_ac].piaa03 = l_piaa.piaa03    
    LET g_piaa[l_ac].piaa04 = l_piaa.piaa04 
    LET g_piaa[l_ac].piaa05 = l_piaa.piaa05    
    LET g_piaa[l_ac].piaa06 = l_piaa.piaa06 
    LET g_piaa[l_ac].piaa07 = l_piaa.piaa07
    LET g_piaa[l_ac].piaa09 = l_piaa.piaa09
    LET g_piaa[l_ac].piaa931 = l_piaa.piaa931                           #FUN-930122
    LET g_piaa16 = l_piaa.piaa16
    LET g_piaa19 = l_piaa.piaa19
    LET g_piaa08 = l_piaa.piaa08
    LET g_piaa66 = l_piaa.piaa66
    LET g_piaa67 = l_piaa.piaa67
    LET g_piaa68 = l_piaa.piaa68
    CASE WHEN SQLCA.SQLCODE = 100         LET g_errno = 'mfg0002' 
           #FUN-6B0019 begin
              #    LET g_piaa.piaa02 = NULL 
              #LET g_piaa.piaa03 = NULL    LET g_piaa.piaa04 = NULL
              #LET g_piaa.piaa05 = NULL    LET g_piaa.piaa06 = NULL 
              #LET g_piaa.piaa07 = NULL    LET g_piaa.piaa09 = NULL  
              LET l_ima02       = NULL    LET l_imaacti     = NULL
                  LET g_piaa[l_ac].piaa02 = NULL 
              LET g_piaa[l_ac].piaa03 = NULL    LET g_piaa[l_ac].piaa04 = NULL
              LET g_piaa[l_ac].piaa05 = NULL    LET g_piaa[l_ac].piaa06 = NULL 
              LET g_piaa[l_ac].piaa07 = NULL    LET g_piaa[l_ac].piaa09 = NULL
              LET g_piaa[l_ac].piaa931 = NULL                          #FUN-930122  
           #FUN-6B0019 end
    	 WHEN l_imaacti='N'               LET g_errno = '9028' 
      #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------    	 
         WHEN l_ima906 NOT MATCHES '[23]' LET  g_errno = 'asm-384' 
         OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------' 
    END CASE
    #LET g_piaa_t.* = g_piaa.*        #FUN-6B0019
    LET g_piaa_t.* = g_piaa[l_ac].*   #FUN-6B0019
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
      #FUN-6B0019 begin
       #DISPLAY BY NAME g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04,
       #                g_piaa.piaa05,g_piaa.piaa06,g_piaa.piaa07,
       #                g_piaa.piaa09
       #DISPLAY l_ima02 TO FORMONLY.ima02 
 
       DISPLAY BY NAME g_piaa[l_ac].piaa02,g_piaa[l_ac].piaa03,g_piaa[l_ac].piaa04,
                       g_piaa[l_ac].piaa05,g_piaa[l_ac].piaa06,g_piaa[l_ac].piaa07,
                       g_piaa[l_ac].piaa09,g_piaa[l_ac].piaa931                        #FUN-930122 Add piaa931 
       LET g_piaa[l_ac].ima02 = l_ima02
       DISPLAY BY NAME  g_piaa[l_ac].ima02
      #FUN-6B0019 end
 
       IF g_argv1 = '1' THEN 
        #FUN-6B0019 begin
          #LET g_qty     = g_piaa.piaa50
          #LET g_peo     = g_piaa.piaa54
          #LET g_tagdate = g_piaa.piaa55
          #IF g_tagdate IS NULL OR g_tagdate = ' ' THEN
          #   LET g_tagdate = g_tagdate_o
          #END IF
          #IF g_tagdate IS NULL OR g_tagdate = ' ' THEN 
          #   LET g_tagdate = g_today
          #END IF
          #IF g_peo IS NULL OR g_peo = '' THEN 
          #   LET g_peo = g_peo_o 
          #END IF
          #DISPLAY g_piaa.piaa50 TO FORMONLY.qty  
          #DISPLAY g_peo         TO FORMONLY.peo
          #DISPLAY g_tagdate     TO FORMONLY.tagdate
          #DISPLAY g_piaa.piaa30 TO FORMONLY.qty1 
          #DISPLAY g_piaa.piaa35 TO FORMONLY.tagdate1
          #DISPLAY g_piaa.piaa34 TO FORMONLY.peo1
          #LET g_peo2 = g_piaa.piaa34
 
 
          LET g_piaa[l_ac].qty     = l_piaa.piaa50
          LET g_piaa[l_ac].peo     = l_piaa.piaa54
          LET g_piaa[l_ac].tagdate = l_piaa.piaa55
          LET g_piaa[l_ac].qty1    = l_piaa.piaa30
          LET g_piaa[l_ac].peo1    = l_piaa.piaa34
          LET g_piaa[l_ac].tagdate1= l_piaa.piaa35
          IF g_piaa[l_ac].tagdate IS NULL OR g_piaa[l_ac].tagdate = ' ' THEN 
             LET g_piaa[l_ac].tagdate = g_today
          END IF
          IF g_piaa[l_ac].peo IS NULL OR g_piaa[l_ac].peo = '' THEN 
             LET g_piaa[l_ac].peo = g_piaa_o.peo 
          END IF
 
          DISPLAY BY NAME  g_piaa[l_ac].qty  
          DISPLAY BY NAME  g_piaa[l_ac].peo
          DISPLAY BY NAME  g_piaa[l_ac].tagdate
          DISPLAY BY NAME  g_piaa[l_ac].qty1 
          DISPLAY BY NAME  g_piaa[l_ac].tagdate1
          DISPLAY BY NAME  g_piaa[l_ac].peo1
      #FUN-6B0019 end
       ELSE 
      #FUN-6B0019 begin
          #LET g_qty     = g_piaa.piaa60
          #LET g_peo     = g_piaa.piaa64
          #LET g_tagdate = g_piaa.piaa65
          #IF g_tagdate IS NULL OR g_tagdate = ' ' THEN 
          #   LET g_tagdate = g_tagdate_o
          #END IF
          #IF g_tagdate IS NULL OR g_tagdate = ' ' THEN
          #   LET g_tagdate = g_today
          #END IF
          #IF g_peo IS NULL OR g_peo = '' THEN 
          #   LET g_peo = g_peo_o 
          #END IF
          #DISPLAY g_piaa.piaa60 TO FORMONLY.qty  
          #DISPLAY g_peo         TO FORMONLY.peo
          #DISPLAY g_tagdate     TO FORMONLY.tagdate
          #DISPLAY g_piaa.piaa40 TO FORMONLY.qty1 
          #DISPLAY g_piaa.piaa45 TO FORMONLY.tagdate1
          #DISPLAY g_piaa.piaa44 TO FORMONLY.peo1
          #LET g_peo2 = g_piaa.piaa44
 
 
          LET g_piaa[l_ac].qty     = l_piaa.piaa60
          LET g_piaa[l_ac].peo     = l_piaa.piaa64
          LET g_piaa[l_ac].tagdate = l_piaa.piaa65
          LET g_piaa[l_ac].qty1    = l_piaa.piaa40
          LET g_piaa[l_ac].peo1    = l_piaa.piaa44
          LET g_piaa[l_ac].tagdate1= l_piaa.piaa45
          IF g_piaa[l_ac].tagdate IS NULL OR g_piaa[l_ac].tagdate = ' ' THEN 
             LET g_piaa[l_ac].tagdate = g_today
          END IF
          IF g_piaa[l_ac].peo IS NULL OR g_piaa[l_ac].peo = '' THEN 
             LET g_piaa[l_ac].peo = g_piaa_o.peo
          END IF
          DISPLAY BY NAME g_piaa[l_ac].qty  
          DISPLAY BY NAME g_piaa[l_ac].peo
          DISPLAY BY NAME g_piaa[l_ac].tagdate
          DISPLAY BY NAME g_piaa[l_ac].qty1 
          DISPLAY BY NAME g_piaa[l_ac].tagdate1
          DISPLAY BY NAME g_piaa[l_ac].peo1
      #FUN-6B0019 end
       END IF
 
 
      #FUN-6B0019 begin
       #IF g_peo IS NOT NULL AND g_peo != ' ' THEN 
       #   CALL t852_peo('d','2',g_peo)
       #END IF
       #IF g_peo2 IS NOT NULL AND g_peo2 != ' ' THEN 
       #   CALL t852_peo('d','1',g_peo2)
       #END IF
 
       IF g_piaa[l_ac].peo IS NOT NULL AND g_piaa[l_ac].peo != ' ' THEN 
          CALL t852_peo('d','2',g_piaa[l_ac].peo)
       END IF
       IF g_piaa[l_ac].peo1 IS NOT NULL AND g_piaa[l_ac].peo1 != ' ' THEN 
          CALL t852_peo('d','1',g_piaa[l_ac].peo1)
       END IF
      #FUN-6B0019 begin
    END IF
END FUNCTION
 
 
   
FUNCTION t852_piaa02(p_cmd)  #料件編號
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima08      LIKE ima_file.ima08,
           l_ima906     LIKE ima_file.ima906,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
    LET l_ima02=' '
    SELECT ima02,ima08,ima25,imaacti,ima906 
      INTO l_ima02,l_ima08,g_ima25,l_imaacti,l_ima906
      FROM ima_file 
     #WHERE ima01 = g_piaa.piaa02        #FUN-6B0019
     WHERE ima01 = g_piaa[l_ac].piaa02   #FUN-6B0019
 
    CASE WHEN SQLCA.SQLCODE = 100         LET g_errno = 'mfg0002' 
                                          LET l_ima02 = NULL 
    	 WHEN l_imaacti='N'               LET g_errno = '9028' 
      #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------    	 
         WHEN l_ima906 NOT MATCHES '[23]' LET  g_errno = 'asm-384' 
         OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------' 
    END CASE
  #FUN-6B0019 begin
    #IF g_piaa.piaa66 IS NULL OR g_piaa.piaa66 = ' ' THEN    
    #   CALL s_cost('1',l_ima08,g_piaa.piaa02) RETURNING g_piaa.piaa66
    #END IF
    #IF g_piaa.piaa67 IS NULL OR g_piaa.piaa67 = ' ' THEN    #FUN-6B0019
    #   CALL s_cost('2',l_ima08,g_piaa.piaa02) RETURNING g_piaa.piaa67
    #END IF
    #IF g_piaa.piaa68 IS NULL OR g_piaa.piaa68 = ' ' THEN 
    #   CALL s_cost('3',l_ima08,g_piaa.piaa02) RETURNING g_piaa.piaa68
    #END IF
    #IF g_piaa.piaa08 IS NULL OR g_piaa.piaa08 = ' ' THEN 
    #   LET g_piaa.piaa08 = 0
    #END IF
    #IF p_cmd = 'a' THEN LET g_piaa.piaa09 = g_ima25 END IF
 
    IF g_piaa66 IS NULL OR g_piaa66 = ' ' THEN               #FUN-6B0019
       CALL s_cost('1',l_ima08,g_piaa[l_ac].piaa02) RETURNING g_piaa66
    END IF
    IF g_piaa67 IS NULL OR g_piaa67 = ' ' THEN               #FUN-6B0019
       CALL s_cost('2',l_ima08,g_piaa[l_ac].piaa02) RETURNING g_piaa67
    END IF
    IF g_piaa68 IS NULL OR g_piaa68 = ' ' THEN 
       CALL s_cost('3',l_ima08,g_piaa[l_ac].piaa02) RETURNING g_piaa68
    END IF
    IF g_piaa08 IS NULL OR g_piaa08 = ' ' THEN 
       LET g_piaa08 = 0
    END IF
    IF p_cmd = 'a' THEN LET g_piaa[l_ac].piaa09 = g_ima25 END IF
   #FUN-6B0019 end
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
      #FUN-6B0019 begin
        #DISPLAY l_ima02 TO FORMONLY.ima02 
        #DISPLAY BY NAME g_piaa.piaa09       
        LET g_piaa[l_ac].ima02 = l_ima02
        DISPLAY BY NAME g_piaa[l_ac].ima02 
        DISPLAY BY NAME g_piaa[l_ac].piaa09       
      #FUN-6B0019 end
    END IF
END FUNCTION
 
 
 
#檢查單位是否存在於單位檔中
FUNCTION t852_unit(p_cmd)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gfe02      LIKE gfe_file.gfe02,
           l_gfeacti    LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti
      #FROM gfe_file WHERE gfe01 = g_piaa.piaa09        #FUN-6B0019
      FROM gfe_file WHERE gfe01 = g_piaa[l_ac].piaa09   #FUN-6B0019
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                                  LET l_gfe02 = NULL
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
   
#盤點人員
FUNCTION t852_peo(p_cmd,p_code,p_peo)  
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           p_code       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           p_peo        LIKE gen_file.gen01,
           l_gen02      LIKE gen_file.gen02,
           l_genacti    LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file 
     WHERE gen01 = p_peo
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3096'
                                  LET l_gen02 = NULL
         WHEN l_genacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       IF p_code = '1' THEN 
          #DISPLAY l_gen02 TO FORMONLY.gen02_1    #FUN-6B0019
          LET g_piaa[l_ac].gen02_1 = l_gen02
       ELSE 
          #DISPLAY l_gen02 TO FORMONLY.gen02_2    #FUN-6B0019
          LET g_piaa[l_ac].gen02_2 = l_gen02
       END IF
    END IF
END FUNCTION
 
FUNCTION t852_q()
  #FUN-6B0019 begin
    ###LET g_row_count = 0
    ###LET g_curs_index = 0
    ###CALL cl_navigator_setting( g_curs_index, g_row_count )
    ###MESSAGE ""
    ###CALL cl_opmsg('q')
    ###DISPLAY '   ' TO FORMONLY.cnt  
    ###CALL t852_cs()                          # 宣告 SCROLL CURSOR
    ###IF INT_FLAG THEN
    ###   LET INT_FLAG = 0
    ###   CLEAR FORM
    ###   RETURN
    ###END IF
    ###OPEN t852_count
    ###FETCH t852_count INTO g_row_count
    ###DISPLAY g_row_count TO FORMONLY.cnt  
    ###OPEN t852_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    ###IF SQLCA.sqlcode THEN
    ###   CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
    ###   INITIALIZE g_piaa.* TO NULL
    ###   LET g_qty     = NULL
    ###   LET g_peo     = NULL
    ###   LET g_tagdate = NULL
    ###ELSE
    ###   CALL t852_fetch('F')                  # 讀出TEMP第一筆並顯示
    ###END IF
 
    CALL t852_b_askkey()
  #FUN-6B0019 end
END FUNCTION
 
 
#FUN-6B0019 add begin
FUNCTION t852_b_askkey()
DEFINE  l_flag          LIKE type_file.chr1,    #FUN-CB0087
        l_where         STRING                  #FUN-CB0087
 
  CLEAR FORM
  CALL g_piaa.clear()
  IF NOT cl_null(g_argv2) THEN
     LET g_wc2=" piaa01='",g_argv2,"'"
  ELSE
    CONSTRUCT g_wc2 ON                    # 螢幕上取條件
          piaa01, piaa09, piaa02, piaa03,
          piaa04, piaa05, piaa06, piaa07,piaa931,piaa70         #FUN-930122 Add piaa931  #FUN-CB0087 add piaa70
        FROM 
          s_piaa[1].piaa01, s_piaa[1].piaa09, 
          s_piaa[1].piaa02, s_piaa[1].piaa03, 
          s_piaa[1].piaa04, s_piaa[1].piaa05, 
          s_piaa[1].piaa06, s_piaa[1].piaa07,
          s_piaa[1].piaa931,s_piaa[1].piaa70                   #FUN-930122 Add piaa931 #FUN-CB0087 add piaa70
          
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
        CASE
            WHEN INFIELD(piaa02) #查詢料件編號
#FUN-AA0059 --Begin--
            #  CALL cl_init_qry_var()
            #  LET g_qryparam.state    = "c"
            #  LET g_qryparam.form     ="q_ima"
            #  CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
              DISPLAY g_qryparam.multiret TO piaa02 
              NEXT FIELD piaa02
           WHEN INFIELD(piaa03) #倉庫
#FUN-AA0061 --modify
#             CALL cl_init_qry_var()
#             LET g_qryparam.state    = "c"
#             LET g_qryparam.form     ="q_imd"
#             LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#             CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret
#FUN-AA0061 --end
              DISPLAY g_qryparam.multiret TO piaa03 
              NEXT FIELD piaa03
           WHEN INFIELD(piaa07) #會計科目
             CALL cl_init_qry_var()
             LET g_qryparam.state    = "c"
             LET g_qryparam.form     ="q_aag"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO piaa07 
             NEXT FIELD piaa07
           WHEN INFIELD(piaa09) #庫存單位
             CALL cl_init_qry_var()
             LET g_qryparam.state    = "c"
             LET g_qryparam.form     = "q_gfe"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO piaa09 
             NEXT FIELD piaa09
           WHEN INFIELD(peo) #初盤人員
             CALL cl_init_qry_var()
             LET g_qryparam.state    = "c"
             LET g_qryparam.form     = "q_gen"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO peo
             NEXT FIELD peo
           WHEN INFIELD(piaa04) #儲位
#FUN-AA0061 --modify
#             CALL cl_init_qry_var()
#             LET g_qryparam.state    = "c"
#             LET g_qryparam.form     = "q_ime"
#             CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
#FUN-AA0061 --end
             DISPLAY g_qryparam.multiret TO piaa04
             NEXT FIELD piaa04 
           WHEN INFIELD(piaa05) #批號
             CALL cl_init_qry_var()
             LET g_qryparam.state    = "c"
             LET g_qryparam.form     = "q_img"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO piaa05
             NEXT FIELD piaa05
           #FUN-930122--Begin--#  
           WHEN INFIELD(piaa931)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_piaa931"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO piaa931
             NEXT FIELD piaa931
             #FUN-930122--End--#             
          #FUN-CB0087---add---str---
          WHEN INFIELD(piaa70) #理由
             CALL cl_init_qry_var()
             LET g_qryparam.form     ="q_azf41"
             LET g_qryparam.state = "c"
            #LET g_qryparam.default1 = g_piaa[l_ac].piaa70  #TQC-D20042
            #CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa70   #TQC-D20042
            #DISPLAY g_piaa[l_ac].piaa70 TO piaa70                #TQC-D20042  
            #CALL t852_azf03()                                    #TQC-D20042
             CALL cl_create_qry() RETURNING g_qryparam.multiret   #TQC-D20042
             DISPLAY g_qryparam.multiret TO piaa70                #TQC-D20042
             NEXT FIELD piaa70
          #FUN-CB0087---add---end---
          OTHERWISE EXIT CASE
       END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controlg    
          CALL cl_cmdask()     
 
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
  END IF
  CALL t852_b_fill(g_wc2)
END FUNCTION
#FUN-6B0019 add end
 
 
 
#FUN-6B0019 add begin
FUNCTION t852_b()
  DEFINE
    l_ac_t       LIKE type_file.num5,          #未取消的ARRAY CNT
    l_n          LIKE type_file.num5,          #檢查重複用#No.FU
    l_lock_sw    LIKE type_file.chr1,          #單身鎖住否#No.F
    p_cmd        LIKE type_file.chr1,          #處理狀態#No.FUN
    l_flag       LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1       
  DEFINE l_piaa  RECORD LIKE piaa_file.*,
         l_piaa16    LIKE piaa_file.piaa16,
         l_piaa19    LIKE piaa_file.piaa19
  DEFINE l_i,l_j    LIKE type_file.num5
  DEFINE l_ima906       LIKE ima_file.ima906
  DEFINE l_sum          LIKE piaa_file.piaa30
  DEFINE l_pia09        LIKE pia_file.pia09,
         l_pia10        LIKE pia_file.pia10,
         l_ima25        LIKE ima_file.ima25,
         l_mesg,l_str   LIKE ze_file.ze03,     
         l_cnt          LIKE type_file.num10,
         l_where         STRING,                 #FUN-CB0087
         l_sql           STRING                  #FUN-CB0087  
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    LET g_forupd_sql = "SELECT piaa01,piaa09,piaa02,'',",
                       "       piaa03,piaa04,piaa05,piaa06,piaa07,",
                       "       0,'','','',0,'','','',piaa931,piaa70,''",   #FUN-930122 Add piaa931  #FUN-CB0087 add piaa70,''
                       "  FROM piaa_file WHERE piaa01 = ? AND piaa09 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t852_bcl CURSOR FROM g_forupd_sql      # LOCK CU
 
    INPUT ARRAY g_piaa WITHOUT DEFAULTS FROM s_piaa.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW = l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_before_input_done = FALSE
            CALL t852_set_entry(p_cmd)
            CALL t852_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            LET g_piaa_t.* = g_piaa[l_ac].*  #BACKUP
            LET g_piaa_o.* = g_piaa[l_ac].*  #BACKUP
            SELECT piaa10,piaa19,piaa08 INTO g_piaa10,g_piaa19,g_piaa08 FROM piaa_file  #MOD-CB0268 add piaa08
             WHERE piaa01 = g_piaa[l_ac].piaa01
               AND piaa09 = g_piaa[l_ac].piaa09
            IF g_piaa19 = 'Y' THEN  #已過帳，不可更改
              CALL cl_err(g_piaa[l_ac].piaa01,'mfg0132',1) 
              LET l_j = 0
              FOR l_i = l_ac TO g_rec_b
                SELECT piaa19 INTO l_piaa19 FROM piaa_file
                 WHERE piaa01 = g_piaa[l_i].piaa01
                   AND piaa09 = g_piaa[l_i].piaa09
                IF l_piaa19 = 'N' THEN
                  LET l_j = l_i
                  EXIT FOR
                END IF
              END FOR
              IF l_j <> 0 THEN
                  LET l_ac = l_j  
                  CALL fgl_set_arr_curr(l_ac)
                  CONTINUE INPUT         #TQC-D20047
                  LET g_before_input_done = FALSE
                  CALL t852_set_entry(p_cmd)
                  CALL t852_set_no_entry(p_cmd)
                  LET g_before_input_done = TRUE
                  LET g_piaa_t.* = g_piaa[l_ac].*  #BACKUP
                  LET g_piaa_o.* = g_piaa[l_ac].*  #BACKUP
              ELSE
                  ROLLBACK WORK
                  EXIT INPUT
              END IF
            END IF
            OPEN t852_bcl USING g_piaa_t.piaa01,g_piaa_t.piaa09
            IF STATUS THEN
               CALL cl_err("OPEN t852_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t852_bcl INTO g_piaa[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_piaa_t.piaa01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL t852_piaa02('d')
               CALL t852_peo_show()
               CALL t852_azf03()  #FUN-CB0087
               IF cl_null(g_piaa[l_ac].peo) THEN 
                 IF l_ac > 1 THEN
                   LET g_piaa[l_ac].peo = g_piaa[ l_ac-1 ].peo
                   LET g_piaa[l_ac].gen02_2 = g_piaa[ l_ac-1 ].gen02_2
                   #SELECT gen01,gen02 INTO g_piaa[l_ac].peo,g_piaa[l_ac].gen02_2
                   #  FROM zx_file,gen_file
                   # WHERE zx02 = gen02
                   #   AND zx01 = g_user
                 END IF
               END IF
               #LET g_piaa[l_ac].peo = g_user
               LET g_piaa[l_ac].tagdate = g_today
               DISPLAY BY NAME g_piaa[l_ac].peo,
                               g_piaa[l_ac].gen02_2,
                               g_piaa[l_ac].tagdate
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
 
         LET g_before_input_done = FALSE
         CALL t852_set_entry(p_cmd)
         CALL t852_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
         INITIALIZE g_piaa[l_ac].* TO NULL      
         LET g_piaa16 = 'N'
         LET g_piaa19 = 'N'
         LET g_piaa[l_ac].piaa01 = g_piaa_t.piaa01
         LET g_piaa[l_ac].piaa02 = g_piaa_t.piaa02
         LET g_piaa[l_ac].ima02  = g_piaa_t.ima02
         LET g_piaa[l_ac].piaa03 = g_piaa_t.piaa03
         LET g_piaa[l_ac].piaa04 = g_piaa_t.piaa04
         LET g_piaa[l_ac].piaa05 = g_piaa_t.piaa05
         CALL cl_show_fld_cont()     
         INITIALIZE g_piaa_o.* TO NULL
         INITIALIZE g_piaa_t.* TO NULL
         NEXT FIELD piaa01
 
      #AFTER INSERT
      #  IF INT_FLAG THEN
      #      CALL cl_err('',9001,0)
      #      LET INT_FLAG = 0
      #      CLOSE t852_bcl
      #      CANCEL INSERT
      #  END IF
 
      #  INITIALIZE l_piaa.* TO NULL
 
      #  IF g_piaa[l_ac].piaa01 IS NULL THEN
      #     SELECT MAX(piaa01) INTO g_piaa[l_ac].piaa01 FROM piaa_file
      #     LET g_piaa[l_ac].piaa01[g_no_sp,g_no_ep]=(g_piaa[l_ac].piaa01[g_no_sp,g_no_ep] + 1) using '&&&&&&'
      #     IF g_piaa[l_ac].piaa01 IS NULL THEN LET g_piaa[l_ac].piaa01='STK-000001' END IF
      #  END IF
      #  IF cl_null(g_piaa[l_ac].piaa09) THEN
      #     NEXT FIELD piaa09
      #  END IF
      #  IF g_piaa[l_ac].piaa03 IS NULL THEN LET g_piaa[l_ac].piaa03 = ' ' END IF
      #  IF g_piaa[l_ac].piaa04 IS NULL THEN LET g_piaa[l_ac].piaa04 = ' ' END IF
      #  IF g_piaa[l_ac].piaa05 IS NULL THEN LET g_piaa[l_ac].piaa05 = ' ' END IF
 
      #  LET l_piaa.piaa30 = g_piaa[l_ac].qty
      #  LET l_piaa.piaa31 = g_user
      #  LET l_piaa.piaa32 = g_today
      #  LET l_piaa.piaa33 = TIME  
      #  LET l_piaa.piaa34 = g_piaa[l_ac].peo
      #  LET l_piaa.piaa35 = g_piaa[l_ac].tagdate
      #  SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_piaa[l_ac].piaa02
      #  IF l_ima906='2' THEN LET l_piaa.piaa00='1' END IF
      #  IF l_ima906='3' THEN LET l_piaa.piaa00='2' END IF
      #  LET l_piaa.piaa01 = g_piaa[l_ac].piaa01
      #  LET l_piaa.piaa02 = g_piaa[l_ac].piaa02
      #  LET l_piaa.piaa03 = g_piaa[l_ac].piaa03
      #  LET l_piaa.piaa04 = g_piaa[l_ac].piaa04
      #  LET l_piaa.piaa05 = g_piaa[l_ac].piaa05
      #  LET l_piaa.piaa06 = g_piaa[l_ac].piaa06
      #  LET l_piaa.piaa07 = g_piaa[l_ac].piaa07
      #  LET l_piaa.piaa08 = g_piaa08
      #  LET l_piaa.piaa09 = g_piaa[l_ac].piaa09
      #  LET l_piaa.piaa10 = g_piaa10
      #  LET l_piaa.piaa13 = g_today
      #  LET l_piaa.piaa16 = g_piaa[l_ac].piaa16
      #  LET l_piaa.piaa19 = g_piaa[l_ac].piaa19
      #  LET l_piaa.piaa66  = g_piaa66
      #  LET l_piaa.piaa67  = g_piaa67
      #  LET l_piaa.piaa68  = g_piaa68
      #  LET l_piaa.piaa930 = g_piaa930
      #  INSERT INTO piaa_file VALUES (l_piaa.*)
      #  IF SQLCA.sqlcode THEN
      #     CALL cl_err3("ins","piaa_file",g_piaa[l_ac].piaa01,"",SQLCA.sqlcode,"","",0)
      #     CANCEL INSERT
      #  ELSE
      #     MESSAGE 'INSERT O.K'
      #     LET g_rec_b=g_rec_b+1
      #     DISPLAY g_rec_b TO FORMONLY.cnt
      #     COMMIT WORK
      #  END IF
 
      #  SELECT ima906 INTO l_ima906 FROM ima_file
      #   WHERE ima01=g_piaa[l_ac].piaa02
      # IF (l_ima906 = '2') OR (l_ima906='3') THEN
      #     LET l_sum=0
      #     SELECT SUM(piaa30*piaa10) INTO l_sum FROM piaa_file
      #      WHERE piaa01=g_piaa[l_ac].piaa01
      #        AND piaa02=g_piaa[l_ac].piaa02
      #        AND piaa03=g_piaa[l_ac].piaa03
      #        AND piaa04=g_piaa[l_ac].piaa04
      #        AND piaa05=g_piaa[l_ac].piaa05
      #        AND piaa30 IS NOT NULL
      #        AND piaa10 IS NOT NULL
      #     IF cl_null(l_sum) THEN
      #        LET l_sum=0
      #     END IF
      #     SELECT pia09,ima25 INTO l_pia09,l_ima25 FROM pia_file,ima_file
      #        WHERE pia01=g_piaa[l_ac].piaa01 and ima01=pia02
      #     CALL s_umfchk(g_piaa[l_ac].piaa02,l_ima25,l_pia09)
      #          RETURNING l_cnt,l_pia10
      #     IF l_cnt THEN
      #        LET l_pia10=1
      #     END IF
      #     LET l_sum = l_sum*l_pia10
 
      #     IF cl_null(g_argv2) THEN
      #        UPDATE pia_file SET pia30=l_sum, 
      #         pia44=g_piaa[l_ac].peo,pia45=g_piaa[l_ac].tagdate                               
      #         WHERE pia01=g_piaa[l_ac].piaa01
      #           AND pia02=g_piaa[l_ac].piaa02
      #           AND pia03=g_piaa[l_ac].piaa03
      #           AND pia04=g_piaa[l_ac].piaa04
      #           AND pia05=g_piaa[l_ac].piaa05
      #        IF SQLCA.sqlcode THEN
      #           CALL cl_err3("upd","pia_file",g_piaa[l_ac].piaa01,g_piaa[l_ac].piaa09,SQLCA.sqlcode,
      #                        "","update pia",1)  
      #        END IF
      #     END IF
      #  END IF
 
 
        AFTER FIELD piaa01 
           IF p_cmd='z' AND g_piaa[l_ac].piaa01 IS NULL OR g_piaa[l_ac].piaa01 = ' '
              THEN NEXT FIELD piaa01
           END IF
            
           IF p_cmd <> 'a' THEN
              SELECT COUNT(*) INTO g_cnt FROM piaa_file
               WHERE piaa01=g_piaa[l_ac].piaa01
              IF g_cnt=0 THEN
                 CALL cl_err(g_piaa[l_ac].piaa01,'mfg0114',0)
                 NEXT FIELD piaa01
              END IF
           END IF
           CALL t852_set_entry(p_cmd)
           CALL t852_set_no_entry(p_cmd)
          
           LET g_piaa_o.piaa01 = g_piaa[l_ac].piaa01
           #FUN-CB0087--add--str--
           IF NOT t852_piaa70_chk() THEN
              NEXT FIELD piaa70
           END IF
           #FUN-CB0087--add--end--
 
 
        BEFORE FIELD piaa09
           CALL t852_set_entry(p_cmd)
 
 
        AFTER FIELD piaa09 
         IF g_piaa_o.piaa09 IS NULL OR (g_piaa[l_ac].piaa09 !=g_piaa_o.piaa09) THEN
            CALL t852_unit('a') 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_piaa[l_ac].piaa09,g_errno,0)
               LET g_piaa[l_ac].piaa09 = g_piaa_o.piaa09
               DISPLAY BY NAME g_piaa[l_ac].piaa09
               NEXT FIELD piaa09
            END IF
            IF g_sma.sma12 = 'Y' THEN 
               CALL s_umfchk(g_piaa[l_ac].piaa02,g_ima25,g_piaa[l_ac].piaa09)
                    RETURNING g_cnt,g_piaa10
               IF g_cnt THEN 
                  CALL cl_err('','mfg3075',0)
                  LET g_piaa[l_ac].piaa09 = g_piaa_o.piaa09
                  DISPLAY BY NAME g_piaa[l_ac].piaa09
                  NEXT FIELD piaa09
               END IF
            ELSE
               LET g_piaa10 = 1
            END IF
         END IF
         CALL t852_piaa01('d')
         IF NOT cl_null(g_errno)  THEN 
            CALL cl_err(g_piaa[l_ac].piaa01,'mfg0114',1)
            NEXT FIELD piaa01
         END IF
         
         SELECT piaa16,piaa19 INTO l_piaa16,l_piaa19 FROM piaa_file
          WHERE piaa01=g_piaa[l_ac].piaa01  AND piaa09=g_piaa[l_ac].piaa09
         IF l_piaa19 ='Y' THEN 
            CALL cl_err(g_piaa[l_ac].piaa01,'mfg0132',1) 
            EXIT INPUT
         END IF
         LET g_piaa_o.piaa02 = g_piaa[l_ac].piaa02
         IF g_piaa[l_ac].peo IS NULL OR g_piaa[l_ac].peo =' ' THEN 
            LET g_piaa[l_ac].peo  = g_piaa_t.peo
            LET g_piaa[l_ac].qty=s_digqty(g_piaa[l_ac].qty,g_piaa[l_ac].piaa09)   #No.FUN-BB0086
            DISPLAY BY NAME g_piaa[l_ac].qty   #No.FUN-BB0086
            DISPLAY BY NAME g_piaa[l_ac].peo
         END IF
         IF g_piaa[l_ac].tagdate IS NULL OR g_piaa[l_ac].tagdate =' ' THEN 
            LET g_piaa[l_ac].tagdate = g_today 
            DISPLAY BY NAME g_piaa[l_ac].tagdate 
         END IF
         LET g_piaa_o.piaa09 = g_piaa[l_ac].piaa09
         CALL t852_set_no_entry(p_cmd)
 
        BEFORE FIELD piaa02
          IF g_sma.sma60 = 'Y' THEN	# 若須分段輸入
            CALL s_inp5(7,23,g_piaa[l_ac].piaa02) RETURNING g_piaa[l_ac].piaa02
            DISPLAY BY NAME g_piaa[l_ac].piaa02 
            IF INT_FLAG THEN 
               LET INT_FLAG = 0 
            END IF
       	  END IF
        #顯示舊值
          IF g_piaa_t.piaa02 IS NOT NULL AND g_piaa_t.piaa02 != ' ' THEN 
               CALL cl_getmsg('mfg6194',g_lang) RETURNING l_mesg
               LET l_mesg = l_mesg clipped,g_piaa_t.piaa02
               ERROR l_mesg 
          END IF
 
 
        AFTER FIELD piaa02      #料件編
          IF NOT cl_null(g_piaa[l_ac].piaa02) THEN 
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_piaa[l_ac].piaa02,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_piaa[l_ac].piaa02= g_piaa_t.piaa02
               NEXT FIELD piaa02
            END IF
#FUN-AA0059 ---------------------end-------------------------------
             IF g_piaa_o.piaa02 IS NULL OR 
                  (g_piaa_o.piaa02 != g_piaa[l_ac].piaa02) THEN
                   CALL t852_piaa02('d')
                   IF NOT cl_null(g_errno)  THEN 
                      CALL cl_err(g_piaa[l_ac].piaa02,g_errno,1)
                      LET g_piaa[l_ac].piaa02 = g_piaa_o.piaa02
                      DISPLAY BY NAME g_piaa[l_ac].piaa02 
                      NEXT FIELD piaa02
                   END IF
                   LET g_piaa[l_ac].qty=s_digqty(g_piaa[l_ac].qty,g_piaa[l_ac].piaa09)   #No.FUN-BB0086
                   DISPLAY BY NAME g_piaa[l_ac].qty   #No.FUN-BB0086
             END IF
             #使用者為單倉時，只須檢查盤點資料檔中是否有此料號
             IF g_sma.sma12 = 'N' THEN
                SELECT COUNT(*) INTO l_n FROM piaa_file
                    WHERE piaa02=g_piaa[l_ac].piaa02 
                IF l_n IS NOT NULL AND l_n > 0 THEN
                   CALL cl_err(g_piaa[l_ac].piaa02,'mfg6084',1)
                      LET g_piaa[l_ac].piaa02 = g_piaa_o.piaa02
                      DISPLAY BY NAME g_piaa[l_ac].piaa02 
                      NEXT FIELD piaa02
                END IF
             END IF
             IF g_piaa_t.piaa02 != g_piaa[l_ac].piaa02 THEN
                CALL cl_getmsg('mfg6190',g_lang) RETURNING l_str
                IF NOT cl_prompt(0,0,l_str) THEN
                   NEXT FIELD piaa02 
                END IF
             END IF
             LET g_piaa_o.piaa02 = g_piaa[l_ac].piaa02
              #FUN-CB0087--add--str--
              IF NOT t852_piaa70_chk() THEN
                 NEXT FIELD piaa70
              END IF
              #FUN-CB0087--add--end--
          END IF
 
 
        BEFORE FIELD piaa03 
          #顯示舊值
          IF g_piaa_t.piaa03 IS NOT NULL AND g_piaa_t.piaa03 != ' ' THEN
             CALL cl_getmsg('mfg6195',g_lang) RETURNING l_mesg
             LET l_mesg = l_mesg clipped,g_piaa_t.piaa03
             ERROR l_mesg 
          END IF
 
 
        #倉庫編號  
        AFTER FIELD piaa03 
          IF NOT cl_null(g_piaa[l_ac].piaa03) THEN 
              #---->依系統參數的設定,檢查倉庫的使用
              IF NOT s_stkchk(g_piaa[l_ac].piaa03,'A') THEN 
                 CALL cl_err(g_piaa[l_ac].piaa03,'mfg6076',1)    
                 LET g_piaa[l_ac].piaa03 = g_piaa_o.piaa03
                 DISPLAY BY NAME g_piaa[l_ac].piaa03 
                 NEXT FIELD piaa03
              END IF
              IF g_piaa_t.piaa03 != g_piaa[l_ac].piaa03 THEN
                 CALL cl_getmsg('mfg6191',g_lang) RETURNING l_str
                 IF NOT cl_prompt(0,0,l_str) THEN
                    NEXT FIELD piaa03 
                 END IF
              END IF
#FUN-AA0061 --add
              IF NOT s_chk_ware(g_piaa[l_ac].piaa03) THEN
                 NEXT FIELD piaa03
              END IF
#FUN-AA0061 --end
              LET g_piaa_o.piaa03 = g_piaa[l_ac].piaa03
              #FUN-CB0087--add--str--
              IF NOT t852_piaa70_chk() THEN
                 NEXT FIELD piaa70
              END IF
              #FUN-CB0087--add--end--
          END IF
 
 
        BEFORE FIELD piaa04  #儲位
           #顯示舊值
           IF g_piaa_t.piaa04 IS NOT NULL AND g_piaa_t.piaa04 != ' ' THEN
              CALL cl_getmsg('mfg6196',g_lang) RETURNING l_mesg
              LET l_mesg = l_mesg clipped,g_piaa_t.piaa04
              ERROR l_mesg 
           END IF
 
        AFTER FIELD piaa04  #儲位
           IF g_piaa[l_ac].piaa04 IS NULL THEN LET g_piaa[l_ac].piaa04 = ' ' END IF
           IF g_piaa[l_ac].piaa04 IS NOT NULL AND g_piaa[l_ac].piaa04 != ' ' THEN
              #---->檢查料件儲位的使用
              CALL s_prechk(g_piaa[l_ac].piaa02,g_piaa[l_ac].piaa03,g_piaa[l_ac].piaa04)
                   RETURNING g_cnt,g_chr  
              IF NOT g_cnt THEN
                 CALL cl_err(g_piaa[l_ac].piaa04,'mfg1102',1)
                 LET g_piaa[l_ac].piaa04 = g_piaa_o.piaa04
                 DISPLAY BY NAME g_piaa[l_ac].piaa04 
                 NEXT FIELD piaa04
              END IF
           END IF
           IF g_piaa_t.piaa04 != g_piaa[l_ac].piaa04 THEN
              CALL cl_getmsg('mfg6192',g_lang) RETURNING l_str
              IF NOT cl_prompt(0,0,l_str) THEN
                 NEXT FIELD piaa04 
              END IF
           END IF
           LET g_piaa_o.piaa04 = g_piaa[l_ac].piaa04
 
        BEFORE FIELD piaa05  
           #顯示舊值
           IF g_piaa_t.piaa05 IS NOT NULL AND g_piaa_t.piaa05 != ' ' THEN 
              CALL cl_getmsg('mfg6197',g_lang) RETURNING l_mesg
              LET l_mesg = l_mesg clipped,g_piaa_t.piaa05
              ERROR l_mesg 
           END IF
 
        AFTER FIELD piaa05  #批號
           IF g_piaa[l_ac].piaa05 IS NULL THEN LET g_piaa[l_ac].piaa05 = ' ' END IF
           #---->資料是否重複檢查
           IF (g_piaa_t.piaa02 != g_piaa[l_ac].piaa02) OR 
              (g_piaa_t.piaa03 != g_piaa[l_ac].piaa03) OR 
              (g_piaa_t.piaa04 != g_piaa[l_ac].piaa04) OR 
              (g_piaa_t.piaa05 != g_piaa[l_ac].piaa05) THEN
    	      SELECT COUNT(*) INTO l_n
    	        FROM piaa_file
    	       WHERE piaa02=g_piaa[l_ac].piaa02 AND piaa03=g_piaa[l_ac].piaa03
    	         AND piaa04=g_piaa[l_ac].piaa04 AND piaa05=g_piaa[l_ac].piaa05
    	         AND piaa09=g_piaa[l_ac].piaa09
    	      IF l_n IS NOT NULL AND l_n > 0 THEN
    	          CALL cl_err(g_piaa[l_ac].piaa05,'mfg6084',1)
                  LET g_piaa[l_ac].piaa05 = g_piaa_o.piaa05
                  DISPLAY BY NAME g_piaa[l_ac].piaa05 
                  NEXT FIELD piaa05
              END IF
           END IF
           IF g_piaa_t.piaa05 != g_piaa[l_ac].piaa05 THEN 
              CALL cl_getmsg('mfg6193',g_lang) RETURNING l_str
              IF NOT cl_prompt(0,0,l_str) THEN
                 NEXT FIELD piaa05 
              END IF
           END IF
           LET g_piaa_o.piaa05 = g_piaa[l_ac].piaa05
 
 
        AFTER FIELD piaa07  
           IF g_piaa[l_ac].piaa07 IS NOT NULL THEN
              IF g_sma.sma03='Y' THEN
                 IF NOT s_actchk3(g_piaa[l_ac].piaa07,g_aza.aza81) THEN  #No.FUN-730033
                    #FUN-B10049--begin
                    #CALL cl_err(g_piaa[l_ac].piaa07,'mfg0018',1)
                    CALL cl_err(g_piaa[l_ac].piaa07,'mfg0018',0)
                    CALL cl_init_qry_var()                                         
                    LET g_qryparam.form ="q_aag"                                   
                    LET g_qryparam.default1 = g_piaa[l_ac].piaa07  
                    LET g_qryparam.construct = 'N'                
                    LET g_qryparam.arg1 = g_aza.aza81  
                    LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_piaa[l_ac].piaa07 CLIPPED,"%' "            
                    CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa07
                    DISPLAY BY NAME g_piaa[l_ac].piaa07 
                    #FUN-B10049--end                      
                    NEXT FIELD piaa07 
                 END IF
              END IF
           END IF
 
 
        AFTER FIELD qty
           LET g_piaa[l_ac].qty=s_digqty(g_piaa[l_ac].qty,g_piaa[l_ac].piaa09)   #No.FUN-BB0086
           DISPLAY BY NAME g_piaa[l_ac].qty   #No.FUN-BB0086
           IF g_piaa[l_ac].qty IS NULL OR g_piaa[l_ac].qty = ' ' OR g_piaa[l_ac].qty < 0 THEN 
              NEXT FIELD qty
           END IF 

 
       AFTER FIELD peo    
           IF g_piaa[l_ac].peo IS NOT NULL AND g_piaa[l_ac].peo !=' ' THEN   
              CALL t852_peo('a','2',g_piaa[l_ac].peo)
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_piaa[l_ac].peo,g_errno,0)
                 LET g_piaa[l_ac].peo = g_piaa_o.peo
                 DISPLAY BY NAME g_piaa[l_ac].peo 
                 NEXT FIELD peo  
               END IF
           END IF  
           IF g_piaa[l_ac].peo IS NOT NULL THEN LET g_piaa_o.peo = g_piaa[l_ac].peo END IF
 
                   
       AFTER FIELD tagdate #盤點日期 
           IF g_piaa[l_ac].tagdate IS NULL OR g_piaa[l_ac].tagdate = ' '  THEN
	      LET g_piaa[l_ac].tagdate = g_today
              DISPLAY BY NAME g_piaa[l_ac].tagdate 
              NEXT FIELD tagdate
           END IF
           IF g_piaa[l_ac].tagdate IS NOT NULL THEN 
              LET g_piaa_o.tagdate = g_piaa[l_ac].tagdate 
           END IF
			
       #FUN-CB0087--add--str--
       BEFORE FIELD piaa70
          IF g_aza.aza115 = 'Y' AND cl_null(g_piaa[l_ac].piaa70) THEN 
             CALL s_reason_code(g_piaa[l_ac].piaa01,'','',g_piaa[l_ac].piaa02,
                                g_piaa[l_ac].piaa03,g_piaa[l_ac].peo1,'') RETURNING g_piaa[l_ac].piaa70
             DISPLAY BY NAME g_piaa[l_ac].piaa70
             CALL t852_azf03()              
          END IF

       AFTER FIELD piaa70
          IF NOT t852_piaa70_chk() THEN 
             NEXT FIELD piaa70
          ELSE
             CALL t852_azf03()
          END IF
       #FUN-CB0087--add--end--
 
       AFTER INPUT
          IF g_piaa[l_ac].piaa03 IS NULL THEN LET g_piaa[l_ac].piaa03 = ' ' END IF
          IF g_piaa[l_ac].piaa04 IS NULL THEN LET g_piaa[l_ac].piaa04 = ' ' END IF
          IF g_piaa[l_ac].piaa05 IS NULL THEN LET g_piaa[l_ac].piaa05 = ' ' END IF
          LET l_flag='N'
          IF INT_FLAG THEN EXIT INPUT END IF
          IF cl_null(g_piaa10) THEN LET l_flag='Y' END IF
          IF l_flag='Y' THEN 
             CALL cl_err('','mfg2719',0) NEXT FIELD piaa02 
          END IF
          LET l_flag='N'
          IF g_piaa[l_ac].piaa02 IS NULL OR g_piaa[l_ac].piaa02 = ' ' THEN
             LET l_flag='Y'
             DISPLAY BY NAME g_piaa[l_ac].piaa02 
          END IF    
          IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD piaa02
          END IF
 
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(piaa02) #查詢料件編號
#FUN-AA0059 --Begin--
              #    CALL cl_init_qry_var()
              #    LET g_qryparam.form     ="q_ima"
              #    LET g_qryparam.default1 = g_piaa[l_ac].piaa02
              #    CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa02
                  CALL q_sel_ima(FALSE, "q_ima", "", g_piaa[l_ac].piaa02, "", "", "", "" ,"",'' )  RETURNING g_piaa[l_ac].piaa02
#FUN-AA0059 --End--
		  CALL t852_piaa02('a')
                  DISPLAY BY NAME g_piaa[l_ac].piaa02          
                  NEXT FIELD piaa02
               WHEN INFIELD(piaa03) #倉庫
#FUN-AA0061 --modify
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     ="q_imd"
#                 LET g_qryparam.default1 = g_piaa[l_ac].piaa03
#                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 
#                 CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa03
                  CALL q_imd_1(FALSE,TRUE,g_piaa[l_ac].piaa03,"","","","") RETURNING g_piaa[l_ac].piaa03
#FUN-AA0061   --end
                  DISPLAY BY NAME  g_piaa[l_ac].piaa03        
                  NEXT FIELD piaa03
               WHEN INFIELD(piaa04) #儲位
#FUN-AA0061 --modify
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form     ="q_ime"
#                  LET g_qryparam.default1 = g_piaa[l_ac].piaa04
#                  LET g_qryparam.arg1    = g_piaa[l_ac].piaa03 #倉庫編號 
#                  LET g_qryparam.arg2    = 'SW'        #倉庫類別
#                  CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa04
                   CALL q_ime_1(FALSE,TRUE,g_piaa[l_ac].piaa04,g_piaa[l_ac].piaa03,"",g_plant,"","","") RETURNING g_piaa[l_ac].piaa04
#FUN-AA0061   --end
                  DISPLAY BY NAME g_piaa[l_ac].piaa04          
                  NEXT FIELD piaa04
               WHEN INFIELD(piaa05) #批號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_img1"
                  LET g_qryparam.construct = "N"
                  LET g_qryparam.default1 = g_piaa[l_ac].piaa03
                  LET g_qryparam.default2 = g_piaa[l_ac].piaa04
                  LET g_qryparam.default3 = g_piaa[l_ac].piaa05
                  LET g_qryparam.arg1     = g_piaa[l_ac].piaa02
                  IF g_piaa[l_ac].piaa03 IS NOT NULL THEN
                     LET g_qryparam.where = " img02='",g_piaa[l_ac].piaa03,"'"
                  END IF
                  IF g_piaa[l_ac].piaa04 IS NOT NULL THEN
                     IF cl_null(g_qryparam.where) THEN
                       LET g_qryparam.where = "img03='",g_piaa[l_ac].piaa04,"'"
                     ELSE
                       LET g_qryparam.where = g_qryparam.where CLIPPED,
                                              " AND img03='",g_piaa[l_ac].piaa04,"'"
                     END IF
                  END IF
                  CALL cl_create_qry() 
                  RETURNING g_piaa[l_ac].piaa03,g_piaa[l_ac].piaa04,g_piaa[l_ac].piaa05
                  DISPLAY BY NAME g_piaa[l_ac].piaa03,g_piaa[l_ac].piaa04,g_piaa[l_ac].piaa05
               WHEN INFIELD(piaa07) #會計科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_aag"
                  LET g_qryparam.default1 = g_piaa[l_ac].piaa07
                  LET g_qryparam.arg1 = g_aza.aza81  
                   CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa07 
                   DISPLAY BY NAME g_piaa[l_ac].piaa07     
                  NEXT FIELD piaa07
               WHEN INFIELD(piaa09) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_piaa[l_ac].piaa09
                  CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa09
                   DISPLAY BY NAME g_piaa[l_ac].piaa09            
                  NEXT FIELD piaa09
               WHEN INFIELD(peo) #初盤人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.default1 = g_piaa[l_ac].peo
                  CALL cl_create_qry() RETURNING g_piaa[l_ac].peo
                  DISPLAY BY NAME g_piaa[l_ac].peo  
                  NEXT FIELD peo  
               #FUN-CB0087---add---str---
               WHEN INFIELD(piaa70) #理由
                  CALL s_get_where(g_piaa[l_ac].piaa01,'','',g_piaa[l_ac].piaa02,
                                   g_piaa[l_ac].piaa03,g_piaa[l_ac].peo1,'') RETURNING l_flag,l_where
                  IF l_flag AND g_aza.aza115 = 'Y' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_piaa[l_ac].piaa70
                  ELSE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     ="q_azf41"
                      LET g_qryparam.default1 = g_piaa[l_ac].piaa70
                  END IF
                  CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa70
                  DISPLAY g_piaa[l_ac].piaa70 TO piaa70
                  CALL t852_azf03()
                  NEXT FIELD piaa70
               #FUN-CB0087---add---end---
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION mntn_unit
         CALL cl_cmdrun("aooi101 ")
 
      ON ACTION mntn_unit_conv
         CALL cl_cmdrun("aooi102 ")
 
      ON ACTION mntn_item_unit_conv
         CALL cl_cmdrun("aooi103")
   
 
      ON ACTION def_imf
         CALL cl_init_qry_var()
         LET g_qryparam.form     = "q_imf"
         LET g_qryparam.default1 = g_piaa[l_ac].piaa03       
         LET g_qryparam.default2 = g_piaa[l_ac].piaa04          
         LET g_qryparam.arg1     = g_piaa[l_ac].piaa02
         LET g_qryparam.arg2     = "A"
         IF g_qryparam.arg2 != 'A' THEN
            LET g_qryparam.where=g_qryparam.where CLIPPED, 
                                 " AND ime04 matches'",g_qryparam.arg2,"'"
         END IF
         CALL cl_create_qry() RETURNING g_piaa[l_ac].piaa03,g_piaa[l_ac].piaa04
         DISPLAY BY NAME g_piaa[l_ac].piaa03,g_piaa[l_ac].piaa04
         NEXT FIELD piaa03 
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
  
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_piaa[l_ac].* = g_piaa_t.*
            CLOSE t852_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_piaa[l_ac].piaa01,-263,0)
            LET g_piaa[l_ac].* = g_piaa_t.*
         ELSE
             INITIALIZE l_piaa.*  TO NULL
             SELECT * INTO l_piaa.* FROM piaa_file 
              WHERE piaa01 = g_piaa[l_ac].piaa01            
                AND piaa09 = g_piaa[l_ac].piaa09
             LET g_success = 'Y'
             LET l_piaa.piaa01 = g_piaa[l_ac].piaa01
             LET l_piaa.piaa02 = g_piaa[l_ac].piaa02
             LET l_piaa.piaa03 = g_piaa[l_ac].piaa03
             LET l_piaa.piaa04 = g_piaa[l_ac].piaa04
             LET l_piaa.piaa05 = g_piaa[l_ac].piaa05
             LET l_piaa.piaa06 = g_piaa[l_ac].piaa06
             LET l_piaa.piaa07 = g_piaa[l_ac].piaa07
             LET l_piaa.piaa08 = g_piaa08
             LET l_piaa.piaa09 = g_piaa[l_ac].piaa09
             LET l_piaa.piaa10 = g_piaa10
             LET l_piaa.piaa13 = g_today
             LET l_piaa.piaa66 = g_piaa66
             LET l_piaa.piaa67 = g_piaa67
             LET l_piaa.piaa68 = g_piaa68
             LET l_piaa.piaaplant = g_plant #FUN-980004 add
             LET l_piaa.piaalegal = g_legal #FUN-980004 add
             LET l_piaa.piaa70 = g_piaa[l_ac].piaa70   #FUN-CB0087
 
             IF l_piaa.piaa03 IS NULL THEN LET l_piaa.piaa03 = ' ' END IF
             IF l_piaa.piaa04 IS NULL THEN LET l_piaa.piaa04 = ' ' END IF
             IF l_piaa.piaa05 IS NULL THEN LET l_piaa.piaa05 = ' ' END IF
             IF g_argv1 = '1' THEN 
                 LET l_piaa.piaa50 = g_piaa[l_ac].qty
                 LET l_piaa.piaa51 = g_user
                 LET l_piaa.piaa52 = g_today
                 LET l_piaa.piaa53 = TIME  
                 LET l_piaa.piaa54 = g_piaa[l_ac].peo
                 LET l_piaa.piaa55 = g_piaa[l_ac].tagdate
             ELSE 
                 LET l_piaa.piaa60 = g_piaa[l_ac].qty
                 LET l_piaa.piaa61 = g_user
                 LET l_piaa.piaa62 = g_today
                 LET l_piaa.piaa63 = TIME
                 LET l_piaa.piaa64 = g_piaa[l_ac].peo
                 LET l_piaa.piaa65 = g_piaa[l_ac].tagdate
             END IF
             UPDATE piaa_file SET piaa_file.* = l_piaa.*    # 更新DB
                 WHERE piaa01  = g_piaa_t.piaa01
                   AND piaa09  = g_piaa_t.piaa09
             IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","piaa_file",g_piaa_t.piaa01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
                 LET g_piaa[l_ac].* = g_piaa_t.*
                 LET g_success = 'N'
             END IF
 
             IF cl_null(g_argv2) THEN
                IF g_argv1 = '1' THEN 
                    SELECT SUM(piaa50*piaa10) INTO l_sum FROM piaa_file
                     WHERE piaa01=g_piaa[l_ac].piaa01
                       AND piaa02=g_piaa[l_ac].piaa02
                       AND piaa03=g_piaa[l_ac].piaa03
                       AND piaa04=g_piaa[l_ac].piaa04
                       AND piaa05=g_piaa[l_ac].piaa05
                       AND piaa50 IS NOT NULL
                       AND piaa10 IS NOT NULL
                    IF cl_null(l_sum) THEN LET l_sum=0 END IF
                    #No.FUN-BB0086--add--start--
                    SELECT pia09 INTO l_pia09 FROM pia_file WHERE pia01 = g_piaa[l_ac].piaa01
                    LET l_sum = s_digqty(l_sum,l_pia09)
                    #No.FUN-BB0086--add--start--
                    UPDATE pia_file SET pia50=l_sum, 
                     pia54=g_piaa[l_ac].peo,pia55=g_piaa[l_ac].tagdate                                
                     WHERE pia01=g_piaa[l_ac].piaa01
                       AND pia02=g_piaa[l_ac].piaa02
                       AND pia03=g_piaa[l_ac].piaa03
                       AND pia04=g_piaa[l_ac].piaa04
                       AND pia05=g_piaa[l_ac].piaa05
                ELSE
                    SELECT SUM(piaa60*piaa10) INTO l_sum FROM piaa_file
                     WHERE piaa01=g_piaa[l_ac].piaa01
                       AND piaa02=g_piaa[l_ac].piaa02
                       AND piaa03=g_piaa[l_ac].piaa03
                       AND piaa04=g_piaa[l_ac].piaa04
                       AND piaa05=g_piaa[l_ac].piaa05
                       AND piaa60 IS NOT NULL
                       AND piaa10 IS NOT NULL
                    IF cl_null(l_sum) THEN LET l_sum=0 END IF
                    #No.FUN-BB0086--add--start--
                    SELECT pia09 INTO l_pia09 FROM pia_file WHERE pia01 = g_piaa[l_ac].piaa01
                    LET l_sum = s_digqty(l_sum,l_pia09)
                    #No.FUN-BB0086--add--start--
                    UPDATE pia_file SET pia60=l_sum, 
                     pia64=g_piaa[l_ac].peo,pia65=g_piaa[l_ac].tagdate                            
                     WHERE pia01=g_piaa[l_ac].piaa01
                       AND pia02=g_piaa[l_ac].piaa02
                       AND pia03=g_piaa[l_ac].piaa03
                       AND pia04=g_piaa[l_ac].piaa04
                       AND pia05=g_piaa[l_ac].piaa05
                END IF
                IF SQLCA.sqlcode THEN                                       
                   CALL cl_err3("upd","pia_file",g_piaa[l_ac].piaa01,g_piaa[l_ac].piaa02,SQLCA.sqlcode,
                                "update pia","",1)   #NO.FUN-640266
                   LET g_success = 'N'
                END IF 
 
                IF g_success = 'Y' THEN
                  MESSAGE  "UPDATE O.K"
                  COMMIT WORK
                ELSE
                  ROLLBACK WORK
                END IF
             END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()            # 新增
        #LET l_ac_t = l_ac                # 新增  #FUN-D40030 Mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_piaa[l_ac].* = g_piaa_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_piaa.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE t852_bcl            # 新增
            ROLLBACK WORK         # 新增
            EXIT INPUT
         END IF
 
         LET l_ac_t = l_ac                      #FUN-D40030 Add
         CLOSE t852_bcl            # 新增
         COMMIT WORK
    
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
  END INPUT
  CLOSE t852_bcl
  COMMIT WORK
END FUNCTION
#FUN-6B0019 add end
 
 
#FUN-6B0019 remark begin
###FUNCTION t852_fetch(p_flpiaa)
###    DEFINE p_flpiaa          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
###
###    CASE p_flpiaa
###        WHEN 'N' FETCH NEXT     t852_cs INTO g_piaa.piaa01,g_piaa.piaa09
###        WHEN 'P' FETCH PREVIOUS t852_cs INTO g_piaa.piaa01,g_piaa.piaa09
###        WHEN 'F' FETCH FIRST    t852_cs INTO g_piaa.piaa01,g_piaa.piaa09
###        WHEN 'L' FETCH LAST     t852_cs INTO g_piaa.piaa01,g_piaa.piaa09
###        WHEN '/'
###            IF (NOT mi_no_ask) THEN
###                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
###                LET INT_FLAG = 0  ######add for prompt bug
###                PROMPT g_msg CLIPPED,': ' FOR g_jump
###                   ON IDLE g_idle_seconds
###                      CALL cl_on_idle()
### 
###                    ON ACTION about         #MOD-4C0121
###                       CALL cl_about()      #MOD-4C0121
###               
###                    ON ACTION help          #MOD-4C0121
###                       CALL cl_show_help()  #MOD-4C0121
###               
###                    ON ACTION controlg      #MOD-4C0121
###                       CALL cl_cmdask()     #MOD-4C0121
### 
###                END PROMPT
###                IF INT_FLAG THEN
###                   LET INT_FLAG = 0
###                   EXIT CASE
###                END IF
###            END IF
###            FETCH ABSOLUTE g_jump t852_cs INTO g_piaa.piaa01,g_piaa.piaa09
###            LET mi_no_ask = FALSE
###    END CASE
###    IF SQLCA.sqlcode THEN
###       CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
###       INITIALIZE g_piaa.* TO NULL  #TQC-6B0105
###       RETURN
###    ELSE
###       CASE p_flpiaa
###          WHEN 'F' LET g_curs_index = 1
###          WHEN 'P' LET g_curs_index = g_curs_index - 1
###          WHEN 'N' LET g_curs_index = g_curs_index + 1
###          WHEN 'L' LET g_curs_index = g_row_count
###          WHEN '/' LET g_curs_index = g_jump
###       END CASE
###       CALL cl_navigator_setting( g_curs_index, g_row_count )
###    END IF
###    SELECT * INTO g_piaa.* FROM piaa_file   # 重讀DB,因TEMP有不被更新特性
###     WHERE piaa01 = g_piaa.piaa01 AND piaa09 = g_piaa.piaa09
###    IF SQLCA.sqlcode THEN
####      CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0) #No.FUN-660156
###       CALL cl_err3("sel","piaa_file",g_piaa.piaa01,"",SQLCA.sqlcode,
###                    "","",1)   #NO.FUN-640266
###    ELSE
###       CALL t852_show()                      # 重新顯示
###    END IF
###END FUNCTION
###
###FUNCTION t852_show()
### DEFINE  g_peo2  LIKE piaa_file.piaa34
###
###    LET g_piaa_t.* = g_piaa.*
###    DISPLAY BY NAME 
###        g_piaa.piaa01,g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04,
###        g_piaa.piaa05,g_piaa.piaa06,g_piaa.piaa09,
###        g_piaa.piaa07
###    IF g_argv1 = '1' THEN 
###       LET g_qty     = g_piaa.piaa50
###       LET g_peo     = g_piaa.piaa54
###       LET g_tagdate = g_piaa.piaa55
###       IF g_tagdate IS NULL OR g_tagdate = ' ' THEN 
###          LET g_tagdate = g_today
###       END IF
###       DISPLAY g_piaa.piaa50 TO FORMONLY.qty  
###       DISPLAY g_tagdate     TO FORMONLY.tagdate
###       DISPLAY g_peo         TO FORMONLY.peo
###       DISPLAY g_piaa.piaa30 TO FORMONLY.qty1 
###       DISPLAY g_piaa.piaa35 TO FORMONLY.tagdate1
###       DISPLAY g_piaa.piaa34 TO FORMONLY.peo1
###       LET g_peo2 = g_piaa.piaa34
###    ELSE 
###       LET g_qty     = g_piaa.piaa60
###       LET g_peo     = g_piaa.piaa64
###       LET g_tagdate = g_piaa.piaa65
###       IF g_tagdate IS NULL OR g_tagdate = ' ' THEN 
###          LET g_tagdate = g_today
###       END IF
###       DISPLAY g_piaa.piaa60 TO FORMONLY.qty  
###       DISPLAY g_tagdate     TO FORMONLY.tagdate
###       DISPLAY g_peo         TO FORMONLY.peo
###       DISPLAY g_piaa.piaa40 TO FORMONLY.qty1 
###       DISPLAY g_piaa.piaa45 TO FORMONLY.tagdate1
###       DISPLAY g_piaa.piaa44 TO FORMONLY.peo1
###       LET g_peo2 = g_piaa.piaa44
###    END IF
###    IF g_peo IS NOT NULL THEN LET g_peo_o = g_peo END IF
###    IF g_tagdate IS NOT NULL THEN LET g_tagdate_o = g_tagdate END IF
###    CALL t852_piaa02('d')
###    CALL t852_peo('d','2',g_peo)
###    CALL t852_peo('d','1',g_peo2)
###    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
###END FUNCTION
###   
###FUNCTION t852_u()
### DEFINE l_sum          LIKE pia_file.pia30
###
###    IF s_shut(0) THEN RETURN END IF
###    IF g_piaa.piaa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
###    SELECT * INTO g_piaa.* FROM piaa_file WHERE piaa01=g_piaa.piaa01
###    IF g_piaa.piaa19 ='Y' THEN 
###       CALL cl_err(g_piaa.piaa01,'mfg0132',0) RETURN 
###    END IF
###    MESSAGE ""
###    CALL cl_opmsg('u')
###    LET g_piaa01_t = g_piaa.piaa01
###    LET g_piaa09_t = g_piaa.piaa09
###    LET g_piaa_o.*=g_piaa.*   
###    BEGIN WORK
###
###    OPEN t852_cl USING g_piaa.piaa01,g_piaa.piaa09
###    IF STATUS THEN
###       CALL cl_err("OPEN t852_cl:", STATUS, 1)
###       CLOSE t852_cl
###       ROLLBACK WORK
###       RETURN
###    END IF
###    FETCH t852_cl INTO g_piaa.*               # 對DB鎖定
###    IF SQLCA.sqlcode THEN
###       CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
###       RETURN
###    END IF
###    CALL t852_show()                          # 顯示最新資料
###    IF g_peo     IS NULL THEN LET g_peo = g_peo_o         END IF
###    IF g_tagdate IS NULL THEN LET g_tagdate = g_tagdate_o END IF
###    WHILE TRUE
###        CALL t852_i("u")                      # 欄位更改
###        IF INT_FLAG THEN
###           LET INT_FLAG = 0
###           LET g_piaa.*=g_piaa_t.*
###           CALL t852_show()
###           CALL cl_err('',9001,0)
###           EXIT WHILE
###        END IF
###{&}     IF g_piaa.piaa03 IS NULL THEN LET g_piaa.piaa03 = ' ' END IF
###        IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04 = ' ' END IF
###        IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05 = ' ' END IF
###        LET l_sum=0
###        IF g_argv1 = '1' THEN 
###           LET g_piaa.piaa50 = g_qty
###           LET g_piaa.piaa51 = g_user
###           LET g_piaa.piaa52 = g_today
###           LET g_piaa.piaa53 = TIME  
###           LET g_piaa.piaa54 = g_peo
###           LET g_piaa.piaa55 = g_tagdate
###        ELSE 
###           LET g_piaa.piaa60 = g_qty
###           LET g_piaa.piaa61 = g_user
###           LET g_piaa.piaa62 = g_today
###           LET g_piaa.piaa63 = TIME  
###           LET g_piaa.piaa64 = g_peo
###           LET g_piaa.piaa65 = g_tagdate
###        END IF
###        UPDATE piaa_file SET piaa_file.* = g_piaa.*    # 更新DB
###         WHERE piaa01 = g_piaa.piaa01 AND piaa09 = g_piaa.piaa09             # COLAUTH?
###        IF SQLCA.sqlcode THEN
####          CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
###           CALL cl_err3("upd","piaa_file",g_piaa_t.piaa01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
###           CONTINUE WHILE
###        END IF
###        IF cl_null(g_argv2) THEN
###           IF g_argv1 = '1' THEN 
###              SELECT SUM(piaa50*piaa10) INTO l_sum FROM piaa_file
###               WHERE piaa01=g_piaa.piaa01                               
###                 AND piaa02=g_piaa.piaa02                               
###                 AND piaa03=g_piaa.piaa03                               
###                 AND piaa04=g_piaa.piaa04                               
###                 AND piaa05=g_piaa.piaa05
###                 AND piaa50 IS NOT NULL
###                 AND piaa10 IS NOT NULL
###              IF cl_null(l_sum) THEN LET l_sum=0 END IF
###              UPDATE pia_file SET pia50=l_sum,                          
###               pia54=g_pia.pia54,pia55=g_pia55   #FUN-5B0137                          
###               WHERE pia01=g_piaa.piaa01                               
###                 AND pia02=g_piaa.piaa02                               
###                 AND pia03=g_piaa.piaa03                               
###                 AND pia04=g_piaa.piaa04                               
###                 AND pia05=g_piaa.piaa05
###           ELSE
###              SELECT SUM(piaa60*piaa10) INTO l_sum FROM piaa_file
###               WHERE piaa01=g_piaa.piaa01                               
###                 AND piaa02=g_piaa.piaa02                               
###                 AND piaa03=g_piaa.piaa03                               
###                 AND piaa04=g_piaa.piaa04                               
###                 AND piaa05=g_piaa.piaa05
###                 AND piaa60 IS NOT NULL
###                 AND piaa10 IS NOT NULL
###              IF cl_null(l_sum) THEN LET l_sum=0 END IF
###              UPDATE pia_file SET pia60=l_sum,                          
###               pia64=g_pia.pia64,pia65=g_pia65   #FUN-5B0137                          
###               WHERE pia01=g_piaa.piaa01                               
###                 AND pia02=g_piaa.piaa02                               
###                 AND pia03=g_piaa.piaa03                               
###                 AND pia04=g_piaa.piaa04                               
###                 AND pia05=g_piaa.piaa05
###           END IF
###           IF SQLCA.sqlcode THEN                                       
####             CALL cl_err('update pia',SQLCA.sqlcode,1)                
###              CALL cl_err3("upd","pia_file",g_piaa.piaa01,g_piaa.piaa02,SQLCA.sqlcode,
###                           "update pia","",1)   #NO.FUN-640266
###           END IF 
###        END IF
###        ERROR ""   
###        EXIT WHILE
###    END WHILE
###    CLOSE t852_cl
###    COMMIT WORK
###END FUNCTION
#FUN-6B0019 end
 
FUNCTION t852_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("piaa01,piaa09",TRUE)
   END IF
   IF INFIELD(piaa01) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("piaa02,piaa03,piaa04,piaa05,piaa06,piaa07",TRUE)
   END IF
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("piaa03,piaa04,piaa05",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t852_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("piaa01,piaa09",FALSE)
   END IF
   IF INFIELD(piaa09) OR (NOT g_before_input_done) THEN
      #IF g_piaa.piaa16 = 'N' THEN    #FUN-6B0019
      IF g_piaa16 = 'N' THEN          #FUN-6B0019
          CALL cl_set_comp_entry("piaa02,piaa03,piaa04,piaa05,piaa06,piaa07",FALSE)
      END IF
   END IF
   IF (NOT g_before_input_done) THEN
      IF g_sma.sma12 = 'N' THEN 
          CALL cl_set_comp_entry("piaa03,piaa04,piaa05",FALSE)
      END IF
   END IF
 
END FUNCTION
#FUN-CB0087--add--str---
FUNCTION t852_piaa70_chk()
DEFINE  l_flag          LIKE type_file.chr1,
        l_n             LIKE type_file.num5,
        l_where         STRING,
        l_sql           STRING

   IF NOT cl_null(g_piaa[l_ac].piaa70) THEN
      LET l_n = 0
      LET l_flag= FALSE
      IF g_aza.aza115='Y' THEN
         CALL s_get_where(g_piaa[l_ac].piaa01,'','',g_piaa[l_ac].piaa02,
                          g_piaa[l_ac].piaa03,g_piaa[l_ac].peo1,'') RETURNING l_flag,l_where
      END IF
      IF g_aza.aza115='Y' AND l_flag THEN
         LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_piaa[l_ac].piaa70,"' AND ",l_where
         PREPARE ggc08_pre1 FROM l_sql
         EXECUTE ggc08_pre1 INTO l_n
         IF l_n < 1 THEN
            CALL cl_err(g_piaa[l_ac].piaa70,'aim-425',0)
            RETURN FALSE
         END IF
      ELSE
         SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_piaa[l_ac].piaa70 AND azf02='2'
         IF l_n < 1 THEN
            CALL cl_err(g_piaa[l_ac].piaa70,'aim-425',0)
            RETURN FALSE
         END IF
      END IF
   ELSE                              #TQC-D20042
      #LET g_piaa[l_ac].piaa70 = ' ' #TQC-D20042  #TQC-D20047 
      LET g_piaa[l_ac].azf03 = ' ' #TQC-D20047
      DISPLAY BY NAME g_piaa[l_ac].azf03   #TQC-D20042
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t852_azf03()
   #LET g_piaa[l_ac].piaa70 = ' ' #TQC-D20042  #TQC-D20047
   LET g_piaa[l_ac].azf03 = ' ' #TQC-D20047
   SELECT azf03 INTO g_piaa[l_ac].azf03 FROM azf_file
    WHERE azf01 = g_piaa[l_ac].piaa70
      AND azf02 = '2'
   DISPLAY BY NAME g_piaa[l_ac].azf03
END FUNCTION
#FUN-CB0087--add--end---
