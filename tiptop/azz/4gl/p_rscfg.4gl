# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: p_rscfg.4gl
# Descriptions...: TIPTOP 系統報表伺服器參數設定
# Date & Author..: 09/11/03 By jacklai  FUN-980098
# Modify.........: No.FUN-980098 09/11/03 By jacklai 新增程式
# Modify.........: No:FUN-A10101 10/01/18 by jacklai Webi報表移除多語言報表名稱
# Modify.........: No:FUN-A10143 10/01/28 by jacklai Webi報表新增匯入單支客製程式功能
# Modify.........: No:FUN-A30104 10/03/29 by jacklai 在更新zz_file時，當程式代號重複時，以客製程式的紀錄為主。
# Modify.........: No:FUN-A70007 10/07/02 by jacklai 在整批匯入與單支程式匯入時，依據報表樣板檔名加入行業別欄位

#No:FUN-980098 --start--
IMPORT com
IMPORT xml
IMPORT os

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../aws/4gl/aws_bigw2.inc"          

DEFINE g_gdg                RECORD LIKE gdg_file.*  #報表伺服器參數設定檔
DEFINE g_before_input_done  LIKE type_file.num5     #判斷是否已執行 Before Input指令

MAIN
    DEFINE p_row, p_col  LIKE type_file.num5
    
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM
        
    DEFER INTERRUPT

    WHENEVER ERROR CALL cl_err_msg_log
    
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF

    IF (NOT cl_setup("AZZ")) THEN
        EXIT PROGRAM
    END IF

    LET p_row = 4 LET p_col = 2
    OPEN WINDOW p_rscfg_w AT p_row, p_col WITH FORM "azz/42f/p_rscfg" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
    
    cALL p_rscfg_show()

    LET g_action_choice=""
    CALL p_rscfg_menu()

    CLOSE WINDOW p_rscfg_w
END MAIN

FUNCTION p_rscfg_menu()
 
    MENU ""
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL p_rscfg_u()
            END IF
        ON ACTION importreport
            LET g_action_choice="importreport"
            IF cl_chk_act_auth() THEN
                 CALL p_rscfg_imprep()
            END IF
        
        #No:FUN-A10143 --start--
        ON ACTION importsingle
            LET g_action_choice="importsingle"
            IF cl_chk_act_auth() THEN
                 CALL p_rscfg_imp()
            END IF
        #No:FUN-A10143 --end--
        
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont() 
            
        ON ACTION help
            CALL cl_show_help()
            
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
            
        ON ACTION controlg
            CALL cl_cmdask()
            
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
 
        ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121

        COMMAND KEY(INTERRUPT)
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU

END FUNCTION

FUNCTION p_rscfg_show()
    SELECT * INTO g_gdg.* FROM gdg_file ORDER BY gdg01, gdg02
    IF SQLCA.sqlcode OR g_gdg.gdg01 IS NULL THEN
        LET g_gdg.gdg01 = ""
        LET g_gdg.gdg02 = ""
        LET g_gdg.gdg03 = ""
        LET g_gdg.gdg04 = ""
        LET g_gdg.gdg05 = ""
        LET g_gdg.gdg06 = ""
        LET g_gdg.gdg07 = ""
    END IF
       
    DISPLAY BY NAME g_gdg.gdg01,g_gdg.gdg02,g_gdg.gdg03,g_gdg.gdg04,
                    g_gdg.gdg05,g_gdg.gdg06,g_gdg.gdg07
    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION p_rscfg_i()    
    DEFINE l_input   LIKE type_file.chr1
    
    DISPLAY BY NAME
        g_gdg.gdg01,g_gdg.gdg02,g_gdg.gdg03,g_gdg.gdg04,g_gdg.gdg05,
        g_gdg.gdg06,g_gdg.gdg07
 
    INPUT BY NAME
        g_gdg.gdg01,g_gdg.gdg02,g_gdg.gdg03,g_gdg.gdg04,g_gdg.gdg05,
        g_gdg.gdg06,g_gdg.gdg07
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET l_input='N'
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE

        AFTER INPUT
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_gdg.gdg01 IS NULL AND g_gdg.gdg02 IS NULL THEN
                NEXT FIELD gdg01
            END IF

        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF          # 欄位說明
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

        ON ACTION about         #MOD-4C0121
            CALL cl_about()     #MOD-4C0121

        ON ACTION help          #MOD-4C0121
            CALL cl_show_help() #MOD-4C0121

    END INPUT
    
END FUNCTION

FUNCTION p_rscfg_u()
    
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
    
    CALL p_rscfg_show()                          # 顯示最新資料
    WHILE TRUE
        CALL p_rscfg_i()                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL p_rscfg_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        DELETE FROM gdg_file
        INSERT INTO gdg_file VALUES (g_gdg.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err("gdg",SQLCA.sqlcode,1)
            CONTINUE WHILE
        ELSE
            MESSAGE ""
            EXIT WHILE
        END IF
    END WHILE
    COMMIT WORK
END FUNCTION

#從BOE匯入報表
FUNCTION p_rscfg_imprep()
    DEFINE l_gdh            RECORD LIKE gdh_file.*  #CR+WEBI報表資料檔
    DEFINE l_status         LIKE type_file.num10    #WS status
    DEFINE l_result         STRING                  #WS response string
    DEFINE l_str            STRING
    DEFINE l_type           STRING
    DEFINE l_name           STRING
    #DEFINE l_splitpos       LIKE type_file.num10   #NO:FUN-A10101
    DEFINE l_cnt            LIKE type_file.num10
    DEFINE l_cnt2           LIKE type_file.num10
    DEFINE l_cnt3           LIKE type_file.num10
    DEFINE l_i              LIKE type_file.num10
    DEFINE l_xmldoc         om.DomDocument
    DEFINE l_docroot        om.DomNode
    DEFINE n_category       om.DomNode
    DEFINE n_report         om.DomNode
    DEFINE n_parent         om.DomNode
    DEFINE nl_category      om.NodeList
    DEFINE nl_report        om.NodeList
    DEFINE l_zz08           LIKE zz_file.zz08
    DEFINE l_outlog         STRING
    DEFINE l_errlog         STRING
    DEFINE l_outmsg         STRING
    DEFINE l_errmsg         STRING
    DEFINE ls_date          STRING
    DEFINE l_module         STRING
    #DEFINE l_langname       STRING #NO:FUN-A10101
    DEFINE l_mod_first      STRING
    DEFINE l_zz011          LIKE zz_file.zz011
    DEFINE l_zz_arr         DYNAMIC ARRAY OF RECORD LIKE gdh_file.* #FUN-A30104
    DEFINE l_j              LIKE type_file.num10    #FUN-A30104
    DEFINE l_find           LIKE type_file.num5     #FUN-A30104
    DEFINE l_startPos       LIKE type_file.num10    #No:FUN-A70007
    DEFINE l_endPos         LIKE type_file.num10    #No:FUN-A70007
    
    SELECT * INTO g_gdg.* FROM gdg_file ORDER BY gdg01, gdg02
    IF SQLCA.sqlcode THEN
        RETURN
    END IF
    
    LET ls_date = TODAY USING 'YYYYMMDD'
    LET l_outlog = FGL_GETENV("TEMPDIR"),os.Path.separator(),"p_rscfg-",ls_date,".log"
    LET l_errlog = FGL_GETENV("TEMPDIR"),os.Path.separator(),"p_rscfg_err-",ls_date,".log"

    CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
    #呼叫VpWebService取得Token
    LET BI2_VpWebServiceImplService_VpWebServiceImplPortLocation = g_gdg.gdg03  CLIPPED #FUN-840065 #指定 Soap server location
    CALL BI2_GetCatelogReportListByCms(g_gdg.gdg04, g_gdg.gdg05, g_gdg.gdg06) #連接 V-Point Express SOAP server #caiyao modified
        RETURNING l_status, l_result

    DISPLAY "l_status= ", l_status
    IF l_status = 0 THEN
        #DISPLAY l_result
        LET l_xmldoc = om.DomDocument.createFromString(l_result)
        LET l_docroot = l_xmldoc.getDocumentElement()
        
        IF l_docroot IS NULL THEN
          
            IF FGL_GETENV('FGLGUI') = '1' THEN
                LET l_str = "XML parser error:\n\n", l_str
            ELSE
                LET l_str = "XML parser error: ", l_str
            END IF
            LET l_str = l_str, l_result
            CALL cl_err(l_str,'!','1')
            
            RETURN
        END IF
        
        BEGIN WORK
        
        #清除gdh_file
        DELETE FROM gdh_file
        
        LET l_cnt = 0
        #LET nl_category = l_docroot.selectByPath("//Category[@cuid=\"AdeDB1s8oh5Oo2.gJYi3Ox0\"]")
        LET l_str = "//Category[@name=\"",g_gdg.gdg07,"\"]"
        LET nl_category = l_docroot.selectByPath(l_str)

        LET n_category = nl_category.item(1)
        IF n_category IS NOT NULL THEN
            LET nl_report = n_category.selectByTagName("Report")
            LET l_cnt = nl_report.getLength()
        END IF
        IF cl_null(l_cnt) OR l_cnt = 0 THEN
            CALL cl_err('','azz-135',1)
            ROLLBACK WORK
            RETURN
        END IF
        
        FOR l_i = 1 to l_cnt
            LET n_report = nl_report.item(l_i)
            LET l_type = n_report.getAttribute("type")
            
            #取BOE報表的種類
            CASE l_type
                WHEN "Webi"
                    LET l_gdh.gdh01 = "wid"
                WHEN "CrystalReport"
                    #LET l_gdh.gdh01 = "rpt"
                    CONTINUE FOR
            END CASE
 
            #取模組名稱
            LET n_parent = n_report.getParent()
            LET n_parent = n_parent.getParent()
            LET l_module = n_parent.getAttribute("name") CLIPPED
            LET l_zz011 = l_module
            
            #將模組名稱轉大寫
            LET l_module = l_module.toUpperCase()
            
            #取報表名稱的程式代號
            LET l_name = n_report.getAttribute("name") CLIPPED
            #No:FUN-A10101 --start--
            LET l_gdh.gdh02 = l_name
            LET l_gdh.gdh07 = "0"
            #No:FUN-A10101 --end--
            
            #設定行業別
            #No:FUN-A70007 --start--
            LET l_startPos = l_name.getIndexOf("_",1)
            IF l_startPos > 0 THEN
                LET l_endPos = l_name.getLength()
                LET l_gdh.gdh06 = l_name.subString(l_startPos + 1, l_endPos)
            ELSE
                LET l_gdh.gdh06 = "std"
            END IF 
            #No:FUN-A70007 --end--
            
            #設定客製否
            LET l_mod_first = l_module.getCharAt(1)
            CASE l_mod_first
               WHEN "C"
                  LET l_gdh.gdh05 = "Y"
               WHEN "A"
                  LET l_gdh.gdh05 = "N"
               WHEN "G"
                  LET l_gdh.gdh05 = "N"
            END CASE
            
            #取BOE上該物件的CUID
            LET l_gdh.gdh03 = n_report.getAttribute("cuid") CLIPPED
            
            #取BOE上該物件的路徑
            LET l_gdh.gdh04 = n_report.getAttribute("path") CLIPPED
            
            SELECT COUNT(*) INTO l_cnt3 FROM gdh_file WHERE gdh03 = l_gdh.gdh03
            IF l_cnt3 = 0 THEN
            
                INSERT INTO gdh_file VALUES (l_gdh.*)

                # 未成功導入報表清單
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                    CALL cl_err(l_gdh.gdh02, SQLCA.sqlcode, 0)
                    LET l_errmsg = l_errmsg CLIPPED,l_gdh.gdh01 CLIPPED,
                                            "(",l_gdh.gdh02 CLIPPED,")\n"
                END IF
             END IF
        END FOR
        #FUN-A30104 --start--
        DECLARE cur_gdh CURSOR FOR SELECT * FROM gdh_file ORDER BY gdh05 DESC, gdh02 ASC
        LET l_i = 1
        FOREACH cur_gdh INTO l_gdh.*
            LET l_find = 0
            FOR l_j = 1 TO l_i
                IF l_zz_arr[l_j].gdh02 = l_gdh.gdh02 THEN
                    LET l_find = 1
                    EXIT FOR
                END IF
            END FOR
            IF l_find = 0 THEN
                LET l_zz_arr[l_i].* = l_gdh.*
                #更新zz_file報表程式欄位
                LET l_module = p_rscfg_get_module(l_gdh.gdh04)
                LET l_zz011 = l_module    
                
                SELECT COUNT(*) INTO l_cnt2 FROM zz_file WHERE zz01 = l_gdh.gdh02
                LET l_zz08 = "$FGLRUN $AZZi/p_report '",l_gdh.gdh02 CLIPPED,"' '",l_gdh.gdh01 CLIPPED,"' '",l_gdh.gdh05 CLIPPED,"' "
                IF l_cnt2 > 0 THEN
                    UPDATE zz_file SET zz08 = l_zz08, zz011 = l_zz011 WHERE zz01 = l_gdh.gdh02
                ELSE
                    INSERT INTO zz_file(zz01,zz011,zz03,zz05,zz06,zz08,zz13,zz15,
                                        zz25,zz26,zz27,zz28,zz29,zz30,
                                zzuser,zzgrup,zzmodu,zzdate)
                    VALUES (l_gdh.gdh02,l_zz011,"R","N","1",l_zz08,"N","N",
                        "N","N","sm1","3","1",0,g_user,g_grup,"",g_today)
                END IF
                
                IF SQLCA.sqlcode THEN
                    CALL cl_err(l_gdh.gdh02, SQLCA.sqlcode, 0)
                    LET l_errmsg = l_errmsg CLIPPED,l_gdh.gdh01 CLIPPED,
                                   "(",l_gdh.gdh02 CLIPPED,")\n"
                ELSE
                    #成功導入報表清單
                    LET l_outmsg = l_outmsg CLIPPED,l_gdh.gdh01 CLIPPED,
                                   "(",l_gdh.gdh02 CLIPPED,")\n"
                END IF
            END IF
            LET l_i = l_i + 1
        END FOREACH
        COMMIT WORK
        #FUN-A30104 --end--
        
        CALL p_rscfg_log(l_outlog, l_outmsg)
        CALL p_rscfg_log(l_errlog, l_errmsg)
        LET l_str = cl_getmsg("aoo-302",g_lang),"\n[out log]: ",l_outlog,"\n[err log]: ",l_errlog
        CALL cl_msgany(0,0,l_str)
        
        #COMMIT WORK    #FUN-A30104
    ELSE
        IF FGL_GETENV('FGLGUI') = '1' THEN
            LET l_str = "Connection failed:\n\n", 
                        "  [Code]: ", wserror.code, "\n",
                        "  [Action]: ", wserror.action, "\n",
                        "  [Description]: ", wserror.description
        ELSE
            LET l_str = "Connection failed: ", wserror.description
        END IF
        CALL cl_err(l_str, '!', 1)   #連接失敗        
    END IF
END FUNCTION

FUNCTION p_rscfg_log(p_filepath, p_str)
    DEFINE p_filepath   STRING
    DEFINE p_str        STRING
    DEFINE l_ch         base.Channel
    
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(p_filepath, "a")
    CALL l_ch.setDelimiter("")
    CALL l_ch.writeline(p_str)
    CALL l_ch.close()
END FUNCTION
#No:FUN-980098 --end--

#No:FUN-A10143 --start--
FUNCTION p_rscfg_imp()
    DEFINE l_zz     RECORD
           zz01     LIKE zz_file.zz01,
           zz011    LIKE zz_file.zz011
    END RECORD
    DEFINE l_modules    STRING

    INITIALIZE l_zz.* TO NULL
    
    OPEN WINDOW p_rscfg_imp_win AT 4, 16
        WITH FORM "azz/42f/p_rscfg_imp" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("p_rscfg_imp")
 
    MESSAGE ''
    
    #設定模組別下拉選單
    DECLARE p_zz011_cur CURSOR FOR
        SELECT gao01 FROM gao_file
        WHERE gao01 NOT IN ('SUB','CSUB','LIB','CLIB','QRY','CQRY')
        ORDER BY gao01
        
    #-----END TQC-760169-----
    LET l_modules = ""
    FOREACH p_zz011_cur INTO l_zz.zz011
        IF cl_null(l_modules) THEN
            LET l_modules = l_zz.zz011
        ELSE
            LET l_modules = l_modules CLIPPED,",",l_zz.zz011 CLIPPED
        END IF
    END FOREACH
 
    # MOD-4B0130 加上 "MENU"
    LET l_modules = l_modules CLIPPED,",MENU"

    CALL cl_set_combo_items("zz011",l_modules,l_modules)
 
    INPUT BY NAME l_zz.zz01, l_zz.zz011 WITHOUT DEFAULTS
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF           # 使用者不玩了
            CALL p_rscfg_imp_single(l_zz.zz01, l_zz.zz011)
            
        ON ACTION controlp
            CASE
                WHEN INFIELD(zz01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz"
                   LET g_qryparam.default1= l_zz.zz01
                   LET g_qryparam.arg1= g_lang
                   CALL cl_create_qry() RETURNING l_zz.zz01
                   DISPLAY l_zz.zz01 TO zz01
                   NEXT FIELD zz01
            END CASE
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
        
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG = 0 END IF
    CLOSE WINDOW p_rscfg_imp_win
END FUNCTION

#No:FUN-A10143 --start--
FUNCTION p_rscfg_imp_single(p_prog,p_module)
    DEFINE p_prog           LIKE zz_file.zz01
    DEFINE p_module         LIKE zz_file.zz011
    DEFINE l_gdh            RECORD LIKE gdh_file.*  #CR+WEBI報表資料檔
    DEFINE l_status         LIKE type_file.num10    #WS status
    DEFINE l_result         STRING                  #WS response string
    DEFINE l_str            STRING
    DEFINE l_type           STRING
    DEFINE l_name           STRING
    DEFINE l_cnt            LIKE type_file.num10
    DEFINE l_cnt2           LIKE type_file.num10
    DEFINE l_cnt3           LIKE type_file.num10
    DEFINE l_i              LIKE type_file.num10
    DEFINE l_xmldoc         om.DomDocument
    DEFINE l_docroot        om.DomNode
    DEFINE n_category       om.DomNode
    DEFINE n_report         om.DomNode
    DEFINE n_parent         om.DomNode
    DEFINE nl_category      om.NodeList
    DEFINE nl_report        om.NodeList
    DEFINE l_zz08           LIKE zz_file.zz08
    DEFINE l_errmsg         STRING
    DEFINE l_module         STRING
    DEFINE l_mod_first      STRING
    DEFINE l_zz011          LIKE zz_file.zz011
    DEFINE l_prog_arr       DYNAMIC ARRAY OF LIKE zz_file.zz01  #NO:FUN-A10143
    DEFINE l_startPos       LIKE type_file.num10    #No:FUN-A70007
    DEFINE l_endPos         LIKE type_file.num10    #No:FUN-A70007
    
    CALL fgl_ws_setOption("http_invoketimeout", 60)         #若 60 秒內無回應則放棄
    #呼叫VpWebService取得Token
    LET BI2_VpWebServiceImplService_VpWebServiceImplPortLocation = g_gdg.gdg03  CLIPPED #FUN-840065 #指定 Soap server location
    CALL BI2_GetCatelogReportListByCms(g_gdg.gdg04, g_gdg.gdg05, g_gdg.gdg06) #連接 V-Point Express SOAP server #caiyao modified
        RETURNING l_status, l_result

    DISPLAY "l_status= ", l_status
    IF l_status = 0 THEN
        #DISPLAY l_result
        LET l_xmldoc = om.DomDocument.createFromString(l_result)
        LET l_docroot = l_xmldoc.getDocumentElement()
        
        IF l_docroot IS NULL THEN
            IF FGL_GETENV('FGLGUI') = '1' THEN
                LET l_str = "XML parser error:\n\n", l_str
            ELSE
                LET l_str = "XML parser error: ", l_str
            END IF
            LET l_str = l_str, l_result
            CALL cl_err(l_str,'!','1')
            RETURN
        END IF

        LET l_cnt = 0        
        LET l_str = "//Category[@name=\"",g_gdg.gdg07,"\"]"
        LET nl_category = l_docroot.selectByPath(l_str)
        LET n_category = nl_category.item(1)
        IF n_category IS NOT NULL THEN
            LET l_str = "//Report"   #No:FUN-A70007
            LET nl_report = n_category.selectByPath(l_str)
            LET l_cnt = nl_report.getLength()
        END IF
        IF cl_null(l_cnt) OR l_cnt = 0 THEN
            CALL cl_err('','azz-135',1)
            RETURN
        END IF
        
        #清除gdh_file
        DELETE FROM gdh_file WHERE gdh02 = p_prog
        
        BEGIN WORK
        FOR l_i = 1 to l_cnt
            LET n_report = nl_report.item(l_i)
            LET l_type = n_report.getAttribute("type")
            
            #取BOE報表的種類
            CASE l_type
                WHEN "Webi"
                    LET l_gdh.gdh01 = "wid"
                OTHERWISE                    
                    CONTINUE FOR
            END CASE
 
            #取模組名稱
            LET n_parent = n_report.getParent()
            LET n_parent = n_parent.getParent()
            LET l_module = n_parent.getAttribute("name") CLIPPED
            LET l_zz011 = l_module
            
            #將模組名稱轉大寫
            LET l_module = l_module.toUpperCase()
            
            #取報表名稱的程式代號
            LET l_name = n_report.getAttribute("name") CLIPPED
            #FUN-A10101 --start--
            LET l_gdh.gdh02 = l_name
            LET l_gdh.gdh07 = "0"
            #No:FUN-A10101 --end--
            LET l_prog_arr[l_i] = l_name    #No:FUN-A10143
            
            #設定行業別
            #No:FUN-A70007 --start--
            LET l_startPos = l_name.getIndexOf("_",1)
            IF l_startPos > 0 THEN
                LET l_endPos = l_name.getLength()
                LET l_gdh.gdh06 = l_name.subString(l_startPos + 1, l_endPos)
                LET l_gdh.gdh02 = l_name.subString(1, l_startPos - 1)
            ELSE
                LET l_gdh.gdh06 = "std"
            END IF 
            #No:FUN-A70007 --end--
            
            #設定客製否
            LET l_mod_first = l_module.getCharAt(1)
            CASE l_mod_first
               WHEN "C"
                  LET l_gdh.gdh05 = "Y"
               WHEN "A"
                  LET l_gdh.gdh05 = "N"
               WHEN "G"
                  LET l_gdh.gdh05 = "N"
            END CASE
            
            #取BOE上該物件的CUID
            LET l_gdh.gdh03 = n_report.getAttribute("cuid") CLIPPED
            
            #取BOE上該物件的路徑
            LET l_gdh.gdh04 = n_report.getAttribute("path") CLIPPED
            
            IF p_prog = l_gdh.gdh02 AND p_module = l_module THEN    #No:FUN-A70007 將比對的程式代號由l_name改l_gdh.gdh02 
                INSERT INTO gdh_file VALUES (l_gdh.*)

                # 未成功導入報表清單
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                    LET l_errmsg = cl_getmsg("azz1032",g_lang)
                    LET l_errmsg = cl_replace_err_msg(l_errmsg, p_prog)
                    ROLLBACK WORK
                    EXIT FOR
                ELSE
                    LET l_zz08 = "$FGLRUN $AZZi/p_report '",l_gdh.gdh02 CLIPPED,"' '",l_gdh.gdh01 CLIPPED,"' '",l_gdh.gdh05 CLIPPED,"' "
                    
                    #更新zz_file報表程式欄位
                    SELECT COUNT(*) INTO l_cnt2 FROM zz_file WHERE zz01 = l_gdh.gdh02
                    IF l_cnt2 <= 0 THEN
                        INSERT INTO zz_file (zz01, zz011, zz03, zz05, zz06,
                                             zz08, zz13, zz15, zz25, zz26,
                                             zz27, zz28, zz29, zz30, zzuser,
                                             zzgrup, zzmodu, zzdate)
                        VALUES (l_gdh.gdh02, l_zz011, "R", "N", "1",
                                l_zz08, "N", "N", "N", "N",
                                "sm1", "3", "1", 0, g_user,
                                g_grup, "", g_today)
                    ELSE
                        UPDATE zz_file SET zz08 = l_zz08, zz011 = l_zz011 WHERE zz01 = l_gdh.gdh02
                    END IF

                    IF SQLCA.sqlcode THEN
                        LET l_errmsg = cl_getmsg("azz1032",g_lang)
                        LET l_errmsg = cl_replace_err_msg(l_errmsg, p_prog)
                        ROLLBACK WORK
                        EXIT FOR
                    ELSE
                        #成功導入報表清單
                        LET l_str = cl_getmsg("azz1033",g_lang)
                        LET l_str = cl_replace_err_msg(l_str, p_prog)
                        LET l_errmsg = l_errmsg,"\n",l_str
                    END IF
                END IF
            END IF
        END FOR
        COMMIT WORK
        CALL cl_msgany(0,0,l_errmsg)
    ELSE
        IF FGL_GETENV('FGLGUI') = '1' THEN
            LET l_str = "Connection failed:\n\n", 
                        "  [Code]: ", wserror.code, "\n",
                        "  [Action]: ", wserror.action, "\n",
                        "  [Description]: ", wserror.description
        ELSE
            LET l_str = "Connection failed: ", wserror.description
        END IF
        CALL cl_err(l_str, '!', 1)   #連接失敗        
    END IF  
END FUNCTION
#No:FUN-A10143 --end--

#FUN-A30104 --start--
#從BOE路徑中取出模組名稱
FUNCTION p_rscfg_get_module(p_str)
    DEFINE p_str    STRING
    DEFINE l_strtok base.StringTokenizer
    DEFINE l_res    DYNAMIC ARRAY OF STRING
    DEFINE l_i      LIKE type_file.num5
    
    LET l_strtok = base.StringTokenizer.create(p_str, "/")
    LET l_i = 1
    WHILE l_strtok.hasmoretokens()
        LET l_res[l_i] = l_strtok.nexttoken()
        LET l_i = l_i + 1
    END WHILE
    RETURN l_res[l_i - 2]
END FUNCTION
#FUN-A30104 --end--
