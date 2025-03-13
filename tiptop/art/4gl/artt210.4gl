# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: artt210.4gl
# Descriptions...: 盤點計劃維護
# Date & Author..: NO:FUN-960130 08/09/25 By Sunyanchun
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0025 09/11/30 By cockroach 修改臨時表定義
# Modify.........: No:FUN-9B0025 09/12/09 By chenmoyan 整批結案/整批生成盤點單時，加上機構別的判斷
# Modify.........: No:TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No:FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A30030 10/03/11 By Cockroach 添加pos相關管控
# Modify.........: No:TQC-A30041 10/03/16 By Cockroach ADD oriu/orig 
# Modify.........: No:FUN-A70130 10/08/06 By shaoyong  ART單據性質調整,q_smy改为q_oay
# Modify.........: No:FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No:FUN-AB0025 10/11/10 By huangtao 增加料號控管
# Modify.........: No:TQC-AB0287 10/11/30 By huangtao
# Modify.........: No:TQC-AC0169 10/12/16 By wangxin 已產生費用單移除
# Modify.........: No:TQC-AC0308 10/12/24 By chenying 盤點計劃通過右側按鈕生成盤點單時，無需check產品庫存，直接按條件取得商品產生盤點單即可；
#                                                     由盤點計劃批量產生時的盤點單，單身中的帳面庫存與差異數量昀賦值為0
# Modify.........: No:TQC-B10004 11/01/04 By wangxin after field rus13時的產品編號檢查會有錯,原因是沒有依 '|' 隔間符合取出產品編號來檢查.
# Modify.........: No:TQC-B10011 11/01/05 By shenyang 修改5.25PT bug
# Modify.........: No:TQC-B30004 11/03/10 By suncx 取消已傳POS否
# Modify.........: No:FUN-B40062 11/04/26 By shiwuying 产生盘点单时不可输入商户料号和联营料号
# Modify.........: No:FUN-B50042 11/05/10 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B70048 11/07/06 By pauline 非屬營運中心不可修改單據
# Modify.........: No.TQC-B80038 11/08/03 By lilingyu insert rus_file時,出現-391的NULL錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20488 12/02/24 by huangrh 服飾行業，生成母料件單身的資料
# Modify.........: No:FUN-C60091 12/06/26 by qiaozy 整批生成盤點單作業不能生成資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:CHI-CB0045 12/12/10 By Lori 取消確認時,刪除庫存備份(rut_file)
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rus       RECORD LIKE rus_file.*,
       g_rus_t     RECORD LIKE rus_file.*,
       g_rus01_t   LIKE rus_file.rus01,
       g_rusplant_t  LIKE rus_file.rusplant,
       g_wc        STRING,
       g_sql       STRING
 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_chr                 LIKE rus_file.rusacti
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE mi_no_ask             LIKE type_file.num5
DEFINE g_t1                  LIKE oay_file.oayslip
DEFINE g_sort                DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品類中的商品
DEFINE g_sign                DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放品牌中的商品
DEFINE g_factory             DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放廠商中的商品
DEFINE g_no                  DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放商品編號中的商品
DEFINE g_result              DYNAMIC ARRAY OF LIKE ima_file.ima01    #存放商品交集
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT 
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_rus.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM rus_file WHERE rus01 = ? FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t210_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW t210_w AT p_row,p_col WITH FORM "art/42f/artt210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #CALL cl_set_comp_visible("ruspos",g_aza.aza88='Y')   #FUN-A30030 ADD #TQC-B30004 mark
   CALL cl_set_comp_visible("ruspos",FALSE)   #TQC-B30004 ADD
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL t210_menu()
 
   CLOSE WINDOW t210_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t210_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_rus.* TO NULL
    CONSTRUCT BY NAME g_wc ON
        rus01,rus02,rus03,rus04,rus05,rus14,
  #      rusmksg,rus15,rus16,rus900,rusplant,   #FUN-870100        #TQC-AB0287 mark
        rus16,rus900,rusplant,                               #TQC-AB0287
        rusconf,ruscond,rusconu,            #FUN-870100
        rus06,rus07,
        rus08,rus09,rus10,rus11,rus12,rus13,
        rususer,rusgrup,rusmodu,rusdate,rusacti,ruscrat
       ,rusoriu,rusorig                    #TQC-A30041 ADD
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rus01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rus01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rus.rus01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rus01
                 NEXT FIELD rus01
              WHEN INFIELD(rus05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rus05_1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rus.rus05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rus05
                 NEXT FIELD rus05
              WHEN INFIELD(rusconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rusconu"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_rus.rus05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rusconu
                 NEXT FIELD rusconu
              WHEN INFIELD(rus07)                                                                                                 CALL cl_init_qry_var()                                                                                           LET g_qryparam.form = "q_rus07"         
                 LET g_qryparam.state = "c"              
                 LET g_qryparam.form = "q_rus07"
                 LET g_qryparam.default1 = g_rus.rus07  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret       
                 DISPLAY g_qryparam.multiret TO rus07    
                 NEXT FIELD rus07
              WHEN INFIELD(rus09)                       
                 CALL cl_init_qry_var()                
                 LET g_qryparam.form = "q_rus09"      
                 LET g_qryparam.state = "c"          
                 LET g_qryparam.default1 = g_rus.rus09 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret       
                 DISPLAY g_qryparam.multiret TO rus09                    
                 NEXT FIELD rus09
              WHEN INFIELD(rus11)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_rus11"            
                 LET g_qryparam.state = "c"                                                                        
                 LET g_qryparam.default1 = g_rus.rus11                                                                              
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO rus11                                                                               
                 NEXT FIELD rus11
              WHEN INFIELD(rus13)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_rus13"     
                 LET g_qryparam.state = "c"                                                                               
                 LET g_qryparam.default1 = g_rus.rus13                                                                              
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO rus13                                                                               
                 NEXT FIELD rus13
              #bnl 090408 begin
              WHEN INFIELD(rusplant)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_rusplant"     
                 LET g_qryparam.state = "c"                                                                               
                 LET g_qryparam.default1 = g_rus.rusplant                                                                             
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO rusplant                                                                               
                 NEXT FIELD rusplant
              #bnl 090408 end
              OTHERWISE
                 EXIT CASE
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
     CALL cl_qbe_save()
 
    END CONSTRUCT
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #        LET g_wc = g_wc clipped," AND rususer = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc clipped," AND rusgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND rusgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rususer', 'rusgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT rus01,rusplant FROM rus_file ",
        " WHERE ",g_wc CLIPPED, " ORDER BY rus01"
    PREPARE t210_prepare FROM g_sql
    DECLARE t210_cs
        SCROLL CURSOR WITH HOLD FOR t210_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM rus_file WHERE ",g_wc CLIPPED
    PREPARE t210_precount FROM g_sql
    DECLARE t210_count CURSOR FOR t210_precount
END FUNCTION
 
FUNCTION t210_menu()
   DEFINE l_cmd  LIKE type_file.chr1000  
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t210_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t210_q()
            END IF
        ON ACTION next
            CALL t210_fetch('N')
        ON ACTION previous
            CALL t210_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                  CALL t210_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                  CALL t210_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                  CALL t210_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t210_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN                                                 #No.FUN-780056
      #         IF cl_null(g_wc) THEN LET g_wc='1=1' END IF                           #TQC-AB0287   mark
                CALL t210_out()                                                       #TQC-AB0287 
            END IF
       ON ACTION confirm
          IF cl_chk_act_auth() THEN
                CALL t210_yes()
          END IF 
       ON ACTION unconfirm
          IF cl_chk_act_auth() THEN
                CALL t210_no()
          END IF
       ON ACTION create_no
          IF cl_chk_act_auth() THEN
                CALL t210_create_no()
          END IF
       ON ACTION end_no
          IF cl_chk_act_auth() THEN
             CALL t210_end()
          END IF
  
  #TQC-AB0287 --------------------STA        
  #    ON ACTION end_void
  #       IF cl_chk_act_auth() THEN
  #             CALL t210_void()
  #       END IF
  #TQC-AB0287 --------------------END
          
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL t210_fetch('/')
        ON ACTION first
            CALL t210_fetch('F')
        ON ACTION last
            CALL t210_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
      ON ACTION about
         CALL cl_about()
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_rus.rus01 IS NOT NULL THEN
                 LET g_doc.column1 = "rus01"
                 LET g_doc.value1 = g_rus.rus01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t210_cs
END FUNCTION
FUNCTION t210_yes()
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_flag     LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE tok        base.StringTokenizer
DEFINE tok1       base.StringTokenizer
DEFINE l_ck       LIKE type_file.chr50
DEFINE l_ck1      LIKE type_file.chr50
DEFINE l_rus05    LIKE rus_file.rus05
DEFINE l_rtz04    LIKE rtz_file.rtz04
DEFINE l_i        LIKE type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE l_ruscont  LIKE rus_file.ruscont
 
   SELECT * INTO g_rus.* FROM rus_file 
      WHERE rus01=g_rus.rus01 
   IF g_rus.rusconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#   IF g_rus.rusconf = 'X' THEN CALL cl_err(g_rus.rus01,'9024',0) RETURN END IF       #TQC-AB0287
   IF g_rus.rus16 = 'Y' THEN CALL cl_err('','aap-238',0) RETURN END IF
   IF g_rus.rusacti ='N' THEN                                                                                                       
      CALL cl_err('','art-145',0)                                                                                          
      RETURN                                                                                                                        
   END IF
   IF g_rus.rus04 < g_today THEN
      CALL cl_err('','art-346',0)
      RETURN
   END IF
   IF cl_null(g_rus.rus05) THEN
      CALL cl_err('','art-909',1)
      RETURN
   END IF
   #檢查品類、廠商、品牌、商品範圍之間是否有交集
   CALL t210_check_shop() RETURNING l_flag
   IF l_flag = -1 THEN 
      CALL cl_err('','art-367',0) 
      RETURN
   END IF
   #檢查當前盤點日期要盤點的倉庫是否已經盤店過
   LET l_sql = "SELECT rus05 FROM rus_file WHERE rusplant = '",g_rus.rusplant,"' AND ",
               " rusacti = 'Y' AND rusconf = 'Y' AND rus06 = 'N' AND rus08 = 'N' ",
               " AND rus10 = 'N' AND rus12 = 'N' AND rus04 = '",g_rus.rus04,"'"
   PREPARE trus_pb FROM l_sql
   DECLARE rus05_cs CURSOR FOR trus_pb
   FOREACH rus05_cs INTO l_rus05
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET tok = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         #遍歷當前要盤店的倉庫
         LET tok1 = base.StringTokenizer.createExt(g_rus.rus05,"|",'',TRUE)
         WHILE tok1.hasMoreTokens()
            LET l_ck1 = tok1.nextToken()
            IF l_ck1 = l_ck THEN
               CALL cl_err('','art-371',1)
               RETURN
            END IF
         END WHILE
      END WHILE
   END FOREACH
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus.rusplant
   IF NOT cl_null(l_rtz04)  THEN
      #檢查要盤點的商品是否在當前機構的商品策略中
      LET l_flag = 0
      FOR l_i = 1 TO g_result.getLength()
         SELECT count(*) INTO l_n FROM rte_file WHERE rte01 = l_rtz04 AND rte03 = g_result[l_i]
         IF l_n > 0 THEN
            LET l_flag = 1
         END IF
      END FOR
      IF l_flag <> 1 THEN
         CALL cl_err('','art-372',1)
         RETURN
      END IF
   END IF
   #檢查要盤點的商品在同一日期是否有重復
   CALL t210_repate()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,1)
      RETURN
   END IF
   IF NOT cl_confirm('art-026') THEN RETURN END IF
   BEGIN WORK
   OPEN t210_cl USING g_rus.rus01
   IF STATUS THEN
      CALL cl_err("OPEN t210_cl:", STATUS, 1)
      CLOSE t210_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t210_cl INTO g_rus.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rus.rus01,SQLCA.sqlcode,0)
      CLOSE t210_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'
   LET l_ruscont=TIME   #FUN-870100
   UPDATE rus_file SET rusconf='Y',
                       rus900 = '1',
                       ruscond=g_today, 
                       rusconu=g_user,
                       ruscont=l_ruscont 
     WHERE rus01=g_rus.rus01 
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rus_file",g_rus.rus01,"",SQLCA.sqlcode,"","",1)
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      LET g_rus.rusconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_rus.rus01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_rus.* FROM rus_file WHERE rus01=g_rus.rus01
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rus.rusconu
   DISPLAY BY NAME g_rus.rusconf                                                                                         
   DISPLAY BY NAME g_rus.rus900                                                                                         
   DISPLAY BY NAME g_rus.ruscond                                                                                         
   DISPLAY BY NAME g_rus.rusconu
   DISPLAY l_gen02 TO FORMONLY.rusconu_desc
   DISPLAY BY NAME g_rus.ruscont    #FUN-870100
#   IF g_rus.rusconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF           #TQC-AB0287  mark
#   CALL cl_set_field_pic(g_rus.rusconf,"","","",g_chr,"")                      #TQC-AB0287  mark
   CALL cl_set_field_pic(g_rus.rusconf,"","","","","")                          #TQC-AB0287
 
   CALL cl_flow_notify(g_rus.rus01,'V')
END FUNCTION
 
FUNCTION t210_no()
DEFINE l_n       LIKE type_file.num5
DEFINE l_ruscont LIKE rus_file.ruscont   #CHI-D20015 Add
DEFINE l_gen02   LIKE gen_file.gen02     #CHI-D20015 Add
 
   IF g_rus.rus01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_rus.* FROM rus_file WHERE rus01=g_rus.rus01 
   
   IF g_rus.rusconf <> 'Y' THEN CALL cl_err(g_rus.rus01,'art-373',0) RETURN END IF 
   # 查看該盤點計劃是否已經被用過
   SELECT COUNT(*) INTO l_n FROM ruw_file WHERE ruw02 = g_rus.rus01 
   IF l_n > 0 THEN CALL cl_err('','art-410',0) RETURN END IF
   #查看盤點計劃是否已經被盤點清單用過
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM ruu_file WHERE ruu02 = g_rus.rus01
   IF l_n >0 THEN CALL cl_err('','art-410',0) RETURN END IF
 
   IF NOT cl_confirm('aim-304') THEN RETURN END IF
   BEGIN WORK
   OPEN t210_cl USING g_rus.rus01
   
   IF STATUS THEN
      CALL cl_err("OPEN t210_cl:", STATUS, 1)
      CLOSE t210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t210_cl INTO g_rus.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rus.rus01,SQLCA.sqlcode,0)
      CLOSE t210_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'

   LET l_ruscont = TIME       #CHI-D20015 Add 
   UPDATE rus_file SET rusconf='N',
                       rus900='0',
                      #CHI-D20015 Mark&Add Str
                      #ruscond=NULL,
                      #rusconu=NULL,
                      ##ruspos='N', #FUN-B50042 mark
                      #ruscont=NULL
                       ruscond=g_today,
                       rusconu=g_user,
                       ruscont=l_ruscont
                      #CHI-D20015 Mark&Add End
     WHERE rus01=g_rus.rus01  
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","rus_file",g_rus.rus01,"",SQLCA.sqlcode,"","",1)
      LET g_success='N'
   END IF

   #CHI-CB0045 add begin---
   DELETE FROM rut_file WHERE rut01 = g_rus.rus01
   IF SQLCA.SQLCODE  THEN
      CALL cl_err3("del","rut_file",g_rus.rus01,"",SQLCA.sqlcode,"","",1)
      LET g_success='N'
   END IF
   #CHI-CB0045 add end-----
 
   IF g_success = 'Y' THEN
      LET g_rus.rusconf='N'
      COMMIT WORK
      CALL cl_flow_notify(g_rus.rus01,'N')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_rus.* FROM rus_file WHERE rus01=g_rus.rus01
   DISPLAY BY NAME g_rus.rusconf                                                                                         
   DISPLAY BY NAME g_rus.ruscond                                                                                         
   DISPLAY BY NAME g_rus.rusconu
   DISPLAY BY NAME g_rus.rus900
  #DISPLAY '' TO FORMONLY.rusconu_desc                                     #CHI-D20015 Mark
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rus.rusconu       #CHI-D20015 Add
   DISPLAY l_gen02 TO FORMONLY.rusconu_desc                                #CHI-D20015 Add
   #DISPLAY BY NAME g_rus.ruspos #No.FUN-870008 #FUN-B50042 mark
   DISPLAY BY NAME g_rus.ruscont     #FUN-870100
   #CKP
#   IF g_rus.rusconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF             #TQC-AB0287 mark
#   CALL cl_set_field_pic(g_rus.rusconf,"","","",g_chr,"")                        #TQC-AB0287 mark
    CALL cl_set_field_pic(g_rus.rusconf,"","","","","")                           #TQC-AB0287
 
   CALL cl_flow_notify(g_rus.rus01,'V')
END FUNCTION
#產生盤點單
FUNCTION t210_create_no()
DEFINE  l_rtz04       LIKE rtz_file.rtz04
DEFINE  l_result      LIKE type_file.num5
DEFINE  l_ck          LIKE type_file.chr50
DEFINE  tok           base.StringTokenizer
DEFINE  l_n           LIKE type_file.num5
 
#No.FUN-9B0025 --Begin
   IF g_rus.rusplant<>g_plant THEN
      CALL cl_err('','art-120',0)
      RETURN
   END IF
#No.FUN-9B0025 --End
   IF g_rus.rus01 IS NULL OR g_rus.rusplant IS NULL THEN
        CALL cl_err('',-400,0) 
        RETURN 
    END IF
    SELECT * INTO g_rus.* FROM rus_file 
       WHERE rus01=g_rus.rus01
 
   IF g_rus.rusconf <> 'Y' THEN
      CALL cl_err('','art-376',0)
      RETURN
   END IF
 
   IF g_rus.rus16 = 'Y' THEN
      CALL cl_err('','art-409',0)
      RETURN
   END IF
 
   #檢查該盤點計劃對應的倉庫是否已經有盤點單
   LET tok = base.StringTokenizer.createExt(g_rus.rus05,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         CONTINUE WHILE
      END IF
      SELECT COUNT(*) INTO l_n FROM ruw_file WHERE ruw02 = g_rus.rus01 AND ruw05 = l_ck
      IF l_n IS NULL THEN LET l_n = 0 END IF
      IF l_n != 0 THEN CALL cl_err(g_rus.rus01,'art-419',1) RETURN END IF
   END WHILE
 
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus.rusplant
   CALL t210_check_shop() RETURNING l_result
   BEGIN WORK
   LET g_success = 'Y'
 
   IF l_result = 0 THEN
      IF cl_null(l_rtz04) THEN    #當前機構沒有維護商品策略
         LET g_sql = "SELECT ima01 FROM ima_file WHERE imaacti = 'Y'"
      ELSE              #不是總部
         LET g_sql = "SELECT rte03 FROM rte_file WHERE rte01 = '",l_rtz04,
                     "' AND rte07 = 'Y' "
      END IF
      CALL t210_create_no1(g_sql)
   END IF
   
   IF l_result = -1 THEN
      CALL cl_err('','art-367',0)
      ROLLBACK WORK
      RETURN
   END IF
 
   IF l_result = 1 THEN
      CALL t210_create_no2()
   END IF
 
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,1)
      ROLLBACK WORK
      RETURN
   ELSE
      LET g_rus.rus900 = '2'
      UPDATE rus_file SET rus900 = g_rus.rus900
         WHERE rus01 = g_rus.rus01 
      DISPLAY BY NAME g_rus.rus900
      CALL cl_err('','art-423',1)
      COMMIT WORK
   END IF
END FUNCTION 
#無商品限定的情況下，產生盤點單
FUNCTION t210_create_no1(p_sql)
DEFINE p_sql          STRING
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_ima25         LIKE ima_file.ima25
DEFINE l_rut06         LIKE rut_file.rut06
DEFINE l_newno         LIKE ruw_file.ruw01
DEFINE l_shop          LIKE ima_file.ima01
DEFINE li_result       LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_img10         LIKE img_file.img10
DEFINE l_rye03         LIKE rye_file.rye03
DEFINE l_count         LIKE type_file.num5
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_n             LIKE type_file.num5
 
   LET g_errno = ''
 
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus.rusplant  
   
   PREPARE t210_shop_pb FROM p_sql
   DECLARE shop_cs CURSOR FOR t210_shop_pb
 
   #取默盤點單的默認單別   
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_rye03 FROM rye_file WHERE rye01 = 'art' 
   #   AND rye02 = 'J4' AND ryeacti = 'Y'              #FUN-A70130
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','J4',g_plant,'N') RETURNING l_rye03    #FUN-C90050 add

   IF l_rye03 IS NULL THEN LET g_errno = 'art-398' RETURN END IF
 
   LET tok = base.StringTokenizer.createExt(g_rus.rus05,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         CONTINUE WHILE
      END IF
 
#     CALL s_auto_assign_no("art",l_rye03,g_today,"","ruw_file","ruw01","","","")  #FUN-A70130 mark
      CALL s_auto_assign_no("art",l_rye03,g_today,"J4","ruw_file","ruw01","","","")  #FUN-A70130 mod
         RETURNING li_result,l_newno
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF
 
      LET g_cnt = 1
      LET l_cnt = 1
      FOREACH shop_cs INTO l_shop
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF      
         IF l_shop IS NULL THEN CONTINUE FOREACH END IF
        #FUN-B40062 Begin---
         IF s_joint_venture(l_shop,g_rus.rusplant) OR NOT s_internal_item(l_shop,g_rus.rusplant) THEN
            CONTINUE FOREACH
         END IF
        #FUN-B40062 End-----
 
         IF NOT cl_null(l_rtz04) THEN
            #檢查商品是否在當前機構的商品策略中
            SELECT COUNT(*) INTO l_n FROM rte_file WHERE rte01 = l_rtz04 
               AND rte03 = l_shop AND rte07 = 'Y'
            IF l_n IS NULL THEN LET l_n = 0 END IF
            IF l_n = 0 THEN CONTINUE FOREACH END IF
         END IF
        #TQC-AC0308-------mark------------str------------
        ##檢查該商品在倉庫中庫存數量是否是0
        #LET l_img10 = 0
 
        #SELECT img10 INTO l_img10 FROM img_file 
        #    WHERE img01 = l_shop 
        #      AND img02 = l_ck 
        #      AND img03 = ' '
        #      AND img04 = ' '
        #      AND img10 <> 0 
 
        #IF l_img10 IS NULL THEN LET l_img10 =0 END IF
        #IF l_img10 = 0 THEN CONTINUE FOREACH END IF
        #TQC-AC0308-------mark----------end-------------
         
         LET l_ima25 = NULL
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_shop
 
         INSERT INTO rux_file(rux00,rux01,rux02,rux03,rux04,rux05,
                              rux06,rux07,rux08,ruxplant,ruxlegal)
         #TQC-AC0308-------mod------------str---------------------
         #    VALUES('1',l_newno,l_cnt,l_shop,l_ima25,l_img10,
         #            0,0,0-l_img10,g_rus.rusplant,g_rus.ruslegal)
              VALUES('1',l_newno,l_cnt,l_shop,l_ima25,0,
                      0,0,0,g_rus.rusplant,g_rus.ruslegal)
         #TQC-AC0308-------mod------------end---------------------
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_errno = SQLCA.sqlcode
            LET g_success = 'N'
            RETURN
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      
      #l_cnt = 1表示盤點單單身中沒有符合條件的商品，單頭也就不insert
      IF l_cnt != 1 THEN
         #TQC-C20488---add----begin----
         #服飾行業，生成母料件單身的資料
         IF s_industry("slk") THEN
            IF NOT t210_createno_slk(l_newno) THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         #TQC-C20488---end----begin----
   
         INSERT INTO ruw_file(ruw00,ruw01,ruw02,ruw04,ruw05,ruw06,
                           ruwconf,ruwmksg,ruw900,ruwplant,ruwgrup,
                           ruwuser,ruwcrat,ruwacti,ruwlegal,ruworiu,ruworig)
           VALUES('1',l_newno,g_rus.rus01,g_rus.rus04,
                  l_ck,g_user,'N','N','0',g_rus.rusplant, 
                  g_grup,g_user,g_today,'Y',g_rus.ruslegal, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN  
            LET g_errno = SQLCA.sqlcode
            LET g_success = 'N'
            RETURN
         END IF
         LET l_count = l_count + 1
      END IF
   END WHILE
   #l_count=0->生成的盤點單中所有盤點單的單身都沒有insert value,則單頭也不insert
   IF l_count = 0 THEN 
      LET g_errno = 'art-420' 
      LET g_success = 'N'
   END IF
END FUNCTION
#有商品限定的條件下，生成盤點單
FUNCTION t210_create_no2()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_ima25         LIKE ima_file.ima25
DEFINE l_rut06         LIKE rut_file.rut06
DEFINE l_newno         LIKE ruw_file.ruw01
DEFINE l_shop          LIKE ima_file.ima01
DEFINE li_result       LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_img10         LIKE img_file.img10
DEFINE l_rye03         LIKE rye_file.rye03
DEFINE l_count         LIKE type_file.num5
DEFINE l_n             LIKE type_file.num5
DEFINE l_rtz04         LIKE rtz_file.rtz04
 
   LET g_errno = ''
   LET l_count = 0
 
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus.rusplant  
   LET tok = base.StringTokenizer.createExt(g_rus.rus05,"|",'',TRUE)
 
   #取默盤點單的默認單別       
   #FUN-C90050 mark begin---                                                                                                     
   #SELECT rye03 INTO l_rye03 FROM rye_file WHERE rye01 = 'art'                                                                      
   #   AND rye02 = 'J4' AND ryeacti = 'Y'        #FUN-A70130
   #FUN-C90050 mark end-----                                                                 

   CALL s_get_defslip('art','J4',g_plant,'N') RETURNING l_rye03    #FUN-C90050 add  
                      
   IF l_rye03 IS NULL THEN LET g_errno = 'art-398' RETURN END IF
 
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         CONTINUE WHILE
      END IF
 
#     CALL s_auto_assign_no("art",l_rye03,g_today,"","ruw_file","ruw01","","","") #FUN-A70130 mark
      CALL s_auto_assign_no("art",l_rye03,g_today,"J4","ruw_file","ruw01","","","") #FUN-A70130 mod
         RETURNING li_result,l_newno 
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF
 
      LET l_cnt = 1
 
      FOR g_cnt = 1 TO g_result.getLength()
          IF g_result[g_cnt] IS NULL THEN CONTINUE FOR END IF
         
         #FUN-B40062 Begin---
          IF s_joint_venture(g_result[g_cnt],g_rus.rusplant) OR NOT s_internal_item(g_result[g_cnt],g_rus.rusplant) THEN
             CONTINUE FOR
          END IF
         #FUN-B40062 End-----
          #檢查商品是否在商品策略中
          IF NOT cl_null(l_rtz04) THEN
             LET l_n = 0
             SELECT COUNT(*) INTO l_n FROM rte_file WHERE rte01 = l_rtz04 
                AND rte03 = g_result[g_cnt] AND rte07 = 'Y'
             IF l_n IS NULL THEN LET l_n = 0 END IF
             IF l_n = 0 THEN CONTINUE FOR END IF
          END IF
         #TQC-AC0308-----------mod-----------str-----------
         ##檢查庫存
         #LET l_img10 = 0
         #SELECT img10 INTO l_img10 FROM img_file WHERE img01 = g_result[g_cnt] 
         #    AND img02 = l_ck AND img10 <> 0
         #    AND img03 = ' ' AND img04 = ' '
 
         #IF l_img10 IS NULL THEN LET l_img10 =0 END IF
         #IF l_img10 = 0 THEN CONTINUE FOR END IF
         #TQC-AC0308-----------mod-----------end------------         
 
          LET l_ima25 = NULL
          SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_result[g_cnt]
 
          INSERT INTO rux_file(rux00,rux01,rux02,rux03,rux04,rux05,
                              rux06,rux07,rux08,ruxplant,ruxlegal)
           #TQC-AC0308-----------mod-----------str-----------
           #  VALUES('1',l_newno,l_cnt,g_result[g_cnt],l_ima25,l_img10,
           #          0,0,0-l_img10,g_rus.rusplant,g_rus.ruslegal) 
              VALUES('1',l_newno,l_cnt,g_result[g_cnt],l_ima25,0,
                      0,0,0,g_rus.rusplant,g_rus.ruslegal) 
           #TQC-AC0308-----------mod-----------end------------
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_errno = SQLCA.sqlcode
             LET g_success = 'N'
             RETURN
          END IF
          LET l_cnt = l_cnt + 1
      END FOR
      #l_cnt = 1表示盤點單單身中沒有符合條件的商品，單頭也就不insert
      IF l_cnt != 1THEN 
         #TQC-C20488---add----begin----
         #服飾行業，生成母料件單身的資料
         IF s_industry("slk") THEN
            IF NOT t210_createno_slk(l_newno) THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         #TQC-C20488---end----begin----
         INSERT INTO ruw_file(ruw00,ruw01,ruw02,ruw04,ruw05,ruw06,
                              ruwconf,ruwmksg,ruw900,ruwplant,ruwgrup,
                              ruwuser,ruwcrat,ruwacti,ruwlegal,ruworiu,ruworig)
              VALUES('1',l_newno,g_rus.rus01,g_rus.rus04, 
                     l_ck,g_user,'N','N','0',g_rus.rusplant,
                     g_grup,g_user,g_today,'Y',g_rus.ruslegal, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
            LET g_errno = SQLCA.sqlcode
            LET g_success = 'N'
            RETURN
         END IF
         LET l_count = l_count + 1
      END IF
   END WHILE
  
   #l_count=0->生成的盤點單中所有盤點單的單身都沒有insert value,則單頭也不insert
   IF l_count = 0 THEN 
      LET g_errno = 'art-420' 
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#結案
FUNCTION t210_end()
DEFINE l_ruw01     LIKE ruw_file.ruw01
DEFINE l_ruw03     LIKE ruw_file.ruw02
DEFINE l_ruw08     LIKE ruw_file.ruw08
DEFINE l_cnt       LIKE type_file.num5
 
#No.FUN-9B0025 --Begin
   IF g_rus.rusplant<>g_plant THEN
      CALL cl_err('','art-120',0)
      RETURN
   END IF
#No.FUN-9B0025 --End
   IF g_rus.rusconf <> 'Y' THEN CALL cl_err(g_rus.rus01,'art-416',0) RETURN END IF
 
   LET g_sql = "SELECT ruw01,ruw03 FROM ruw_file WHERE ruw00 = '1' AND ruw02 ='",
               g_rus.rus01,"'"
   PREPARE t210_ruw01 FROM g_sql
   DECLARE ruw01_cs CURSOR FOR t210_ruw01
 
   LET l_cnt = 0
   FOREACH ruw01_cs INTO l_ruw01,l_ruw03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_ruw03 IS NULL THEN
         CALL cl_err(l_ruw01,'art-414',1)
         RETURN
      END IF
      SELECT ruw08 INTO l_ruw08 FROM ruw_file WHERE ruw00 = '2'
       # AND ruw01 = l_ruw03 AND ruw930 = g_rus.rusplant         #TQC-B10011
         AND ruw01 = l_ruw03                                     #TQC-B10011
      IF l_ruw08 IS NULL THEN LET l_ruw08 = 'N' END IF
      IF l_ruw08 = 'N' THEN CALL cl_err(l_ruw03,'art-415',1) RETURN END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   IF l_cnt = 0 THEN CALL cl_err('','art-415',1) RETURN END IF
 
   BEGIN WORK
   OPEN t210_cl USING g_rus.rus01
   IF STATUS THEN
      CALL cl_err("OPEN t210_cl:", STATUS, 1)
      CLOSE t210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE rus_file SET rus16 = 'Y' WHERE rus01 = g_rus.rus01 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","rus_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
      ROLLBACK WORK
      RETURN
   END IF
   
   #刪除盤點清單、盤點單、盤點變更單、盤點庫存備份資料
   IF g_sma.sma139 = 'Y' THEN
      #刪除盤點清單的單頭檔
      DELETE FROM ruu_file WHERE ruu02 = g_rus.rus01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ruu_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
         ROLLBACK WORK 
         RETURN 
      END IF
      #刪除盤店清單的單身檔     
      DELETE FROM ruv_file WHERE 
         ruv01 IN (SELECT ruu01 FROM ruu_file WHERE ruu02 = g_rus.rus01) 
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("del","ruv_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
         RETURN
      END IF
      #刪除盤差單單身檔
      DELETE FROM rux_file WHERE rux00 = '1' AND 
         rux01 IN (SELECT ruw01 FROM ruw_file WHERE ruw02 = g_rus.rus01 
         AND ruw00 = '1')
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","rux_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
         RETURN
      END IF
      #刪除盤點單單頭檔
      DELETE FROM ruw_file WHERE ruw02 = g_rus.rus01 
         AND ruw00 = '1'
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("del","ruw_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
         RETURN
      END IF
      #清空盤差單的盤點單號
      UPDATE ruw_file SET ruw03 = NULL WHERE ruw00 = '2' AND ruw02 = g_rus.rus01
      #刪除盤點庫存備份資料
      DELETE FROM rut_file WHERE rut01 = g_rus.rus01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","rux_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
         RETURN
      END IF
      #刪除盤點變更單單頭
      DELETE FROM ruy_file WHERE ruy02 = g_rus.rus01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ruy_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
         RETURN
      END IF
      #刪除盤點變更單單身檔
      DELETE FROM ruz_file WHERE 
         ruz01 IN (SELECT ruy01 FROM ruy_file WHERE ruy02 = g_rus.rus01) 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ruz_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
         ROLLBACK WORK
         RETURN
      END IF
   END IF
   COMMIT WORK
 
   LET g_rus.rus16 = 'Y' 
   DISPLAY BY NAME g_rus.rus16
   CALL cl_err('','art-497',0)
END FUNCTION

#TQC-AB0287 ----------------------------mark
# FUNCTION t210_void()
# DEFINE l_ruw08     LIKE ruw_file.ruw08
# DEFINE l_n         LIKE type_file.num5
# DEFINE l_ruscont  LIKE rus_file.ruscont   #FUN-870100
#
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#
#  IF g_rus.rus01 IS NULL OR g_rus.rusplant IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF 
#
#  SELECT * INTO g_rus.* FROM rus_file 
#      WHERE rus01=g_rus.rus01 
#  #審核過的盤點計劃才可以廢止
#  IF g_rus.rusconf <> 'Y' THEN
#     CALL cl_err('','art-081',0) 
#     RETURN
#  END IF
#  #檢查用過該盤店計劃的盤差單是否已經調整過庫存，調整過不能廢止
#  LET g_sql = "SELECT ruw08 FROM ruw_file WHERE ruw00='2' ",
#               " AND  ruw02 = '",g_rus.rus01,"'"
#  PREPARE t210_ruw_pb FROM g_sql
#  DECLARE ruw1_cs CURSOR FOR t210_ruw_pb
#  FOREACH ruw1_cs INTO l_ruw08
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     IF l_ruw08 IS NULL THEN LET l_ruw08 = 'N' END IF
#     IF l_ruw08 = 'Y' THEN CALL cl_err('','art-413',0) RETURN END IF
#  END FOREACH
#
#  # 查看該盤點計劃是否已經被用過                                                                                                   
#  SELECT COUNT(*) INTO l_n FROM ruw_file WHERE ruw02 = g_rus.rus01
#  IF l_n > 0 THEN CALL cl_err('','art-410',0) RETURN END IF
#  #查看盤點計劃是否已經被盤點清單用過
#  LET l_n = 0    
#  SELECT COUNT(*) INTO l_n FROM ruu_file WHERE ruu02 = g_rus.rus01 
#  IF l_n >0 THEN CALL cl_err('','art-410',0) RETURN END IF
#
#  BEGIN WORK
#  OPEN t210_cl USING g_rus.rus01
#  IF STATUS THEN
#     CALL cl_err("OPEN t210_cl:", STATUS, 1)
#     CLOSE t210_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#  FETCH t210_cl INTO g_rus.*
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(g_rus.rus01,SQLCA.sqlcode,0)
#     CLOSE t210_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#   IF NOT cl_confirm('lib-016') THEN                                                                                                
#      RETURN                                                                                                                      
#   END IF
#    LET l_ruscont=TIME    #FUN-870100
#    UPDATE rus_file SET rusconf = 'X',ruscont=l_ruscont WHERE rus01 = g_rus.rus01     
#    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err3("upd","rus_file",g_rus.rus01,"",SQLCA.sqlcode,"","",1)
#       ROLLBACK WORK
#       RETURN
#    END IF
#  COMMIT WORK
#  LET g_rus.rusconf = 'X'               
#  DISPLAY BY NAME g_rus.rusconf
#  DISPLAY BY NAME g_rus.ruscont     #FUN-870100
#  CALL t210_show()   

# END FUNCTION 
#TQC-AB0287 ------------------------------------mark

FUNCTION t210_a()
DEFINE li_result   LIKE type_file.num5 
DEFINE l_azp02     LIKE azp_file.azp02
 
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_rus.* LIKE rus_file.*
    LET g_rus01_t = NULL
    LET g_rusplant_t = NULL
    LET g_wc = NULL
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_rus.rususer = g_user
        LET g_rus.rusoriu = g_user #FUN-980030
        LET g_rus.rusorig = g_grup #FUN-980030
        LET g_data_plant  =g_plant #TQC-A10128
        LET g_rus.rusgrup = g_grup
        LET g_rus.ruscrat = g_today
        LET g_rus.rusacti = 'Y'
        LET g_rus.rus03 = g_today
        LET g_rus.rus04 = g_today
        LET g_rus.rusplant = g_plant
        LET g_rus.ruslegal = g_legal
        LET g_rus.rus900 = '0'
        LET g_rus.rusmksg = 'N'
        #LET g_rus.rus15 = 'N'  #TQC-AC0169 mark
        LET g_rus.rus16 = 'N'
        LET g_rus.rus06 = 'N'
        LET g_rus.rus08 = 'N'
        LET g_rus.rus10 = 'N'
        LET g_rus.rus12 = 'N'
        LET g_rus.rusconf = 'N'
        #LET g_rus.ruspos = 'N' #FUN-B50042 mark
        SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rus.rusplant    
        DISPLAY l_azp02 TO rusplant_desc
        CALL t210_i("a")
        IF INT_FLAG THEN 
            INITIALIZE g_rus.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_rus.rus01 IS NULL OR g_rus.rusplant IS NULL THEN
            CONTINUE WHILE
        END IF
        BEGIN WORK
#       CALL s_auto_assign_no("art",g_rus.rus01,g_today,"","rus_file","rus01","","","")  #FUN-A70130 mark
        CALL s_auto_assign_no("art",g_rus.rus01,g_today,"D5","rus_file","rus01","","","")  #FUN-A70130 mod
           RETURNING li_result,g_rus.rus01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_rus.rus01

#TQC-B80038 --BEGIN--
        IF cl_null(g_rus.ruspos) THEN
           LET g_rus.ruspos = 'N'
        END IF
#TQC-B80038 --END--

        INSERT INTO rus_file VALUES(g_rus.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rus_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
       	   COMMIT WORK 
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t210_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5,
            li_result   LIKE type_file.num5,
            l_rtz04     LIKE rtz_file.rtz04, 
            l_flag      LIKE type_file.num5
 
   DISPLAY BY NAME
      g_rus.rus01,g_rus.rus02,g_rus.rus03,g_rus.rus04,
  #    g_rus.rus05,g_rus.rus14,g_rus.ruspos,g_rus.rusmksg,g_rus.rus06,   #FUN-870100     #TQC-AB0287 mark
      g_rus.rus05,g_rus.rus14,g_rus.rus06,                               #TQC-AB0287     #FUN-B50042 remove POS
      g_rus.rus07,g_rus.rus08,
      g_rus.rus09,g_rus.rus10,g_rus.rus11,g_rus.rus12,
 #     g_rus.rus13,g_rus.rus15,g_rus.rus16,g_rus.rusmksg,                                #TQC-AB0287 mark
      g_rus.rus13,g_rus.rus16,                                               #TQC-AB0287
      g_rus.rus900,g_rus.rusconf,g_rus.ruscond,g_rus.rusconu,g_rus.ruscont, #FUN-870100
      g_rus.rusplant,
      g_rus.rususer,g_rus.rusgrup,g_rus.rusmodu,
      g_rus.rusdate,g_rus.rusacti,g_rus.ruscrat
     ,g_rus.rusoriu,g_rus.rusorig                                #TQC-A30041 ADD 

   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_rus.rusplant                                                
   
   INPUT BY NAME g_rus.rusoriu,g_rus.rusorig,
      g_rus.rus01,g_rus.rus02,g_rus.rus03,g_rus.rus04,
 #     g_rus.rus05,g_rus.rus14,g_rus.rusmksg,                                            #TQC-AB0287 mark
      g_rus.rus05,g_rus.rus14,                                                           #TQC-AB0287
      g_rus.rus06,g_rus.rus07,g_rus.rus08,
      g_rus.rus09,g_rus.rus10,g_rus.rus11,g_rus.rus12,
      g_rus.rus13,g_rus.rus16,
      g_rus.rus900,g_rus.rusconf,g_rus.ruscond,g_rus.rusconu,
      g_rus.rusplant,
      g_rus.rususer,g_rus.rusgrup,g_rus.rusmodu,
      g_rus.rusdate,g_rus.rusacti,g_rus.ruscrat
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t210_set_entry(p_cmd)
          CALL t210_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("rus01")
          IF g_rus.rus06 = 'Y' THEN     
             CALL cl_set_comp_entry("rus07",TRUE)       
          ELSE                                         
             CALL cl_set_comp_entry("rus07",FALSE)  
          END IF
          IF g_rus.rus08 = 'Y' THEN 
             CALL cl_set_comp_entry("rus09",TRUE) 
          ELSE
             CALL cl_set_comp_entry("rus09",FALSE) 
          END IF
          IF g_rus.rus10 = 'Y' THEN 
             CALL cl_set_comp_entry("rus11",TRUE)
          ELSE
             CALL cl_set_comp_entry("rus11",FALSE)
          END IF
          IF g_rus.rus12 = 'Y' THEN 
             CALL cl_set_comp_entry("rus13",TRUE)
          ELSE 
             CALL cl_set_comp_entry("rus13",FALSE)
          END IF
      AFTER FIELD rus01
         DISPLAY "AFTER FIELD rus01"
         IF g_rus.rus01 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rus.rus01 != g_rus01_t) THEN
#              CALL s_check_no("art",g_rus.rus01,g_rus01_t,"D","rus_file","rus01","") #FUN-A70130 mark
               CALL s_check_no("art",g_rus.rus01,g_rus01_t,"D5","rus_file","rus01","") #FUN-A70130 mod
                  RETURNING li_result,g_rus.rus01
               DISPLAY BY NAME g_rus.rus01
               IF (NOT li_result) THEN
                  LET g_rus.rus01=g_rus_t.rus01
                  NEXT FIELD rus01
               END IF
            END IF
         END IF
 
      AFTER FIELD rus04
         IF g_rus.rus04 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rus.rus04 != g_rus_t.rus04) THEN 
               IF g_rus.rus04 < g_today THEN
                  CALL cl_err('','art-346',0)
                  NEXT FIELD rus04
               END IF
               #CALL t210_check_store()
               #IF NOT cl_null(g_errno) THEN
               #   CALL cl_err('',g_errno,0)
               #     NEXT FIELD rus04
               # END IF
            END IF
         END IF
 
      AFTER FIELD rus05
         IF g_rus.rus05 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd = "u" AND g_rus.rus05 != g_rus_t.rus05) THEN          
               CALL t210_rus05()
               IF NOT cl_null(g_errno)  THEN 
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rus05        
               END IF
               #CALL t210_check_store()                                                                                              
               #IF NOT cl_null(g_errno) THEN                                                                                         
               #   CALL cl_err('',g_errno,0)                                                                                         
               #   NEXT FIELD rus04                                                                                                  
               #END IF
            END IF
         END IF
      AFTER FIELD rus06
         IF g_rus.rus06 IS NOT NULL THEN
            IF g_rus.rus06 = 'Y' THEN
               CALL cl_set_comp_entry("rus07",TRUE)
            ELSE
               LET g_rus.rus07 = ''
               DISPLAY BY NAME g_rus.rus07
       	       CALL cl_set_comp_entry("rus07",FALSE)
            END IF
         END IF
         
      ON CHANGE rus06          
         IF g_rus.rus06 IS NOT NULL THEN
            IF g_rus.rus06 = 'Y' THEN
               CALL cl_set_comp_entry("rus07",TRUE)
            ELSE
               LET g_rus.rus07 = ''
               DISPLAY BY NAME g_rus.rus07
               CALL cl_set_comp_entry("rus07",FALSE)
            END IF
         END IF
   
      AFTER FIELD rus07
         IF g_rus.rus07 IS NOT NULL THEN
            CALL t210_rus07()
            IF NOT cl_null(g_errno)  THEN  
               CALL cl_err('',g_errno,0)
               NEXT FIELD rus07        
            END IF
         END IF
      AFTER FIELD rus09
         IF g_rus.rus09 IS NOT NULL THEN
            CALL t210_rus09()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rus09
            END IF 
         END IF
 
      AFTER FIELD rus11
         IF g_rus.rus11 IS NOT NULL THEN
            CALL t210_rus11()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD rus11
            END IF
         END IF
      AFTER FIELD rus13
         IF g_rus.rus13 IS NOT NULL THEN
            #TQC-B10004 mark -----------------begin---------------------------
            ##FUN-AB0025 ---------------------start----------------------------
            #IF NOT s_chk_item_no(g_rus.rus13,"") THEN
            #   CALL cl_err('',g_errno,1)
            #   LET g_rus.rus13=g_rus_t.rus13 
            #   NEXT FIELD rus13
            #END IF
            ##FUN-AB0025 ---------------------end-------------------------------
            #TQC-B10004 mark ------------------end----------------------------
            IF cl_null(l_rtz04) THEN
               CALL t210_rus13_1()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rus13
               END IF
            ELSE
               CALL t210_rus13()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD rus13
               END IF
            END IF
         END IF
 
      AFTER FIELD rus08
         IF g_rus.rus08 IS NOT NULL THEN
            IF g_rus.rus08 = 'Y' THEN
               CALL cl_set_comp_entry("rus09",TRUE)
            ELSE
               LET g_rus.rus09 = ''
               DISPLAY BY NAME g_rus.rus09
               CALL cl_set_comp_entry("rus09",FALSE)
            END IF
         END IF
         
      ON CHANGE rus08          
         IF g_rus.rus08 IS NOT NULL THEN
            IF g_rus.rus08 = 'Y' THEN
               CALL cl_set_comp_entry("rus09",TRUE)
            ELSE
               LET g_rus.rus09 = ''
               DISPLAY BY NAME g_rus.rus09
               CALL cl_set_comp_entry("rus09",FALSE)
            END IF
         END IF   
         
      AFTER FIELD rus10
         IF g_rus.rus10 IS NOT NULL THEN
            IF g_rus.rus10 = 'Y' THEN
               CALL cl_set_comp_entry("rus11",TRUE)
            ELSE
               LET g_rus.rus11 = ''
               DISPLAY BY NAME g_rus.rus11
               CALL cl_set_comp_entry("rus11",FALSE)
            END IF
         END IF
         
      ON CHANGE rus10          
         IF g_rus.rus10 IS NOT NULL THEN
            IF g_rus.rus10 = 'Y' THEN
               CALL cl_set_comp_entry("rus11",TRUE)
            ELSE
               LET g_rus.rus11 = ''
               DISPLAY BY NAME g_rus.rus11
               CALL cl_set_comp_entry("rus11",FALSE)
            END IF
         END IF
      
      AFTER FIELD rus12
         IF g_rus.rus12 IS NOT NULL THEN
            IF g_rus.rus12 = 'Y' THEN
               CALL cl_set_comp_entry("rus13",TRUE)
            ELSE
               LET g_rus.rus13 = ''
               DISPLAY BY NAME g_rus.rus13
               CALL cl_set_comp_entry("rus13",FALSE)
            END IF
         END IF
         
      ON CHANGE rus12          
         IF g_rus.rus12 IS NOT NULL THEN
            IF g_rus.rus12 = 'Y' THEN
               CALL cl_set_comp_entry("rus13",TRUE)
            ELSE
               LET g_rus.rus13 = ''
               DISPLAY BY NAME g_rus.rus13
               CALL cl_set_comp_entry("rus13",FALSE)
            END IF
         END IF
      
      #bnl -090408 begin
      AFTER FIELD rusplant
         IF g_rus.rusplant IS NOT NULL THEN
            CALL t210_rusplant('a')
            IF NOT cl_null(g_errno)  THEN  
               CALL cl_err('',g_errno,0)
               NEXT FIELD rusplant       
            END IF
         END IF
      #bnl -090408 end
            
      AFTER INPUT
         LET g_rus.rususer = s_get_data_owner("rus_file") #FUN-C10039
         LET g_rus.rusgrup = s_get_data_group("rus_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_rus.rus01 IS NULL THEN
               DISPLAY BY NAME g_rus.rus01
               LET l_input='Y'
            END IF
            #CALL t210_check_shop() RETURNING l_flag
            #IF l_flag = -1 THEN
            #   CALL cl_err('','art-367',0)
            #   NEXT FIELD rus07
            #END IF
 
            IF l_input='Y' THEN
               NEXT FIELD rus01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(rus01) THEN
            LET g_rus.* = g_rus_t.*
            CALL t210_show()
            NEXT FIELD rus01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rus01)
              LET g_t1=s_get_doc_no(g_rus.rus01)                                                                                    
#             CALL q_smy(FALSE,FALSE,g_t1,'ART','D') RETURNING g_t1    #FUN-A70130--mark--                                                             
              CALL q_oay(FALSE,FALSE,g_t1,'D5','ART') RETURNING g_t1    #FUN-A70130--end--                                                             
              LET g_rus.rus01 = g_t1                                                                                                
              DISPLAY BY NAME g_rus.rus01 
              NEXT FIELD rus01
              
           WHEN INFIELD(rus05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imd01_2"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = g_rus.rusplant
              LET g_qryparam.default1 = g_rus.rus05
              CALL cl_create_qry() RETURNING g_rus.rus05
              DISPLAY BY NAME g_rus.rus05
              NEXT FIELD rus05
 
           WHEN INFIELD(rus07)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima131_1"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_rus.rus07
              CALL cl_create_qry() RETURNING g_rus.rus07
              DISPLAY BY NAME g_rus.rus07
              NEXT FIELD rus07
              
           WHEN INFIELD(rus09)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima1005"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_rus.rus09
              CALL cl_create_qry() RETURNING g_rus.rus09
              DISPLAY BY NAME g_rus.rus09
              NEXT FIELD rus09
           
           WHEN INFIELD(rus11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rty05_2"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_rus.rus11
              LET g_qryparam.arg1 = g_rus.rusplant
              CALL cl_create_qry() RETURNING g_rus.rus11
              DISPLAY BY NAME g_rus.rus11
              NEXT FIELD rus11
              
           WHEN INFIELD(rus13)
#FUN-AA0059---------mod------------str-----------------           
#              CALL cl_init_qry_var()
#             IF cl_null(l_rtz04) THEN
#                 LET g_qryparam.form = "q_ima"
#             ELSE
#                SELECT rtz04 INTO l_rtz04 FROM rtz_file 
#                   WHERE rtz01 = g_rus.rusplant
#                CALL cl_init_qry_var()    
#                LET g_qryparam.arg1 = l_rtz04
#                LET g_qryparam.form = "q_rte03_6"
#                LET g_qryparam.state = "c"
#                LET g_qryparam.default1 = g_rus.rus13
#                CALL cl_create_qry() RETURNING g_rus.rus13
#             END IF
#              LET g_qryparam.state = "c"
#              LET g_qryparam.default1 = g_rus.rus13
#              CALL cl_create_qry() RETURNING g_rus.rus13
               CALL q_sel_ima(TRUE, "q_ima","",g_rus.rus13,"","","","","",'')
                 RETURNING  g_rus.rus13                                     
#FUN-AA0059---------mod------------end-----------------
              DISPLAY BY NAME g_rus.rus13
              NEXT FIELD rus13
          #bnl 090408 begin
          WHEN INFIELD(rusplant)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_azp"
              LET g_qryparam.default1 = g_rus.rusplant
              CALL cl_create_qry() RETURNING g_rus.rusplant
              DISPLAY BY NAME g_rus.rusplant
              CALL t210_rusplant('d')
              NEXT FIELD rusplant
          #bnl 090408 end
                
           OTHERWISE
              EXIT CASE
           END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
END FUNCTION
#檢查當前設定的盤點日期，在沒有任何限定的情況下，是否有盤點過當前設定的倉庫
FUNCTION t210_check_store()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_n             LIKE type_file.num5
 
   IF g_rus.rus04 IS NULL OR g_rus.rus05 IS NULL THEN
      RETURN
   END IF
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus.rus13,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT COUNT(*) INTO l_n FROM rus_file WHERE rus04 = g_rus.rus04
         AND rus05 = l_ck AND rus06 = 'N' 
         AND rus08 = 'N' AND rus10 = 'N' AND rus12 = 'N'
      IF l_n IS NULL THEN LET l_n = 0 END IF
      IF l_n <> 0 THEN
         LET g_errno = 'art-368'
         RETURN
      END IF
   END WHILE
END FUNCTION
#檢查同一日期、同一倉庫、同一機構是否已經盤店過該商品
FUNCTION t210_repate()
DEFINE l_ck            LIKE type_file.chr50                                                                                        
DEFINE tok             base.StringTokenizer
DEFINE l_result        DYNAMIC ARRAY OF LIKE ima_file.ima01  #當前商品的交集
DEFINE l_i             LIKE type_file.num5
DEFINE l_j             LIKE type_file.num5
DEFINE l_old_rus05     LIKE rus_file.rus05
DEFINE l_old_rus07     LIKE rus_file.rus07
DEFINE l_old_rus09     LIKE rus_file.rus07
DEFINE l_old_rus11     LIKE rus_file.rus07
DEFINE l_old_rus13     LIKE rus_file.rus07
DEFINE l_flag          LIKE type_file.num5
DEFINE l_ck1           LIKE type_file.chr50
DEFINE tok1            base.StringTokenizer
 
   LET g_errno = ''
   
   #當前商品的交集
   FOR g_cnt=1 TO g_result.getLength()
       LET l_result[g_cnt] = g_result[g_cnt]
   END FOR
 
   LET l_old_rus05 = g_rus.rus05
   LET l_old_rus07 = g_rus.rus07
   LET l_old_rus09 = g_rus.rus09
   LET l_old_rus11 = g_rus.rus11
   LET l_old_rus13 = g_rus.rus13
 
   LET g_sql = "SELECT rus05,rus07,rus09,rus11,rus13 FROM rus_file ",
               " WHERE (rus06 <> 'N' OR rus08 <> 'N' OR rus10 <> 'N' OR rus12 <> 'N') ",
               " AND rusacti = 'Y' AND rusconf = 'Y' AND rus04 = '",g_rus.rus04,"' ",
               " AND rusplant = '",g_rus.rusplant,"'"
   PREPARE trus1_pb FROM g_sql
   DECLARE rus05_cs1 CURSOR FOR trus1_pb
   FOREACH rus05_cs1 INTO g_rus.rus05,g_rus.rus07,g_rus.rus09,g_rus.rus11,g_rus.rus13
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #沒有商品限定情況的盤點
      IF g_rus.rus06 = 'N' AND g_rus.rus08 = 'N' 
         AND g_rus.rus10 = 'N' AND g_rus.rus12 = 'N' THEN
         LET tok = base.StringTokenizer.createExt(g_rus.rus05,"|",'',TRUE)
         WHILE tok.hasMoreTokens()
            LET l_ck = tok.nextToken()
            LET tok1 = base.StringTokenizer.createExt(l_old_rus05,"|",'',TRUE)
            WHILE tok1.hasMoreTokens()
               LET l_ck1 = tok1.nextToken()
               IF l_ck = l_ck1 THEN LET g_errno = 'art-371' RETURN END IF
            END WHILE   
         END WHILE
      END IF   
      CALL t210_check_shop() RETURNING l_flag
      IF l_flag = -1 THEN CONTINUE FOREACH END IF
      FOR l_i = 1 TO l_result.getLength()    #遍歷當前要盤點的商品
         LET tok1 = base.StringTokenizer.createExt(l_old_rus05,"|",'',TRUE)
         WHILE tok1.hasMoreTokens()          #遍歷當前要盤點的倉庫
            LET l_ck1 = tok1.nextToken()
            FOR l_j = 1 TO g_result.getLength()   #遍歷當天已經盤店過的商品
               LET tok = base.StringTokenizer.createExt(g_rus.rus05,"|",'',TRUE)
               WHILE tok.hasMoreTokens()          #遍歷當天已經盤店過的倉庫
                  LET l_ck = tok.nextToken()
                  IF l_result[l_i] = g_result[l_j] AND l_ck = l_ck1 THEN
                     LET g_errno = 'art-371'
                     LET g_rus.rus07 = l_old_rus07
                     LET g_rus.rus09 = l_old_rus09
                     LET g_rus.rus11 = l_old_rus11
                     LET g_rus.rus13 = l_old_rus13
                     RETURN
                  END IF
               END WHILE
            END FOR
         END WHILE
      END FOR
   END FOREACH
   LET g_rus.rus07 = l_old_rus07
   LET g_rus.rus09 = l_old_rus09
   LET g_rus.rus11 = l_old_rus11
   LET g_rus.rus13 = l_old_rus13
END FUNCTION
#檢查品類、品牌、廠商、商品之間是否有交集
#返回值：0----->表示盤點商品策略中所有的商品
#       -1----->表示品類、品牌、廠商、商品之間沒有交集
#        1----->表示品類、品牌、廠商、商品之間有交集
FUNCTION t210_check_shop()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_n1            LIKE type_file.num5
DEFINE l_n2            LIKE type_file.num5
DEFINE l_n3            LIKE type_file.num5   
DEFINE l_n4            LIKE type_file.num5
DEFINE l_sql           STRING
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_rte03         LIKE rte_file.rte03
 
   LET g_errno = ''
   #如果品類、品牌、廠商、商品都沒有錄入資料，返回0，表示盤點當前機構商品策略中的商品
   IF cl_null(g_rus.rus07) AND cl_null(g_rus.rus09)
      AND cl_null(g_rus.rus11) AND cl_null(g_rus.rus13) THEN
      SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus.rusplant
      IF NOT cl_null(l_rtz04) THEN
         LET l_sql = "SELECT rte03 FROM rte_file WHERE rte01 = '",l_rtz04,"' AND rte07 = 'Y' "
         PREPARE rte_pb1 FROM l_sql
         DECLARE rte_cs1 CURSOR FOR rte_pb1
         LET g_cnt = 1
         FOREACH rte_cs1 INTO l_rte03
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF l_rte03 IS NULL THEN CONTINUE FOREACH END IF
            LET g_result[g_cnt] = l_rte03
            LET g_cnt = g_cnt + 1
         END FOREACH
         CALL g_result.deleteElement(g_cnt)
         RETURN 0
      END IF
   END IF
 
  #CREATE TEMP TABLE sort(ima01 varchar(40))            #FUN-9B0025 MARK
   CREATE TEMP TABLE sort(
                          ima01 LIKE ima_file.ima01)    #FUN-9B0025 ADD
  #CREATE TEMP TABLE sign(ima01 varchar(40))            #FUN-9B0025 MARK 
   CREATE TEMP TABLE sign(
                          ima01 LIKE ima_file.ima01)    #FUN-9B0025 ADD
  #CREATE TEMP TABLE factory(ima01 varchar(40))         #FUN-9B0025 MARK   
   CREATE TEMP TABLE factory(
                             ima01 LIKE ima_file.ima01) #FUN-9B0025 ADD
  #CREATE TEMP TABLE no(ima01 varchar(40))              #FUN-9B0025 MARK
   CREATE TEMP TABLE no(
                        ima01 LIKE ima_file.ima01)      #FUN-9B0025 ADD

   CALL t210_get_sort()
   CALL t210_get_sign()
   CALL t210_get_factory()
   CALL t210_get_no()
 
   SELECT count(*) INTO l_n1 FROM sort
   SELECT count(*) INTO l_n2 FROM sign
   SELECT count(*) INTO l_n3 FROM factory
   SELECT count(*) INTO l_n4 FROM no
  
   CALL g_result.clear()
 
   IF l_n1 != 0 THEN               #有品類限定
      IF l_n2 != 0 THEN            #有品類限定、品牌限定
         IF l_n3 != 0 THEN         #有品類限定、品牌限定、廠商限定
            IF l_n4 != 0 THEN      #有品類限定、品牌限定、廠商限定、商品限定
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 ",
                           " AND C.ima01 = D.ima01 "
            ELSE                   #有品類限定、品牌限定、廠商限定，無商品限定
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 "
            END IF
         ELSE                     
            IF l_n4 != 0 THEN      #有品類限定、品牌限定、商品限定，無廠商限定
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = D.ima01 "
            ELSE                   #有品類限定、品牌限定、無商品限定，無廠商限定
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B ",
                           " WHERE A.ima01 = B.ima01 "
            END IF
         END IF
      ELSE
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,factory C,no D ",
                           " WHERE A.ima01 = C.ima01 AND D.ima01 = C.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,factory C ",
                           " WHERE A.ima01 = C.ima01 "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,no D ",
                           " WHERE A.ima01 = D.ima01"
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A "
            END IF
         END IF
      END IF
   ELSE
      IF l_n2 != 0 THEN
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT B.ima01 FROM sign B,factory C,no D ",
                           " WHERE B.ima01 = C.ima01 AND D.ima01 = C.ima01 " 
            ELSE
               LET l_sql = "SELECT B.ima01 FROM sign B,factory C ",
                           " WHERE B.ima01 = C.ima01 "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT B.ima01 FROM sign B,no D ",
                           " WHERE B.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT B.ima01 FROM sign B "
            END IF
         END IF
      ELSE
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT C.ima01 FROM factory C,no D ",
                           " WHERE C.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT C.ima01 FROM factory C "
            END IF
         ELSE
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT D.ima01 FROM no D "
            END IF
         END IF
      END IF
   END IF
   
   IF l_sql IS NULL THEN RETURN 0 END IF
   PREPARE t210_get_pb FROM l_sql
   DECLARE rus_get_cs1 CURSOR FOR t210_get_pb
   LET g_cnt = 1
   FOREACH rus_get_cs1 INTO g_result[g_cnt]
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET g_cnt = g_cnt + 1
   END FOREACH  
   CALL g_result.deleteElement(g_cnt)
 
   DROP TABLE sort
   DROP TABLE sign
   DROP TABLE factory
   DROP TABLE no
 
   IF g_result.getLength() = 0 THEN
      RETURN -1
   ELSE
      IF cl_null(g_result[1]) THEN
         RETURN -1
      END IF
      RETURN 1
   END IF
END FUNCTION
#獲取所選擇品類中所有的商品
FUNCTION t210_get_sort()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
    CALL g_sort.clear()
    #獲取所選擇品類中所有的商品                                                                                                      
    IF NOT cl_null(g_rus.rus07) THEN
       LET tok = base.StringTokenizer.createExt(g_rus.rus07,"|",'',TRUE)
       LET g_cnt = 1
       WHILE tok.hasMoreTokens()
          LET l_ck = tok.nextToken()
          #取出當前品類對應的所有商品
          LET g_sql = "SELECT ima01 FROM ima_file WHERE ima131 = '",l_ck,"'"  
         #TQC-C20488---add----begin----
         #服飾行業，不提取母料件資料
         IF s_industry("slk") THEN
            LET g_sql = g_sql CLIPPED," AND ima151<>'Y'"
         END IF
         #TQC-C20488---end----begin----

          PREPARE t210_pb1 FROM g_sql
          DECLARE rus_cs1 CURSOR FOR t210_pb1
          FOREACH rus_cs1 INTO g_sort[g_cnt]
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
             INSERT INTO sort VALUES(g_sort[g_cnt])
             LET g_cnt = g_cnt + 1
          END FOREACH
       END WHILE
       CALL g_sort.deleteElement(g_cnt)
    END IF
END FUNCTION
#獲取品牌中所有的商品
FUNCTION t210_get_sign()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   CALL g_sign.clear()
   #獲取品牌中所有的商品
   IF NOT cl_null(g_rus.rus09) THEN
      LET tok = base.StringTokenizer.createExt(g_rus.rus09,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         #取出當前品類對應的所有商品                                                                                                
         LET g_sql = "SELECT ima01 FROM ima_file WHERE ima1005 = '",l_ck,"'"
         #TQC-C20488---add----begin----
         #服飾行業，不提取母料件資料
         IF s_industry("slk") THEN
            LET g_sql = g_sql CLIPPED," AND ima151<>'Y'"
         END IF
         #TQC-C20488---end----begin----
         PREPARE t210_pb2 FROM g_sql
         DECLARE rus_cs2 CURSOR FOR t210_pb2
         FOREACH rus_cs2 INTO g_sign[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            INSERT INTO sign VALUES(g_sign[g_cnt])
            LET g_cnt = g_cnt + 1
         END FOREACH
      END WHILE
      CALL g_sign.deleteElement(g_cnt)
   END IF   
END FUNCTION
#獲取廠商中所有的商品
FUNCTION t210_get_factory()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
   
   CALL g_factory.clear()
   IF NOT cl_null(g_rus.rus11) THEN
      LET tok = base.StringTokenizer.createExt(g_rus.rus11,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         #取出當前品類對應的所有商品                                                                                                
         LET g_sql = "SELECT rty02 FROM rty_file ",
                     " WHERE rty05 = '",l_ck,"' AND rty01 = '",g_rus.rusplant,"'" 
         #TQC-C20488---add----begin----
         #服飾行業，不提取母料件資料
         IF s_industry("slk") THEN
            LET g_sql = g_sql CLIPPED," AND ima151<>'Y'"
         END IF
         #TQC-C20488---end----begin----

         PREPARE t210_pb3 FROM g_sql
         DECLARE rus_cs3 CURSOR FOR t210_pb3
         FOREACH rus_cs3 INTO g_factory[g_cnt]
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            INSERT INTO factory VALUES(g_factory[g_cnt])
            LET g_cnt = g_cnt + 1
         END FOREACH
      END WHILE
      CALL g_factory.deleteElement(g_cnt)
   END IF
END FUNCTION
#獲取商品編號中所有的商品
FUNCTION t210_get_no()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_ima151        LIKE ima_file.ima151    #TQC-C20488 add
   
   CALL g_no.clear()
   IF NOT cl_null(g_rus.rus13) THEN
      LET tok = base.StringTokenizer.createExt(g_rus.rus13,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         LET g_no[g_cnt] = l_ck
         #TQC-C20488---add----begin----
         #服飾行業，不提取母料件資料
         IF s_industry("slk") THEN
            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=g_no[g_cnt]
            IF l_ima151='Y' THEN
               CONTINUE WHILE
            END IF
         END IF
         #TQC-C20488---end----begin----

         INSERT INTO no VALUES(g_no[g_cnt]) 
         LET g_cnt = g_cnt + 1
      END WHILE
      CALL g_no.deleteElement(g_cnt)
   END IF
END FUNCTION
#檢查產品分類碼是否合法
FUNCTION t210_rus07()
DEFINE l_obaacti       LIKE oba_file.obaacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus.rus07,"|",'',TRUE) 
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT obaacti INTO l_obaacti FROM oba_file
          WHERE oba01 = l_ck
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-349'
         RETURN
      END IF
      IF l_obaacti IS NULL OR l_obaacti = 'N' THEN
         LET g_errno = 'art-350'
         RETURN
      END IF
   END WHILE 
END FUNCTION
#檢查品牌編號是否合法
FUNCTION t210_rus09()
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_tqaacti       LIKE tqa_file.tqaacti
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus.rus09,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT tqaacti INTO l_tqaacti FROM tqa_file
          WHERE tqa01 = l_ck AND tqa03 = '2'
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-352'
         RETURN
      END IF
      IF l_tqaacti IS NULL OR l_tqaacti = 'N' THEN
         LET g_errno = 'art-353'
         RETURN
      END IF
   END WHILE
END FUNCTION
#檢查廠商編號是否合法
FUNCTION t210_rus11()
DEFINE l_pmcacti       LIKE pmc_file.pmcacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus.rus11,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         LET g_errno = 'art-358'
         RETURN
      END IF
      SELECT pmcacti INTO l_pmcacti FROM pmc_file
          WHERE pmc01 = l_ck
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-354'
         RETURN
      END IF
      IF l_pmcacti IS NULL OR l_pmcacti = 'N' THEN
         LET g_errno = 'art-355'
         RETURN
      END IF
   END WHILE
END FUNCTION
#總部情況下，檢查產品編號是否合法
FUNCTION t210_rus13_1()
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus.rus13,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN
         LET g_errno = 'art-358'
         RETURN
      END IF
      #TQC-B10004 mark -----------------begin---------------------------
      IF NOT s_chk_item_no(l_ck,"") THEN
         CALL cl_err('',g_errno,1)
         LET g_rus.rus13=g_rus_t.rus13 
         CONTINUE WHILE
      END IF 
      #TQC-B10004 mark ------------------end----------------------------
      SELECT imaacti INTO l_imaacti FROM ima_file WHERE ima01 = l_ck
      IF SQLCA.sqlcode = 100  THEN                                                                                                  
         LET g_errno = 'art-374'                                                                                                    
         RETURN                                                                                                                     
      END IF
      IF l_imaacti = 'N' THEN
         LET g_errno = 'art-375'
         RETURN
      END IF
   END WHILE
END FUNCTION
#非總部情況下檢查商品編號是否合法
FUNCTION t210_rus13()
DEFINE l_rtz04         LIKE rtz_file.rtz04
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_rte07         LIKE rte_file.rte07
 
   LET g_errno = ''
   SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01 = g_rus.rusplant
   LET tok = base.StringTokenizer.createExt(g_rus.rus13,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         LET g_errno = 'art-358'
         RETURN
      END IF
      #TQC-B10004 mark -----------------begin---------------------------
      IF NOT s_chk_item_no(l_ck,"") THEN
         CALL cl_err('',g_errno,1)
         LET g_rus.rus13=g_rus_t.rus13 
         CONTINUE WHILE
      END IF 
      #TQC-B10004 mark ------------------end----------------------------
      SELECT rte07 INTO l_rte07 FROM rte_file
          WHERE rte03 = l_ck AND rte01 = l_rtz04
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-356'
         RETURN
      END IF
      IF l_rte07 IS NULL OR l_rte07 = 'N' THEN
         LET g_errno = 'art-357'
         RETURN
      END IF
   END WHILE
END FUNCTION
#檢查倉庫是否合法
FUNCTION t210_rus05()
DEFINE l_imd11         LIKE imd_file.imd11
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_imdacti       LIKE imd_file.imdacti
 
   LET g_errno = ''
   LET tok = base.StringTokenizer.createExt(g_rus.rus05,"|",'',TRUE)
   WHILE tok.hasMoreTokens()
      LET l_ck = tok.nextToken()
      IF l_ck IS NULL THEN 
         LET g_errno = 'art-358'
         RETURN
      END IF 
      SELECT imd11,imdacti INTO l_imd11,l_imdacti FROM imd_file
          WHERE imd01 = l_ck AND imd20 = g_rus.rusplant
      IF SQLCA.sqlcode = 100  THEN
         LET g_errno = 'art-359'
         RETURN
      END IF
      IF l_imdacti IS NULL OR l_imdacti = 'N' THEN
         LET g_errno = 'art-360'
         RETURN
      END IF
      IF l_imd11 IS NULL OR l_imd11 = 'N' THEN
         LET g_errno = 'art-361'
         RETURN
      END IF
   END WHILE
END FUNCTION
FUNCTION t210_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_rus.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t210_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t210_count
    FETCH t210_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t210_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rus.rus01,SQLCA.sqlcode,0)
        INITIALIZE g_rus.* TO NULL
    ELSE
        CALL t210_fetch('F')
    END IF
END FUNCTION
 
FUNCTION t210_fetch(p_flrus)
    DEFINE
        p_flrus         LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)  
 
    CASE p_flrus
        WHEN 'N' FETCH NEXT     t210_cs INTO g_rus.rus01,g_rus.rusplant
        WHEN 'P' FETCH PREVIOUS t210_cs INTO g_rus.rus01,g_rus.rusplant
        WHEN 'F' FETCH FIRST    t210_cs INTO g_rus.rus01,g_rus.rusplant
        WHEN 'L' FETCH LAST     t210_cs INTO g_rus.rus01,g_rus.rusplant
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   #No.FUN-6A0066
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0 
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t210_cs INTO g_rus.rus01,g_rus.rusplant
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rus.rus01,SQLCA.sqlcode,0)
        INITIALIZE g_rus.* TO NULL
        RETURN
    ELSE
      CASE p_flrus
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF
 
    SELECT * INTO g_rus.* FROM rus_file
       WHERE rus01 = g_rus.rus01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rus_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
    ELSE
        LET g_data_owner=g_rus.rususer
        LET g_data_group=g_rus.rusgrup
        LET g_data_plant = g_rus.rusplant #TQC-B70048
        CALL t210_show()
    END IF
END FUNCTION
 
FUNCTION t210_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_File.azp02
 
    LET g_rus_t.* = g_rus.*
    DISPLAY BY NAME g_rus.rus01,g_rus.rus02,g_rus.rus03,g_rus.rus04, g_rus.rusoriu,g_rus.rusorig,
                    g_rus.rus05,g_rus.rus06,g_rus.rus07,g_rus.rus08,
                    g_rus.rus09,g_rus.rus10,g_rus.rus11,g_rus.rus12,
                    g_rus.rus13,g_rus.rus14,g_rus.rus16,
                    g_rus.ruscont,  #FUN-870100  #FUN-B50042 remove POS
        #            g_rus.rusconf,g_rus.ruscond,g_rus.rusconu,g_rus.rusmksg,                 #TQC-AB0287 mark
                    g_rus.rusconf,g_rus.ruscond,g_rus.rusconu,                                #TQC-AB0287
                    g_rus.rus900,g_rus.rusplant,g_rus.rususer,g_rus.rusgrup,
                    g_rus.ruscrat,g_rus.rusmodu,g_rus.rusdate,g_rus.rusacti
    SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_rus.rusplant
    DISPLAY l_azp02 TO FORMONLY.rusplant_desc
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_rus.rusconu
    DISPLAY l_gen02 TO FORMONLY.rusconu_desc
#    IF g_rus.rusconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                        #TQC-AB0287 mark                         
#    CALL cl_set_field_pic(g_rus.rusconf,"","","",g_chr,"")                                   #TQC-AB0287 mark
    CALL cl_set_field_pic(g_rus.rusconf,"","","","","")                                       #TQC-AB0287
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t210_u()
    IF g_rus.rus01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_rus.* FROM rus_file 
       WHERE rus01=g_rus.rus01
    IF g_rus.rusacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    IF g_rus.rusconf <> 'N' THEN
        CALL cl_err('','art-345',0) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rus01_t = g_rus.rus01
    LET g_rusplant_t = g_rus.rusplant
    BEGIN WORK
 
    OPEN t210_cl USING g_rus.rus01
    IF STATUS THEN
       CALL cl_err("OPEN t210_cl:", STATUS, 1)
       CLOSE t210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t210_cl INTO g_rus.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rus.rus01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_rus.rusmodu=g_user
    LET g_rus.rusdate = g_today
  # LET g_rus.ruspos='N' #No.FUN-870008  #FUN-A30030 MARK
   #FUN-A30030 ADD----------------------
    #IF g_aza.aza88 = 'Y' THEN #FUN-B50042 mark
    #   LET g_rus.ruspos='N'   #FUN-B50042 mark
    #END IF                    #FUN-B50042 mark
   #FUN-A30030 END----------------------
    CALL t210_show()
    WHILE TRUE
        CALL t210_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rus.*=g_rus_t.*
            CALL t210_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE rus_file SET rus_file.* = g_rus.*
            WHERE rus01 = g_rus.rus01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","rus_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t210_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t210_x()
    IF g_rus.rus01 IS NULL OR g_rus.rusplant IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#    IF g_rus.rusconf = 'X' THEN CALL cl_err('',9023,0) RETURN END IF              #TQC-AB0287  mark
    IF g_rus.rusconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_rus.rus16 = 'Y' THEN CALL cl_err('',9004,0) RETURN END IF
    BEGIN WORK
 
    OPEN t210_cl USING g_rus.rus01
    IF STATUS THEN
       CALL cl_err("OPEN t210_cl:", STATUS, 1)
       CLOSE t210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t210_cl INTO g_rus.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rus.rus01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t210_show()
    IF cl_exp(0,0,g_rus.rusacti) THEN
        LET g_chr=g_rus.rusacti
        IF g_rus.rusacti='Y' THEN
            LET g_rus.rusacti='N'
        ELSE
            LET g_rus.rusacti='Y'
        END IF
        UPDATE rus_file
            SET rusacti=g_rus.rusacti
            WHERE rus01 = g_rus.rus01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_rus.rus01,SQLCA.sqlcode,0)
            LET g_rus.rusacti=g_chr
        END IF
        DISPLAY BY NAME g_rus.rusacti
    END IF
    CLOSE t210_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t210_r()
 
    IF g_rus.rus01 IS NULL OR g_rus.rusplant IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    ##TQC-B30004 mark  begin---------------
    ##FUN-870100---begin
    # IF g_aza.aza88='Y' THEN   #FUN-A30030 ADD
    #    IF NOT (g_rus.rusacti='N' AND g_rus.ruspos='Y') THEN
    #       CALL cl_err("", 'art-648', 1)
    #       RETURN
    #    END IF
    # END IF
    ##FUN-870100---end
    ##TQC-B30004 mark  end-----------------
    
    SELECT * INTO g_rus.* FROM rus_file
       WHERE rus01=g_rus.rus01 
 
    IF g_rus.rusconf = 'Y' THEN
       CALL cl_err('','art-023',1)
       RETURN
    END IF
#TQC-AB0287 ------------mark
#   IF g_rus.rusconf = 'X' THEN 
#      CALL cl_err('','9024',0)
#      RETURN
#   END IF
#TQC-AB0287 -----------mark
 
    IF g_rus.rus16 = 'Y' THEN
       CALL cl_err('','art-922',0)
       RETURN
    END IF
    IF g_rus.rusacti ='N' THEN 
       CALL cl_err('','mfg1000',0)
       RETURN     
    END IF
    BEGIN WORK
 
    OPEN t210_cl USING g_rus.rus01
    IF STATUS THEN
       CALL cl_err("OPEN t210_cl:", STATUS, 0)
       CLOSE t210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t210_cl INTO g_rus.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rus.rus01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t210_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "rus01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_rus.rus01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM rus_file 
          WHERE rus01 = g_rus.rus01 
       CLEAR FORM
       OPEN t210_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t210_cs
          CLOSE t210_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       FETCH t210_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t210_cs
          CLOSE t210_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t210_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t210_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t210_fetch('/')
       END IF
    END IF
    CLOSE t210_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t210_copy()
    DEFINE
        l_newno         LIKE rus_file.rus01,
        l_oldno         LIKE rus_file.rus01,
        p_cmd           LIKE type_file.chr1,
        l_input         LIKE type_file.chr1,  
        l_oldplant      LIKE rus_file.rusplant,
        li_result       LIKE type_file.num5  
  
    IF g_rus.rus01 IS NULL OR g_rus.rusplant IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL t210_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM rus01
 
        AFTER FIELD rus01
           IF l_newno IS NULL THEN
              NEXT FIELD rus01
           ELSE
#             CALL s_check_no("art",l_newno,"","D","rus_file","rus01","") #FUN-A70130 mark 
              CALL s_check_no("art",l_newno,"","D5","rus_file","rus01","") #FUN-A70130 mod
                 RETURNING li_result,l_newno 
              IF (NOT li_result) THEN
                 LET g_rus.rus01=g_rus_t.rus01
                 NEXT FIELD rus01
              END IF
              BEGIN WORK
#             CALL s_auto_assign_no("art",l_newno,g_today,"","rus_file","rus01","","","")  #FUN-A70130 mark
              CALL s_auto_assign_no("art",l_newno,g_today,"D5","rus_file","rus01","","","")  #FUN-A70130 mod
                 RETURNING li_result,l_newno
              IF (NOT li_result) THEN
                 ROLLBACK WORK 
                 NEXT FIELD rus01
              ELSE
              	 COMMIT WORK 
              END IF 
           END IF
 
        ON ACTION controlp
           IF INFIELD(rus01) THEN
              LET g_t1=s_get_doc_no(l_newno)
#             CALL q_smy(FALSE,FALSE,g_t1,'ART','D') RETURNING g_t1     #FUN-A70130--mark--                                                            
              CALL q_oay(FALSE,FALSE,g_t1,'D5','ART') RETURNING g_t1    #FUN-A70130--end--                                                             
              LET l_newno = g_t1                                                                                                
              DISPLAY l_newno TO rus01                                                                                           
              NEXT FIELD rus01 
           END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help 
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_rus.rus01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM rus_file
        WHERE rus01 = g_rus.rus01
        INTO TEMP x
    UPDATE x
        SET rus01=l_newno,
            rusacti='Y',
            rususer=g_user,
            rusgrup=g_grup,
            rusoriu=g_user,     #TQC-A30041 ADD
            rusorig=g_grup,     #TQC-A30041 ADD
            rusmodu=NULL,
            rusdate=NULL,
            ruscrat = g_today,
            rusconf = 'N',
            ruscond = NULL,
            rusconu = NULL,
            rus900 = '0',
            rusplant = g_plant,
            #ruspos = 'N',    #FUN-870100  #FUN-B50042 mark
            ruscont = NULL,
            ruslegal = g_legal 
    INSERT INTO rus_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","rus_file",g_rus.rus01,"",SQLCA.sqlcode,"","",0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_rus.rus01
        LET l_oldplant = g_rus.rusplant
        LET g_rus.rus01 = l_newno
        SELECT rus_file.* INTO g_rus.* FROM rus_file
               WHERE rus01 = l_newno 
        CALL t210_u()
        #SELECT rus_file.* INTO g_rus.* FROM rus_file  #FUN-C80046
        #       WHERE rus01 = l_oldno                  #FUN-C80046
    END IF
    #LET g_rus.rus01 = l_oldno       #FUN-C80046
    #LET g_rus.rusplant = l_oldplant #FUN-C80046
    CALL t210_show()
END FUNCTION
 
#TQC-AB0287 ---------------STA
FUNCTION t210_out()
DEFINE l_cmd   LIKE type_file.chr1000

    IF cl_null(g_wc)  THEN
       LET g_wc = " rus01 = '",g_rus.rus01,"'"
    END IF
    LET l_cmd='p_query "artt210" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
END FUNCTION

#TQC-AB0287 ---------------END
 
FUNCTION t210_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rus01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t210_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("rus01",FALSE)
    END IF
 
END FUNCTION
#bnl 090408 -begin
FUNCTION t210_rusplant(p_cmd)  #机构編號
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_azp02   LIKE azp_file.azp02
 
   LET g_errno = " "
 
   SELECT azp02
     INTO l_azp02
     FROM azp_file WHERE azp01 = g_rus.rusplant
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-044'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.rusplant_desc
   END IF
 
END FUNCTION
#bnl 090408 -end
#NO.FUN-960130------end------

#TQC-C20488 add-----bgin--- 服飾行業，生成母料件單身的資料
FUNCTION t210_createno_slk(p_ruw01)
  DEFINE p_ruw01         LIKE ruw_file.ruw01
  DEFINE l_ima25         LIKE ima_file.ima25
  DEFINE l_ruxslk03      LIKE ruxslk_file.ruxslk03
  DEFINE l_cnt           LIKE type_file.num10
  DEFINE l_ima151        LIKE ima_file.ima151
  DEFINE l_n             LIKE type_file.num5     #FUN-C60091---ADD--       

    DECLARE ruxslk_cs CURSOR FOR SELECT DISTINCT(COALESCE(imx00,rux03)) 
                                   FROM rux_file LEFT JOIN imx_file ON imx000=rux03
                                  WHERE rux00='1' AND rux01=p_ruw01

    LET l_cnt=1
    FOREACH ruxslk_cs INTO l_ruxslk03

       LET l_ima25=NULL
       SELECT ima25,ima151 INTO l_ima25,l_ima151 FROM ima_file WHERE ima01 = l_ruxslk03
#FUN-C60091----ADD-----STR----
       IF l_ima151='Y' THEN
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM imx_file WHERE imx00=l_ruxslk03  
          IF l_n=0 THEN
             #l_cnt=l_cnt+1   
             CONTINUE FOREACH
          END IF
       END IF 
#FUN-C60091----ADD-----END-----
       INSERT INTO ruxslk_file(ruxslk00,ruxslk01,ruxslk02,ruxslk03,ruxslk04,
                               ruxslk06,ruxslkplant,ruxslklegal)
            VALUES('1',p_ruw01,l_cnt,l_ruxslk03,l_ima25,
                    0,g_rus.rusplant,g_rus.ruslegal)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_errno = SQLCA.sqlcode
          RETURN FALSE
       END IF
       IF l_ima151='Y' THEN
          UPDATE rux_file SET rux10s=l_ruxslk03,
                              rux11s=l_cnt
           WHERE rux00='1' AND rux01=p_ruw01
             AND rux03 IN ( SELECT imx000
                              FROM imx_file
                             WHERE imx00=l_ruxslk03) 
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_errno = SQLCA.sqlcode
             RETURN FALSE
          END IF
                             
       ELSE
          UPDATE rux_file SET rux10s=l_ruxslk03,
                              rux11s=l_cnt
           WHERE rux00='1' AND rux01=p_ruw01 AND rux03=l_ruxslk03
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_errno = SQLCA.sqlcode
             RETURN FALSE
          END IF
       END IF

       LET l_cnt=l_cnt+1

    END FOREACH
     
    RETURN TRUE

END FUNCTION
#TQC-C20488 add-----bgin--- 
