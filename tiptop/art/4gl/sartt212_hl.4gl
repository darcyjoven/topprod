# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: sarttt212.4gl
# Descriptions...: 供artt212,artt215兩支程序調用
# Date & Author..: NO.FUN-960130 09/07/07 By  Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-9B0068 09/11/10 BY lilingyu 臨時表字段改成LIKE的形式
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30050 10/03/15 By Cockroach ADD oriu/orig
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No.FUN-A50071 10/05/19 By lixia 程序增加POS單號字段 并增加相应管控
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong  ART單據性質調整
# Modify.........: No.FUN-A70130 10/08/16 By huangtao 修改單據性質,q_smy改为q_oay
# Modify.........: No.FUN-AA0059 10/10/28 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AA0049 10/10/29 by destiny  增加倉庫的權限控管 
# Modify.........: No:FUN-B50042 11/05/03 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B80085 11/08/09 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sartt212.global"
 
FUNCTION t212(p_argv1)
DEFINE l_time    LIKE type_file.chr8,
       p_argv1   LIKE ruw_file.ruw00
       
   WHENEVER ERROR CONTINUE
   
   LET g_argv1=p_argv1
   
   LET g_forupd_sql = "SELECT * FROM ruw_file WHERE ruw00 = ? AND ruw01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t212_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 9
 
   OPEN WINDOW t212_w AT p_row,p_col WITH FORM "art/42f/artt212"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   
   IF g_argv1 = '2' THEN
      CALL cl_set_act_visible("create_check,get_store",FALSE)
      CALL cl_set_act_visible("update_store",TRUE)
   ELSE
      CALL cl_set_act_visible("create_check,get_store",TRUE)
      CALL cl_set_act_visible("update_store",FALSE)
   END IF
   
   IF g_argv1 = '2' THEN
      CALL cl_set_comp_visible("ruw08,ruw09",TRUE)
      CALL cl_set_comp_visible("ruw10",FALSE)               #No.FUN-A50071
   ELSE
      CALL cl_set_comp_visible("ruw08,ruw09",FALSE)
      CALL cl_set_comp_visible("ruw10",g_aza.aza88 = 'Y')   #No.FUN-A50071 
   END IF
   LET g_ruw.ruw00 = g_argv1
   DISPLAY BY NAME g_ruw.ruw00
 
   CALL t212_menu()
   CLOSE WINDOW t212_w
END FUNCTION
 
FUNCTION t212_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM
   DISPLAY g_argv1 TO ruw00
   CALL g_rux.clear()
  
   IF NOT cl_null(g_argv3) THEN
      LET g_wc = " ruw01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_ruw.* TO NULL
      CONSTRUCT BY NAME g_wc ON ruw01,ruw02,ruw03,ruw04,ruw05,    #FUN-A50071 add ruw10
                                ruw06,ruwconf,ruwcond,ruwconu,ruwmksg,   #FUN-870100
                                ruw900,ruwplant,ruw07,ruw08,ruw09,ruw10,ruwpos,ruwuser,  #FUN-870100
                                ruwgrup,ruwmodu,ruwdate,ruwacti,ruwcrat
                               ,ruworiu,ruworig                          #TQC-A30050  ADD
                                
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ruw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw01"
                  LET g_qryparam.arg1 = g_argv1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw01
                  NEXT FIELD ruw01
      
               WHEN INFIELD(ruw02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw02"
                  LET g_qryparam.arg1 = g_argv1 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw02
                  NEXT FIELD ruw02
                  
               WHEN INFIELD(ruw03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw03"
                  LET g_qryparam.arg1 = g_argv1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw03
                  NEXT FIELD ruw03
       
               WHEN INFIELD(ruw05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw05_1"
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.where=" ruwplant= '",g_plant,"' "  #No.FUN-AA0049
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw05
                  NEXT FIELD ruw05
                  
               WHEN INFIELD(ruw06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ruw06"
                  LET g_qryparam.arg1 = g_argv1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw06
                  NEXT FIELD ruw06
                  
               WHEN INFIELD(ruwconu)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                       
                  LET g_qryparam.form ="q_ruwconu" 
                  LET g_qryparam.arg1 = g_argv1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO ruwconu                                                                              
                  NEXT FIELD ruwconu
               OTHERWISE EXIT CASE
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_wc = g_wc clipped," AND ruwuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_wc = g_wc clipped," AND ruwgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_wc = g_wc clipped," AND ruwgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ruwuser', 'ruwgrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv4) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON rux02,rux03,rux04,rux05,rux06,rux07,rux08,rux09
              FROM s_rux[1].rux02,s_rux[1].rux03,s_rux[1].rux04,
                   s_rux[1].rux05,s_rux[1].rux06,s_rux[1].rux07,
                   s_rux[1].rux08,s_rux[1].rux09
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(rux03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.form ="q_rux03_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rux03
                  NEXT FIELD rux03
               WHEN INFIELD(rux04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.arg1 = g_argv1
                  LET g_qryparam.form ="q_rux04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rux04
                  NEXT FIELD rux04
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
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    END IF
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT ruw00,ruw01 FROM ruw_file ",
                  " WHERE ruw00 = '",g_argv1,"' AND ", 
                  g_wc CLIPPED,
                  " ORDER BY ruw00,ruw01"
   ELSE
      LET g_sql = "SELECT UNIQUE ruw00,ruw01",
                  "  FROM ruw_file, rux_file ",
                  " WHERE ruw01 = rux01 AND ruw00 = rux00 ",
                  "   AND ruw00 ='",g_argv1,"' AND ", 
                  g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY ruw00,ruw01"
   END IF
 
   PREPARE t212_prepare FROM g_sql
   DECLARE t212_cs
       SCROLL CURSOR WITH HOLD FOR t212_prepare
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM ruw_file WHERE ruw00 ='",g_argv1,
                "' AND ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT ruw01) FROM ruw_file,rux_file WHERE ",
                "rux01=ruw01 AND ruw00 = rux00 AND ",
                " ruw00 = '",g_argv1,"' AND ",
                g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t212_precount FROM g_sql
   DECLARE t212_count CURSOR FOR t212_precount
 
END FUNCTION
 
FUNCTION t212_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL t212_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t212_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t212_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t212_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t212_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t212_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL t212_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                  CALL t212_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t212_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
   
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                  CALL t212_yes()
            END IF
 
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
                  CALL t212_no()
            END IF
            
         WHEN "void"
            IF cl_chk_act_auth() THEN
                  CALL t212_void()
            END IF
        WHEN "create_check"
	   IF cl_chk_act_auth() THEN
                 CALL t212_create()
           END IF
        WHEN "get_store"
	   IF cl_chk_act_auth() THEN
                 CALL t212_get_store()
           END IF
         WHEN "update_store"
            IF cl_chk_act_auth() THEN
                  CALL t212_update_store()
            END IF
               
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rux),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_ruw.ruw01 IS NOT NULL THEN
                 LET g_doc.column1 = "ruw01"
                 LET g_doc.value1 = g_ruw.ruw01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
#調整庫存
FUNCTION t212_update_store()
DEFINE l_sql        STRING
DEFINE l_img01      LIKE img_file.img01
DEFINE l_img02      LIKE img_file.img02
DEFINE l_img03      LIKE img_file.img03
DEFINE l_img04      LIKE img_file.img04
DEFINE l_rty06      LIKE rty_file.rty06
DEFINE l_rux02      LIKE rux_file.rux02
DEFINE l_rux03      LIKE rux_file.rux03
DEFINE l_rux04      LIKE rux_file.rux04
DEFINE l_rux06      LIKE rux_file.rux06
DEFINE l_rux08      LIKE rux_file.rux08
DEFINE l_img09    LIKE img_file.img09
DEFINE l_img10    LIKE img_file.img10
DEFINE l_img26    LIKE img_file.img26
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file
      WHERE ruw01=g_ruw.ruw01
        AND ruW00=g_ruw.ruw00 
 
   IF g_ruw.ruwconf <> 'Y' THEN CALL cl_err('','art-417',0) RETURN END IF
   IF g_ruw.ruw08 = 'Y' THEN CALL cl_err('','art-429',0) RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
       CLOSE t212_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   LET l_sql = "SELECT rux02,rux03,rux04,rux06,rux08 FROM rux_file ",
               " WHERE rux00 = '2' AND rux01 = '",g_ruw.ruw01,"'",
               "   AND rux08 <> 0 "
   PREPARE rux_upd FROM l_sql
   DECLARE ruxupd_cs CURSOR FOR rux_upd
 
   LET g_cnt = 1
   FOREACH ruxupd_cs INTO l_rux02,l_rux03,l_rux04,l_rux06,l_rux08
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF l_rux03 IS NULL THEN CONTINUE FOREACH END IF
      IF l_rux06 IS NULL THEN LET l_rux06 = 0 END IF
      IF l_rux08 IS NULL THEN LET l_rux08 = 0 END IF
 
      SELECT rty06 INTO l_rty06 FROM rty_file WHERE rty01 = g_ruw.ruwplant 
          AND rty02 = l_rux03
      #檢查該商品在倉庫中是否已經存在
      SELECT img01,img02,img03,img04 
	INTO l_img01,l_img02,l_img03,l_img04 FROM img_file 
         WHERE img01 = l_rux03 
           AND img02 = g_ruw.ruw05
           AND img03 = ' '
           AND img04 = ' '
      CALL s_upimg(l_img01,l_img02,l_img03,l_img04,'2',l_rux08,g_today,l_rux03,g_ruw.ruw05,'','',g_ruw.ruw01,
                   l_rux02,l_rux04,l_rux08,l_rux04,1,1,1,'','','','','','')
      IF g_success = 'N' THEN EXIT FOREACH END IF 
      SELECT img09,img10,img26 INTO l_img09,l_img10,l_img26
         FROM img_file WHERE img01 = l_rux03 AND img02 = g_ruw.ruw05
          AND img03 = ' ' AND img04 = ' '
      IF SQLCA.SQLCODE THEN
         CALL cl_err('',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      INITIALIZE g_tlf.* TO NULL
      IF l_rux08 < 0 THEN    
        LET l_rux08      =l_rux08 * -1
        #----來源----
        LET g_tlf.tlf02=50         	             #來源為倉庫(盤虧)
        LET g_tlf.tlf020=g_plant                 #工廠別
        LET g_tlf.tlf021=g_ruw.ruw05  	         #倉庫別
        LET g_tlf.tlf022=" "     	         #儲位別
        LET g_tlf.tlf023=" "     	         #入庫批號
        LET g_tlf.tlf024= l_img10                #(+/-)異動後庫存數量
        LET g_tlf.tlf025= l_img09                #庫存單位(ima or img) #TQC-660091     
    	LET g_tlf.tlf026=g_ruw.ruw01             #參考單据(盤點單)
    	LET g_tlf.tlf027= l_rux02
        #----目的----
        LET g_tlf.tlf03=0          	 	         #目的為盤點
        LET g_tlf.tlf030=g_plant       	         #工廠別
        LET g_tlf.tlf031=''            	         #倉庫別
        LET g_tlf.tlf032=''         	         #儲位別
        LET g_tlf.tlf033=''         	         #批號
        LET g_tlf.tlf034=''                      #異動後庫存數量
    	LET g_tlf.tlf035=''                   
    	LET g_tlf.tlf036='Physical'     
    	LET g_tlf.tlf037=''
 
        LET g_tlf.tlf15=''                       #貸方會計科目(盤虧)
        LET g_tlf.tlf16= l_img26                 #料件會計科目(存貨)
      ELSE 
        #----來源----
        LET g_tlf.tlf02=0          	             #來源為盤點(盤盈)
        LET g_tlf.tlf020=g_plant       	         #倉庫別
        LET g_tlf.tlf021=''            	         #倉庫別
        LET g_tlf.tlf022=''         	         #儲位別
        LET g_tlf.tlf023=''         	         #批號
        LET g_tlf.tlf024=''                      #異動後庫存數量
    	LET g_tlf.tlf025=''                   
    	LET g_tlf.tlf026=g_ruw.ruw01     
    	LET g_tlf.tlf027=''
        #----目的----
        LET g_tlf.tlf03=50         	 	         #目的為倉庫
        LET g_tlf.tlf030=g_plant      	         #工廠別
        LET g_tlf.tlf031=g_ruw.ruw05  	         #倉庫別
        LET g_tlf.tlf032=" "     	         #儲位別
        LET g_tlf.tlf033=" "     	         #入庫批號
        LET g_tlf.tlf034=l_img10                 #(+/-)異動後庫存數量
        LET g_tlf.tlf035=l_img09                 #庫存單位(ima or img)
    	LET g_tlf.tlf036=g_ruw.ruw01             #參考單据
    	LET g_tlf.tlf037=l_rux02
 
        LET g_tlf.tlf15= l_img26             #料件會計科目(存貨)
        LET g_tlf.tlf16=' '                  #貸方會計科目(盤盈)
      END IF
      LET g_tlf.tlf01=l_rux03     	     #異動料件編號
#--->異動數量
      LET g_tlf.tlf04=' '                      #工作站
      LET g_tlf.tlf05=g_prog                   #作業序號
      LET g_tlf.tlf06=g_ruw.ruwcond  #g_ruw.ruw04              #盤點日期   #Modi by zm 090617
      LET g_tlf.tlf07=g_today                  #異動資料產生日期  
      LET g_tlf.tlf08=TIME                     #異動資料產生時:分:秒
      LET g_tlf.tlf09=g_user                   #產生人
      LET g_tlf.tlf10=l_rux08                  #異動數量
      LET g_tlf.tlf11=l_rux04                  #庫存單位
      LET g_tlf.tlf12=1                        #單位轉換率  
      LET g_tlf.tlf13='差整'                #異動命令代號
      LET g_tlf.tlf14=''                       #異動原因
      CALL s_imaQOH(l_rux03)
         RETURNING g_tlf.tlf18               #異動後總庫存量
      LET g_tlf.tlf19= ' '                     #異動廠商/客戶編號
      LET g_tlf.tlf20= ' '                     #project no.      
      LET g_tlf.tlfplant=g_ruw.ruwplant 
      LET g_tlf.tlflegal=g_ruw.ruwlegal 
      #LET g_tlf.tlf01 = l_rux03
      #LET g_tlf.tlf020 = g_ruw.ruwplant
      #LET g_tlf.tlf02 = '07'
      #LET g_tlf.tlf021 = g_ruw.ruw05
      #LET g_tlf.tlf022 = " "           #bnl 090205
      #LET g_tlf.tlf023 = " "           #bnl 090205
      #LET g_tlf.tlf024 = l_img10
 
      CALL s_tlf(1,0)
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt != 1 AND g_success = 'Y' THEN
      LET g_ruw.ruw08 = 'Y'
      LET g_ruw.ruw09 = g_today
      UPDATE ruw_file SET ruw08 = 'Y',ruw09 = g_today 
         WHERE ruw00 = '2' AND ruw01 = g_ruw.ruw01 
      IF SQLCA.sqlcode THEN 
         CALL cl_err('',SQLCA.sqlcode,1)
         LET g_ruw.ruw08 = 'N'
         LET g_ruw.ruw09 = ''
         ROLLBACK WORK
      ELSE
         COMMIT WORK
         DISPLAY BY NAME g_ruw.ruw08,g_ruw.ruw09
         CALL cl_err('','art-498',0)
      END IF
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#產生盤差單
FUNCTION t212_create()
DEFINE l_rux02    LIKE rux_file.rux02
DEFINE l_newno     LIKE ruw_file.ruw01
DEFINE li_result   LIKE type_file.num5
DEFINE l_rux03    LIKE rux_file.rux03
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL   
      OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err('',-400,0)      
      RETURN
   END IF
   
   SELECT * INTO g_ruw.* FROM ruw_file
      WHERE ruw01=g_ruw.ruw01
        AND ruw00=g_ruw.ruw00 
 
   IF g_ruw.ruw03 IS NOT NULL THEN
      CALL cl_err('','art-407',1)
      RETURN
   END IF
 
   IF g_ruw.ruwconf <> 'Y' THEN
      CALL cl_err('','art-394',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('art-403') THEN RETURN END IF
   MESSAGE ""
   LET g_ruw01_t = g_ruw.ruw01
   BEGIN WORK
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
       CLOSE t212_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL t212_show()
   #獲取盤差單的默認單別
   SELECT rye03 INTO l_newno FROM rye_file 
      WHERE rye01 = 'art' AND rye02 = 'J5' AND ryeacti = 'Y'      #FUN-A70130
   IF SQLCA.sqlcode = 100 THEN
      CALL cl_err(l_newno,'art-315',1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
#  CALL s_auto_assign_no("art",l_newno,g_today,"","ruw_file","ruw01","","","")  #FUN-A70130 mark                                            
   CALL s_auto_assign_no("art",l_newno,g_today,"J5","ruw_file","ruw01","","","")  #FUN-A70130 mod                                           
      RETURNING li_result,l_newno
   IF (NOT li_result) THEN
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
   COMMIT WORK
   #生成盤差單
   DROP TABLE y
   SELECT * FROM ruw_file
       WHERE ruw01=g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
       INTO TEMP y
   
   UPDATE y
       SET ruw00='2',
           ruw01=l_newno,
           ruw03 = g_ruw.ruw01,
           ruw06 = g_user,
           ruwconf = 'N',
           ruwcond = NULL,
           ruwconu = NULL,
           ruwuser=g_user,
           ruwgrup=g_grup,
           ruwmodu=NULL,
           ruwdate=NULL,
           ruwacti='Y',
           ruwcrat=g_today,
           ruworiu=g_user,      #TQC-A30050 ADD
           ruworig=g_grup,      #TQC-A30050 ADD
           ruwmksg = 'N',
           ruw900 = '0',
           ruw08 = 'N',
           ruwplant = g_plant,
           ruwlegal = g_legal,
           ruwpos='N'  #FUN-870100
   INSERT INTO ruw_file SELECT * FROM y
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","ruw_file","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM rux_file
       WHERE rux01=g_ruw.ruw01 AND rux00=g_ruw.ruw00
         AND rux08 != 0
       INTO TEMP x
   UPDATE x SET rux00='2',rux01=l_newno,ruxplant = g_plant,ruxlegal = g_legal
   #對單身中的項次重新編號，防止跳號
   LET g_sql = "SELECT rux02,rux03 FROM x ORDER BY rux02 "
   PREPARE t212_get_x FROM g_sql
   DECLARE rux_cs_x CURSOR FOR t212_get_x
   LET g_cnt = 1
   FOREACH rux_cs_x INTO l_rux02,l_rux03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      UPDATE x SET rux02 = g_cnt WHERE rux03 = l_rux03
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt = 1 THEN
      DELETE FROM ruw_file WHERE ruw00 = '2' AND ruw01 = l_newno 
      CALL cl_err('','art-411',1)
      RETURN
   END IF
   INSERT INTO rux_file SELECT * FROM x
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                    
      CALL cl_err3("ins","rux_file","","",SQLCA.sqlcode,"","",1)                                                                    
      RETURN                                                                                                                        
   END IF
   UPDATE ruw_file SET ruw03 = l_newno WHERE ruw00 = '1' AND ruw01 = g_ruw.ruw01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                                    
      CALL cl_err3("ins","ruw_file","","",SQLCA.sqlcode,"","",1)                                                                    
      RETURN                                                                                                                        
   END IF
   DISPLAY l_newno TO ruw03
   CALL cl_err(l_newno,'art-399',1)
END FUNCTION
#取帳面庫存
FUNCTION t212_get_store()
DEFINE l_rux06          LIKE rux_file.rux06
DEFINE l_rux07          LIKE rux_file.rux07
DEFINE l_rut06          LIKE rut_file.rut06
DEFINE l_rux03          LIKE rux_file.rux03
  
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_ruw.* FROM ruw_file
      WHERE ruw01=g_ruw.ruw01
        AND ruw00=g_ruw.ruw00 
 
   IF g_ruw.ruwacti ='N' THEN
      CALL cl_err(g_ruw.ruw01,'mfg1000',0)
      RETURN
   END IF
 
   IF g_ruw.ruwconf = 'Y' THEN
      CALL cl_err('','art-405',0)
      RETURN
   END IF
   IF g_ruw.ruwconf = 'X' THEN CALL cl_err(g_ruw.ruw01,'9024',0) RETURN END IF 
   
   BEGIN WORK
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
       CLOSE t212_cl
       ROLLBACK WORK
       RETURN
   END IF
   
   CALL t212_show()
   LET g_sql = "SELECT rux03,rux06,rux07 FROM rux_file ",
               " WHERE rux00 = '1' AND rux01 = '",g_ruw.ruw01,"'"
   PREPARE t121_rux1 FROM g_sql
   DECLARE rux1_cs CURSOR FOR t121_rux1
   FOREACH rux1_cs INTO l_rux03,l_rux06,l_rux07
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_rux03 IS NULL THEN CONTINUE FOREACH END IF
      SELECT rut06-rut07 INTO l_rut06 FROM rut_file WHERE rut01=g_ruw.ruw02 AND #bnl add rut07
         rut03 = g_ruw.ruw05 AND rut04 = l_rux03
      IF l_rut06 IS NULL THEN LET l_rut06 = 0 END IF
 
      UPDATE rux_file SET rux05 = l_rut06 WHERE rux00='1' AND rux01=g_ruw.ruw01
         AND rux03 = l_rux03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1) 
         CLOSE t212_cl
         ROLLBACK WORK
         RETURN
      END IF
      IF l_rux06 IS NULL THEN LET l_rux06 = 0 END IF
      IF l_rux07 IS NULL THEN LET l_rux07 = 0 END IF
 
      UPDATE rux_file SET rux08 = l_rux06+l_rux07-l_rut06 WHERE rux00 = '1'   #bnl -090204
         AND rux01 = g_ruw.ruw01 
         AND rux03 = l_rux03
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("ins","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1)
         CLOSE t212_cl
         ROLLBACK WORK 
         RETURN
      END IF
   END FOREACH  
   COMMIT WORK
   CALL cl_err('','art-406',1)
   CALL t212_b_fill("1=1")   
END FUNCTION
 
FUNCTION t212_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_argv1 = '2' THEN
            CALL cl_set_action_active("INSERT,reproduce",FALSE)
         END IF
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL t212_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t212_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t212_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t212_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t212_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
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
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      ON ACTION create_check
         LET g_action_choice="create_check"
         EXIT DISPLAY
      
      ON ACTION get_store
         LET g_action_choice="get_store"
         EXIT DISPLAY
 
      ON ACTION update_store
         LET g_action_choice = "update_store"
         EXIT DISPLAY
   
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls       
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t212_yes()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_ruwcont  LIKE ruw_file.ruwcont  #FUN-870100
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   #Add by zm 090617
   SELECT sma53 INTO g_sma.sma53 FROM sma_file
   IF g_sma.sma53 IS NOT NULL AND g_ruw.ruw04 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1)
      RETURN
   END IF
   #End by zm 090617
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01 
      AND ruw00=g_ruw.ruw00 
   IF g_ruw.ruwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruw.ruwconf = 'X' THEN CALL cl_err(g_ruw.ruw01,'9024',0) RETURN END IF 
   IF g_ruw.ruwacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM rux_file
    WHERE rux01=g_ruw.ruw01 AND rux00=g_ruw.ruw00 
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   SELECT * FROM ruw_file                                                                                                        
      WHERE ruw00 = g_ruw.ruw00 AND ruwconf = 'Y'                                                                               
        AND ruw02 = g_ruw.ruw02 AND ruw05 = g_ruw.ruw05                                                                         
   IF SQLCA.SQLCODE <> 100 THEN                                                                                                  
      CALL cl_err('','art-390',0)
      RETURN                                                                                                    
   END IF
 
   IF NOT cl_confirm('art-026') THEN RETURN END IF
   BEGIN WORK
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      CLOSE t212_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   LET l_ruwcont=TIME        #FUN-870100
   UPDATE ruw_file SET ruwconf='Y',
                       ruwcond=g_today, 
                       ruwconu=g_user,
                       ruwcont=l_ruwcont    #FUN-870100
     WHERE ruw01=g_ruw.ruw01
       AND ruw00=g_ruw.ruw00 
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_ruw.ruwconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_ruw.ruw01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01 
      AND ruw00=g_ruw.ruw00 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruw.ruwconu
   DISPLAY BY NAME g_ruw.ruwconf                                                                                         
   DISPLAY BY NAME g_ruw.ruwcond                                                                                         
   DISPLAY BY NAME g_ruw.ruwconu
   DISPLAY l_gen02 TO FORMONLY.ruwconu_desc
   DISPLAY BY NAME g_ruw.ruwcont          #FUN-870100
   #CKP
   IF g_ruw.ruwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruw.ruwconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruw.ruw01,'V')
END FUNCTION
 
FUNCTION t212_no()
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_gen02    LIKE gen_file.gen02 
DEFINE l_n        LIKE type_file.num5
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF

   #No.FUN-A50071 -----start---------   
   #-->POS單號不為空時不可取消確認
   IF NOT cl_null(g_ruw.ruw10) THEN
      CALL cl_err(' ','axm-743',0)
      RETURN
   END IF 
   #No.FUN-A50071 -----end---------
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01 
      AND ruw00=g_ruw.ruw00 
   CALL t212_show()
   IF g_ruw.ruwconf <> 'Y' THEN CALL cl_err('','art-373',0) RETURN END IF
   IF g_argv1 = '1' THEN
      SELECT COUNT(*) INTO l_n  FROM ruw_file 
         WHERE ruw00 = '2' AND ruw03 = g_ruw.ruw01 
      IF l_n > 0 THEN
         CALL cl_err('','art-402',0)
         RETURN
      END IF
   ELSE
      IF g_ruw.ruw08 = 'Y' THEN
         CALL cl_err('','art-404',0)
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('aim-304') THEN RETURN END IF
   BEGIN WORK
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      CLOSE t212_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
 
   UPDATE ruw_file SET ruwconf='N',
                       ruwcond=NULL, 
                       ruwconu=NULL,
                       ruwpos='N', #No.FUN-870008
                       ruwcont=NULL
     WHERE ruw01=g_ruw.ruw01
       AND ruw00=g_ruw.ruw00 
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
 
   IF g_success = 'Y' THEN
      LET g_ruw.ruwconf='N'
      COMMIT WORK
      CALL cl_flow_notify(g_ruw.ruw01,'Y')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01 
      AND ruw00=g_ruw.ruw00 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruw.ruwconu
   DISPLAY BY NAME g_ruw.ruwconf                                                                                         
   DISPLAY BY NAME g_ruw.ruwcond                                                                                         
   DISPLAY BY NAME g_ruw.ruwconu
   DISPLAY '' TO FORMONLY.ruwconu_desc
   DISPLAY BY NAME g_ruw.ruwpos #No.FUN-870008
   DISPLAY BY NAME g_ruw.ruwcont
   #CKP
   IF g_ruw.ruwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruw.ruwconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruw.ruw01,'V')
END FUNCTION
 
FUNCTION t212_void()
DEFINE l_n LIKE type_file.num5
DEFINE l_ruwcont LIKE ruw_file.ruwcont     #FUN-870100
 
   IF s_shut(0) THEN RETURN END IF
      
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN 
      CALL cl_err('',-400,0) 
      RETURN 
   END IF
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01
      AND ruw00=g_ruw.ruw00 
   IF g_ruw.ruwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruw.ruwacti = 'N' THEN CALL cl_err('','art-142',0) RETURN END IF
   BEGIN WORK
 
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_void(0,0,g_ruw.ruwconf) THEN
      LET g_chr = g_ruw.ruwconf
      IF g_ruw.ruwconf = 'N' THEN
         LET g_ruw.ruwconf = 'X'
      ELSE
         LET g_ruw.ruwconf = 'N'
      END IF
      LET l_ruwcont=TIME    #FUN-870100
      UPDATE ruw_file SET ruwconf=g_ruw.ruwconf,
                          ruwmodu=g_user,
                          ruwdate=g_today,
                          ruwpos='N', #No.FUN-870008
                          ruwcont=l_ruwcont     #FUN-870100
       WHERE ruw01 = g_ruw.ruw01 
         AND ruw00=g_ruw.ruw00
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","up ruwconf",1)
          LET g_ruw.ruwconf = g_chr
          ROLLBACK WORK
          RETURN
       END IF
   END IF
 
   CLOSE t212_cl
   COMMIT WORK
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01=g_ruw.ruw01
      AND ruw00=g_ruw.ruw00 
   DISPLAY BY NAME g_ruw.ruwconf                                                                                        
   DISPLAY BY NAME g_ruw.ruwmodu                                                                                        
   DISPLAY BY NAME g_ruw.ruwdate
   DISPLAY BY NAME g_ruw.ruwpos #No.FUN-870008
   DISPLAY BY NAME g_ruw.ruwcont        #FUN-870100
    #CKP
   IF g_ruw.ruwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ruw.ruwconf,"","","",g_chr,"")
 
   CALL cl_flow_notify(g_ruw.ruw01,'V')
END FUNCTION
FUNCTION t212_bp_refresh()
  DISPLAY ARRAY g_rux TO s_rux.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t212_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rux.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_ruw.* LIKE ruw_file.*
   LET g_ruw01_t = NULL
 
   LET g_ruw_t.* = g_ruw.*
   LET g_ruw_o.* = g_ruw.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ruw.ruwuser=g_user
      LET g_ruw.ruworiu = g_user #FUN-980030
      LET g_ruw.ruworig = g_grup #FUN-980030
      LET g_data_plant = g_plant #TQC-A10128 ADD
      LET g_ruw.ruwgrup=g_grup
      LET g_ruw.ruwacti='Y'
      LET g_ruw.ruwcrat = g_today
      LET g_ruw.ruwconf = 'N'
      LET g_ruw.ruw00 = g_argv1
      LET g_ruw.ruw06 = g_user
      LET g_ruw.ruw08 = 'N'
      LET g_ruw.ruwmksg = 'N'
      LET g_ruw.ruwplant = g_plant
      LET g_ruw.ruwlegal = g_legal
      LET g_ruw.ruw900 = '0'
      LET g_ruw.ruwcont = ''  #FUN-870100
      LET g_ruw.ruwpos = 'N'  #FUN-870100
      DISPLAY g_ruw.ruwcont TO ruwcont  #FUN-870100
      DISPLAY g_ruw.ruwpos TO ruwpos  #FUN-870100
      CALL t212_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_ruw.* TO NULL
         LET INT_FLAG = 0
         CLEAR FORM 
         DISPLAY g_argv1 TO ruw00
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ruw.ruw01) OR cl_null(g_ruw.ruw00)
         OR cl_null(g_ruw.ruwplant) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#FUN-A70130--begin--
#     CALL s_auto_assign_no("art",g_ruw.ruw01,g_today,"","ruw_file","ruw01","","","")        #FUN-A70130 mark                                     
#          RETURNING li_result,g_ruw.ruw01                                                   #FUN-A70130 mark
      IF  g_ruw.ruw00 = '1' THEN
          CALL s_auto_assign_no("art",g_ruw.ruw01,g_today,"J4","ruw_file","ruw01","","","")                                             
               RETURNING li_result,g_ruw.ruw01
      ELSE
          CALL s_auto_assign_no("art",g_ruw.ruw01,g_today,"J5","ruw_file","ruw01","","","")                                             
               RETURNING li_result,g_ruw.ruw01
      END IF
#FUN-A70130--end--
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_ruw.ruw01
      INSERT INTO ruw_file VALUES (g_ruw.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #   ROLLBACK WORK         # FUN-B80085---回滾放在報錯後---
         CALL cl_err3("ins","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK          # FUN-B80085--add--
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_ruw.ruw01,'I')
      END IF
 
      LET g_ruw01_t = g_ruw.ruw01
      LET g_ruw_t.* = g_ruw.*
      LET g_ruw_o.* = g_ruw.*
      CALL g_rux.clear()
 
      LET g_rec_b = 0
      CALL t212_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t212_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruw00 IS NULL 
      OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file
    WHERE ruw01=g_ruw.ruw01
      AND ruw00=g_ruw.ruw00 
 
   IF g_ruw.ruwacti ='N' THEN
      CALL cl_err(g_ruw.ruw01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_ruw.ruwconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
 
   IF g_ruw.ruwconf = 'X' THEN
      CALL cl_err('','art-025',0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ruw01_t = g_ruw.ruw01
   BEGIN WORK
 
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
       CLOSE t212_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t212_show()
 
   WHILE TRUE
      LET g_ruw01_t = g_ruw.ruw01
      LET g_ruw_t.* = g_ruw.*
      LET g_ruw_o.* = g_ruw.*
      LET g_ruw.ruwmodu=g_user
      LET g_ruw.ruwdate=g_today
      LET g_ruw.ruwpos='N' #No.FUN-870008 
      CALL t212_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ruw.*=g_ruw_t.*
         CALL t212_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_ruw.ruw01 != g_ruw01_t OR g_ruw.ruw00 != g_ruw_t.ruw00 THEN
         UPDATE ruw_file SET ruw01 = g_ruw.ruw01,ruw00=g_ruw.ruw00
           WHERE rux01 = g_ruw01_t
             AND rux00=g_ruw_t.ruw00 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rux_file",g_ruw01_t,"",SQLCA.sqlcode,"","rux",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE ruw_file SET ruw_file.* = g_ruw.*
       WHERE ruw01 = g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ruw_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t212_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruw.ruw01,'U')
 
   CALL t212_b_fill("1=1")
   CALL t212_bp_refresh()
 
END FUNCTION
 
FUNCTION t212_i(p_cmd)
DEFINE
   l_pmc05     LIKE pmc_file.pmc05,
   l_pmc30     LIKE pmc_file.pmc30,
   l_n         LIKE type_file.num5,
   p_cmd       LIKE type_file.chr1,
   li_result   LIKE type_file.num5,
   l_gen02     LIKE gen_file.gen02,
   l_azp02     LIKE azp_file.azp02,
   l_ck        LIKE type_file.chr50,
   tok         base.StringTokenizer,
   l_rus05     LIKE rus_file.rus05,
   l_temp      LIKE type_file.chr1000
	 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_ruw.ruw01,g_ruw.ruw02,g_ruw.ruw03,
                   g_ruw.ruw04,g_ruw.ruw05,g_ruw.ruw06,g_ruw.ruwconf,
                   g_ruw.ruwcond,g_ruw.ruwconu,g_ruw.ruwcont,g_ruw.ruwmksg,   #FUN-870100
                   g_ruw.ruw900,g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08, #FUN-A50071 add ruw10
                   g_ruw.ruw09,g_ruw.ruw10,g_ruw.ruwpos,g_ruw.ruwuser,g_ruw.ruwmodu,g_ruw.ruwgrup,  #FUN-870100
                   g_ruw.ruwdate,g_ruw.ruwacti,g_ruw.ruwcrat,
                   g_ruw.ruworiu,g_ruw.ruworig                                   #TQC-A30050 ADD
                   
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ruw.ruw06                
   DISPLAY l_gen02 TO FORMONLY.ruw06_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruw.ruwplant
   DISPLAY l_azp02 TO FORMONLY.ruwplant_desc
   
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_ruw.ruw00,g_ruw.ruw01,g_ruw.ruw02,g_ruw.ruw03,          #TQC-A30050 MARK g_ruw.ruworiu,g_ruw.ruworig,
                 g_ruw.ruw04,g_ruw.ruw05,g_ruw.ruw06,g_ruw.ruwconf,
                 g_ruw.ruwcond,g_ruw.ruwconu,g_ruw.ruwmksg,        #FUN-A50071 add ruw10
                 g_ruw.ruw900,g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08,
                 g_ruw.ruw09,g_ruw.ruw10,g_ruw.ruwuser,g_ruw.ruwmodu,g_ruw.ruwgrup,
                 g_ruw.ruwdate,g_ruw.ruwacti,g_ruw.ruwcrat
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t212_set_entry(p_cmd)
         CALL t212_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ruw01")
 
      AFTER FIELD ruw01
         IF NOT cl_null(g_ruw.ruw01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruw.ruw01 != g_ruw_t.ruw01) THEN
               IF g_ruw.ruw00 = '1' THEN
#                 CALL s_check_no("art",g_ruw.ruw01,g_ruw01_t,"J","ruw_file","ruw01","")  #FUN-A70130 mark
                  CALL s_check_no("art",g_ruw.ruw01,g_ruw01_t,"J4","ruw_file","ruw01","")  #FUN-A70130 mod
                     RETURNING li_result,g_ruw.ruw01
               ELSE
#                 CALL s_check_no("art",g_ruw.ruw01,g_ruw01_t,"L","ruw_file","ruw01","")  #FUN-A70130 mark
                  CALL s_check_no("art",g_ruw.ruw01,g_ruw01_t,"J5","ruw_file","ruw01","")  #FUN-A70130 mod
                     RETURNING li_result,g_ruw.ruw01
               END IF
               DISPLAY BY NAME g_ruw.ruw01
               IF (NOT li_result) THEN
                  LET g_ruw.ruw01=g_ruw_t.ruw01
                  NEXT FIELD ruw01
               END IF
            END IF
         END IF
         
      AFTER FIELD ruw02
         IF NOT cl_null(g_ruw.ruw02) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruw.ruw02 != g_ruw_t.ruw02) THEN
               CALL t212_ruw02()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ruw02        
               END IF
               
               CALL t212_ruw05()                                                                                                  
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD ruw02        
               END IF
            END IF
         END IF
         
      AFTER FIELD ruw05
         IF NOT cl_null(g_ruw.ruw05) THEN
            #No.FUN-AA0049--begin
            IF NOT s_chk_ware(g_ruw.ruw05) THEN
               NEXT FIELD ruw05
            END IF 
            #No.FUN-AA0049--end         
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_ruw.ruw05 != g_ruw_t.ruw05) THEN
               CALL t212_ruw05()                                                                                                  
               IF NOT cl_null(g_errno)  THEN    
                  CALL cl_err('',g_errno,0)    
                  NEXT FIELD ruw05            
               END IF
            END IF
         END IF
      
      AFTER FIELD ruw06
         IF NOT cl_null(g_ruw.ruw06) THEN
            CALL t212_ruw06()
            IF NOT cl_null(g_errno)  THEN                                                                                         
               CALL cl_err('',g_errno,0)                                                                                          
               NEXT FIELD ruw06                                                                                                   
            END IF
         END IF   
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ruw01)
               LET g_t1=s_get_doc_no(g_ruw.ruw01)
               IF g_argv1 = '1' THEN
#                 CALL q_smy(FALSE,FALSE,g_t1,'ART','J') RETURNING g_t1  #FUN-A70130--mark--
                  CALL q_oay(FALSE,FALSE,g_t1,'J4','ART') RETURNING g_t1  #FUN-A70130--mod--
               ELSE
#                 CALL q_smy(FALSE,FALSE,g_t1,'ART','L') RETURNING g_t1  #FUN-A70130--mark--
                  CALL q_oay(FALSE,FALSE,g_t1,'J5','ART') RETURNING g_t1  #FUN-A70130--mod--
               END IF
               LET g_ruw.ruw01 = g_t1
               DISPLAY BY NAME g_ruw.ruw01
               NEXT FIELD ruw01 
            
            WHEN INFIELD(ruw02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_rus"
               LET g_qryparam.default1 = g_ruw.ruw02
               CALL cl_create_qry() RETURNING g_ruw.ruw02
               DISPLAY BY NAME g_ruw.ruw02
               CALL t212_ruw02()
               NEXT FIELD ruw02
                  
            WHEN INFIELD(ruw05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ruw05"
               SELECT rus05 INTO l_rus05 FROM rus_file
                  WHERE rus01 = g_ruw.ruw02
                    AND rusplant=g_plant   #No.FUN-AA0049
               LET tok = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
               LET g_qryparam.where = " imd01 IN ('"
               WHILE tok.hasMoreTokens()
                  LET l_ck = tok.nextToken()
                  LET g_qryparam.where = g_qryparam.where,l_ck,"','"
               END WHILE
               LET g_qryparam.where = g_qryparam.where.trimRight()
               LET l_temp = g_qryparam.where
               LET g_qryparam.where = l_temp[1,g_qryparam.where.getLength()-2]
               LET g_qryparam.where = g_qryparam.where,")"
               LET g_qryparam.default1 = g_ruw.ruw05
               CALL cl_create_qry() RETURNING g_ruw.ruw05
               DISPLAY BY NAME g_ruw.ruw05
               CALL t212_ruw05()
               NEXT FIELD ruw05
               
            WHEN INFIELD(ruw06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_ruw.ruw06
               CALL cl_create_qry() RETURNING g_ruw.ruw06
               DISPLAY BY NAME g_ruw.ruw06
               CALL t212_ruw06()
               NEXT FIELD ruw06
               
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t212_ruw02()
DEFINE l_rus02    LIKE rus_file.rus02
DEFINE l_rusacti  LIKE rus_file.rusacti
DEFINE l_rusconf  LIKE rus_file.rusconf
 
   LET g_errno = ""
   SELECT rus02,rus04 INTO l_rus02,g_ruw.ruw04
      FROM rus_file WHERE rus01 = g_ruw.ruw02 
      
   CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-388'
        WHEN l_rusacti='N'  LET g_errno = '9028'
        WHEN l_rusconf<>'Y' LET g_errno = 'art-384'
        OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
                            DISPLAY l_rus02 TO FORMONLY.ruw02_desc
                            DISPLAY BY NAME g_ruw.ruw04
   END CASE
END FUNCTION
 
FUNCTION t212_ruw05()
DEFINE l_rus05    LIKE rus_file.rus05
DEFINE l_rusacti  LIKE rus_file.rusacti
DEFINE l_rusconf  LIKE rus_file.rusconf
DEFINE l_count    LIKE type_file.num5
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_imd02    LIKE imd_file.imd02
 
   LET g_errno = ""
   
   IF g_ruw.ruw02 IS NULL OR g_ruw.ruw05 IS NULL THEN
      RETURN
   END IF
   #檢查當前機構是否存在該盤點計劃
   SELECT rus05,rusacti,rusconf INTO l_rus05,l_rusacti,l_rusconf 
      FROM rus_file WHERE rus01 = g_ruw.ruw02 
   CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-392'
        WHEN l_rusacti='N'  LET g_errno = '9028'
        WHEN l_rusconf<>'Y' LET g_errno = 'art-384'
        OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   #檢查當前錄入的倉庫是否屬于盤點計劃中的倉庫
   IF cl_null(g_errno) THEN
      LET tok = base.StringTokenizer.createExt(l_rus05,"|",'',TRUE)
      LET l_count = 0
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         IF l_ck = g_ruw.ruw05 THEN LET l_count = 1 END IF 
      END WHILE
      IF l_count = 0 THEN LET g_errno = 'art-385' END IF 
   END IF 
   #檢查盤點計劃和盤點倉庫是否有重用
   IF cl_null(g_errno) THEN
      SELECT * FROM ruw_file
          WHERE ruw00 = g_ruw.ruw00 AND ruwconf = 'Y'
            AND ruw02 = g_ruw.ruw02 AND ruw05 = g_ruw.ruw05
      IF SQLCA.SQLCODE <> 100 THEN
         LET g_errno = 'art-390'
      END IF
   END IF
   IF cl_null(g_errno) THEN
      SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = g_ruw.ruw05 
      DISPLAY l_imd02 TO FORMONLY.ruw05_desc
   END IF
END FUNCTION 
 
FUNCTION t212_ruw06()
DEFINE l_gen02    LIKE gen_file.gen02
DEFINE l_genacti  LIKE gen_file.genacti
 
   LET g_errno = ""
 
   SELECT gen02,genacti
     INTO l_gen02,l_genacti
     FROM gen_file WHERE gen01 = g_ruw.ruw06
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-391'
        WHEN l_genacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY l_gen02 TO FORMONLY.ruw06_desc
   END CASE
 
END FUNCTION
 
FUNCTION t212_rux03()
DEFINE l_imaacti LIKE ima_file.imaacti
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_n       LIKE type_file.num5
DEFINE l_i       LIKE type_file.num5
DEFINE l_flag    LIKE type_file.num5 
DEFINE l_rus07   LIKE rus_file.rus07                                                  
DEFINE l_rus09   LIKE rus_file.rus09                                                     
DEFINE l_rus11   LIKE rus_file.rus11                                                    
DEFINE l_rus13   LIKE rus_file.rus13
 
   LET g_errno = ""
 
   SELECT ima02,imaacti,ima25,gfe02
      INTO g_rux[l_ac].rux03_desc,l_imaacti,
           g_rux[l_ac].rux04,g_rux[l_ac].rux04_desc
      FROM ima_file,gfe_file 
      WHERE ima01 = g_rux[l_ac].rux03 AND gfe01 = ima25
 
   CASE WHEN SQLCA.SQLCODE = 100  
                           LET g_errno = 'art-037'
        WHEN l_imaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                           DISPLAY g_rux[l_ac].rux03_desc TO FORMONLY.rux03_desc
                           DISPLAY g_rux[l_ac].rux04_desc TO FORMONLY.rux04_desc
                           DISPLAY BY NAME g_rux[l_ac].rux04
                           
   END CASE
   
   IF cl_null(g_errno) THEN
      SELECT rtz04 INTO l_rtz04 
         FROM rtz_file WHERE rtz01=g_ruw.ruwplant
      IF NOT cl_null(l_rtz04) THEN
         SELECT rus07,rus09,rus11,rus13 
       	     INTO l_rus07,l_rus09,l_rus11,l_rus13
             FROM rus_file 
             WHERE rus01 = g_ruw.ruw02 
         CALL t212_get_shop(l_rus07,l_rus09,l_rus11,l_rus13) RETURNING l_flag
         IF l_flag = 0 THEN
            SELECT COUNT(*) INTO l_n FROM rte_file 
               WHERE rte01 = l_rtz04 AND rte03 = g_rux[l_ac].rux03
            IF l_n = 0 OR l_n IS NULL THEN
               LET g_errno = 'art-054'
            END IF    
         ELSE
       	    FOR l_i=1 TO g_result.getLength()
               IF g_result[l_i] = g_rux[l_ac].rux03 THEN
                  LET l_flag = 3
               END IF
            END FOR
            IF l_flag <> '3' THEN
               LET g_errno = 'art-387'
            END IF
         END IF
      END IF
   END IF
   
   IF cl_null(g_errno) THEN
      SELECT rut06-rut07 INTO g_rux[l_ac].rux05 FROM rut_file WHERE rut01=g_ruw.ruw02 #bnl add rut07
         AND rut02=g_ruw.ruw04 AND rut03=g_ruw.ruw05
         AND rut04=g_rux[l_ac].rux03
      IF g_rux[l_ac].rux05 IS NULL THEN LET g_rux[l_ac].rux05 = 0 END IF
   END IF
END FUNCTION
 
FUNCTION t212_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rux.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t212_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ruw.* TO NULL
      RETURN
   END IF
 
   OPEN t212_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ruw.* TO NULL
   ELSE
      OPEN t212_count
      FETCH t212_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t212_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION t212_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
      WHEN 'P' FETCH PREVIOUS t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
      WHEN 'F' FETCH FIRST    t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
      WHEN 'L' FETCH LAST     t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
        FETCH ABSOLUTE g_jump t212_cs INTO g_ruw.ruw00,g_ruw.ruw01
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      INITIALIZE g_ruw.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_ruw.* FROM ruw_file WHERE ruw01 = g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ruw_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_ruw.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_ruw.ruwuser
   LET g_data_group = g_ruw.ruwgrup
   LET g_data_plant = g_ruw.ruwplant   #TQC-A10128 ADD
 
   CALL t212_show()
 
END FUNCTION
 
FUNCTION t212_show()
DEFINE  l_gen02  LIKE gen_file.gen02
DEFINE  l_azp02  LIKE azp_file.azp02
DEFINE  l_rus02  LIKE rus_file.rus02
DEFINE  l_imd02  LIKE imd_file.imd02
 
   LET g_ruw_t.* = g_ruw.*
   LET g_ruw_o.* = g_ruw.*
   DISPLAY BY NAME g_ruw.ruw01,g_ruw.ruw02,g_ruw.ruw03, g_ruw.ruworiu,g_ruw.ruworig,
                   g_ruw.ruw04,g_ruw.ruw05,g_ruw.ruw06,g_ruw.ruwconf,
                   g_ruw.ruwcond,g_ruw.ruwconu,g_ruw.ruwcont,g_ruw.ruwmksg,         #FUN-870100
                   g_ruw.ruw900,g_ruw.ruwplant,g_ruw.ruw07,g_ruw.ruw08,    #FUN-A50071 add ruw10
                   g_ruw.ruw09,g_ruw.ruw10,g_ruw.ruwpos,g_ruw.ruwuser,g_ruw.ruwmodu,g_ruw.ruwgrup,  #FUN-870100
                   g_ruw.ruwdate,g_ruw.ruwacti,g_ruw.ruwcrat
                  ,g_ruw.ruworiu,g_ruw.ruworig                                   #TQC-A30050 ADD
 
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruw.ruwconu
   DISPLAY l_gen02 TO FORMONLY.ruwconu_desc
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01 = g_ruw.ruwplant
   DISPLAY l_azp02 TO FORMONLY.ruwplant_desc
   SELECT rus02 INTO l_rus02 FROM rus_file WHERE rus01 = g_ruw.ruw02
   DISPLAY l_rus02 TO FORMONLY.ruw02_desc
   LET l_gen02 = ''
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_ruw.ruw06
   DISPLAY l_gen02 TO FORMONLY.ruw06_desc
   SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = g_ruw.ruw05
   DISPLAY l_imd02 TO FORMONLY.ruw05_desc
 
   #CKP                                                                                                                             
   IF g_ruw.ruwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF                                                                
   CALL cl_set_field_pic(g_ruw.ruwconf,"","","",g_chr,"")
   CALL t212_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t212_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruw.ruw01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_ruw.ruwconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ruw.ruwconf = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   BEGIN WORK 
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t212_show()
 
   IF g_ruw.ruwconf = 'Y' THEN
      CALL cl_err('','art-022',0)
      RETURN
   END IF
 
   IF cl_exp(0,0,g_ruw.ruwacti) THEN
      LET g_chr=g_ruw.ruwacti
      IF g_ruw.ruwacti='Y' THEN
         LET g_ruw.ruwacti='N'
      ELSE
         LET g_ruw.ruwacti='Y'
      END IF
 
      UPDATE ruw_file SET ruwacti=g_ruw.ruwacti,
                          ruwmodu=g_user,
                          ruwdate=g_today
       WHERE ruw01=g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ruw_file",g_ruw.ruw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_ruw.ruwacti=g_chr
      END IF
   END IF
 
   CLOSE t212_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ruw.ruw01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT ruwacti,ruwmodu,ruwdate
     INTO g_ruw.ruwacti,g_ruw.ruwmodu,g_ruw.ruwdate FROM ruw_file
    WHERE ruw01=g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
   DISPLAY BY NAME g_ruw.ruwacti,g_ruw.ruwmodu,g_ruw.ruwdate
 
END FUNCTION
 
FUNCTION t212_r()
DEFINE l_rows       LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ruw.ruw01 IS NULL OR g_ruw.ruwplant IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_aza.aza88 = 'Y' THEN
      IF NOT (g_ruw.ruwacti='N' AND g_ruw.ruwpos='Y') THEN
        #CALL cl_err('', 'aim-944', 1)     #FUN-A30030 MARK
         #CALL cl_err('', 'art-648', 1)     #ADD
         CALL cl_err('', 'apc-139', 1)     #NO.FUN-B50042
         RETURN
      END IF
   ELSE
      IF g_ruw.ruwacti='N' THEN
         CALL cl_err('','mfg1000',1)
         RETURN
      END IF
   END IF
   SELECT * INTO g_ruw.* FROM ruw_file
       WHERE ruw01=g_ruw.ruw01 
         AND ruw00 = g_ruw.ruw00
 
   IF g_ruw.ruwconf = 'Y' THEN
      CALL cl_err('','art-023',1)
      RETURN
   END IF
   IF g_ruw.ruwconf = 'X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
   IF STATUS THEN
      CALL cl_err("OPEN t212_cl:", STATUS, 1)
      CLOSE t212_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t212_cl INTO g_ruw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t212_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ruw01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ruw.ruw01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM ruw_file WHERE ruw01 = g_ruw.ruw01 
         AND ruw00 = g_ruw.ruw00 
      DELETE FROM rux_file WHERE rux01 = g_ruw.ruw01
         AND rux00 = g_ruw.ruw00 
      IF g_argv1 = '2' THEN
         UPDATE ruw_file SET ruw03 = NULL WHERE ruw00 = '1' 
            AND ruw03 = g_ruw.ruw01
      END IF
      IF g_argv1 = '1' THEN
         SELECT COUNT(*) INTO l_rows FROM ruw_file 
             WHERE ruw02 = g_ruw.ruw02 
               AND ruwconf <> 'X'
         IF l_rows IS NULL THEN LET l_rows = 0 END IF
         IF l_rows = 0 THEN 
            UPDATE rus_file SET rus900 = '0'
                WHERE rus01 = g_ruw.ruw02 
            UPDATE ruu_file SET ruu900 = '0' WHERE ruu02 = g_ruw.ruw02
         END IF
      END IF
      CLEAR FORM
      DISPLAY g_argv1 TO ruw00
      CALL g_rux.clear()
      OPEN t212_count
      FETCH t212_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t212_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t212_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t212_fetch('/')
      END IF
   END IF
 
   CLOSE t212_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ruw.ruw01,'D')
END FUNCTION
 
FUNCTION t212_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_n1            LIKE type_file.num5,
    l_n2            LIKE type_file.num5,
    l_n3            LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_misc          LIKE gef_file.gef01,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_pmc05         LIKE pmc_file.pmc05,
    l_pmc30         LIKE pmc_file.pmc30
 
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE l_i       LIKE type_file.num5
DEFINE l_rtz04   LIKE rtz_file.rtz04
DEFINE l_rus07   LIKE rus_file.rus07
DEFINE l_rus09   LIKE rus_file.rus09
DEFINE l_rus11   LIKE rus_file.rus11
DEFINE l_rus13   LIKE rus_file.rus13
DEFINE l_flag    LIKE type_file.num5
DEFINE l_temp    LIKE type_file.chr1000
DEFINE l_sql     STRING             #FUN-AA0059
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_ruw.ruw01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_ruw.* FROM ruw_file
     WHERE ruw01=g_ruw.ruw01
       AND rux00 = g_ruw.ruw00 
 
    IF g_ruw.ruwacti ='N' THEN
       CALL cl_err(g_ruw.ruw01,'mfg1000',0)
       RETURN
    END IF
    
    IF g_ruw.ruwconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN
    END IF
    IF g_ruw.ruwconf = 'X' THEN                                                                                             
       CALL cl_err('','art-025',0)                                                                                          
       RETURN                                                                                                               
    END IF
    CALL cl_opmsg('b')
 
    SELECT rtz04 INTO l_rtz04 FROM rtz_file WHERE rtz01=g_ruw.ruwplant                                     
    LET g_forupd_sql = "SELECT rux02,rux03,'',rux04,'',rux05,rux06,rux07,rux08,rux09 ",
                       "  FROM rux_file ",
                       " WHERE rux00 = ? AND rux01=? AND rux02=? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t212_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_rux WITHOUT DEFAULTS FROM s_rux.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t212_cl USING g_ruw.ruw00,g_ruw.ruw01
           IF STATUS THEN
              CALL cl_err("OPEN t212_cl:", STATUS, 1)
              CLOSE t212_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t212_cl INTO g_ruw.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_ruw.ruw01,SQLCA.sqlcode,0)
              CLOSE t212_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rux_t.* = g_rux[l_ac].*  #BACKUP
              LET g_rux_o.* = g_rux[l_ac].*  #BACKUP
              OPEN t212_bcl USING g_ruw.ruw00,g_ruw.ruw01,g_rux_t.rux02
              IF STATUS THEN
                 CALL cl_err("OPEN t212_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t212_bcl INTO g_rux[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rux_t.rux02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t212_rux03() 
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rux[l_ac].* TO NULL
           LET g_rux[l_ac].rux07 = 0               #Body default
 
           LET g_rux_t.* = g_rux[l_ac].*
           LET g_rux_o.* = g_rux[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rux02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           INSERT INTO rux_file(rux00,rux01,rux02,rux03,rux04,rux05,rux06,
                                rux07,rux08,rux09,ruxplant,ruxlegal)
           VALUES(g_ruw.ruw00,g_ruw.ruw01,g_rux[l_ac].rux02,
                  g_rux[l_ac].rux03,g_rux[l_ac].rux04,
                  g_rux[l_ac].rux05,g_rux[l_ac].rux06,
                  g_rux[l_ac].rux07,g_rux[l_ac].rux08,
                  g_rux[l_ac].rux09,g_ruw.ruwplant,g_ruw.ruwlegal)
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","rux_file",g_ruw.ruw01,g_rux[l_ac].rux02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD rux02
           IF g_rux[l_ac].rux02 IS NULL OR g_rux[l_ac].rux02 = 0 THEN
              SELECT max(rux02)+1
                INTO g_rux[l_ac].rux02
                FROM rux_file
               WHERE rux01 = g_ruw.ruw01
                 AND rux00 = g_ruw.ruw00
              IF g_rux[l_ac].rux02 IS NULL THEN
                 LET g_rux[l_ac].rux02 = 1
              END IF
           END IF
 
        AFTER FIELD rux02
           IF NOT cl_null(g_rux[l_ac].rux02) THEN
              IF g_rux[l_ac].rux02 != g_rux_t.rux02
                 OR g_rux_t.rux02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM rux_file
                  WHERE rux01 = g_ruw.ruw01
                    AND rux02 = g_rux[l_ac].rux02
                    AND rux00 = g_ruw.ruw00
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rux[l_ac].rux02 = g_rux_t.rux02
                    NEXT FIELD rux02
                 END IF 
              END IF
           END IF
        AFTER FIELD rux03
           IF NOT cl_null(g_rux[l_ac].rux03) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_rux[l_ac].rux03,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rux[l_ac].rux03= g_rux_t.rux03
                 NEXT FIELD rux03
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              IF g_rux_o.rux03 IS NULL OR
                 (g_rux[l_ac].rux03 != g_rux_o.rux03 ) THEN
                 SELECT COUNT(*) INTO l_n FROM rux_file WHERE rux00 = g_ruw.ruw00
                    AND rux01 = g_ruw.ruw01 
                    AND rux03 = g_rux[l_ac].rux03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD rux03
                 END IF
                 CALL t212_rux03()          
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rux[l_ac].rux03,g_errno,0)
                    LET g_rux[l_ac].rux03 = g_rux_o.rux03
                    DISPLAY BY NAME g_rux[l_ac].rux03
                    NEXT FIELD rux03
                 END IF
                 #檢查商品是否在商品策略中
                 IF NOT cl_null(l_rtz04) THEN
                    SELECT COUNT(*) INTO l_n FROM rte_file 
                       WHERE rte01 = l_rtz04 AND rte03 = g_rux[l_ac].rux03
                    IF l_n = 0 OR l_n IS NULL THEN
                       CALL cl_err('','art-389',0)
                       NEXT FIELD rux03
                    END IF
                 END IF
                 IF NOT cl_null(g_rux[l_ac].rux05) AND NOT cl_null(g_rux[l_ac].rux06)
                    AND NOT cl_null(g_rux[l_ac].rux07) THEN
                    LET g_rux[l_ac].rux08 = g_rux[l_ac].rux06+g_rux[l_ac].rux07 -g_rux[l_ac].rux05 #bnl -090204
                 END IF
              END IF
           END IF
           
        AFTER FIELD rux06
           IF NOT cl_null(g_rux[l_ac].rux06) THEN
              IF g_rux[l_ac].rux06 < 0 THEN
                 CALL cl_err('','art-386',0)
                 NEXT FIELD rux06                
              END IF
              IF NOT cl_null(g_rux[l_ac].rux05) AND NOT cl_null(g_rux[l_ac].rux06)
                 AND NOT cl_null(g_rux[l_ac].rux07) THEN
                 LET g_rux[l_ac].rux08 = g_rux[l_ac].rux06+g_rux[l_ac].rux07 -g_rux[l_ac].rux05 #bnl -090204
              END IF
           END IF
        
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rux_t.rux02 > 0 AND g_rux_t.rux02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rux_file
               WHERE rux01 = g_ruw.ruw01
                 AND rux02 = g_rux_t.rux02
                 AND rux00 = g_ruw.ruw00
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rux_file",g_ruw.ruw01,g_rux_t.rux02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_rux[l_ac].* = g_rux_t.*
              CLOSE t212_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rux[l_ac].rux02,-263,1)
              LET g_rux[l_ac].* = g_rux_t.*
           ELSE
              UPDATE rux_file SET rux02=g_rux[l_ac].rux02,
                                  rux03=g_rux[l_ac].rux03,
                                  rux04=g_rux[l_ac].rux04,
                                  rux05=g_rux[l_ac].rux05,
                                  rux06=g_rux[l_ac].rux06,
                                  rux07=g_rux[l_ac].rux07,
                                  rux08=g_rux[l_ac].rux08,
                                  rux09=g_rux[l_ac].rux09
               WHERE rux01=g_ruw.ruw01
                 AND rux02=g_rux_t.rux02
                 AND rux00=g_ruw.ruw00
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rux_file",g_ruw.ruw01,g_rux_t.rux02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_rux[l_ac].* = g_rux_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
        
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rux[l_ac].* = g_rux_t.*
              END IF
              CLOSE t212_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t212_bcl
           COMMIT WORK
           
        ON ACTION CONTROLO
           IF INFIELD(rux02) AND l_ac > 1 THEN
              LET g_rux[l_ac].* = g_rux[l_ac-1].*
              LET g_rux[l_ac].rux02 = g_rec_b + 1
              NEXT FIELD rux02
           END IF 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
           
        ON ACTION controlp
           CASE
              WHEN INFIELD(rux03)
#FUN-AA0059---------mod------------str-----------------
      #           CALL cl_init_qry_var()                                                     #FUN-AA0059 mark
                  IF cl_null(l_rtz04) THEN
      #              LET g_qryparam.form = "q_ima"                                           #FUN-AA0059 mark
                     CALL q_sel_ima(FALSE,'q_ima',"",g_rux[l_ac].rux03,"","","","","",'') #FUN-AA0059 add
                         RETURNING g_rux[l_ac].rux03                                         #FUN-AA0059 add 
                  ELSE
               	    SELECT rus07,rus09,rus11,rus13 
                      INTO l_rus07,l_rus09,l_rus11,l_rus13
                      FROM rus_file 
                      WHERE rus01 = g_ruw.ruw02 
                    CALL t212_get_shop(l_rus07,l_rus09,l_rus11,l_rus13)
                       RETURNING l_flag
                   IF l_flag = 0 THEN
                        CALL cl_init_qry_var()                              #FUN-AA0059 add 
                        LET g_qryparam.form = "q_rte03"  
                        LET g_qryparam.arg1 = l_rtz04 
                        LET g_qryparam.default1 = g_rux[l_ac].rux03                 
                        CALL cl_create_qry() RETURNING g_rux[l_ac].rux03    #FUN-AA0059 add
                    ELSE
#FUN-AA0059 mark
#                      LET g_qryparam.where = " ima01 IN ('"
#                      FOR l_i = 1 TO g_result.getLength()
#                        LET g_qryparam.where = g_qryparam.where,g_result[l_i],"','"
#                      END FOR
#                      LET l_temp = g_qryparam.where
#                      LET g_qryparam.where = l_temp[1,g_qryparam.where.getLength()-2]
#                      LET g_qryparam.where = g_qryparam.where,")"
#                      LET g_qryparam.form = "q_ima" 
#                      LET g_qryparam.where = g_qryparam.where," AND ima01 IN (SELECT ",
#                                             " rte03 FROM rte_file WHERE rte01='",l_rtz04,"') "
#FUN-AA0059 mark
#FUN-AA0059 add
                       LET l_sql = " ima01 IN ('"
                       FOR l_i = 1 TO g_result.getLength()
                         LET l_sql  = l_sql,g_result[l_i],"','"
                       END FOR
                       LET l_temp = l_sql
                       LET l_sql = l_temp[1,l_sql.getLength()-2]
                       LET l_sql = l_sql,")"
                       LET l_sql = l_sql," AND ima01 IN (SELECT ",
                                              " rte03 FROM rte_file WHERE rte01='",l_rtz04,"') "
                       CALL q_sel_ima(FALSE,'q_ima',l_sql,g_rux[l_ac].rux03,"","","","","",'') #FUN-AA0059 add
                         RETURNING g_rux[l_ac].rux03                                                      #FUN-AA0059 add
#FUN-AA0059 add
                    END IF
                 END IF                       
       #          LET g_qryparam.default1 = g_rux[l_ac].rux03                 #FUN-AA0059 mark
       #          CALL cl_create_qry() RETURNING g_rux[l_ac].rux03            #FUN-AA0059 mark     
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_rux[l_ac].rux03
                 CALL t212_rux03()
                 NEXT FIELD rux03
              OTHERWISE EXIT CASE
            END CASE
 
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
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
   END INPUT
   IF p_cmd = 'u' THEN
      UPDATE ruw_file SET ruwmodu = g_ruw.ruwmodu,ruwdate = g_ruw.ruwdate
         WHERE ruw01 = g_ruw.ruw01 AND rwx00 = g_ruw.ruw00 
     
      DISPLAY BY NAME g_ruw.ruwmodu,g_ruw.ruwdate
   END IF 
   CLOSE t212_bcl
   COMMIT WORK
   CALL t212_delall()
 
END FUNCTION
 
FUNCTION t212_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM rux_file
    WHERE rux01 = g_ruw.ruw01 
      AND rux00 = g_ruw.ruw00 
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM ruw_file WHERE ruw01 = g_ruw.ruw01
         AND ruw00 = g_ruw.ruw00 
   ELSE
      IF g_argv1 = "1" THEN
         UPDATE rus_file SET rus900 = '2' 
             WHERE rus01 = g_ruw.ruw02
      END IF
   END IF
END FUNCTION
 
FUNCTION t212_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT rux02,rux03,'',rux04,'',rux05,rux06,rux07,rux08,rux09 ",
               "  FROM rux_file",
               " WHERE rux01 ='",g_ruw.ruw01,"' AND rux00 = '",g_ruw.ruw00,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rux02 "
 
   DISPLAY g_sql
 
   PREPARE t212_pb FROM g_sql
   DECLARE rux_cs CURSOR FOR t212_pb
 
   CALL g_rux.clear()
   LET g_cnt = 1
 
   FOREACH rux_cs INTO g_rux[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT ima02 INTO g_rux[g_cnt].rux03_desc FROM ima_file
           WHERE ima01 = g_rux[g_cnt].rux03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","ima_file",g_rux[g_cnt].rux03,"",SQLCA.sqlcode,"","",0)  
          LET g_rux[g_cnt].rux03_desc = NULL
       END IF
       SELECT gfe02 INTO g_rux[g_cnt].rux04_desc FROM gfe_file
          WHERE gfe01 = g_rux[g_cnt].rux04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rux.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t212_get_shop(p_sort,p_sign,p_factory,p_shop)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE l_n1            LIKE type_file.num5
DEFINE l_n2            LIKE type_file.num5
DEFINE l_n3            LIKE type_file.num5   
DEFINE l_n4            LIKE type_file.num5
DEFINE l_sql           STRING
DEFINE p_sort          LIKE rus_file.rus07
DEFINE p_sign          LIKE rus_file.rus09
DEFINE p_factory       LIKE rus_file.rus11
DEFINE p_shop          LIKE rus_file.rus13
 
   LET g_errno = ''
   
   IF cl_null(p_sort) AND cl_null(p_sign)
      AND cl_null(p_factory) AND cl_null(p_shop) THEN
      RETURN 0
   END IF

#FUN-9B0068 --begin-- 
#   CREATE TEMP TABLE sort(ima01 varchar(40))
#   CREATE TEMP TABLE sign(ima01 varchar(40))
#   CREATE TEMP TABLE factory(ima01 varchar(40))
#   CREATE TEMP TABLE no(ima01 varchar(40))
   CREATE TEMP TABLE sort(
             ima01   LIKE ima_file.ima01)
   CREATE TEMP TABLE sign(
             ima01   LIKE ima_file.ima01)
   CREATE TEMP TABLE factory(
             ima01   LIKE ima_file.ima01)
   CREATE TEMP TABLE no(
             ima01   LIKE ima_file.ima01)
#FUN-9B0068 --end-- 
   CALL t210_get_sort(p_sort)
   CALL t210_get_sign(p_sign)
   CALL t210_get_factory(p_factory)
   CALL t210_get_no(p_shop)
 
   SELECT count(*) INTO l_n1 FROM sort
   SELECT count(*) INTO l_n2 FROM sign
   SELECT count(*) INTO l_n3 FROM factory
   SELECT count(*) INTO l_n4 FROM no
  
   CALL g_result.clear()
 
   IF l_n1 != 0 THEN
      IF l_n2 != 0 THEN
         IF l_n3 != 0 THEN
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 ",
                           " AND C.ima01 = D.ima01 "
            ELSE
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,factory C ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = C.ima01 "
            END IF
         ELSE                     
            IF l_n4 != 0 THEN
               LET l_sql = "SELECT A.ima01 FROM sort A,sign B,no D ",
                           " WHERE A.ima01 = B.ima01 AND B.ima01 = D.ima01 "
            ELSE
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
   PREPARE t212_get_pb FROM l_sql
   DECLARE rus_get_cs1 CURSOR FOR t212_get_pb
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
FUNCTION t210_get_sort(p_sort)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE p_sort          LIKE rus_file.rus07
 
    CALL g_sort.clear()
                                                                                                     
    IF NOT cl_null(p_sort) THEN
       LET tok = base.StringTokenizer.createExt(p_sort,"|",'',TRUE)
       LET g_cnt = 1
       WHILE tok.hasMoreTokens()
          LET l_ck = tok.nextToken()
          LET g_sql = "SELECT ima01 FROM ima_file WHERE ima131 = '",l_ck,"'"  
          PREPARE t212_pb1 FROM g_sql
          DECLARE rus_cs1 CURSOR FOR t212_pb1
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
FUNCTION t210_get_sign(p_sign)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE p_sign          LIKE rus_file.rus09
 
   CALL g_sign.clear()
   IF NOT cl_null(p_sign) THEN
      LET tok = base.StringTokenizer.createExt(p_sign,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()                                                                                              
         LET g_sql = "SELECT ima01 FROM ima_file WHERE ima1005 = '",l_ck,"'"
         PREPARE t212_pb2 FROM g_sql
         DECLARE rus_cs2 CURSOR FOR t212_pb2
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
FUNCTION t210_get_factory(p_factory)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE p_factory       LIKE rus_file.rus11
   
   CALL g_factory.clear()
   IF NOT cl_null(p_factory) THEN
      LET tok = base.StringTokenizer.createExt(p_factory,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()                                                                                               
         LET g_sql = "SELECT rty02 FROM rty_file ",
                     " WHERE rty05 = '",l_ck,"' AND rty01 = '",g_ruw.ruwplant,"'" 
         PREPARE t212_pb3 FROM g_sql
         DECLARE rus_cs3 CURSOR FOR t212_pb3
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
FUNCTION t210_get_no(p_shop)
DEFINE l_ck            LIKE type_file.chr50
DEFINE tok             base.StringTokenizer
DEFINE p_shop       LIKE rus_file.rus13  
 
   CALL g_no.clear()
   IF NOT cl_null(p_shop) THEN
      LET tok = base.StringTokenizer.createExt(p_shop,"|",'',TRUE)
      LET g_cnt = 1
      WHILE tok.hasMoreTokens()
         LET l_ck = tok.nextToken()
         LET g_no[g_cnt] = l_ck
         INSERT INTO no VALUES(g_no[g_cnt]) 
         LET g_cnt = g_cnt + 1
      END WHILE
      CALL g_sort.deleteElement(g_cnt)
   END IF
END FUNCTION
 
FUNCTION t212_copy()
   DEFINE l_newno     LIKE ruw_file.ruw01,
          l_oldno     LIKE ruw_file.ruw01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ruw.ruw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t212_set_entry('a')
   CALL cl_set_docno_format("ruw01")
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM ruw01
 
       AFTER FIELD ruw01
          IF l_newno IS NULL THEN                                                                                                  
              NEXT FIELD ruw01                                                                                                      
           ELSE                                                                                                                    
              IF g_ruw.ruw00 = '1' THEN
#                CALL s_check_no("art",l_newno,"","J","ruw_file","ruw01","")  #FUN-A70130 mark                                                         
                 CALL s_check_no("art",l_newno,"","J4","ruw_file","ruw01","")  #FUN-A70130 mod                                                          
                    RETURNING li_result,l_newno
              ELSE
#                CALL s_check_no("art",l_newno,"","L","ruw_file","ruw01","")  #FUN-A70130 mark
                 CALL s_check_no("art",l_newno,"","J5","ruw_file","ruw01","")  #FUN-A70130 mod
                    RETURNING li_result,l_newno
              END IF                                                                                
              IF (NOT li_result) THEN                                                                                               
                 LET g_ruw.ruw01=g_ruw_t.ruw01                                                                                      
                 NEXT FIELD ruw01                                                                                                   
              END IF                                                                                                                
              BEGIN WORK                                                                                                            
#             CALL s_auto_assign_no("art",l_newno,g_today,"","rus_file","rus01","","","")  #FUN-A70130 mark                                         
              CALL s_auto_assign_no("art",l_newno,g_today,"D5","rus_file","rus01","","","")  #FUN-A70130 mod                                         
                 RETURNING li_result,l_newno                                                                                        
              IF (NOT li_result) THEN                                                                                               
                 ROLLBACK WORK                                                                                                      
                 NEXT FIELD ruw01                                                                                                   
              ELSE                                                                                                                  
                 COMMIT WORK                                                                                                        
              END IF                                                                                                                
           END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION controlp
         CASE  
            WHEN INFIELD(ruw01) 
               LET g_t1=s_get_doc_no(g_ruw.ruw01) 
               IF g_argv1 = '1' THEN
#                 CALL q_smy(FALSE,FALSE,g_t1,'ART','J') RETURNING g_t1   #FUN-A70130--mark--
                  CALL q_oay(FALSE,FALSE,g_t1,'J4','ART') RETURNING g_t1  #FUN-A70130--mod--
               ELSE                                                
#                 CALL q_smy(FALSE,FALSE,g_t1,'ART','L') RETURNING g_t1   #FUN-A70130--mark--
                  CALL q_oay(FALSE,FALSE,g_t1,'J5','ART') RETURNING g_t1  #FUN-A70130--mod--
               END IF        
               LET l_newno = g_t1 
               DISPLAY l_newno TO ruw01
               NEXT FIELD ruw01
        END CASE
     ON ACTION about
        CALL cl_about()
 
     ON ACTION HELP
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_ruw.ruw01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM ruw_file
       WHERE ruw01=g_ruw.ruw01 AND ruw00 = g_ruw.ruw00
       INTO TEMP y
 
   UPDATE y
       SET ruw01=l_newno,
           ruwconf = 'N',
           ruwcond = NULL,
           ruwconu = NULL,
           ruwuser=g_user,
           ruwgrup=g_grup,
           ruworiu=g_user,         #TQC-A30050 ADD
           ruworig=g_grup,         #TQC-A30050 ADD
           ruwmodu=NULL,
           ruwdate=g_today,
           ruwacti='Y',
           ruwcrat=g_today,
           ruwmksg = 'N',
           ruw900 = '0',
           ruwplant = g_plant,
           ruwlegal = g_legal,
           ruw08 = 'N',
           ruwcont = '',           #FUN-870100
           ruwpos = 'N'           #FUN-870100
 
   INSERT INTO ruw_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ruw_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM rux_file
       WHERE rux01=g_ruw.ruw01 AND rux00=g_ruw.ruw00
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET rux01=l_newno,ruxplant=g_plant,ruxlegal=g_legal
 
   INSERT INTO rux_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK             # FUN-B80085---回滾放在報錯後---
      CALL cl_err3("ins","rux_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK              # FUN-B80085--add--
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_ruw.ruw01
   SELECT ruw_file.* INTO g_ruw.* 
      FROM ruw_file 
      WHERE ruw01 = l_newno AND ruw00 = g_ruw.ruw00
   CALL t212_u()
   CALL t212_b()
   SELECT ruw_file.* INTO g_ruw.* 
      FROM ruw_file 
      WHERE ruw01 = l_oldno AND ruw00 = g_ruw.ruw00
   CALL t212_show()
 
END FUNCTION
 
FUNCTION t212_out()
DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
     
    IF g_wc IS NULL AND g_ruw.ruw01 IS NOT NULL THEN
       LET g_wc = "ruw01='",g_ruw.ruw01,"'"
    END IF        
     
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
                                                                                                                  
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = ' 1=1'                                                                                                     
    END IF                                                                                                                   
                                                                                                                                    
    LET l_cmd='p_query "artt212" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION t212_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ruw01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t212_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ruw01",FALSE)
    END IF
END FUNCTION
#FUN-960130
