# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: axci500.4gl
# Descriptions...: 成本
# Date & Author..: 99/03/29  By Apple 
# Modify ........: No.MOD-490371 04/09/22 By Melody controlp ...display修改
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0015 04/11/08 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/07 By kim 報表轉XML功能
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-590022 05/09/07 By wujie 系統review修改報表
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.CHI-6A0027 06/12/14 By jamie 欄位"jec03 計算順序"改為no use
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/19 By Sunyanchun   橾老報表改成p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60137 10/06/21 By Carrier 单身修改状态下,若参数设置为修改时KEY值不做更改,会出现程序当出的现象
# Modify.........: No.FUN-BA0028 11/10/07 BY jason 檢查新增、刪除時當月是否存在調撥單(且不同成本性質的倉)，存在的話警告但不卡。
# Modify.........: No.CHI-D10050 13/02/19 By bart 增加倉庫名稱的欄位
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_jce           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        jce01       LIKE jce_file.jce01,   
        jce02       LIKE jce_file.jce02,      #CHI-6A0027 mod
        imd02       LIKE imd_file.imd02       #CHI-D10050
       #jce02       LIKE jce_file.jce02,      #CHI-6A0027 mark
       #jce03       LIKE jce_file.jce03       #CHI-6A0027 mark   
                    END RECORD,
    g_jce_t         RECORD                 #程式變數 (舊值)
        jce01       LIKE jce_file.jce01,   
        jce02       LIKE jce_file.jce02,      #CHI-6A0027 mod
        imd02       LIKE imd_file.imd02       #CHI-D10050  
       #jce02       LIKE jce_file.jce02,      #CHI-6A0027 mark
       #jce03       LIKE jce_file.jce03       #CHI-6A0027 mark   
                    END RECORD,
    g_jceacti       LIKE  jce_file.jceacti,     
    g_jceuser       LIKE  jce_file.jceuser,     
    g_jcegrup       LIKE  jce_file.jcegrup,     
    g_jcemodu       LIKE  jce_file.jcemodu,     
    g_jcedate       LIKE  jce_file.jcedate,     
    g_wc2,g_sql     STRING,#TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_before_input_done      LIKE type_file.num5            #No.FUN-570110        #No.FUN-680122 SMALLINT
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_edit            LIKE type_file.chr1     #No.MOD-A60137
 
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i500_w AT p_row,p_col WITH FORM "axc/42f/axci500"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i500_b_fill(g_wc2)
    CALL i500_menu()
    CLOSE WINDOW i500_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION i500_menu()
 
   WHILE TRUE
      CALL i500_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i500_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i500_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               CALL i500_out()                                        #No.FUN-7C0043---del--
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_jce),'','')
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i500_q()
   CALL i500_b_askkey()
END FUNCTION
 
FUNCTION i500_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否              #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態                #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                                          #No.FUN-680122 VARCHAR(01),
    l_allow_delete  LIKE type_file.chr1                                           #No.FUN-680122 VARCHAR(01),
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT jce01,jce02,jce03 FROM jce_file WHERE jce01=? AND jce02=? FOR UPDATE"  #CHI-6A0027 mark
    LET g_forupd_sql = "SELECT jce01,jce02 FROM jce_file        
                        WHERE jce01=? AND jce02=? FOR UPDATE"  #CHI-6A0027 mod
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_jce WITHOUT DEFAULTS FROM s_jce.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac) 
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET g_jce_t.* = g_jce[l_ac].*  #BACKUP
               LET p_cmd='u'
#No.FUN-570110--begin                                                           
                LET g_before_input_done = FALSE                                 
                CALL i500_set_entry_b(p_cmd)                                    
                CALL i500_set_no_entry_b(p_cmd)                                 
                LET g_before_input_done = TRUE                                  
#No.FUN-570110--end
               BEGIN WORK
 
               OPEN i500_bcl USING g_jce_t.jce01,g_jce_t.jce02
               IF STATUS THEN
                  CALL cl_err("OPEN i500_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i500_bcl INTO g_jce[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_jce_t.jce01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
 
               SELECT jceacti,jceuser,jcegrup,jcedate,jcemodu 
                 INTO g_jceacti,g_jceuser,g_jcegrup,g_jcedate,g_jcemodu 
                 FROM jce_file WHERE jce01 = g_jce[l_ac].jce01 
               IF cl_null(g_jceacti) THEN LET g_jceacti = 'Y'    END IF 
               IF cl_null(g_jceuser) THEN LET g_jceuser = g_user END IF 
               #使用者所屬群
               IF cl_null(g_jcegrup) THEN LET g_jcegrup = g_grup END IF
               IF cl_null(g_jcedate) THEN LET g_jcedate = g_today END IF 
               DISPLAY  g_jceuser,g_jcegrup,g_jcedate,g_jcemodu 
                    TO    jceuser,  jcegrup,  jcedate ,  jcemodu 
               CALL cl_show_fld_cont()     #FUN-550037(smin)
               #No.MOD-A60137  --Begin
               IF g_edit = 'N' THEN
                  LET l_ac = l_ac + 1
                  CALL fgl_set_arr_curr(l_ac)
               END IF
               #No.MOD-A60137  --End  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin                                                           
            LET g_before_input_done = FALSE                                     
            CALL i500_set_entry_b(p_cmd)                                        
            CALL i500_set_no_entry_b(p_cmd)                                     
            LET g_before_input_done = TRUE                                      
#No.FUN-570110--end      
            INITIALIZE g_jce[l_ac].* TO NULL      #900423
            LET g_jce_t.* = g_jce[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD jce01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         #FUN-BA0028 --START--
         #當月已開立調撥單時警告
         IF NOT i500_imm_chk() THEN
            CALL cl_err("", "axc-052", 1)
         END IF
         #FUN-BA0028 --END-- 
        #INSERT INTO jce_file(jce01,jce02,jce03,     #CHI-6A0027 mark
         INSERT INTO jce_file(jce01,jce02,           #CHI-6A0027 mod   
                              jceacti,jceuser,jcegrup,jcemodu,
                              jcedate,jceoriu,jceorig)
         VALUES(g_jce[l_ac].jce01,g_jce[l_ac].jce02,'Y',
                g_jceuser,g_jcegrup,g_jcemodu,g_jcedate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
               #g_jce[l_ac].jce03,                   #CHI-6A0027 mark 
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_jce[l_ac].jce01,SQLCA.sqlcode,0)   #No.FUN-660127
             CALL cl_err3("ins","jce_file",g_jce[l_ac].jce01,g_jce[l_ac].jce02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
             CANCEL INSERT 
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD jce02                        #check 編號是否重複
            IF NOT cl_null(g_jce[l_ac].jce01) THEN
            IF g_jce[l_ac].jce01 != g_jce_t.jce01 OR
               g_jce[l_ac].jce02 != g_jce_t.jce02 OR
               (g_jce[l_ac].jce01 IS NOT NULL AND g_jce_t.jce01 IS NULL) OR 
               (g_jce[l_ac].jce02 IS NOT NULL AND g_jce_t.jce02 IS NULL) 
            THEN
                SELECT count(*) INTO l_n FROM jce_file
                    WHERE jce01 = g_jce[l_ac].jce01
                      AND jce02 = g_jce[l_ac].jce02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_jce[l_ac].jce01 = g_jce_t.jce01
                    LET g_jce[l_ac].jce02 = g_jce_t.jce02
                    NEXT FIELD jce01
                END IF
                SELECT * FROM imd_file 
                 WHERE imd01 = g_jce[l_ac].jce02 AND imdacti='Y'
                IF SQLCA.SQLCODE THEN
#                  CALL cl_err(g_jce[l_ac].jce02,'mfg1100',0)   #No.FUN-660127
                   CALL cl_err3("sel","imd_file",g_jce[l_ac].jce02,"","mfg1100","","",1)  #No.FUN-660127
                   NEXT FIELD jce02
                END IF
            END IF
            END IF
            #CHI-D10050---begin
            IF NOT cl_null(g_jce[l_ac].jce02) THEN
               SELECT imd02 INTO g_jce[l_ac].imd02
                 FROM imd_file
                WHERE imd01 =  g_jce[l_ac].jce02
            ELSE
               LET g_jce[l_ac].imd02 = ''
            END IF 
            #CHI-D10050---end
     
        BEFORE DELETE                            #是否取消單身
            IF g_jce_t.jce01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                #FUN-BA0028 --START--
                #當月已開立調撥單時警告
                IF NOT i500_imm_chk() THEN
                   CALL cl_err("", "axc-052", 1)
                END IF
                #FUN-BA0028 --END-- 
                
                DELETE FROM jce_file WHERE jce01 = g_jce_t.jce01
                                       AND jce02 = g_jce_t.jce02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_jce_t.jce01,SQLCA.sqlcode,0)   #No.FUN-660127
                   CALL cl_err3("del","jce_file",g_jce_t.jce01,g_jce_t.jce02,SQLCA.SQLCODE,"","",1)  #No.FUN-660127
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i500_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_jce[l_ac].* = g_jce_t.*
              CLOSE i500_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_jce[l_ac].jce01,-263,1)
              LET g_jce[l_ac].* = g_jce_t.*
           ELSE
              #CHI-6A00027---mod---str---
              #UPDATE jce_file SET(jce01,jce02,jce03,
              #        jcemodu,jcedate)
              #      =(g_jce[l_ac].jce01,g_jce[l_ac].jce02,
              #        g_jce[l_ac].jce03,
              #        g_jcemodu,g_jcedate)
              # WHERE CURRENT OF i500_bcl
              #FUN-BA0028 --START--
              #當月已開立調撥單時警告
              IF NOT i500_imm_chk() THEN
                 CALL cl_err("", "axc-052", 1)
              END IF
              #FUN-BA0028 --END-- 
               UPDATE jce_file SET jce01 = g_jce[l_ac].jce01,
                                   jce02 = g_jce[l_ac].jce02,
                                  #jce03 = g_jce[l_ac].jce03, 
                                   jcemodu = g_jcemodu,
                                   jcedate = g_jcedate
                 WHERE CURRENT OF i500_bcl
              #CHI-6A00027---mod---str---
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_jce[l_ac].jce01,SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("upd","jce_file",g_jce[l_ac].jce01,g_jce[l_ac].jce02,SQLCA.SQLCODE,"","",1)  #No.FUN-660127
                  LET g_jce[l_ac].* = g_jce_t.*
              ELSE
                  DISPLAY  g_jcemodu,g_jcedate
                       TO    jcemodu,  jcedate
                  MESSAGE 'UPDATE O.K'
                  CLOSE i500_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN
                  LET g_jce[l_ac].* = g_jce_t.*    
               #FUN-D40030---add---str---
               ELSE
                  CALL g_jce.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---                                
               END IF
               CLOSE i500_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i500_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i500_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(jce01) AND l_ac > 1 THEN
                LET g_jce[l_ac].* = g_jce[l_ac-1].*
                NEXT FIELD jce01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE WHEN INFIELD(jce02)
               #CALL q_imd(0,0,g_jce[l_ac].jce02,'A') RETURNING g_jce[l_ac].jce02
               #CALL FGL_DIALOG_SETBUFFER( g_jce[l_ac].jce02 )
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imd"
                LET g_qryparam.default1 = g_jce[l_ac].jce02
               #LET g_qryparam.arg1     = "A"
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                CALL cl_create_qry() RETURNING g_jce[l_ac].jce02
#                CALL FGL_DIALOG_SETBUFFER( g_jce[l_ac].jce02 )
                 DISPLAY BY NAME g_jce[l_ac].jce02  #No.MOD-490371
                NEXT FIELD jce02
           END CASE
 
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
 
    CLOSE i500_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i500_b_askkey()
    CLEAR FORM
    CALL g_jce.clear()
   #CHI-6A00027---mod---str---
   #CONSTRUCT g_wc2 ON jce01,jce02,jce03
   #        FROM s_jce[1].jce01,s_jce[1].jce02,s_jce[1].jce03
    CONSTRUCT g_wc2 ON jce01,jce02
            FROM s_jce[1].jce01,s_jce[1].jce02
   #CHI-6A00027---mod---str---
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE WHEN INFIELD(jce02)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imd"
                LET g_qryparam.state    = "c"
                LET g_qryparam.default1 = g_jce[1].jce02
               #LET g_qryparam.arg1     = "A"
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_jce[1].jce02
                NEXT FIELD jce02
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('jceuser', 'jcegrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i500_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i500_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    LET g_sql =
       #"SELECT jce01,jce02,jce03 FROM jce_file",     #CHI-6A0027 mark 
        #"SELECT jce01,jce02 FROM jce_file",           #CHI-6A0027 mod  #CHI-D10050
        "SELECT jce01,jce02,imd02 FROM jce_file,imd_file",      #CHI-D10050
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND jce02 = imd01 ",                      #CHI-D10050
        " ORDER BY jce01,jce02"                       #CHI-6A0027 mod
       #" ORDER BY 3,1,2"                             #CHI-6A0027 mark
    PREPARE i500_pb FROM g_sql
    DECLARE jce_curs CURSOR FOR i500_pb
 
    CALL g_jce.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH jce_curs INTO g_jce[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    MESSAGE ""
    CALL g_jce.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_jce TO s_jce.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                                                                
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-7C0043----BEGIN
FUNCTION i500_out()
#   DEFINE
#       l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#       l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),                # External(Disk) file name
#       l_jce   RECORD LIKE jce_file.*,
#       l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),                #
#       l_chr           LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
    DEFINE l_cmd  LIKE type_file.chr1000
    IF g_wc2 IS NULL THEN                                                       
       CALL cl_err('','9057',0)                                                 
       RETURN                                                                   
    END IF                                                                      
    LET l_cmd = 'p_query "axci500" "',g_wc2 CLIPPED,'"'                         
    CALL cl_cmdrun(l_cmd)
 
#   IF g_wc2 IS NULL THEN
#      CALL cl_err('','9057',0) RETURN END IF
#   CALL cl_wait()
#   CALL cl_outnam('axci500') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM jce_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i500_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i500_co CURSOR FOR i500_p1
 
#   START REPORT i500_rep TO l_name
 
#   FOREACH i500_co INTO l_jce.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i500_rep(l_jce.*)
#   END FOREACH
 
#   FINISH REPORT i500_rep
 
#   CLOSE i500_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#EPORT i500_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
#       sr RECORD LIKE jce_file.*,
#       l_chr           LIKE type_file.chr1            #No.FUN-680122 VARCHAR(1)
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.jce01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT 
#           PRINT g_dash
#          #PRINT g_x[31],g_x[32],g_x[33]  #CHI-6A0027
#           PRINT g_x[31],g_x[32]          #CHI-6A0027
#           PRINT g_dash1
 
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.jce01,
#                 COLUMN g_c[32],sr.jce02            #CHI-6A0027 mod 
#                #COLUMN g_c[32],sr.jce02,           #CHI-6A0027 mark
#                #COLUMN g_c[33],sr.jce03            #MOD-590022 #CHI-6A0027 mark
#       ON LAST ROW
#           IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#              CALL cl_wcchp(g_wc2,'jce01,jce02')
#                   RETURNING g_sql
#              PRINT g_dash
#            #TQC-630166
#            {
#              IF g_sql[001,080] > ' ' THEN
#       	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#              IF g_sql[071,140] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#              IF g_sql[141,210] > ' ' THEN
#       	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#            }
#              CALL cl_prt_pos_wc(g_sql)
#           #END TQC-630166
#           END IF
#           PRINT g_dash
#           LET l_trailer_sw = 'n'
#          #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[7] CLIPPED    #CHI-6A0027 
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #CHI-6A0027
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#              #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[6] CLIPPED   #CHI-6A0027
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #CHI-6A0027
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-570110--begin                                                           
FUNCTION i500_set_entry_b(p_cmd)                                                
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680122 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("jce01,jce02",TRUE)                                 
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i500_set_no_entry_b(p_cmd)                                             
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680122 VARCHAR(1)
                                                                                
   LET g_edit = 'Y'   #No.MOD-A60137
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
      CALL cl_set_comp_entry("jce01,jce02",FALSE)                                
      LET g_edit = 'N'   #No.MOD-A60137
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570110--end      

#檢查當月是否存在調撥單
#FUN-BA0028 --START--
FUNCTION i500_imm_chk()
DEFINE l_cnt    LIKE type_file.num10
DEFINE l_yy     LIKE type_file.num5
DEFINE l_mm     LIKE type_file.num5
DEFINE l_sql    STRING 
   
   LET l_cnt = 0
   CALL s_yp(g_today) RETURNING l_yy,l_mm

   LET l_sql = "SELECT COUNT(*) FROM imm_file",
               " LEFT JOIN imn_file ON imm01 = imn01",
               " WHERE YEAR(imm02) ='", l_yy, "' ",
               "   AND MONTH(imm02) ='", l_mm, "'",
               "   AND (imn04 = '", g_jce[l_ac].jce02, "'",
               "        OR imn15 ='", g_jce[l_ac].jce02, "')"
   PREPARE i500_imm_p1 FROM  l_sql               
   DECLARE i500_imm_c1 CURSOR FOR i500_imm_p1   
   OPEN i500_imm_c1
   IF STATUS THEN   
      CALL cl_err('OPEN i500_imm_c1',STATUS,0)
   ELSE 
      FETCH i500_imm_c1 INTO l_cnt
      IF SQLCA.sqlcode THEN
         CALL cl_err('FETCH i500_imm_c1',SQLCA.sqlcode,0)
      END IF       
   END IF 
   CLOSE i500_imm_c1   
   
   IF l_cnt > 0 THEN
      RETURN FALSE 
   END IF 

   RETURN TRUE 
END FUNCTION 
#FUN-BA0028 --END--
