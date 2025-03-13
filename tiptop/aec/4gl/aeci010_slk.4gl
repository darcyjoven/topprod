# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci010.4gl
# Descriptions...: 單元工時資料維護作業
# Date & Author..: 99/04/28 By Iceman 
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-510032 05/01/17 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6C0190 06/12/27 By Ray 報表問題修改
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-760047 07/06/06 By xufeng 單位工時及單位機時為負數無控管
# Modify.........: No.FUN-780037 07/07/04 By sherry 報表格式修改為p_query  
# Modify.........: No.FUN-810017 08/01/17 By jan 新增服飾作業
# Modify.........: No.FUN-830121 08/03/31 By hongmei sgaslk01-->sga08報工否改為一般行業
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_sga           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        sga01       LIKE sga_file.sga01,   #單元工時代號
        sga02       LIKE sga_file.sga02,   #單元名稱
        sga03       LIKE sga_file.sga03,   #單元規格
        sga04       LIKE sga_file.sga04,   #單元工時
        sga06       LIKE sga_file.sga06,   #單元機時
        sgaslk04    LIKE sga_file.sgaslk04, #現實工價   #No.FUN-810017                        
        sgaslk03    LIKE sga_file.sgaslk03, #標准工價   #No.FUN-810017                       
        sgaslk02    LIKE sga_file.sgaslk02, #現時工價   #No.FUN-810017                       
        sga07       LIKE sga_file.sga07,    #可委外否   #No.FUN-810017                       
        sga08       LIKE sga_file.sga08,    #可報工否   #No.FUN-810017 FUN-830121
        sga05       LIKE sga_file.sga05,    #備註 
        sgaacti     LIKE sga_file.sgaacti   #資料有效
                    END RECORD,
    g_sga_t         RECORD                 #程式變數 (舊值)
        sga01       LIKE sga_file.sga01,   #單元工時代號
        sga02       LIKE sga_file.sga02,   #單元名稱
        sga03       LIKE sga_file.sga03,   #單元規格
        sga04       LIKE sga_file.sga04,   #單元工時
        sga06       LIKE sga_file.sga06,   #單元機時
        sgaslk04    LIKE sga_file.sgaslk04, #現實工價   #No.FUN-810017                        
        sgaslk03    LIKE sga_file.sgaslk03, #標准工價   #No.FUN-810017                       
        sgaslk02    LIKE sga_file.sgaslk02, #現時工價   #No.FUN-810017                       
        sga07       LIKE sga_file.sga07,    #可委外否   #No.FUN-810017                       
        sga08       LIKE sga_file.sga08,    #可報工否   #No.FUN-810017
        sga05       LIKE sga_file.sga05,    #備註
        sgaacti     LIKE sga_file.sgaacti   #資料有效
                    END RECORD,
     g_wc2,g_sql,g_wc1    STRING,  #No.FUN-580092 HCN        #No.FUN-680073
   #l_za05          VARCHAR(40),
    l_za05          LIKE type_file.chr1000, # No.FUN-680073
    g_flag          LIKE type_file.chr1,    #判斷誤動作存入        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    g_rec_b         LIKE type_file.num5,    #單身筆數        #No.FUN-680073 SMALLINT
    p_row,p_col     LIKE type_file.num5,    #No.FUN-680073 SMALLINT SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570110           #No.FUN-680073 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037  
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0100
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_prog = "aeci010_slk"    #No.FUN-810017                                                                                     
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
    LET p_row = 4 LET p_col = 3 
    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "aec/42f/aeci010"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i010_b_fill(g_wc2)
    ERROR ""
    CALL i010_menu()
    CLOSE WINDOW i010_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
END MAIN
 
FUNCTION i010_menu()
 
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL i010_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i010_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN 
            #No.FUN-780037---Begin
            #  CALL i010_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                 
               LET l_cmd = 'p_query "aeci010" "',g_wc2 CLIPPED,'"'              
               CALL cl_cmdrun(l_cmd)   
            #No.FUN-780037---End 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sga),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i010_q()
   CALL i010_b_askkey()
END FUNCTION
 
FUNCTION i010_b()
DEFINE
    l_sga01         LIKE  sga_file.sga01,
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    s_acct          LIKE aab_file.aab02,          # No.FUN-680073   VARCHAR(06),#SELECT npu_cost number880110  
    p_cmd           LIKE type_file.chr1,          #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(01),
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680073 HAR(01),
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sga01,sga02,sga03,sga04,sga06,sgaslk04,sgaslk03,sgaslk02,sga07,sga08,sga05,sgaacti FROM sga_file WHERE sga01=? FOR UPDATE" #FUN-810017
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_sga WITHOUT DEFAULTS FROM s_sga.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sga_t.* = g_sga[l_ac].*         #新輸入資料
#No.FUN-570110 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i010_set_entry(p_cmd)                                                                                           
               CALL i010_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--   
               BEGIN WORK
               OPEN i010_bcl USING g_sga_t.sga01
               IF STATUS THEN
                  CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i010_bcl INTO g_sga[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_sga_t.sga01,STATUS,1) 
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i010_set_entry(p_cmd)                                                                                           
            CALL i010_set_no_entry(p_cmd)                                                                                        
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--   
            INITIALIZE g_sga[l_ac].* TO NULL      #900423
            LET g_sga[l_ac].sgaacti = 'Y' 
            LET g_sga[l_ac].sga07 = 'N'          #FUN-810017
            LET g_sga[l_ac].sga08 = 'N'          #FUN-810017
            LET g_sga[l_ac].sga04   = 0
            LET g_sga[l_ac].sga06   = 0
            LET g_sga_t.* = g_sga[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sga01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO sga_file(sga01,sga02,sga03,sga04,sga06,
                              sgaslk04,sgaslk03,sgaslk02, #No.FUN-810017
                              sga07,sga08,       #No.FUN-810017
                              sga05,sgaacti,sgauser,sgagrup,sgadate,sgaoriu,sgaorig)
          VALUES (g_sga[l_ac].sga01,g_sga[l_ac].sga02,
                  g_sga[l_ac].sga03,g_sga[l_ac].sga04,
                  g_sga[l_ac].sga06,
                  g_sga[l_ac].sgaslk04,g_sga[l_ac].sgaslk03,g_sga[l_ac].sgaslk02,   #No.FUN-810017
                  g_sga[l_ac].sga07,g_sga[l_ac].sga08,            #No.FUN-810017
                  g_sga[l_ac].sga05,
                  g_sga[l_ac].sgaacti,g_user,g_grup,g_today, g_user, g_grup)       #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_sga[l_ac].sga01,SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("ins","sga_file",g_sga[l_ac].sga01,"",SQLCA.sqlcode,"","",1) #FUN-660091
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2 
               COMMIT WORK
           END IF
 
        BEFORE FIELD sga02
            IF g_sga[l_ac].sga01 != g_sga_t.sga01  OR
                cl_null(g_sga_t.sga01)  THEN
                  SELECT COUNT(*) INTO l_n FROM  sga_file
                   WHERE sga01 = g_sga[l_ac].sga01
                    IF l_n > 0 THEN 
                       CALL cl_err('','aec-008',0) 
                       NEXT FIELD sga01
                    END IF
            END IF
 
        #No.TQC-760047  --begin
        AFTER FIELD sga04
           IF NOT cl_null(g_sga[l_ac].sga04)  THEN
              IF g_sga[l_ac].sga04 <0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD sga04
              END IF
           END IF
 
        AFTER FIELD sga06
           IF NOT cl_null(g_sga[l_ac].sga06)  THEN
              IF g_sga[l_ac].sga06 <0 THEN
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD sga06
              END IF
           END IF
        #No.TQC-760047  --end  
#No.FUN-810017--Begin
       AFTER FIELD sgaslk04                                                       
           IF NOT cl_null(g_sga[l_ac].sgaslk04)  THEN                              
              IF g_sga[l_ac].sgaslk04 <0 THEN                                      
                 CALL cl_err('','mfg4012',0)                                    
                 NEXT FIELD sgaslk04                                               
              END IF                                                            
           END IF
       AFTER FIELD sgaslk03                                                    
           IF NOT cl_null(g_sga[l_ac].sgaslk03)  THEN                          
              IF g_sga[l_ac].sgaslk03 <0 THEN                                  
                 CALL cl_err('','mfg4012',0)                                    
                 NEXT FIELD sgaslk03                                           
              END IF                                                            
           END IF
      AFTER FIELD sgaslk02                                                    
           IF NOT cl_null(g_sga[l_ac].sgaslk02)  THEN                          
              IF g_sga[l_ac].sgaslk02 <0 THEN                                  
                 CALL cl_err('','mfg4012',0)                                    
                 NEXT FIELD sgaslk02                                           
              END IF                                                            
           END IF
#No.FUN-810017--End
        BEFORE DELETE                            #是否取消單身
             IF g_sga_t.sga01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
            DELETE FROM sga_file
                WHERE sga01 = g_sga_t.sga01 
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_sga_t.sga01,SQLCA.sqlcode,0) #No.FUN-660091
                CALL cl_err3("del","sga_file",g_sga_t.sga01,"",SQLCA.sqlcode,"","",1) #FUN-660091
                ROLLBACK WORK
                CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2 
            MESSAGE "Delete OK" 
            CLOSE i010_bcl     
            COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_sga[l_ac].* = g_sga_t.*
              CLOSE i010_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_sga[l_ac].sga01,-263,1)
              LET g_sga[l_ac].* = g_sga_t.*
           ELSE
              UPDATE sga_file SET sga01=g_sga[l_ac].sga01,
                                  sga02=g_sga[l_ac].sga02,
                                  sga03=g_sga[l_ac].sga03,
                                  sga04=g_sga[l_ac].sga04,
                                  sga06=g_sga[l_ac].sga06,
                                  #No.FUN-810017--Begin
                                  sgaslk04=g_sga[l_ac].sgaslk04,              
                                  sgaslk03=g_sga[l_ac].sgaslk03,              
                                  sgaslk02=g_sga[l_ac].sgaslk02,              
                                  sga07=g_sga[l_ac].sga07,           
                                  sga08=g_sga[l_ac].sga08,               
                                  #No.FUN-810017--End
                                  sga05=g_sga[l_ac].sga05,
                                  sgaacti=g_sga[l_ac].sgaacti,
                                  sgamodu=g_today
               WHERE sga01 = g_sga_t.sga01
               IF SQLCA.sqlcode THEN
                  #No.+045 010403 by plum
                  #CALL cl_err('','update sga error ',0) 
#                  CALL cl_err('update sga error',SQLCA.SQLCODE,0) #No.FUN-660091
                   CALL cl_err3("upd","sga_file",g_sga_t.sga01,"",SQLCA.sqlcode,"","update sga error",1) #FUN-660091
                   LET g_sga[l_ac].* = g_sga_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd='u' THEN
                  LET g_sga[l_ac].* = g_sga_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sga.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i010_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i010_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i010_b_askkey()
            EXIT INPUT
 
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
 
    CLOSE i010_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_b_askkey()
    CLEAR FORM
    CALL g_sga.clear()
    CONSTRUCT g_wc2 ON sga01, sga02, sga03, sga04, sga06,
                       sgaslk04,sgaslk03,sgaslk02,       #No.FUN-810017
                       sga07,sga08,                         #No.FUN-810017
                       sga05 ,sgaacti 
            FROM s_sga[1].sga01,s_sga[1].sga02,s_sga[1].sga03,
                 s_sga[1].sga04,s_sga[1].sga06,
                 s_sga[1].sgaslk04,s_sga[1].sgaslk03,s_sga[1].sgaslk02, #No.FUN-810017
                 s_sga[1].sga07,s_sga[1].sga08,          #No.FUN-810017
                 s_sga[1].sga05,s_sga[1].sgaacti 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('sgauser', 'sgagrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i010_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(200)
 
    LET g_sql =
        " SELECT sga01,sga02,sga03,sga04,sga06,",                      #No.FUN-810017
        " sgaslk04,sgaslk03,sgaslk02,sga07,sga08,sga05,sgaacti",    #No.FUN-810017
        " FROM   sga_file " ,
        " WHERE  ", p_wc2 CLIPPED,
        " ORDER BY sga01, sga02"
    PREPARE i010_pb FROM g_sql
    DECLARE sga_curs CURSOR FOR i010_pb
 
    CALL g_sga.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH sga_curs INTO g_sga[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_sga.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sga TO s_sga.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780037---Begin
{
FUNCTION i010_out()
    DEFINE
        l_i             LIKE type_file.num5,     #No.FUN-680073 SMALLINT
        l_name          LIKE type_file.chr20,    # No.FUN-680073 VARCHAR(20), # External(Disk) file name
        l_za05          LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40),
        l_chr           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
        l_sga   RECORD  LIKE  sga_file.*,
    sr              RECORD
        sga01       LIKE sga_file.sga01,   #單元工時代號
        sga02       LIKE sga_file.sga02,   #單元名稱
        sga03       LIKE sga_file.sga03,   #單元規格
        sga04       LIKE sga_file.sga04,   #單元工時
        sga06       LIKE sga_file.sga06,   #單元機時
        sga05       LIKE sga_file.sga05,   #備註
        sgaacti     LIKE sga_file.sgaacti #資料有效
                    END RECORD
#No.TQC-710076 -- begin --
   IF cl_null(g_wc2) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL cl_wait()
    CALL cl_outnam('aeci010') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql=
        " SELECT sga01,sga02,sga03,sga04,sga06,sga05,sgaacti,''",
        " FROM   sga_file ",
        " ORDER BY sga01, sga02"
    PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i010_co                         # SCROLL CURSOR
        CURSOR FOR i010_p1
 
    START REPORT i010_rep TO l_name
 
    FOREACH i010_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i010_rep(sr.*)
    END FOREACH
    FINISH REPORT i010_rep
    CLOSE i010_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i010_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1),
        l_chr           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    sr              RECORD
        sga01       LIKE sga_file.sga01,   #單元工時代號
        sga02       LIKE sga_file.sga02,   #單元名稱
        sga03       LIKE sga_file.sga03,   #單元規格
        sga04       LIKE sga_file.sga04,   #單元工時
        sga06       LIKE sga_file.sga06,   #單元機時
        sga05       LIKE sga_file.sga05,   #備註
        sgaacti     LIKE sga_file.sgaacti #資料有效
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sga01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31], sr.sga01,
                  COLUMN g_c[32], sr.sga02 CLIPPED, 
                  COLUMN g_c[33], sr.sga03 CLIPPED, 
#No.TQC-6C0190 --begin
#                 COLUMN g_c[34], sr.sga04,
#                 COLUMN g_c[35], sr.sga06,
                  COLUMN g_c[34], cl_numfor(sr.sga04,34,2),
                  COLUMN g_c[35], cl_numfor(sr.sga06,35,2),
#No.TQC-6C0190 --end
                  COLUMN g_c[36], sr.sga05 CLIPPED,
                  COLUMN g_c[37], sr.sgaacti 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
 
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780037---ENd
#No.FUN-570110 --start--                                                                                                            
FUNCTION i010_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                  #No.FUN-680073 VARCHAR(1)   
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("sga01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i010_set_no_entry(p_cmd)                                                                                                   
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("sga01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--     
