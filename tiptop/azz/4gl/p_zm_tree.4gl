# Prog. Version..: '5.30.06-13.03.12(00001)'      #
#
# Pattern name...: p_zm_tree.4gl
# Descriptions...: 系統目錄資料建立作業 (TREE)
# Date & Author..: 2012/02/12 By ka0132
# Modify.........: No:FUN-C20117 2012/02/24 By ka0132

DATABASE ds
    
GLOBALS "../../config/top.global"

DEFINE l_ac         LIKE type_file.num10
DEFINE l_ac2        LIKE type_file.num10
DEFINE l_expand     LIKE type_file.num10
DEFINE l_zm         LIKE type_file.chr20
DEFINE g_rec_b      LIKE type_file.num10
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_zm01       LIKE type_file.chr20
DEFINE g_act        LIKE type_file.chr20
DEFINE g_forupd_sql STRING
DEFINE l_tmp        STRING

DEFINE m_tree DYNAMIC ARRAY OF RECORD
       name         LIKE type_file.chr100,
       description  LIKE type_file.chr100,
       pid          LIKE type_file.chr20,
       id           LIKE type_file.chr20,
       hasChildren  BOOLEAN,
       layer        LIKE type_file.num5,
       code         LIKE type_file.chr20,
       pcode        LIKE type_file.chr20
END RECORD

DEFINE m_tree_rt DYNAMIC ARRAY OF RECORD
       name         LIKE type_file.chr100,
       description  LIKE type_file.chr100,
       pid          LIKE type_file.chr20,
       id           LIKE type_file.chr20,
       hasChildren  BOOLEAN,
       layer        LIKE type_file.num5,
       code         LIKE type_file.chr20,
       pcode        LIKE type_file.chr20
END RECORD

DEFINE o_tree DYNAMIC ARRAY OF RECORD
       oname         LIKE type_file.chr100,
       odescription  LIKE type_file.chr100,
       opid          LIKE type_file.chr20,
       oid           LIKE type_file.chr20,
       ohasChildren  BOOLEAN,
       olayer        LIKE type_file.num5
END RECORD


DEFINE m_tree_t RECORD
       name          LIKE type_file.chr100,
       description   LIKE type_file.chr100,
       pid           LIKE type_file.chr20,
       id            LIKE type_file.chr20,
       hasChildren   BOOLEAN,
       layer         LIKE type_file.num5,
       code          LIKE type_file.chr20,
       pcode         LIKE type_file.chr20
END RECORD     
    
DEFINE m_tree_t2 RECORD
       name          LIKE type_file.chr100,
       description   LIKE type_file.chr100,
       pid           LIKE type_file.chr20,
       id            LIKE type_file.chr20,
       hasChildren   BOOLEAN,
       layer         LIKE type_file.num5,
       code          LIKE type_file.chr20,
       pcode         LIKE type_file.chr20
END RECORD  
         
DEFINE m_tree_upd RECORD
       name          LIKE type_file.chr100,
       description   LIKE type_file.chr100,
       pid           LIKE type_file.chr20,
       id            LIKE type_file.chr20,
       hasChildren   BOOLEAN,
       layer         LIKE type_file.num5,
       code          LIKE type_file.chr20,
       pcode         LIKE type_file.chr20
END RECORD      

MAIN
DEFINE l_windowid LIKE type_file.chr100

    #各項設定初始化
    #CALL ap_init("AZZ") 

    #從資料庫(gna_file)中搜尋出對應的SQL
    #CALL ap_lock_cursor("aoo","azb-01") RETURNING g_forupd_sql
    #DECLARE i010_cl CURSOR FROM g_forupd_sql
    
    #開啟畫面,指定各項參數, 並判斷該程式是否為背景執行
    #CALL ap_open_window("azz","p_zm_tree",g_win_style,'N') RETURNING l_windowid 
   
    OPTIONS                                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                                              #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
    
    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AZZ")) THEN
        EXIT PROGRAM
    END IF
    
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
    
    OPEN WINDOW p_zm_tree_w WITH FORM "azz/42f/p_zm_tree" ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    
    #畫面額外初始化設定
    CALL p_zm_tree_init()

    #進入選單 Menu
    CALL p_zm_tree_menu()
    
    CLOSE WINDOW p_zm_tree_w 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
    
    #畫面關閉
    #CALL ap_close_m_window(l_windowid)

END MAIN



FUNCTION p_zm_tree_init()

    #LET g_zm01 = g_argv[1]
    LET g_zm01 = ARG_VAL(1)
    IF cl_null(g_zm01) THEN 
        LET g_zm01='menu' 
    END IF

    LET g_forupd_sql = "SELECT zm01,zm03,zm04,'' FROM zm_file WHERE zm01=? ORDER BY zm03 FOR UPDATE NOWAIT"
    #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_zm_tree_cur CURSOR FROM g_forupd_sql 

    LET g_forupd_sql = "SELECT gaz03 FROM gaz_file WHERE gaz01= ? AND gaz02= ? AND gaz05='N'"
    PREPARE p_zm_tree_q_gaz03 FROM g_forupd_sql

    LET g_forupd_sql = "SELECT count(*) FROM zm_file WHERE zm01= ? "
    PREPARE p_zm_tree_q_zmcnt FROM g_forupd_sql
    
END FUNCTION 

FUNCTION p_zm_tree_menu()

    DEFINE l_id      LIKE type_file.num5
    DEFINE l_status  LIKE type_file.num5
    DEFINE l_dnd     ui.DragDrop
    DEFINE l_source  STRING
    DEFINE l_target  STRING
    DIALOG ATTRIBUTE(UNBUFFERED)

        #左區
        DISPLAY ARRAY o_tree TO s_zmo_tree.* ATTRIBUTE(COUNT=g_rec_b) 
            
            BEFORE ROW
                LET l_ac = ARR_CURR()
                
            #啟動拖拉時,標定左區為起始區
            ON DRAG_START(l_dnd)         
                LET l_source="LEFT"      
                LET l_ac = ARR_CURR()
            
            #進入左區時,標定左區為目的區
            ON DRAG_ENTER(l_dnd)            
                LET l_target = "LEFT"    
            
            #在左區的TABLE上移動時進行判定
            ON DRAG_OVER(l_dnd)        
                IF l_source == "LEFT" THEN
                    CALL l_dnd.setOperation(NULL)
                ELSE
                    #標註拖拉功能的處理方法,NULL(不做),move(搬移),copy(複製)
                    CALL l_dnd.setOperation("move")  
                    #標註拖過來時,本區畫面對應方法-insert(兩行之間),select(選定行反藍),all(兩者都要)
                    CALL l_dnd.setFeedback("select") 
                END IF

            #拖動完成target區的處理 (拖入本區的處理) 也就是 右 -> 左 的處理
            ON DROP(l_dnd)
                IF l_source == "RIGHT" AND l_ac > 0 THEN
                    CALL p_zm_delnode(l_ac)                        
                    LET l_ac = 0
                END IF
                
        END DISPLAY

        #右區
        DISPLAY ARRAY m_tree TO s_zm_tree.* ATTRIBUTE(COUNT=g_rec_b)     #右邊tree
            
            BEFORE ROW
                LET l_ac = ARR_CURR()
            
            AFTER ROW
                CALL p_zm_confirmhasc()
                
            #啟動拖拉時,標定右區為起始區
            ON DRAG_START(l_dnd)         
                LET l_source="RIGHT"     
                LET l_ac = ARR_CURR()
            
            #進入右區時,標定右區為目的區
            ON DRAG_ENTER(l_dnd)    
                LET l_target = "RIGHT"
            
            #於右區拖拉時進行資料位置變更
            ON DRAG_FINISHED (l_dnd)
                IF l_target = "RIGHT" AND l_ac <> l_dnd.getLocationRow() THEN
                    CALL p_zm_move(l_ac,l_dnd.getLocationRow()) 
                END IF
                
             #在右區的TABLE上移動時進行判定
            ON DRAG_OVER(l_dnd)          
                IF l_source == "RIGHT" THEN
                    #標註拖拉功能的處理方法,NULL(不做),move(搬移),copy(複製)
                    CALL l_dnd.setFeedback("insert") 
                ELSE
                    #標註拖拉功能的處理方法,NULL(不做),move(搬移),copy(複製)
                    CALL l_dnd.setOperation("move")        
                    #標註拖過來時,本區畫面對應方法-insert(兩行之間),select(選定行反藍),all(兩者都要)                                                 
                    CALL l_dnd.setFeedback("select")                                        
                END IF

            #拖動完成target區的處理 (拖入本區的處理) 也就是 左 -> 右 的處理
            ON DROP(l_dnd)              
                IF l_source == "LEFT" THEN
                CALL p_zm_addnode(l_dnd.getLocationRow(),o_tree[l_ac].oname)
                END IF

            ON EXPAND(l_id)
                CALL p_zm_tree_collapse(l_id)
                CALL p_zm_tree_expand(l_id ,g_zm01)

            ON COLLAPSE(l_id)
                CALL p_zm_tree_collapse(l_id)
                
            #ON ACTION insert
            #    CALL p_zm_addnode(l_ac,'')
                
            ON ACTION delete
                CALL p_zm_delnode(l_ac)
               
             
        END DISPLAY

        BEFORE DIALOG
            BEGIN WORK
            LET g_act = FALSE
            CALL cl_set_action_active("commit,rollback",FALSE)
            CALL p_zm_tree_expand(0,g_zm01)
            CALL cl_set_comp_visible("accept,cancel",FALSE)
            
        ON ACTION query_zz 
            CALL cl_set_comp_visible("accept,cancel",TRUE)
            CALL p_zm_tree_csz() RETURNING l_status
            CALL cl_set_comp_visible("accept,cancel",FALSE)

        ON ACTION query_zm
            CALL cl_set_comp_visible("accept,cancel",TRUE)
            CALL p_zm_tree_csm() RETURNING l_status
            IF l_status = 1 THEN
                CALL m_tree.clear()
                CALL p_zm_tree_expand(0,g_zm01)
            ELSE
            END IF
            CALL cl_set_comp_visible("accept,cancel",FALSE)
                
                
        ON ACTION EXIT
            IF p_zm_exit() THEN
                EXIT DIALOG
            END IF                                         
                    
        ON ACTION CLOSE                                         
            IF p_zm_exit() THEN
                EXIT DIALOG
            END IF

        ON ACTION commit
            CALL p_zm_commit()    
            
        ON ACTION rollback
            CALL p_zm_rollback()

        ON IDLE g_idle_seconds          
            CALL cl_on_idle() 
            CONTINUE DIALOG 

    END DIALOG

END FUNCTION

PRIVATE FUNCTION p_zm_tree_csm()
DEFINE l_zm01 LIKE zm_file.zm01

    INPUT l_zm01 FROM zm01

        ON ACTION controlp
            CASE
                WHEN INFIELD(zm01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_zm"
                    LET g_qryparam.arg1 = g_lang CLIPPED
                    CALL cl_create_qry() RETURNING l_zm01
                    DISPLAY l_zm01 TO zm01
                    NEXT FIELD zm01
            END CASE

        ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT

        ON ACTION about           
            CALL cl_about()       

        ON ACTION controlg       
            CALL cl_cmdask()      

        ON ACTION help            
            CALL cl_show_help()  
    END INPUT

    IF INT_FLAG THEN
        LET INT_FLAG = FALSE
        RETURN 0
    END IF

    LET g_zm01 = l_zm01
    RETURN 1
END FUNCTION

PRIVATE FUNCTION p_zm_tree_csz()

DEFINE l_wc      LIKE type_file.chr200
DEFINE l_sql     LIKE type_file.chr500
DEFINE l_zz01    LIKE zz_file.zz01
DEFINE l_gaz03   LIKE gaz_file.gaz03

    
    CONSTRUCT BY NAME l_wc ON zz01 

        ON ACTION controlp
            CASE
                WHEN INFIELD(zz01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gaz"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = g_lang CLIPPED
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO zz01
                    NEXT FIELD zz01
            END CASE

        ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT

        ON ACTION about           
            CALL cl_about()        

        ON ACTION controlg      
            CALL cl_cmdask()     

        ON ACTION help             
            CALL cl_show_help()  
    END CONSTRUCT

    IF INT_FLAG THEN
        LET INT_FLAG = FALSE
        RETURN 0
    END IF

    LET l_sql = "SELECT zz01 FROM zz_file WHERE ",l_wc CLIPPED, " ORDER BY zz01"
    PREPARE p_zm_tree_q_pre FROM l_sql
    DECLARE p_zm_tree_q_cur CURSOR FOR p_zm_tree_q_pre

    INITIALIZE o_tree TO NULL
    LET g_cnt = 1
    FOREACH p_zm_tree_q_cur INTO l_zz01

        LET o_tree[g_cnt].oname = l_zz01
        LET o_tree[g_cnt].olayer = 0

        EXECUTE p_zm_tree_q_gaz03 USING l_zz01,g_lang INTO l_gaz03
        LET o_tree[g_cnt].odescription = l_gaz03
        IF SQLCA.sqlcode THEN
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
        END IF
    END FOREACH
    CALL o_tree.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1

    RETURN "1"

END FUNCTION

PRIVATE FUNCTION p_zm_tree_expand(p_ac,p_zm01)
DEFINE l_pid    LIKE type_file.chr20
DEFINE l_node   STRING
DEFINE p_ac     LIKE type_file.num10
DEFINE l_idx    LIKE type_file.num10
DEFINE p_zm01   LIKE zm_file.zm01
DEFINE l_zm     RECORD LIKE zm_file.*
DEFINE l_gaz03  LIKE gaz_file.gaz03
DEFINE l_cnt    LIKE type_file.num10

    IF p_ac = 0 THEN
        LET l_pid = 0
        LET l_zm.zm01 = p_zm01
    ELSE
        LET l_pid = m_tree[p_ac].id
        LET l_node = m_tree[p_ac].name
        LET l_zm.zm01 = l_node.subString(l_node.getIndexOf("(",1)+1, l_node.getLength() -1)
    END IF
        
    LET l_idx = 0 
    LET g_errno = 0
        
    #確定該筆資料沒有被鎖定
    OPEN p_zm_tree_cur USING l_zm.zm01
    IF status <> 0 THEN
        CALL cl_err(l_zm.zm01,"azz-941",1)     
        RETURN 
    END IF 
        
    FOREACH p_zm_tree_cur USING l_zm.zm01 INTO l_zm.zm01, l_zm.zm03,l_zm.zm04,l_gaz03
        EXECUTE p_zm_tree_q_gaz03 USING l_zm.zm04,g_lang INTO l_gaz03
        LET p_ac = p_ac + 1
        LET l_idx = l_idx + 1
        CALL m_tree.insertElement(p_ac)
            
        #當序號有誤時更新DB序號
        IF l_idx <> l_zm.zm03 THEN
            UPDATE zm_file SET zm03 = l_idx WHERE zm01 = l_zm.zm01 AND zm04 = l_zm.zm04
            IF SQLCA.sqlcode THEN
                LET g_errno = SQLCA.sqlcode
            END IF
        END IF
            
        LET m_tree[p_ac].id = l_pid || "." || l_idx
        LET m_tree[p_ac].pid = l_pid
        LET m_tree[p_ac].name = l_gaz03 CLIPPED," (",l_zm.zm04 CLIPPED,")"
        LET m_tree[p_ac].code = l_zm.zm04
        LET m_tree[p_ac].pcode = l_zm.zm01
        LET m_tree[p_ac].hasChildren = p_zm_hasc(p_ac)
        
        EXECUTE p_zm_tree_q_zmcnt USING l_zm.zm01 INTO m_tree[p_ac].layer
        IF m_tree[p_ac].layer > 1 THEN
            LET m_tree[p_ac].layer = 1
        END IF

        IF p_ac = 0 THEN
            EXECUTE p_zm_tree_q_gaz03 USING l_zm.zm04,g_lang INTO l_gaz03
            LET m_tree[p_ac].description = l_gaz03
        ELSE
            LET m_tree[p_ac].description = l_gaz03
            END IF
    END FOREACH

    #UPD過程中有錯誤則ROLLBACK
    IF g_errno <> 0 THEN
        CALL cl_err(g_errno,g_errno,1)
        CALL p_zm_whenerr()
    END IF
        
END FUNCTION

FUNCTION p_zm_getID(p_num,p_type)
DEFINE p_num    STRING 
DEFINE p_type   LIKE type_file.chr1
DEFINE l_tok    base.StringTokenizer
DEFINE l_tok_t  STRING  
DEFINE l_code   LIKE type_file.num10
DEFINE l_output STRING 

    LET l_tok = base.StringTokenizer.create(p_num,".")
    LET l_output = l_tok.nextToken()
    IF l_tok.hasMoreTokens() = FALSE THEN
        LET l_tok_t = l_output
        IF p_type = 'a' THEN
            LET l_code = l_tok_t+1
        ELSE
            LET l_code = l_tok_t-1
        END IF
          LET l_output = l_code
    END IF
    WHILE l_tok.hasMoreTokens() 
        LET l_tok_t = l_tok.nextToken()
        IF l_tok.hasMoreTokens() THEN
            LET l_output = l_output,".",l_tok_t
        ELSE 
            IF p_type = 'a' THEN
                LET l_code = l_tok_t+1
            ELSE
                LET l_code = l_tok_t-1
            END IF
                LET l_tok_t = l_code
                LET l_output = l_output,".",l_tok_t
          END IF  
    END WHILE 

    RETURN l_output.trim()
	 
END FUNCTION 

FUNCTION p_zm_tree_collapse(p_ac)
DEFINE p_ac             LIKE type_file.num20  
DEFINE l_cnt1,l_cnt2    LIKE type_file.num10 
DEFINE l_close          DYNAMIC ARRAY OF LIKE type_file.num20 
 
    #定位要關閉的節點
    LET l_close[1] = p_ac
    
    #尋找要關閉的節點及所有子節點
    FOR l_cnt1 = p_ac TO m_tree.getLength()
        FOR l_cnt2 = 1 TO l_close.getLength()
            IF m_tree[l_cnt1].pid = m_tree[l_close[l_cnt2]].id THEN 
                CALL l_close.appendElement()
                LET l_close[l_close.getLength()] = l_cnt1
            END IF 
        END FOR 
    END FOR 
    
    #移除在Tree中該節點的所有子節點
    FOR l_cnt2 = 2 TO l_close.getLength()
        CALL m_tree.deleteElement(l_close[1]+1)
    END FOR 
    
END FUNCTION  

FUNCTION p_zm_addnode(p_ac,p_name)
DEFINE p_ac   LIKE type_file.num20
DEFINE p_name LIKE type_file.chr20
DEFINE l_ac   LIKE type_file.num20
DEFINE l_zm04 LIKE type_file.chr100
DEFINE l_des  LIKE type_file.chr100
DEFINE l_cnt  LIKE type_file.num20

    #資料先行備份
    LET m_tree_rt.* = m_tree.*
    LET g_errno = 0

    #定義該節點代碼
    #IF cl_null(p_name) THEN
    #    PROMPT "Please enter the name:" FOR p_name
    #END IF
    IF cl_null(p_name) THEN
        CALL cl_err("azz-931","azz-931",1)
        RETURN
    END IF

    #確定直系枝幹上沒有重複定義
    IF p_zm_isDup(m_tree[p_ac].code,p_name) THEN
        CALL cl_err("azz-932","azz-932",1)
        RETURN
    END IF
    
    #確定目的目錄底下沒有重複資料
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM zm_file WHERE zm01 = m_tree[p_ac].code AND zm04 = p_name
    IF l_cnt > 0 THEN
        CALL cl_err("azz-932","azz-932",1)
        RETURN
    END IF
    
    #刷新資料
    CALL p_zm_tree_collapse(p_ac)
    CALL p_zm_tree_expand(p_ac,g_zm01)

    #判定插入點為目錄
    LET l_tmp = m_tree[p_ac].code 
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM zm_file WHERE zm01 = m_tree[p_ac].code 
    CASE
        WHEN l_tmp.substring(1,1) MATCHES '[emn]'
        WHEN l_tmp.getLength() >= 3 AND l_tmp.substring(1,3) = 'sop'
        WHEN l_cnt > 0
        OTHERWISE
            CALL cl_err("azz-933","azz-933",1)
            RETURN
    END CASE
    
    #判定插入位置
    LET l_ac = p_ac + 1
    WHILE l_ac <= m_tree.getLength()
        IF m_tree[l_ac].pid <> m_tree[p_ac].id THEN
            EXIT WHILE
        END IF
        LET l_ac = l_ac + 1
    END WHILE
    CALL m_tree.insertElement(l_ac)
    
    #賦予新插入類別屬性
    IF l_ac = (p_ac+1) THEN 
        #前一筆為上層
        LET m_tree[l_ac].pid = m_tree[p_ac].id
        LET m_tree[l_ac].pcode = m_tree[p_ac].code
        LET m_tree[l_ac].id = m_tree[p_ac].id,".1"            
        LET m_tree[l_ac].layer = m_tree[p_ac].layer
    ELSE
        #前一筆為同層
        LET m_tree[l_ac].* = m_tree[l_ac-1].*         
        LET m_tree[l_ac].id = p_zm_getID(m_tree[l_ac-1].id,'a')
    ENd IF    
    
    #確定該筆資料底下是否有其他資料
    LET m_tree[l_ac].hasChildren = p_zm_hasc(l_ac)
    
    #取得name資訊
    LET m_tree[l_ac].name = p_name
    
    #取得對應的描述
    LET g_errno = 0 
    LET l_zm04 = m_tree[l_ac].name
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM gaz_file WHERE gaz01=l_zm04 AND gaz02=g_lang AND gaz05='N'
    IF l_cnt > 0 THEN
        #被新增的節點已存在於gaz_file中
        SELECT gaz03 INTO l_des FROM gaz_file WHERE gaz01=l_zm04 AND gaz02=g_lang AND gaz05='N'
    ELSE
        CALL cl_err("azz-934","azz-934",1)
        #被新增的節點不存在於gaz_file中, 需新增
        #PROMPT "Please enter the description:" FOR l_des
        #INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05,gaz06,gazuser,gazdate) 
        #            VALUES (l_zm04,g_lang,l_des,'N',l_des,g_user,g_today)
    END IF
    
    LET m_tree[l_ac].description = l_des
    LET m_tree[l_ac].code = m_tree[l_ac].name
    LET m_tree[l_ac].name = m_tree[l_ac].description, "(", m_tree[l_ac].name, ")"
    CALL p_zm_sql(l_ac,"ins") 
    
    #若處理過程中出現錯誤則還原資料
    IF g_errno <> 0 THEN
        CALL cl_err(g_errno,g_errno,1)
        CALL p_zm_whenerr()
        RETURN
    END IF    
    LET g_act = TRUE
    CALL cl_set_action_active("commit,rollback",TRUE)
END FUNCTION 

FUNCTION p_zm_sql(p_ac,p_type)
DEFINE p_ac    LIKE type_file.num10 
DEFINE p_type  LIKE type_file.chr20
DEFINE l_zm    RECORD LIKE zm_file.*
DEFINE l_cnt   LIKE type_file.num10
DEFINE l_tmp   LIKE type_file.chr20

    #取得父節點的名稱
    LET l_zm.zm01 = m_tree[p_ac].pcode
    
    #取得本節點的名稱
    LET l_zm.zm04 = m_tree[p_ac].code
    
    #取得本節點的序號
    LET l_tmp = m_tree[p_ac].pid,"."
    LET l_zm.zm03 = cl_replace_str(m_tree[p_ac].id,l_tmp,'')
    
    CASE p_type
        #新增一筆資料
        WHEN "ins"
            #取得序號
            IF cl_null(l_zm.zm03) THEN
                LET l_zm.zm03 = 1
            END IF

            INSERT INTO zm_file (zm01, zm03, zm04) VALUES (l_zm.zm01, l_zm.zm03, l_zm.zm04)
            
        #移動時更新資料(zm_file)
        WHEN "upd_m"
            LET l_tmp = m_tree[p_ac].pid,"."
            #取得序號
            LET l_zm.zm03 = cl_replace_str(m_tree[p_ac].id,l_tmp,"")
            
            UPDATE zm_file SET zm01 = l_zm.zm01, zm03 = l_zm.zm03, zm04 = l_zm.zm04 WHERE zm01 = l_zm.zm01 AND zm03 = l_zm.zm03

        #刪除時更新資料(zm_file)
        WHEN "upd_d"
            LET l_tmp = m_tree[p_ac].pid,"."
            #取得序號
            LET l_zm.zm03 = cl_replace_str(m_tree[p_ac].id,l_tmp,"")
            UPDATE zm_file SET zm01 = l_zm.zm01, zm03 = l_zm.zm03, zm04 = l_zm.zm04 WHERE zm01 = l_zm.zm01 AND zm04 = l_zm.zm04
        
        #修改資料(gaz_file)
        WHEN "upd_gaz"
            UPDATE gaz_file SET gaz01 = m_tree[p_ac].code, gaz03 = m_tree[p_ac].description, gaz06 = m_tree[p_ac].description
                   WHERE gaz01 = m_tree_rt[p_ac].code AND gaz02 = g_lang AND gaz03 = m_tree_rt[p_ac].description AND gaz05 = 'N'
        
    END CASE
    
    IF SQLCA.sqlcode THEN
        LET g_errno = SQLCA.sqlcode
    END IF
    
END FUNCTION 

FUNCTION p_zm_move(p_ac,p_ac2) 
DEFINE p_ac,p_ac2 LIKE type_file.num10 #p_ac出發地,p_ac2目的地
DEFINE l_ac,l_ac2 LIKE type_file.num10 #定位用
DEFINE l_idx      LIKE type_file.num10
DEFINE l_cnt      LIKE type_file.num10
DEFINE l_zm03     LIKE type_file.num10
    
    #資料先行備份
    LET m_tree_rt.* = m_tree.*
    LET g_errno = 0
    
    #將p_ac資料由原位移動到p_ac2的位置
    IF p_ac = 0 OR p_ac2 = 0 OR p_ac = p_ac2 THEN
        LET m_tree.* = m_tree_rt.*
        CALL cl_err("azz-935","azz-935",1)
        RETURN
    END IF
    
    #確定直系枝幹上沒有重複定義
    IF p_zm_isDup(m_tree[p_ac2].code,m_tree[p_ac].code) THEN
        LET m_tree.* = m_tree_rt.*
        CALL cl_err("azz-932","azz-932",1)
        RETURN
    END IF
    
    #確定目的目錄底下沒有重複資料(前提是不同目錄間的移動)
    SELECT COUNT(*) INTO l_cnt FROM zm_file WHERE zm01 = m_tree[p_ac2].pcode AND zm04 = m_tree[p_ac].code
    IF l_cnt > 0 AND m_tree[p_ac].pcode <> m_tree[p_ac2].pcode THEN
        LET m_tree.* = m_tree_rt.*
        CALL cl_err("azz-932","azz-932",1)
        RETURN
    END IF
    
    #備份資料
    LET m_tree_t.* = m_tree[p_ac].*
    LET m_tree_t2.* = m_tree[p_ac2].*
    
    #關閉即將移動的資料
    IF m_tree[p_ac].id = m_tree[p_ac+1].pid THEN
        CALL p_zm_tree_collapse(p_ac)  #p_ac先行關閉
    END IF
    IF m_tree[p_ac2].id = m_tree[p_ac2+1].pid THEN
        CALL p_zm_tree_collapse(p_ac2) #p_ac2先行關閉
    END IF
    
    #重新定位
    LET p_ac = 0
    LET p_ac2 = 0
    FOR l_idx = 1 TO m_tree.getLength()
        CASE m_tree[l_idx].id
            WHEN m_tree_t.id
                LET p_ac = l_idx
            WHEN m_tree_t2.id
                LET p_ac2 = l_idx
        END CASE
    END FOR
    
    #確保移動的起始地與目的地正確
    IF p_ac = 0 OR p_ac2 = 0 THEN
        LET m_tree.* = m_tree_rt.*
        CALL cl_err("azz-935","azz-935",1)
        RETURN
    END IF
    
    #複製p_ac資料到p_ac2位置
    LET m_tree_upd.* = m_tree[p_ac].*
    LET m_tree[p_ac2].name = m_tree[p_ac].name
    LET m_tree[p_ac2].code = m_tree[p_ac].code
    LET m_tree[p_ac2].description = m_tree[p_ac].description
    LET m_tree[p_ac2].hasChildren = p_zm_hasc(p_ac2)
    
    #刪除p_ac的資料
    CALL m_tree.deleteElement(p_ac)
    IF p_ac < p_ac2 THEN
        LET p_ac2 = p_ac2-1
    ELSE
        LET p_ac = p_ac+1
    END IF
    
    #還原原本p_ac2的資料
    CALL m_tree.insertElement(p_ac2+1)
    LET m_tree[p_ac2+1].* = m_tree_t2.*

    #p_ac後的資料序號往前一格(同parent)
    LET l_ac = p_ac
    WHILE l_ac <= m_tree.getLength()
        IF m_tree[l_ac].pid = m_tree_t.pid THEN
            LET l_tmp = m_tree[l_ac].id
            LET m_tree[l_ac].id = p_zm_getID(m_tree[l_ac].id,'d')
            CALL p_zm_confirm(l_tmp,m_tree[l_ac].id,l_ac)
        END IF
        LET l_ac = l_ac+1
    END WHILE
    
    #p_ac2後的資料序號往後一格(同parent)
    LET l_ac2 = p_ac2+1
    WHILE l_ac2 <= m_tree.getLength()
        IF m_tree[l_ac2].pid = m_tree_t2.pid  THEN
            LET l_tmp = m_tree[l_ac2].id
            LET m_tree[l_ac2].id = p_zm_getID(m_tree[l_ac2].id,'a')
            CALL p_zm_confirm(l_tmp,m_tree[l_ac2].id,l_ac2)
        END IF
        LET l_ac2 = l_ac2+1
    END WHILE
    
    #進行資料更新動作(DB)
    IF m_tree_t.pcode = m_tree_t2.pcode THEN
        #同目錄下移動
        FOR l_cnt = 1 TO m_tree.getLength()
            IF m_tree[l_cnt].pcode = m_tree_t.pcode THEN
                CALL p_zm_sql(l_cnt,'upd_m')
            END IF
        END FOR 
    ELSE
        #不同目錄下移動(p_ac的目錄會少一筆資料)
        SELECT MAX(zm03) INTO l_zm03 FROM zm_file WHERE zm01 = m_tree_t.pcode
        DELETE FROM zm_file WHERE zm03 = l_zm03 AND zm01 = m_tree_t.pcode 
        IF SQLCA.sqlcode THEN
            LET g_errno = SQLCA.sqlcode
        END IF
        FOR l_cnt = 1 TO m_tree.getLength()
            IF m_tree[l_cnt].pcode = m_tree_t.pcode THEN
                CALL p_zm_sql(l_cnt,'upd_m')
            END IF
        END FOR 
        
        #不同目錄下移動(p_ac2的目錄會多一筆資料)
        SELECT MAX(zm03) INTO l_zm03 FROM zm_file WHERE zm01 = m_tree_t2.pcode
        LET l_zm03 = l_zm03+1
        INSERT INTO zm_file (zm01, zm03, zm04) VALUES (m_tree_t2.pcode, l_zm03, m_tree_t2.code)
        IF SQLCA.sqlcode THEN
            LET g_errno = SQLCA.sqlcode
        END IF
        FOR l_cnt = 1 TO m_tree.getLength()
            IF m_tree[l_cnt].pcode = m_tree_t2.pcode THEN
                CALL p_zm_sql(l_cnt,'upd_m')
            END IF
        END FOR         
    END IF
    
    #若處理過程中出現錯誤則還原資料
    IF g_errno <> 0 THEN
        CALL cl_err(g_errno,g_errno,1)
        CALL p_zm_whenerr()
    END IF
    
    CALL p_zm_clear() 
    LET g_act = TRUE
    CALL cl_set_action_active("commit,rollback",TRUE)
END FUNCTION 

FUNCTION p_zm_clear() 
DEFINE l_cnt LIKE type_file.num10

    FOR l_cnt = 1 TO m_tree.getLength()
        IF cl_null(m_tree[l_cnt].name) OR cl_null(m_tree[l_cnt].id) THEN
            CALL m_tree.deleteElement(l_cnt)
        END IF
    END FOR
END FUNCTION 

FUNCTION p_zm_confirm(p_old,p_new,p_ac)
DEFINE p_old,p_new   LIKE type_file.chr20
DEFINE p_ac          LIKE type_file.num10 
DEFINE l_cnt         LIKE type_file.num10
DEFINE l_tmp1,l_tmp2 LIKE type_file.chr20

    #編號異動時進行連帶更新其他資料編號
    LET l_tmp1 = p_old,"."
    LET l_tmp2 = p_new,"."
    FOR l_cnt = p_ac TO m_tree.getLength()
        LET m_tree[l_cnt].id = cl_replace_str(m_tree[l_cnt].id,l_tmp1,l_tmp2)
        LET m_tree[l_cnt].pid = cl_replace_str(m_tree[l_cnt].pid,p_old,p_new)
        LET m_tree_t.pid = cl_replace_str(m_tree_t.pid,p_old,p_new)
        LET m_tree_t2.pid = cl_replace_str(m_tree_t2.pid,p_old,p_new)
        LET m_tree_t.id = cl_replace_str(m_tree_t.id,l_tmp1,l_tmp2)
        LET m_tree_t2.id = cl_replace_str(m_tree_t2.id,l_tmp1,l_tmp2)
    END FOR
    
END FUNCTION

FUNCTION p_zm_delnode(p_ac)
DEFINE p_ac    LIKE type_file.num10
DEFINE l_zm    DYNAMIC ARRAY OF RECORD LIKE zm_file.*
DEFINE l_sql   LIKE type_file.chr500
DEFINE l_idx   LIKE type_file.num10
DEFINE l_idx2  LIKE type_file.num10
DEFINE l_cnt   LIKE type_file.num10
DEFINE l_cnt2  LIKE type_file.num10
DEFINE l_pcode LIKE type_file.chr100

    #步驟0 - 先確定是否刪除該筆資料,若是則關閉要砍除的節點及資料備份
    IF NOT cl_confirm("azz-937") THEN
        RETURN
    END IF
    
    LET m_tree_rt.* = m_tree.*
    LET g_errno = 0
    
    CALL p_zm_tree_collapse(p_ac)
    
    #步驟1 - 確定該節點是否為他人的主節點
    SELECT COUNT(*) INTO l_cnt FROM zx_file WHERE zx05 = m_tree[p_ac].code
    IF l_cnt = 1 THEN
        CALL cl_err("azz-936","azz-936",1)
        LET m_tree.* = m_tree_rt.*
        RETURN
    END IF
    
    #步驟2 - 若不為他人得主節點則判斷該節點是否只存在一個地方
    SELECT COUNT(*) INTO l_cnt FROM zm_file WHERE zm04 = m_tree[p_ac].code
    
    #取得該筆資料的父節點與本身節點代碼
    LET l_zm[1].zm01 = m_tree[p_ac].pcode
    LET l_zm[1].zm04 = m_tree[p_ac].code
    
    CASE l_cnt
        #步驟2-0 - 該節點不存在
        WHEN 0
            CALL cl_err("azz-934","azz-934",1)
            CALL p_zm_whenerr()
            RETURN
            
        #步驟2-1 - 若只存在於一個地方則移除該節點以下所有節點
        WHEN 1
            #搜尋被移除節點的所有子節點
            LET l_idx  = 2
            LET l_idx2 = 1
            LET l_sql = "SELECT * FROM zm_file WHERE zm01 = ? FOR UPDATE"
            DECLARE p_zm_del_cur CURSOR FROM l_sql
            
            WHILE l_idx2 <= l_zm.getLength()
                SELECT COUNT(*) INTO l_cnt2 FROM zm_file WHERE zm04 = l_zm[l_idx2].zm04
                #若該節點存在於不只一處則不對該節點底下子節點做處理
                IF l_cnt2 = 1 THEN
                    FOREACH p_zm_del_cur USING l_zm[l_idx2].zm04 INTO l_zm[l_idx].*
                        LET l_idx = l_idx + 1
                    END FOREACH
                END IF
                LET l_idx2 = l_idx2+1
            END WHILE
            
            #移除DB內的節點資料
            FOR l_idx = 1 TO l_zm.getLength()-1
                DELETE FROM zm_file WHERE zm01 = l_zm[l_idx].zm01 AND zm04 = l_zm[l_idx].zm04
                IF SQLCA.sqlcode THEN
                    CALL cl_err(SQLCA.sqlcode,SQLCA.sqlcode,1)
                    LET g_errno = SQLCA.sqlcode
                    CALL p_zm_whenerr()
                    RETURN
                END IF
            END FOR
            
        #步驟2-2 - 若不只存在於一個地方則只移除該節點
        OTHERWISE
            DELETE FROM zm_file WHERE zm01 = l_zm[1].zm01 AND zm04 = l_zm[1].zm04
            IF SQLCA.sqlcode THEN
                CALL cl_err(SQLCA.sqlcode,SQLCA.sqlcode,1)
                LET g_errno = SQLCA.sqlcode
                CALL p_zm_whenerr()
                RETURN
            END IF
    END CASE
    
    #步驟3 - 移除資料後須重新排序(含DB)
    LET l_pcode = m_tree[p_ac].pcode
    CALL m_tree.deleteElement(p_ac)
    FOR l_cnt = p_ac TO m_tree.getLength()
        IF m_tree[l_cnt].pcode = l_pcode THEN
            LET m_tree[l_cnt].id = p_zm_getID(m_tree[l_cnt].id,'d')
            CALL p_zm_sql(l_cnt,'upd_d')
        END IF
    END FOR
        
    #若處理過程中出現錯誤則還原資料
    IF g_errno <> 0 THEN
        CALL cl_err(SQLCA.sqlcode,SQLCA.sqlcode,1)
        CALL p_zm_whenerr()
    END IF
    LET g_act = TRUE
    CALL cl_set_action_active("commit,rollback",TRUE)
END FUNCTION 

FUNCTION p_zm_isDup(p_code1,p_code2) 
DEFINE p_code1  LIKE type_file.chr200 #被新增的節點
DEFINE p_code2  LIKE type_file.chr200 #新增的節點
DEFINE l_zm04   DYNAMIC ARRAY OF LIKE type_file.chr200
DEFINE l_idx    LIKE type_file.num20
DEFINE l_idx2   LIKE type_file.num20
DEFINE l_sql    LIKE type_file.chr200

    #把該節點的祖先抓出來比較是否有重複
    LET l_sql = "SELECT zm01 FROM zm_file WHERE zm04 = ?"
    DECLARE p_zm_confirm_cur CURSOR FROM l_sql
    LET l_zm04[1] = p_code1
    LET l_idx  = 1
    LET l_idx2 = 2
    WHILE l_idx <= l_zm04.getLength()
        FOREACH p_zm_confirm_cur USING l_zm04[l_idx] INTO l_zm04[l_idx2]
                IF l_zm04[l_idx2] = p_code2 THEN
                    RETURN TRUE
                END IF
                LET l_idx2 = l_idx2 + 1
        END FOREACH
        LET l_idx = l_idx+1
    END WHILE
    RETURN FALSE
END FUNCTION 

FUNCTION p_zm_hasc(p_ac)
DEFINE p_ac     LIKE type_file.num10
DEFINE l_cnt    LIKE type_file.num10

    LET l_cnt = 0
    
    #判定該節點是否有子節點
    SELECT COUNT(*) INTO l_cnt FROM zm_file WHERE zm01 = m_tree[p_ac].code
    IF l_cnt > 0 THEN
        RETURN TRUE
    ELSE
        RETURN FALSE
    END IF
    
END FUNCTION

FUNCTION p_zm_confirmhasc()
DEFINE l_ac     LIKE type_file.num10
DEFINE l_cnt    LIKE type_file.num10

    FOR l_ac = 1 TO m_tree.getLength()
        LET l_cnt = 1
        SELECT COUNT(*) INTO l_cnt FROM zm_file WHERE zm01 = m_tree[l_ac].code
        IF l_cnt > 0 THEN
            LET m_tree[l_ac].hasChildren = TRUE
        ELSE
            LET m_tree[l_ac].hasChildren = FALSE
        END IF
    END FOR
    
END FUNCTION

#FUN-C20117 - Start -
FUNCTION p_zm_commit()

    IF cl_confirm("azz-938") THEN
        COMMIT WORK
        BEGIN WORK
        LET g_act = FALSE
        CALL cl_set_action_active("commit,rollback",FALSE)
    END IF
    
END FUNCTION

FUNCTION p_zm_rollback()

    IF cl_confirm("azz-939") THEN
        CALL p_zm_whenerr()
    END IF
    
END FUNCTION

FUNCTION p_zm_exit()
DEFINE   l_msg          LIKE ze_file.ze03
DEFINE   l_msg2         LIKE ze_file.ze03
DEFINE   l_result       BOOLEAN       
DEFINE   l_title        LIKE ze_file.ze03           
 
	#確定使用者是否確定離開程式
    LET l_msg = "azz-940"
    
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF cl_null(g_lang) THEN
        LET g_lang = "0"
    END IF
 
    SELECT ze03 INTO l_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
    IF SQLCA.SQLCODE THEN
        LET l_title = "Confirm"
    END IF
 
    SELECT ze03 INTO l_msg2 FROM ze_file WHERE ze01 = l_msg AND ze02 = g_lang
    IF NOT SQLCA.SQLCODE THEN
        LET l_msg = l_msg2 
    END IF
  
    LET l_result = FALSE
    
    IF g_act = TRUE THEN
        MENU l_title ATTRIBUTE (STYLE="dialog", COMMENT=l_msg, IMAGE="question")
        
            #儲存變更
            ON ACTION sc
                LET l_result = TRUE
                COMMIT WORK
                EXIT MENU
            
            #放棄變更
            ON ACTION ac
                LET l_result = TRUE
                ROLLBACK WORK
                EXIT MENU
                
            #取消(不動作)
            ON ACTION ca
                LET l_result = FALSE
                EXIT MENU
                
            ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE MENU
        
        END MENU
    ELSE
        LET l_result = TRUE
    END IF
    
    IF (INT_FLAG) THEN
        LET INT_FLAG = FALSE
        LET l_result = FALSE
    END IF
    
    RETURN l_result
    
END FUNCTION

FUNCTION p_zm_whenerr()

    #當存取資料庫發生錯誤or使用者不欲儲存資料時
    ROLLBACK WORK
    BEGIN WORK
    INITIALIZE m_tree TO NULL
    CALL p_zm_tree_expand(0,g_zm01)
    LET g_act = FALSE
    CALL cl_set_action_active("commit,rollback",FALSE)
    
END FUNCTION
#FUN-C20117 -  End  -
