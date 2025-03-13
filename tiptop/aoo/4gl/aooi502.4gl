# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aooi502.4gl
# Descriptions...: 
# Date & Author..: 05/10/09 By Lifeng
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6C0157 06/12/26 By day 增加匯出excel功能
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/06/29 By mike   報表格式修改為p_query
# Modify.........: No.TQC-7A0033 07/10/12 By Mandy informix區r.c2不過
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0025 10/12/16 By chenying 替換CURRENT OF i502_bcl寫法
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_get           DYNAMIC ARRAY OF RECORD  #變量名稱數組(Program Variables)
        get01       LIKE get_file.get01,   #變量代碼
        get02       LIKE get_file.get02   #變量名稱□
                    END RECORD,
    g_get_t         RECORD               #臨時變量名稱數組(Program Variables)
        get01       LIKE get_file.get01,   #變量代碼         
        get02       LIKE get_file.get02   #變量名稱              □
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN 
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的□ARRAY CNT        #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680102 INTEGER
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0081
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680102 SMALLINT
    OPTIONS                                #改變一些系統默認值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷健，由程序處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("aoo")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 4 LET p_col = 08
    OPEN WINDOW i502_w AT p_row,p_col WITH FORM "aoo/42f/aooi502"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_set_locale_frm_name("aooi502")
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i502_b_fill(g_wc2)
    CALL i502_menu()
    CLOSE WINDOW i502_w                 #關閉畫面□
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間（退出時間） #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION i502_menu()
 DEFINE l_cmd  LIKE  type_file.chr1000                            #No.FUN-780056 
   WHILE TRUE
      CALL i502_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i502_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i502_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i502_out()                                   #No.FUN-780056
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF      #No.FUN-780056
               LET l_cmd='p_query "aooi502" "',g_wc2 CLIPPED,'"'  #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                              #No.FUN-780056
            END IF
       
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.TQC-6C0157--begin
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_get),'','')
            END IF
         #No.TQC-6C0157--end   
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i502_q()
   CALL i502_b_askkey()
END FUNCTION
 
FUNCTION i502_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的□□□ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #檢查重復用        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_strlen        LIKE type_file.num5,           #No.FUN-680102  SMALLINT,           #取字符串長度
    l_get01         LIKE get_file.get01,           #No.FUN-680102  VARCHAR(10),
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102  VARCHAR(1),
    l_allow_delete  LIKE type_file.chr1            #No.FUN-680102  VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
     "SELECT get01,get02", 
     "  FROM get_file WHERE get01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i502_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    #CKP2
    IF g_rec_b=0 THEN CALL g_get.clear() END IF
 
    INPUT ARRAY g_get WITHOUT DEFAULTS FROM s_get.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED,INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
               LET g_get_t.* = g_get[l_ac].*  #BACKUP
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_get_t.* = g_get[l_ac].*  #BACKUP
               BEGIN WORK
               OPEN i502_bcl USING g_get_t.get01
               IF STATUS THEN
                  CALL cl_err("OPEN i502_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE    
                  FETCH i502_bcl INTO g_get[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_get_t.get01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_get[l_ac].* TO NULL
   #         LET g_get[l_ac].getacti = 'Y'       #Body default
   #         LET g_get[l_ac].get01 = '$$'
            LET g_get_t.* = g_get[l_ac].*       #賦初值□
            NEXT FIELD get01
 
      AFTER INSERT
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
              INITIALIZE g_get[l_ac].* TO NULL  #賦初值□
              DISPLAY g_get[l_ac].* TO s_get.*
              CALL g_get.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
         END IF
         INSERT INTO get_file(get01,get02)
         VALUES(g_get[l_ac].get01,g_get[l_ac].get02)
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_get[l_ac].get01,SQLCA.sqlcode,0)   #No.FUN-660131
             CALL cl_err3("ins","get_file",g_get[l_ac].get01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD get01    #check 變量代碼是否重復
            IF NOT cl_null(g_get[l_ac].get01) THEN 
               LET l_strlen = LENGTH(g_get[l_ac].get01)
               LET l_get01 = g_get[l_ac].get01 CLIPPED
               IF (g_get[l_ac].get01 != g_get_t.get01 OR
                  (g_get[l_ac].get01 IS NOT NULL AND g_get_t.get01 IS NULL)) 
               THEN
                   SELECT count(*) INTO l_n FROM get_file
                    WHERE get01 = g_get[l_ac].get01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_get[l_ac].get01 = g_get_t.get01
                       NEXT FIELD get01
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #刪除數據（按下單身刪除鍵時會執行此區塊）
            IF g_get_t.get01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM get_file 
                 WHERE get01 = g_get_t.get01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_get_t.get01,SQLCA.sqlcode,0)   #No.FUN-660131
                   CALL cl_err3("del","get_file",g_get_t.get01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i502_bcl     
                COMMIT WORK
            END IF
      {  AFTER DELETE
          IF l_ac > g_rec_b THEN
            LET l_ac = l_ac - 1
            CALL fgl_set_arr_curr(l_ac)
          END IF 
      }  
        ON ROW CHANGE
           IF INT_FLAG THEN                 #當系統判斷修改過時會執行此段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_get[l_ac].* = g_get_t.*
              CLOSE i502_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_get[l_ac].get01,-263,1)
              LET g_get[l_ac].* = g_get_t.*
           ELSE
              UPDATE get_file SET get01=g_get[l_ac].get01,
                                  get02=g_get[l_ac].get02
#              WHERE CURRENT OF i502_bcl        #TQC-AB0025 mark
               WHERE get01 = g_get_t.get01      #TQC-AB0025 add
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_get[l_ac].get01,SQLCA.sqlcode,0)   #No.FUN-660131
                 CALL cl_err3("upd","get_file",g_get_t.get01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 LET g_get[l_ac].* = g_get_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i502_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                                      
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN 
                  LET g_get[l_ac].* = g_get_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_get.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF 
               CLOSE i502_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i502_bcl                                                      
            COMMIT WORK            
            #CKP2
            #CALL g_get.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLN
            CALL i502_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有□
            IF INFIELD(get01) AND l_ac > 1 THEN
                LET g_get[l_ac].* = g_get[l_ac-1].*
                NEXT FIELD get01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
            CASE
                WHEN INFIELD(get01) CALL cl_fldhlp('get01')
                WHEN INFIELD(get02) CALL cl_fldhlp('get02')
                OTHERWISE           CALL cl_fldhlp('     ')
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
        
        END INPUT
 
    CLOSE i502_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i502_b_askkey()
    CLEAR FORM
    CALL g_get.clear()
    CONSTRUCT g_wc2 ON get01,get02
            FROM s_get[1].get01,s_get[1].get02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i502_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i502_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
    LET g_sql =
        "SELECT get01,get02",
        " FROM get_file",
        " WHERE ",p_wc2 CLIPPED,          
        " ORDER BY get01"
    PREPARE i502_pb FROM g_sql
    DECLARE get_curs CURSOR FOR i502_pb
 
    CALL g_get.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH get_curs INTO g_get[g_cnt].*   
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_get.deleteElement(g_cnt)
 
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i502_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_get TO s_get.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
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
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      #No.TQC-6C0157--begin
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #No.TQC-6C0157--end  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i502_out()
DEFINE
  l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
  l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680102 VARCHAR(20)
  l_za05          LIKE za_file.za05,
  sr RECORD
       get01      LIKE get_file.get01,
       get02      LIKE get_file.get02
  END RECORD
 
#No.TQC-710076 -- begin --
   IF cl_null(g_wc2) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
 
  CALL cl_wait()
  CALL cl_outnam('aooi502') RETURNING l_name
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT get01,get02", #TQC-7A0033
              "  FROM get_file ",           # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED,
              " ORDER BY get01 "
  PREPARE i502_p1 FROM g_sql                # RUNTIME 編譯
  DECLARE i502_co CURSOR FOR i502_p1
 
  START REPORT i502_rep TO l_name
 
  FOREACH i502_co INTO sr.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('Foreach:',SQLCA.sqlcode,1)    
       EXIT FOREACH
    END IF
    OUTPUT TO REPORT i502_rep(sr.*)
  END FOREACH
 
  FINISH REPORT i502_rep
 
  CLOSE i502_co
  ERROR ""
  CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i502_rep(sr)
DEFINE
  l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1)
  sr RECORD
     get01      LIKE get_file.get01,
     get02      LIKE get_file.get02
  END RECORD
 
  OUTPUT
    TOP MARGIN g_top_margin
    LEFT MARGIN g_left_margin
    BOTTOM MARGIN g_bottom_margin
    PAGE LENGTH g_line
 
   ORDER BY sr.get01
 
   FORMAT
     PAGE HEADER
       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
       PRINT
       LET g_pageno = g_pageno + 1
       LET pageno_total = PAGENO USING '<<<',"/pageno" 
       PRINT g_head CLIPPED,pageno_total     
 
       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
       PRINT g_dash[1,g_len]
 
       PRINT g_x[31],g_x[32]
       PRINT g_dash1 
       LET l_trailer_sw = 'y'
 
     ON EVERY ROW           
        PRINT COLUMN g_c[31],sr.get01 CLIPPED,
              COLUMN g_c[32],sr.get02 CLIPPED  
 
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
#No.FUN-780056 -end 
