# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: p_grwp.4gl
# Descriptions...: 報表紙張維護作業
# Date & Author..: 11/02/09 By Kevin
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No.FUN-CC0099 12/12/25 By janet 修改紙張格式時，掃4rp且list，判斷是否更新且增加提示訊息
# Modify.........: No.FUN-D20005 13/02/19 By janet 報表紙張標準格式，不能刪除、修改
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


IMPORT os 
DATABASE ds
 
GLOBALS "../../config/top.global"


#No.FUN-B40095
DEFINE 
     g_gdo           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gdo01       LIKE gdo_file.gdo01,   #紙張格式代號
        gdo02       LIKE gdo_file.gdo02,   #紙張格式名稱
        gdo06       LIKE gdo_file.gdo06,   #紙張說明
        gdo03       LIKE gdo_file.gdo03,   #紙張寬度
        gdo04       LIKE gdo_file.gdo04,   #紙張高度
        gdo05       LIKE gdo_file.gdo05    #長度單位
                    END RECORD,
    g_gdo_t         RECORD                 #程式變數 (舊值)
        gdo01       LIKE gdo_file.gdo01,   #紙張格式代號
        gdo02       LIKE gdo_file.gdo02,   #紙張格式名稱
        gdo06       LIKE gdo_file.gdo06,   #紙張說明
        gdo03       LIKE gdo_file.gdo03,   #紙張寬度
        gdo04       LIKE gdo_file.gdo04,   #紙張高度
        gdo05       LIKE gdo_file.gdo05    #長度單位
                    END RECORD,
    g_wc2,g_sql     STRING,                           #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,              #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
    g_res           LIKE type_file.num5               #FUN-CC0099 add
    
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_forupd_gbo_sql     STRING                  #FOR UPDATE SQL   #FUN-920138
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680102 INTEGER
DEFINE g_before_input_done  LIKE type_file.num5     #FUN-570110   #No.FUN-680102 SMALLINT
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
#FUN-CC0099 add-(s)
DEFINE g_gdw   DYNAMIC ARRAY OF RECORD       
       gdw01   LIKE gdw_file.gdw01, # 程式代號       
       gaz03   LIKE gaz_file.gaz03, # 檔名
       gdw09   LIKE gdw_file.gdw09, # 樣板名稱
       path    VARCHAR(100)         # 路徑  
       END RECORD
DEFINE g_gdw_s   DYNAMIC ARRAY OF RECORD       
       gdw01   LIKE gdw_file.gdw01, # 程式代號       
       gaz03   LIKE gaz_file.gaz03, # 檔名
       gdw09   LIKE gdw_file.gdw09, # 樣板名稱
       path    VARCHAR(100)         # 路徑  
       END RECORD

#FUN-CC0099 add-(e)

 
MAIN
    OPTIONS                                #改變一些系統預設值
    INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081
 
    OPEN WINDOW p_grwp_w WITH FORM "azz/42f/p_grwp"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init() 
    
    LET g_wc2 = '1=1' CALL p_grwp_b_fill(g_wc2)
 
  CALL p_grwp_menu()
  CLOSE WINDOW p_grwp_w                 #結束畫面

  CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION p_grwp_menu()
 
   WHILE TRUE
      CALL p_grwp_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_grwp_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN               
               CALL p_grwp_b()
            ELSE
               LET g_action_choice = NULL
            END IF
           
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gdo),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_grwp_q()
   CALL p_grwp_b_askkey()
END FUNCTION
 
FUNCTION p_grwp_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                #No.FUN-680102 VARCHAR(01),              #可刪除否
    l_cnt           LIKE type_file.num10,               #No.FUN-680102 INTEGER #FUN-670032
    l_reccnt        LIKE type_file.num10,               #計算紙張寬度與高度相同的筆數
    l_i             LIKE type_file.num5,                 #FUN-CC0099
    l_all           LIKE type_file.num5                 #FUN-CC0099

    
    
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT gdo01,gdo02,gdo06,gdo03,gdo04,gdo05",
                       "  FROM gdo_file WHERE gdo01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE p_grwp_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR    
    
    INPUT ARRAY g_gdo WITHOUT DEFAULTS FROM s_gdo.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
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
           LET g_gdo_t.* = g_gdo[l_ac].*  #BACKUP

           LET g_before_input_done = FALSE                                      
           CALL p_grwp_set_entry(p_cmd)                                           
           CALL p_grwp_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       

           OPEN p_grwp_bcl USING g_gdo_t.gdo01
           IF STATUS THEN
              CALL cl_err("OPEN p_grwp_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH p_grwp_bcl INTO g_gdo[l_ac].* 
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gdo_t.gdo01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'

         LET g_before_input_done = FALSE                                        
         CALL p_grwp_set_entry(p_cmd)                                             
         CALL p_grwp_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         

         INITIALIZE g_gdo[l_ac].* TO NULL      #900423      
         LET g_gdo[l_ac].gdo05 = "C" 
         LET g_gdo_t.* = g_gdo[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gdo01
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE p_grwp_bcl           
           CANCEL INSERT
        END IF

         #FUN-D20005 add -(s)  #標準紙張不可刪除              
         IF g_gdo_t.gdo02="A4" OR g_gdo_t.gdo02="A3" OR g_gdo_t.gdo02="Letter" OR 
            g_gdo_t.gdo02="US Std Fanfold" OR g_gdo_t.gdo02="中一刀" THEN
            CALL cl_err('','azz1311',0)
            LET g_gdo[l_ac].gdo01=g_gdo_t.gdo01
            LET g_gdo[l_ac].gdo03=g_gdo_t.gdo03
            LET g_gdo[l_ac].gdo04=g_gdo_t.gdo04
            CANCEL INSERT
         END IF  
         #FUN-D20005 add -(e)
        
        #檢查紙張的寬度或高度是否有重複
        SELECT COUNT(*) INTO l_reccnt FROM gdo_file WHERE gdo03=g_gdo[l_ac].gdo03 
            AND gdo04=g_gdo[l_ac].gdo04 AND gdo05=g_gdo[l_ac].gdo05

        IF l_reccnt > 0 THEN
            CALL cl_err('','azz1076',0)
            CANCEL INSERT
            CONTINUE INPUT
        END IF
  
        BEGIN WORK                    #FUN-680011
 
        INSERT INTO gdo_file(gdo01,gdo02,gdo03,gdo04,gdo05,gdo06)
        VALUES(g_gdo[l_ac].gdo01,g_gdo[l_ac].gdo02,
               g_gdo[l_ac].gdo03,g_gdo[l_ac].gdo04,
               g_gdo[l_ac].gdo05,g_gdo[l_ac].gdo06)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gdo_file",g_gdo[l_ac].gdo01,"",SQLCA.sqlcode,"","",1) 
           ROLLBACK WORK 
           CANCEL INSERT
        END IF
        LET g_rec_b=g_rec_b+1                             
        DISPLAY g_rec_b TO FORMONLY.cn2            
        COMMIT WORK
        
    BEFORE FIELD gdo01                        
        IF g_gdo[l_ac].gdo01 IS NULL THEN
           SELECT max(gdo01)+1
             INTO l_cnt
             FROM gdo_file
             
           IF l_cnt IS NULL THEN
              LET g_gdo[l_ac].gdo01 = 1
           ELSE
              LET g_gdo[l_ac].gdo01 = l_cnt  
           END IF
        END IF
        
    AFTER FIELD gdo01                        #check 編號是否重複
        
        IF NOT cl_null(g_gdo[l_ac].gdo01) THEN
           IF g_gdo[l_ac].gdo01 != g_gdo_t.gdo01 OR g_gdo_t.gdo01 IS NULL THEN
              SELECT count(*) INTO g_cnt FROM gdo_file
               WHERE gdo01 = g_gdo[l_ac].gdo01
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_gdo[l_ac].gdo01 = g_gdo_t.gdo01
                 NEXT FIELD gdo01
              END IF
              
           END IF
        END IF
 
   AFTER FIELD gdo02                        #check 編號是否重複
        IF NOT cl_null(g_gdo[l_ac].gdo02) THEN
           #FUN-D20005 add -(s)  #標準紙張不可刪除              
           IF g_gdo_t.gdo02="A4" OR g_gdo_t.gdo02="A3" OR g_gdo_t.gdo02="Letter" OR 
              g_gdo_t.gdo02="US Std Fanfold" OR g_gdo_t.gdo02="中一刀" THEN
              CALL cl_err('','azz1311',0)
              LET g_gdo[l_ac].gdo01=g_gdo_t.gdo01
              NEXT FIELD gdo02
           END IF  
           #FUN-D20005 add -(e)
           IF g_gdo[l_ac].gdo02 != g_gdo_t.gdo02 OR g_gdo_t.gdo02 IS NULL THEN
              SELECT count(*) INTO g_cnt FROM gdo_file
               WHERE gdo02 = g_gdo[l_ac].gdo02
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_gdo[l_ac].gdo02 = g_gdo_t.gdo02
                 NEXT FIELD gdo02
              END IF
              
           END IF
        END IF
        
    BEFORE DELETE                            #是否取消單身    
        IF g_rec_b>=l_ac THEN
        
           IF g_cnt = 0 THEN 
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              #FUN-D20005 add -(s)  #標準紙張不可刪除              
              IF g_gdo_t.gdo02="A4" OR g_gdo_t.gdo02="A3" OR g_gdo_t.gdo02="Letter" OR 
                 g_gdo_t.gdo02="US Std Fanfold" OR g_gdo_t.gdo02="中一刀" THEN
                 CALL cl_err('','azz1311',0)
                 CANCEL DELETE 
              END IF  
              #FUN-D20005 add -(e)
              DELETE FROM gdo_file WHERE gdo01 = g_gdo_t.gdo01
              
              IF SQLCA.sqlcode THEN                
                 CALL cl_err3("del","gdo_file",g_gdo_t.gdo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 ROLLBACK WORK                                     
                 CANCEL DELETE
                 EXIT INPUT
              ELSE 
                 LET g_rec_b=g_rec_b-1              #MOD-950054 mark
                 DISPLAY g_rec_b TO FORMONLY.cn2    #MOD-950054 mark
                 COMMIT WORK 
              END IF
           END IF   
              
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_gdo[l_ac].* = g_gdo_t.*
           CLOSE p_grwp_bcl           
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_gdo[l_ac].gdo01,-263,0)
           LET g_gdo[l_ac].* = g_gdo_t.*
        ELSE
           #FUN-D20005 add -(s)  #標準紙張不可刪除、修改             
           IF g_gdo_t.gdo02="A4" OR g_gdo_t.gdo02="A3" OR g_gdo_t.gdo02="Letter" OR 
              g_gdo_t.gdo02="US Std Fanfold" OR g_gdo_t.gdo02="中一刀" THEN
              CALL cl_err('','azz1311',0)
              LET g_gdo[l_ac].* = g_gdo_t.*  #值要復原
              ROLLBACK WORK
              EXIT INPUT
           END IF  
           #FUN-D20005 add -(e)       
           IF cl_confirm("azz1299") THEN   #FUN-CC0099 add 是否掃瞄全系統4rp
               CALL p_grwp_tmp1()   #FUN-CC0099 add 建立暫存檔
               IF p_gr_chk_paper_size(g_gdo[l_ac].gdo02) = 0 THEN  #未找到有使用此紙張
                   UPDATE gdo_file 
                       #SET gdo01=g_gdo[l_ac].gdo01,gdo02=g_gdo[l_ac].gdo02, #FUN-CC0099 mark
                        SET gdo03=g_gdo[l_ac].gdo03,gdo05=g_gdo[l_ac].gdo05, #FUN-CC0099 add SET
                           gdo04=g_gdo[l_ac].gdo04,gdo06=g_gdo[l_ac].gdo06
                    WHERE gdo01 = g_gdo_t.gdo01
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","gdo_file",g_gdo[l_ac].gdo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                      LET g_gdo[l_ac].* = g_gdo_t.*
                      ROLLBACK WORK
                   ELSE              
                      COMMIT WORK
                   END IF
               ELSE #有找到使用此紙張格式
                  ##FUN-CC0099 add -(s)
                    CALL p_grwp_4rp_bfill(l_ac)  
                  ##FUN-CC0099 add -(e) 
                   #LET g_gdo[l_ac].* = g_gdo_t.* #FUN-CC0099 mark
                   #CALL cl_err('','azz1077',0)   #FUN-CC0099 mark
               END IF
           #FUN-CC0099 add -(s)
           ELSE 
              LET g_gdo[l_ac].* = g_gdo_t.*  #取消值要復原
           END IF   #cl_confirm("azz1299")
           #FUN-CC0099 add  -(e)
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()         # 新增
#       LET l_ac_t = l_ac             # 新增      #FUN-D30034 mark
 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_gdo[l_ac].* = g_gdo_t.*
           #FUN-D30034---add---str---
           ELSE
              CALL g_gdo.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30034---add---end---
           END IF
           CLOSE p_grwp_bcl         # 新增           
           ROLLBACK WORK          # 新增
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac             # 新增      #FUN-D30034 add
        CLOSE p_grwp_bcl            # 新增
        
        COMMIT WORK
 
     ON ACTION CONTROLO                        
         IF INFIELD(gdo01) AND l_ac > 1 THEN
             LET g_gdo[l_ac].* = g_gdo[l_ac-1].*
             NEXT FIELD gdo01
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
 
     
     END INPUT
 
 
    CLOSE p_grwp_bcl
    COMMIT WORK
END FUNCTION

#FUN-CC0099 add -(s)
FUNCTION p_grwp_tmp1()
DROP TABLE p_gr_tmp 

CREATE TEMP TABLE p_grwp_tmp1(
       gdw01   LIKE gdw_file.gdw01, # 程式代號       
       gaz03   LIKE gaz_file.gaz03, # 檔名
       gdw09   LIKE gdw_file.gdw09, # 樣板名稱
       path    VARCHAR(100))       # 路徑  
       
DELETE FROM p_grwp_tmp1
END FUNCTION 
       
FUNCTION p_grwp_4rp_editLW(p_gdo03,p_gdo04,p_gdo05)
 DEFINE p_gdo03      LIKE gdo_file.gdo03,
        p_gdo04      LIKE gdo_file.gdo04,
        p_gdo05      LIKE gdo_file.gdo05,
        l_j          LIKE type_file.num5,
        l_k          LIKE type_file.num5,
        l_doc        om.DomDocument,                     
        l_doc_root   om.DomNode, 
        l_curnode    om.DomNode,
        l_nodes      om.NodeList,
        l_tagname    STRING,
        l_width      STRING,
        l_length     STRING 

     IF p_gdo05="C" THEN 
       LET l_width=p_gdo03 || "cm"
       LET l_length=p_gdo04 || "cm"
     ELSE 
       LET l_width=p_gdo03 || "inch"
       LET l_length=p_gdo04 || "inch"     
     END IF 
     FOR l_j =1 TO g_gdw.getLength()
         IF g_gdw[l_j].path IS NOT NULL  THEN
            LET l_doc = om.DomDocument.createFromXmlFile(g_gdw[l_j].path)
            IF l_doc IS NOT NULL THEN
                LET l_doc_root = l_doc.getDocumentElement()
                IF l_doc_root IS NOT NULL THEN     
                   #抓取紙張大小
                   LET l_tagname = "report:Settings"                      
                   LET l_nodes = l_doc_root.selectByTagName(l_tagname) 
                   FOR l_k = 1 TO l_nodes.getLength()
                      LET l_curnode=l_nodes.item(l_k) 
                      CALL l_curnode.removeAttribute("RWPageWidth")
                      CALL l_curnode.setAttribute("RWPageWidth",l_width)  
                      CALL l_curnode.removeAttribute("RWPageLength")
                      CALL l_curnode.setAttribute("RWPageLength",l_length)                 
                   END FOR 
                END IF 
            END IF 
            IF os.Path.chrwx(g_gdw[l_j].path,511) THEN END IF 
            CALL l_doc_root.writeXml(g_gdw[l_j].path)  #更新xml
         END IF 
     END FOR 

END FUNCTION 

FUNCTION p_grwp_4rp_bfill(p_ac)
  DEFINE p_ac    LIKE type_file.num5
  DEFINE l_all,l_i   LIKE type_file.num5
  DEFINE l_sql       STRING 
  DEFINE l_cnt,l_max_rec       LIKE type_file.num5
  DEFINE l_gdw01     LIKE gdw_file.gdw01,
         l_gaz03     LIKE gaz_file.gaz03,
         l_gdw09     LIKE gdw_file.gdw09,
         l_cnt_s     LIKE type_file.num5,  #顯示在畫面的陣列筆數
         l_sure      LIKE type_file.chr1   #確認是否有按"是"更新4rp
  

    LET l_sql = "SELECT * FROM p_grwp_tmp1 ORDER BY gdw01,gdw09"
    PREPARE p_grwp_4rp_b FROM l_sql
    DECLARE tmp1_curs CURSOR FOR p_grwp_4rp_b

    SELECT count(*) INTO l_max_rec FROM p_grwp_temp1
 
    CALL g_gdw.clear()
    LET l_cnt = 1
    LET l_gdw01=' '
    LET l_gaz03=' '
    LET l_gdw09=' '
    LET l_cnt_s = 1 
    LET l_sure='N'
    
    FOREACH tmp1_curs INTO g_gdw[l_cnt].*  #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF    

        IF g_gdw[l_cnt].gdw01 <> l_gdw01 AND g_gdw[l_cnt].gaz03 <> l_gaz03 AND 
           g_gdw[l_cnt].gdw09 <> l_gdw09 THEN
           LET  g_gdw_s[l_cnt_s].gaz03=g_gdw[l_cnt].gaz03
           LET  g_gdw_s[l_cnt_s].gdw01=g_gdw[l_cnt].gdw01
           LET  g_gdw_s[l_cnt_s].gdw09=g_gdw[l_cnt].gdw09
           LET  l_cnt_s=l_cnt_s + 1
           LET  l_gaz03=g_gdw[l_cnt].gaz03
           LET  l_gdw01=g_gdw[l_cnt].gdw01
           LET  l_gdw09=g_gdw[l_cnt].gdw09           
        END IF 
      
        LET l_cnt =l_cnt + 1
        IF g_cnt > l_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gdw.deleteElement(l_cnt)
    CALL g_gdw_s.deleteElement(l_cnt_s)
    MESSAGE ""
    LET g_rec_b = l_cnt_s-1
    LET l_cnt = 0

     OPEN WINDOW p_grwp_4rp_w WITH FORM "azz/42f/p_grwp_4rp"
                          ATTRIBUTE(STYLE="azz")
     CALL cl_ui_locale("p_grwp_4rp")
     
     DISPLAY ARRAY g_gdw_s TO s_gdw.* ATTRIBUTE(COUNT=g_res)
       BEFORE ROW
           DISPLAY g_rec_b TO FORMONLY.cn3    
           
       ON ACTION exit                   # Esc.結束
          LET g_action_choice="exit"
          IF l_sure='N' THEN  #未按更新，就將畫面取消掉
             LET g_gdo[p_ac].* = g_gdo_t.* 
          END IF 
          EXIT DISPLAY
       ON ACTION accept
          LET g_action_choice = "detail"
          #LET l_ac = ARR_CURR()
          #DISPLAY "l_ac:",l_ac
                IF cl_confirm("azz1300") THEN #是否更新紙張尺寸及套用至報表?
                    #修改紙張內容
                    LET l_sure='Y'
                    UPDATE gdo_file 
                       
                        SET gdo03=g_gdo[p_ac].gdo03,gdo05=g_gdo[p_ac].gdo05, 
                            gdo04=g_gdo[p_ac].gdo04,gdo06=g_gdo[p_ac].gdo06
                    WHERE gdo01 = g_gdo_t.gdo01   
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","gdo_file",g_gdo[l_ac].gdo01,"",SQLCA.sqlcode,"","",1)  
                        LET g_gdo[p_ac].* = g_gdo_t.*
                        ROLLBACK WORK
                    ELSE              
                        COMMIT WORK
                        #修改4rp長寬
                        CALL p_grwp_4rp_editLW(g_gdo[p_ac].gdo03,g_gdo[p_ac].gdo04,g_gdo[p_ac].gdo05)
                        
                    END IF  

                ELSE 
                     LET g_gdo[p_ac].* = g_gdo_t.*
                     #DISPLAY "p_ac:",p_ac,"--",g_gdo[p_ac].gdo03
                     #DISPLAY "g_gdo_t.gdo03:",g_gdo_t.gdo03
                END IF   #IF cl_confirm("azz1300")                  
       
          EXIT DISPLAY           
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice = "exit"
         IF l_sure='N' THEN  #未按更新，就將畫面取消掉
           LET g_gdo[p_ac].* = g_gdo_t.* 
         END IF 
         EXIT DISPLAY
     END DISPLAY 
     
     CLOSE WINDOW p_grwp_4rp_w                 #結束畫面


  
END FUNCTION 
#FUN-CC0099 add -(e)

 
FUNCTION p_grwp_b_askkey()
 
    CLEAR FORM
    CALL g_gdo.clear()
 
    CONSTRUCT g_wc2 ON gdo01,gdo02,gdo06,gdo03,gdo04,gdo05
         FROM s_gdo[1].gdo01,s_gdo[1].gdo02,s_gdo[1].gdo06,
              s_gdo[1].gdo03,s_gdo[1].gdo04,s_gdo[1].gdo05
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      
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
    LET g_wc2 = g_wc2 CLIPPED

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
   CALL p_grwp_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_grwp_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT gdo01,gdo02,gdo06,gdo03,gdo04,gdo05", 
        " FROM gdo_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY gdo01"
    PREPARE p_grwp_pb FROM g_sql
    DECLARE gdo_curs CURSOR FOR p_grwp_pb
 
    CALL g_gdo.clear()
    LET g_cnt = 1
    
    FOREACH gdo_curs INTO g_gdo[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gdo.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_grwp_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gdo TO s_gdo.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      #ON ACTION output
      #   LET g_action_choice="output"
      #   EXIT DISPLAY
      
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
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 

FUNCTION p_grwp_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
#                                                                                
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
#     CALL cl_set_comp_entry("gdo01",TRUE)                                       
#   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION p_grwp_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
#     CALL cl_set_comp_entry("gdo01",FALSE)                                      
#   END IF                                                                       
                                                                                
END FUNCTION   

# Descriptions...: 檢查紙張格式是否已經被報表使用
FUNCTION p_gr_chk_paper_size(p_gdo02)
    DEFINE p_gdo02      LIKE gdo_file.gdo02 #紙張格式名稱
    DEFINE l_dir        STRING
    DEFINE l_res        LIKE type_file.num10
    DEFINE l_handle     LIKE type_file.num10
    DEFINE l_subdir1    STRING
    DEFINE l_subdir2    STRING
    DEFINE l_cur_file   STRING
    DEFINE l_moddirs    DYNAMIC ARRAY OF STRING
    DEFINE l_langs      DYNAMIC ARRAY OF STRING
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_j          LIKE type_file.num10
    DEFINE l_gao01      LIKE gao_file.gao01
    DEFINE l_gay01      LIKE gay_file.gay01
    DEFINE l_t1         DATETIME HOUR TO FRACTION(5)
    DEFINE l_t2         DATETIME HOUR TO FRACTION(5)
    DEFINE l_doc        om.DomDocument
    DEFINE l_doc_root   om.DomNode
    DEFINE l_gdo02      LIKE gdo_file.gdo02 #紙張格式名稱
    DEFINE l_orient     STRING              #紙張方向
    DEFINE l_4rppath    STRING     
    #FUN-CC0099 add -(s)    
    DEFINE l_gdw09      LIKE gdw_file.gdw09  
    DEFINE l_gdw01      LIKE gdw_file.gdw01  
    DEFINE l_gaz03      LIKE gaz_file.gaz03  
    DEFINE l_4rp_path   varchar(100) 
    DEFINE l_sql        STRING,
           l_gdw02      LIKE gdw_file.gdw02,
           l_gdw03      LIKE gdw_file.gdw03,
           l_gdw05      LIKE gdw_file.gdw05,
           l_gdw04      LIKE gdw_file.gdw04,
           l_gdw06      LIKE gdw_file.gdw06,
           l_gdw08      LIKE gdw_file.gdw08,
           l_zz01       LIKE zz_file.zz01,
           l_zz011      LIKE zz_file.zz011,
           l_sys,l_mdir,l_4rpdir STRING ,
           l_4rpfile    STRING,
           l_all_cnt    INTEGER , 
           l_cnt_ing    INTEGER,
           l_k          LIKE type_file.num5,
           l_pro_cnt    INTEGER,
           l_for_cnt    INTEGER,
           l_pro_ing    INTEGER,
           l_per        LIKE type_file.num10 
    #FUN-CC0099 add -(e)
    
    LET l_t1 = CURRENT HOUR TO FRACTION(5)
    LET l_res = 0
    
    
    DECLARE p_gr_chk_paper_size_cur1 CURSOR FROM "SELECT gao01 FROM gao_file ORDER BY gao01"
    LET l_i = 1
    FOREACH p_gr_chk_paper_size_cur1 INTO l_gao01
        LET l_moddirs[l_i] = DOWNSHIFT(l_gao01)
        LET l_i = l_i + 1
    END FOREACH
    CALL l_moddirs.deleteElement(l_i)

    DECLARE p_gr_chk_paper_size_cur2 CURSOR FROM "SELECT gay01 FROM gay_file ORDER BY gay01"
    LET l_i = 1
    FOREACH p_gr_chk_paper_size_cur2 INTO l_gay01
        LET l_langs[l_i] = l_gay01
        LET l_i = l_i + 1
    END FOREACH
    #CALL l_langs.deleteElement(l_i)  #FUN-CC0099 mark 
    LET l_langs[l_i] = "src"          #FUN-CC0099 add (直接將src存入)

    #FUN-CC0099 mark -(s)--原版
    #LET l_dir = FGL_GETENV("TOP")
    #FOR l_i = 1 TO l_moddirs.getLength()
        #LET l_subdir1 = os.Path.join(l_dir.trim(),l_moddirs[l_i].trim())
        #LET l_subdir1 = os.Path.join(l_subdir1,"4rp")
        #FOR l_j = 1 TO l_langs.getLength()
            #LET l_subdir2 = os.Path.join(l_subdir1,l_langs[l_j].trim())
            #LET l_handle = os.Path.dirOpen(l_subdir2)
            ##DISPLAY l_subdir2,": ",l_handle
            #IF l_handle > 0 THEN
                #WHILE TRUE
                    #LET l_cur_file = os.Path.dirnext(l_handle)
                    #IF l_cur_file.getIndexOf(".4rp.",1)=0 THEN  #FUN-CC0099 add
                    #
                        #LET l_4rppath = os.Path.join(l_subdir2,l_cur_file)
                        #DISPLAY "l_4rppath:",l_4rppath
                        #TRY
                            #IF l_4rppath.getIndexOf(".4rp",1) > 0 THEN
                                ##FUN-CC0099 add -(s)                    
                                #CALL cl_msg(l_cur_file)   #畫面顯示掃瞄狀態
                                #CALL ui.Interface.refresh()
                                ##FUN-CC0099 add -(e)
                                #LET l_doc = om.DomDocument.createFromXmlFile(l_4rppath)
                                #LET l_doc_root = l_doc.getDocumentElement()
                                #CALL cl_gr_get_4rp_paper_size(l_doc_root) RETURNING l_gdo02,l_orient
                                ##DISPLAY "gdo02: ",l_gdo02
                                #IF p_gdo02 = l_gdo02 THEN
                                   #LET l_res = l_res + 1
                                   ##FUN-CC0099 add -(s)
                                   ##將找到的存下來                             
                                   #LET l_gdw09=l_cur_file.subString(1,l_cur_file.getIndexOf(".",1)-1)
                                   #LET l_4rp_path=l_4rppath
                                   #SELECT gdw01,gaz03 INTO l_gdw01,l_gaz03  FROM gaz_file left join gdw_file on gaz01=gdw01
                                          #AND gaz02=g_lang WHERE gdw09 = l_gdw09
                                   #INSERT INTO p_grwp_tmp1 VALUES(l_gdw01,l_gaz03,l_gdw09,l_4rp_path)       
                                   #
                                   ##FUN-CC0099 add -(e)
                                #END IF
                            #END IF
                        #CATCH
                            ##DISPLAY base.Application.getStackTrace()
                        #END TRY 
                    #END IF   #FUN-CC0099 add l_4rppath.getIndexOf(".4rp",1)
                    #IF l_cur_file IS NULL THEN 
                        #EXIT WHILE  
                    #END IF
                #END WHILE
            #END IF
            #CALL os.Path.dirClose(l_handle)
        #END FOR
    #END FOR
    #FUN-CC0099 mark -(e)

    
    #FUN-CC0099 add -(s)

      SELECT COUNT(DISTINCT gdw08) INTO l_all_cnt FROM gdw_file,gdm_file WHERE gdw08=gdm01 
      ORDER BY gdw01,gdw02,gdw03,gdw09
      
      CALL cl_progress_bar(l_all_cnt)  #處理的筆數

      LET l_per=l_all_cnt / 10 
      
      LET l_cnt_ing =0
      FOR l_k = 1 TO l_langs.getLength()     
          LET l_sql = " SELECT DISTINCT gdw01,gdw02,gdw05,gdw04,gdw06,",
                      "                gdw03,gdw09,gdw08",
                      " FROM gdw_file , gdm_file  ",
                      " WHERE gdw08=gdm01 ",
                      " ORDER BY gdw01,gdw02,gdw03,gdw09"
          PREPARE p_gr_def_gdw_pr FROM l_sql
          DECLARE p_gr_def_gdw_cs CURSOR FOR p_gr_def_gdw_pr
          FOREACH p_gr_def_gdw_cs INTO l_gdw01,l_gdw02,l_gdw05,l_gdw04,l_gdw06,
                                       l_gdw03,l_gdw09,l_gdw08

            #抓取系統別
            LET l_zz01 = l_gdw01
            LET l_sql = "SELECT zz011 FROM ds.zz_file WHERE zz01=?"
            PREPARE p_replang_pre FROM l_sql
            EXECUTE p_replang_pre USING l_zz01 INTO l_zz011
            FREE p_replang_pre
            LET l_sys = l_zz011
            LET l_sys = l_sys.toLowerCase()
            IF l_gdw03 = "Y" THEN
                 LET l_sys = 'c',l_sys.subString(2,l_sys.getLength()) CLIPPED
                 LET l_mdir = l_sys
            ELSE
               LET l_mdir = l_sys
            END IF      
            LET l_4rpdir = os.Path.join(FGL_GETENV(UPSHIFT(l_mdir)),"4rp") #取得4rp路徑

            LET l_cnt_ing=l_cnt_ing+1                
                
            IF  l_cnt_ing MOD (l_per*7) =0  AND l_cnt_ing > 1 THEN
               LET l_pro_cnt= l_cnt_ing / 7
               IF l_pro_cnt+l_per>l_all_cnt THEN LET l_pro_cnt=l_all_cnt END IF 
               CALL p_grwp_progressing("serach 4rp.....",l_pro_cnt,l_all_cnt)   #顯示作業處理進度         
            END IF 
            IF os.Path.exists(l_4rpdir) THEN
                LET l_4rpfile = os.Path.join(l_4rpdir,l_langs[l_k] CLIPPED)
                LET l_4rpfile = os.Path.join(l_4rpfile,l_gdw09 CLIPPED||".4rp")
                IF os.Path.exists(l_4rpfile) THEN 
     
                   LET l_doc = om.DomDocument.createFromXmlFile(l_4rpfile)
                   LET l_doc_root = l_doc.getDocumentElement()
                   CALL cl_gr_get_4rp_paper_size(l_doc_root) RETURNING l_gdo02,l_orient
                   IF p_gdo02 = l_gdo02 THEN
                      LET l_res = l_res + 1                     
                      
                      ##將找到的存下來                          
                      LET l_4rp_path=l_4rpfile
                      SELECT gaz03 INTO l_gaz03  FROM gaz_file left join gdw_file on gaz01= l_gdw01
                             AND gaz02=g_lang WHERE gdw09 = l_gdw09
                      INSERT INTO p_grwp_tmp1 VALUES(l_gdw01,l_gaz03,l_gdw09,l_4rp_path)       
                      
                   END IF
                END IF 
              
            END IF 
          END FOREACH
    
      END FOR  #l_langs.getLength() 

    #FUN-CC0099 add -(e)
    LET l_t2 = CURRENT HOUR TO FRACTION(5)
    DISPLAY "p_gr_chk_paper_size() time: ",l_t2 - l_t1
    LET g_res=l_res
    RETURN l_res
END FUNCTION                                                                 

#FUN-CC0099 add -(e)
##################################################
# Descriptions...: 顯現目前處理進度.
# Date & Author..: 2013/01/30 by Janet
# Input Parameter: ps_log STRING 正在處理的作業說明
# Return code....: void
##################################################

FUNCTION p_grwp_progressing(ps_log,mi_pro_cnt,mi_total_count)
  DEFINE ps_log STRING
  DEFINE li_progbar,li_percent   LIKE type_file.num10  
  DEFINE mi_total_count  LIKE type_file.num10          
  DEFINE mi_current      LIKE type_file.num10 
  DEFINE mi_pro_cnt      LIKE type_file.num10  

  LET mi_current= mi_pro_cnt
  LET li_percent = mi_current * 100 / mi_total_count
  LET li_progbar = li_percent

  DISPLAY ps_log,li_progbar,mi_current,mi_total_count,li_percent
       TO proc,progbar,curr,total,p

  CALL ui.Interface.refresh()

  IF (mi_current = mi_total_count) OR (mi_current+(mi_total_count/10) > mi_total_count) THEN
     CALL cl_close_progress_bar()
  END IF
END FUNCTION


#FUN-CC0099 add -(e)
