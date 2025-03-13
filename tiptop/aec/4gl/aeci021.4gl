# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: aeci021.4gl
# Descriptions...: 異常除外屬性維護作業
# Date & Author..: 99/05/31 by patricia
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-510032 05/01/14 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei欄位型態轉換
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/07/04 By sherry 報表格式修改為p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_sgf           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        sgf01       LIKE sgf_file.sgf01,   #
        sgf02       LIKE sgf_file.sgf02,   #
        sgf03       LIKE sgf_file.sgf03,   #
        sgfacti     LIKE sgf_file.sgfacti  #資料有效
                    END RECORD,
    g_sgf_t         RECORD                 #程式變數 (舊值)
        sgf01       LIKE sgf_file.sgf01,   #
        sgf02       LIKE sgf_file.sgf02,   #
        sgf03       LIKE sgf_file.sgf03,   #
        sgfacti     LIKE sgf_file.sgfacti  #資料有效
                    END RECORD,
     g_wc2,g_sql,g_wc1    STRING,  #No.FUN-580092 HCN   
    l_za05          LIKE type_file.chr1000,  # No.FUN-680073  VARCHAR(40),
    g_flag          LIKE type_file.chr1,                #判斷誤動作存入        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680073 SMALLINT
    p_row,p_col     LIKE type_file.num5,                #No.FUN-680073 SMALLINT SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680073 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570110          #No.FUN-680073 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0100
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
    LET p_row = 5 LET p_col = 10
    OPEN WINDOW i021_w AT p_row,p_col WITH FORM "aec/42f/aeci021"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i021_b_fill(g_wc2)
    ERROR ""
    CALL i021_menu()
    CLOSE WINDOW i021_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
END MAIN
 
FUNCTION i021_menu()
 
   WHILE TRUE
      CALL i021_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i021_q() 
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i021_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN 
            #No.FUN-780037---Begin 
            #  CALL i021_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                 
               LET l_cmd = 'p_query "aeci021" "',g_wc2 CLIPPED,'"'              
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgf),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i021_q()
   CALL i021_b_askkey()
END FUNCTION
 
FUNCTION i021_b()
DEFINE
    l_sgf01         LIKE  sgf_file.sgf01,
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    s_acct          LIKE aab_file.aab02,                # No.FUN-680073 VARCHAR(06),   #SELECT npu_cost number880110  
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #No.FUN-680073  VARCHAR(01)
    l_allow_delete  LIKE type_file.dat                  #No.FUN-680073 VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sgf01,sgf02,sgf03,sgfacti FROM sgf_file WHERE sgf01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_sgf WITHOUT DEFAULTS FROM s_sgf.*
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
               LET g_sgf_t.* = g_sgf[l_ac].*  #BACKUP
#No.FUN-570110 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i021_set_entry(p_cmd)                                                                                           
               CALL i021_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--   
               BEGIN WORK
               OPEN i021_bcl USING g_sgf_t.sgf01
               IF STATUS THEN
                  CALL cl_err("OPEN i021_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i021_bcl INTO g_sgf[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_sgf_t.sgf01,STATUS,1) 
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
            CALL i021_set_entry(p_cmd)                                                                                           
            CALL i021_set_no_entry(p_cmd)                                                                                        
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--   
            INITIALIZE g_sgf[l_ac].* TO NULL      #900423
            LET g_sgf[l_ac].sgfacti = 'Y' 
            LET g_sgf_t.* = g_sgf[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sgf01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO sgf_file(sgf01,sgf02,sgf03,sgfacti,sgfuser,sgfgrup,sgfdate,sgforiu,sgforig)
          VALUES (g_sgf[l_ac].sgf01,g_sgf[l_ac].sgf02,
                  g_sgf[l_ac].sgf03,g_sgf[l_ac].sgfacti,
                  g_user,g_grup,g_today, g_user, g_grup)       #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_sgf[l_ac].sgf01,SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("ins","sgf_file",g_sgf[l_ac].sgf01,"",SQLCA.sqlcode,"","",1) #FUN-660091
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               COMMIT WORK
           END IF
 
        BEFORE FIELD sgf02
            IF NOT cl_null(g_sgf[l_ac].sgf01) THEN 
            IF g_sgf[l_ac].sgf01 != g_sgf_t.sgf01  OR
                cl_null(g_sgf_t.sgf01)  THEN
                  SELECT COUNT(*) INTO l_n FROM  sgf_file
                   WHERE sgf01 = g_sgf[l_ac].sgf01
                    IF l_n > 0 THEN 
                       CALL cl_err('','aec-008',0) 
                       NEXT FIELD sgf01
                    END IF
            END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
             IF g_sgf_t.sgf01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
            DELETE FROM sgf_file
                WHERE sgf01 = g_sgf_t.sgf01 
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_sgf_t.sgf01,SQLCA.sqlcode,0) #No.FUN-660091
                CALL cl_err3("del","sgf_file",g_sgf[l_ac].sgf01,"",SQLCA.sqlcode,"","",1) #FUN-660091
                ROLLBACK WORK
                CANCEL DELETE
            END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i021_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_sgf[l_ac].* = g_sgf_t.*
              CLOSE i021_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_sgf[l_ac].sgf01,-263,1)
              LET g_sgf[l_ac].* = g_sgf_t.*
           ELSE
              UPDATE sgf_file SET sgf01=g_sgf[l_ac].sgf01,
                                  sgf02=g_sgf[l_ac].sgf02,
                                  sgf03=g_sgf[l_ac].sgf03,
                                  sgfacti=g_sgf[l_ac].sgfacti,
                                  sgfmodu=g_today
               WHERE sgf01 = g_sgf_t.sgf01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('update sgf error',SQLCA.SQLCODE,0) #No.FUN-660091
                  CALL cl_err3("upd","sgf_file",g_sgf_t.sgf01,"",SQLCA.sqlcode,"","update sgf error !",1) #FUN-660091
                  LET g_sgf[l_ac].* = g_sgf_t.*
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
                  LET g_sgf[l_ac].* = g_sgf_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgf.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i021_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i021_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i021_b_askkey()
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
 
    CLOSE i021_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i021_b_askkey()
    CLEAR FORM
    CALL g_sgf.clear()
    CONSTRUCT g_wc2 ON sgf01, sgf02, sgf03, sgfacti 
            FROM s_sgf[1].sgf01,s_sgf[1].sgf02,s_sgf[1].sgf03,
                 s_sgf[1].sgfacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('sgfuser', 'sgfgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i021_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i021_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000 #No.FUN-680073 VARCHAR(200)
 
    LET g_sql =
        " SELECT sgf01,sgf02,sgf03,sgfacti",
        " FROM   sgf_file " ,
        " WHERE  ", p_wc2 CLIPPED,
        " ORDER BY sgf01, sgf02"
    PREPARE i021_pb FROM g_sql
    DECLARE sgf_curs CURSOR FOR i021_pb
 
    CALL g_sgf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH sgf_curs INTO g_sgf[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_sgf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i021_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgf TO s_sgf.* ATTRIBUTE(COUNT=g_rec_b, UNBUFFERED)
 
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
FUNCTION i021_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
        l_name          LIKE type_file.chr20,    # No.FUN-680073   VARCHAR(20),# External(Disk) file name 
        l_za05          LIKE type_file.chr1000,  # No.FUN-680073  VARCHAR(40),
        l_chr           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
        l_sgb   RECORD  LIKE  sgb_file.*,
    sr              RECORD
         sgf01    LIKE sgf_file.sgf01,
         sgf02    LIKE sgf_file.sgf02,
         sgf03    LIKE sgf_file.sgf03,
         sgfacti  LIKE sgf_file.sgfacti 
                    END RECORD
 
#No.TQC-710076 -- begin --
   IF cl_null(g_wc2) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL cl_wait()
    CALL cl_outnam('aeci021') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql= 
        " SELECT sgf01,sgf02,sgf03,sgfacti ",
        " FROM  sgf_file ",
        " ORDER BY sgf01"
    PREPARE i021_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i021_co                         # SCROLL CURSOR
          CURSOR FOR i021_p1
 
    START REPORT i021_rep TO l_name
 
    FOREACH i021_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i021_rep(sr.*)
    END FOREACH
    FINISH REPORT i021_rep
    CLOSE i021_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i021_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680073  VARCHAR(1),
        l_chr           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    sr              RECORD
         sgf01    LIKE sgf_file.sgf01,
         sgf02    LIKE sgf_file.sgf02,
         sgf03    LIKE sgf_file.sgf03,
         sgfacti  LIKE sgf_file.sgfacti 
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sgf01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            PRINT COLUMN g_c[31], sr.sgf01,
                  COLUMN g_c[32], sr.sgf02 CLIPPED,
                  COLUMN g_c[33], sr.sgf03 CLIPPED,
                  COLUMN g_c[34], sr.sgfacti 
           
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
#No.FUN-780037---End
 
#No.FUN-570110 --start--                                                                                                            
FUNCTION i021_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                    #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("sgf01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i021_set_no_entry(p_cmd)                                                                                                   
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                    #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("sgf01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--     
