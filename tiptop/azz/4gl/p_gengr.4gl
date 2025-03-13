# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: p_gengr.4gl
# Date & Author..: 12/06/26 By janet
# Descriptions...: 產生GRE的程式碼附加於r類程式後
# Modify.........: No.FUN-C60097 12/06/26 By janet 產生GRE的程式碼附加於r類程式後
# Modify.........: No.EXT-D20130 13/02/22 by odyliao 1.增加定義type陣列 2.預設字型為微軟正黑體 3.加上客製否判斷

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/p_gengr.global"

#自定義型別
TYPE markPostion_t RECORD
    startLn     LIKE type_file.num10,
    startCol    LIKE type_file.num10,
    endLn       LIKE type_file.num10,
    endCol      LIKE type_file.num10
END RECORD

#定義常數
CONSTANT GRMARK = "###GENGRE###"

#定義模組變數
PRIVATE DEFINE m_srcpath    STRING                          #4gl檔路徑
PRIVATE DEFINE m_trcnt      LIKE type_file.num10            #自訂Record個數
PRIVATE DEFINE m_mainLn     LIKE type_file.num10            #原始程式MAIN所在行數
PRIVATE DEFINE m_tmpcode    DYNAMIC ARRAY OF STRING         #產生的暫存程式碼陣列
PRIVATE DEFINE m_srccode    DYNAMIC ARRAY OF STRING         #原始程式碼陣列
PRIVATE DEFINE m_start      DATETIME HOUR TO FRACTION(5)    #執行開始時間
PRIVATE DEFINE m_end        DATETIME HOUR TO FRACTION(5)    #執行結束時間
PRIVATE DEFINE m_interval   INTERVAL HOUR TO FRACTION(5)    #執行時間
PRIVATE DEFINE m_grfuncname STRING                          #產生Genero Report準備資料FUNCTION的名稱
PRIVATE DEFINE m_marklines  DYNAMIC ARRAY OF markPostion_t
PRIVATE DEFINE m_picdirurl  STRING

MAIN
    OPTIONS                                     # 改變一些系統預設值
        #FIELD ORDER FORM,
        INPUT NO WRAP
        
    DEFER INTERRUPT                             # 擷取中斷鍵,由程式處理
        
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AZZ")) THEN
        EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW gengr_w AT 2,2 WITH FORM "azz/42f/p_gengr"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)

    CALL cl_ui_init()

   #EXT-D20130 add---(S)
   #語言別選項
    CALL cl_set_combo_lang("lang") 
   #EXT-D20130 add---(E)

    LET m_picdirurl = FGL_GETENV("FGLASIP"),"/doc/pic/"

    LET g_action_choice = "set_prog"
    WHILE(TRUE)
        #DISPLAY "g_action_choice=",g_action_choice
        CASE g_action_choice
            WHEN "set_prog"       #輸入單頭
                CALL gengr_i()
            WHEN "set_fields"       #設定欄位
                CALL gengr_b1()
            WHEN "set_orderby"
                CALL gengr_b2()
            WHEN "set_compute"
                CALL gengr_b3()
            WHEN "exit"             #離開
                EXIT WHILE
            WHEN "finish"
                CALL gengr_update_code()
                CALL p_gengr_ins_grwdata()
                CALL gengr_download()
                EXIT WHILE
            OTHERWISE
                EXIT WHILE
        END CASE
    END WHILE

    CLOSE WINDOW gengr_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#下載rdd及4rp至c:\tiptop
#FUN-C60097
PRIVATE FUNCTION gengr_download()
    DEFINE output_name     STRING
    DEFINE unix_4rp_path   STRING,
           unix_rdd_path   STRING,
           window_path     STRING
    #下載4rp
    LET unix_4rp_path = os.Path.join(FGL_GETENV(g_zz011),"4rp")
    LET unix_4rp_path = os.Path.join(unix_4rp_path,"src")
    LET unix_4rp_path = os.Path.join(unix_4rp_path,g_sr.prog||".4rp")
    LET window_path = "c:\\tiptop\\",g_sr.prog||".4rp"       
    LET status = cl_download_file(unix_4rp_path, window_path) 
    IF status then
       CALL cl_err(output_name,"amd-020",1)
       DISPLAY "Download OK!!"
    ELSE
       CALL cl_err(output_name,"amd-021",1)
       DISPLAY "Download fail!!"
    END IF

    #下載rdd
    LET unix_rdd_path = os.Path.join(FGL_GETENV(g_zz011),"4rp")
    LET unix_rdd_path = os.Path.join(unix_rdd_path,"rdd")
    LET unix_rdd_path = os.Path.join(unix_rdd_path,g_sr.prog||".rdd")
    LET window_path = "c:\\tiptop\\",g_sr.prog||".rdd"  
    LET status = cl_download_file(unix_rdd_path, window_path) 
    IF status then
       CALL cl_err(output_name,"amd-020",1)
       DISPLAY "Download OK!!"
    ELSE
       CALL cl_err(output_name,"amd-021",1)
       DISPLAY "Download fail!!"
    END IF
    
END FUNCTION 

PRIVATE FUNCTION gengr_i()
    DEFINE l_zaw14  LIKE zaw_file.zaw14 #紙張名稱
    DEFINE l_zaw15  LIKE zaw_file.zaw15 #紙張方向
    DEFINE l_sql    STRING

    LET g_action_choice = ""
    LET g_sr.prog = ""
   # LET g_sr.grprog = ""
    LET g_sr.papersize = "" #紙張名稱
    LET g_sr.paperori= ""  #紙張方向
    LET g_sr.progname = ""
    LET g_sr.reporttype = ""
    #LET g_sr.sets = "N" #套表先都隱藏 先不用此欄位
   #EXT-D20130 add--(S)
    LET g_sr.lang = g_lang
    CALL p_gengr_set_fontname()
   #EXT-D20130 add--(E)
    INPUT BY NAME g_sr.* ATTRIBUTE(UNBUFFERED,WITHOUT DEFAULTS)
        AFTER FIELD prog
            IF cl_null(g_sr.prog) THEN
                NEXT FIELD prog
            ELSE
                #檢查檔案是否存在zz_file裡
                SELECT zz01 FROM zz_file WHERE zz01 = g_sr.prog
                IF STATUS THEN
                    NEXT FIELD prog
                END IF

                #顯示程式名稱
                SELECT zz011,zz14 INTO g_zz011,g_sr.reporttype FROM zz_file WHERE zz01=g_sr.prog
                SELECT gaz03 INTO g_sr.progname FROM gaz_file WHERE gaz01 = g_sr.prog AND gaz02=g_lang
                DISPLAY BY NAME g_sr.progname
                DISPLAY BY NAME g_sr.reporttype

                #憑證類報表需顯示套表CheckBox,其他類則隱藏
                #IF g_sr.reporttype = "1" THEN
                    #CALL cl_set_comp_entry("sets",true)
                #ELSE
                    #CALL cl_set_comp_entry("sets",false)
                #END IF
                CALL cl_set_comp_entry("sets",false) #套表先都隱藏 先不用此欄位

                #抓zaw中的紙張大小與紙張方向

                #grprog不用了---MARK----
                #LET l_sql = "SELECT zaw14,zaw15 FROM zaw_file WHERE zaw01=?",
                            #" AND zaw02=? AND zaw05='default' AND zaw04='default'",
                            #" AND zaw10='std' AND zaw06=?"
                #DECLARE gengr_zaw_cur CURSOR FROM l_sql
                #OPEN gengr_zaw_cur USING g_sr.prog,g_sr.prog,g_lang
                #FETCH gengr_zaw_cur INTO l_zaw14,l_zaw15
                #CLOSE gengr_zaw_cur 
                #IF g_sr.prog[4] MATCHES "[r]" THEN 
                    #LET g_sr.grprog = g_sr.prog CLIPPED
                    #LET g_sr.grprog[4] = 'g'
                    #DISPLAY BY NAME g_sr.grprog
                #END IF
                #grprog不用了---MARK----
                
                #LET g_sr.papersize = l_zaw14
                #DISPLAY BY NAME g_sr.papersize
                #LET g_paper_ori = l_zaw15
            END IF


                     
        #sets欄先隱藏起來------mark--start----    
        #AFTER FIELD reporttype
            #IF g_sr.reporttype = "1" THEN
                #CALL cl_set_comp_entry("sets",true)
            #ELSE
                #CALL cl_set_comp_entry("sets",false)
            #END IF
#
        #ON CHANGE reporttype
            #IF g_sr.reporttype = "1" THEN
                #CALL cl_set_comp_entry("sets",true)
            #ELSE
                #CALL cl_set_comp_entry("sets",false)
            #END IF
         #sets欄先隱藏起來------mark--end---- 

       #EXT-D20130 add---(S)
         ON CHANGE lang
            CALL p_gengr_set_fontname()
       
         AFTER FIELD fontname
            IF NOT cl_null(g_sr.fontname) THEN
               IF NOT (g_sr.fontname = cl_getmsg('azz1312',0) OR
                       g_sr.fontname = 'SimHei' OR
                       g_sr.fontname = 'Arial Unicode MS') THEN
                  IF NOT cl_confirm('azz1313') THEN
                     NEXT FIELD CURRENT
                  END IF
               END IF
            END IF
       #EXT-D20130 add---(E)

        AFTER INPUT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                LET g_action_choice = "exit"
                EXIT INPUT
            END IF

            IF cl_null(g_sr.prog) OR cl_null(g_sr.progname) THEN
                NEXT FIELD prog
            END IF
            IF cl_null(g_sr.reporttype) THEN
                NEXT FIELD reporttype
            END IF
            IF cl_null(g_sr.papersize) THEN
                NEXT FIELD papersize
            END IF
            IF cl_null(g_sr.paperOri) THEN
                NEXT FIELD paperOri
            END IF
            LET g_paper_ori = g_sr.paperori 
            
            #複製檔案
            CALL copy_files()

            #複製程式資料
            #CALL copy_zz() #已會建立好
            
            LET g_action_choice = "set_fields"
            EXIT INPUT

        ON ACTION controlp
            CASE
                WHEN INFIELD(prog)
                    CALL cl_init_qry_var()
                    #LET g_qryparam.form = "q_zaw3" 
                    LET g_qryparam.form = "q_zz"                    
                    LET g_qryparam.arg1 =  g_lang                          
                    LET g_qryparam.default1 = g_sr.prog
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY "res:",g_qryparam.multiret
                    LET g_sr.prog = g_qryparam.multiret
                    DISPLAY BY NAME g_sr.prog
                    
                    NEXT FIELD prog
            END CASE
            
        ON ACTION about
            CALL cl_about()
            
        ON ACTION controlg
            CALL cl_cmdask()
            
        ON ACTION HELP
            CALL cl_show_help()
            
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
            
    END INPUT
    LET INT_FLAG = 0
    #明細類報表隱藏單頭
    IF g_sr.reporttype MATCHES "[234]" THEN
        CALL cl_set_comp_visible("Master",FALSE)
    ELSE
        #憑證類套表隱藏只顯示第一行單身
        IF  g_sr.reporttype = "1" AND g_sr.sets = "Y" THEN
        #IF g_sr.reporttype = "1"  THEN #sets先不用
            CALL cl_set_comp_visible("Master",FALSE)
            CALL cl_set_comp_visible("table5",FALSE)
            CALL cl_set_comp_visible("table6",FALSE)
        ELSE
            CALL cl_set_comp_visible("Master",TRUE)
        END IF
    END IF
END FUNCTION

#設定報表欄位
PRIVATE FUNCTION gengr_b1()
    DEFINE l_dnd        ui.DragDrop
    DEFINE l_drag_src   STRING
    DEFINE l_drag_dst   STRING
    DEFINE l_drag_index LIKE type_file.num10
    DEFINE l_drop_index LIKE type_file.num10
    DEFINE l_insertpos  LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_tmp        field_t
    DEFINE l_flag       LIKE type_file.num5

    LET g_action_choice = ""
    DIALOG ATTRIBUTE(UNBUFFERED)
        DISPLAY ARRAY g_table1 TO sr1.* #sr1=table1
            ON DRAG_START(l_dnd) 
                LET l_drag_src = "sr1"
                LET l_drag_index = DIALOG.getCurrentRow("sr1") #取得此行INDEX
            ON DRAG_FINISHED(l_dnd)
                CALL DIALOG.setSelectionRange("sr1",1,-1,0) #select range從頭到尾
                INITIALIZE l_drag_src TO NULL  #初始化成null
                INITIALIZE l_drag_index TO NULL
                INITIALIZE l_drop_index TO NULL
            ON DRAG_ENTER(l_dnd) 
                IF l_drag_src IS NULL OR l_drag_index IS NULL THEN
                    CALL l_dnd.setOperation(NULL)  #定義DRAG & DROP操作的類型，NULL取消/拒絕拖拉
                END IF
            ON DROP (l_dnd)
                LET l_drag_dst = "sr1"   #可以拖的欄位視窗，會愈拖愈少
                LET l_drop_index = l_dnd.getLocationRow() #得到滑鼠POINTING的ROW
                CASE l_drag_src
                    #改變欄位順序
                    WHEN "sr1"
                        INITIALIZE l_tmp TO NULL
                        LET l_flag = FALSE 
                        FOR l_i = 1 TO g_table1.getLength()
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN #被選到的行
                                LET l_tmp.* = g_table1[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i) #刪除此行
                                LET l_flag = TRUE
                                EXIT FOR
                            END IF
                        END FOR
                        IF l_flag THEN #有選行
                            IF l_drop_index > l_drag_index THEN  #滑鼠指的行>當下行的INDEX
                                LET l_insertpos = l_drop_index - 1  #存入的POS=滑鼠指的行-1
                            ELSE
                                LET l_insertpos = l_drop_index  #存入的POS=滑鼠指的行
                            END IF                        
                            CALL DIALOG.insertRow(l_drag_dst,l_insertpos) #目前陣列在POS增加一行
                            CALL DIALOG.setSelectionRange(l_drag_dst,l_insertpos,l_insertpos,TRUE) #set選擇range
                            LET g_table1[l_insertpos].* = l_tmp.*  #將資料再存入
                        END IF
                    WHEN "sr2"
                        FOR l_i = g_table2.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index) #目的陣列增加
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table1[l_drop_index].* = g_table2[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i) #來源陣列刪除
                            END IF
                        END FOR
                    WHEN "sr3"
                        FOR l_i = g_table3.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table1[l_drop_index].* = g_table3[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr4"
                        FOR l_i = g_table4.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table1[l_drop_index].* = g_table4[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr5"
                        FOR l_i = g_table5.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table1[l_drop_index].* = g_table5[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr6"
                        FOR l_i = g_table6.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table1[l_drop_index].* = g_table6[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                END CASE
        END DISPLAY
        
        DISPLAY ARRAY g_table2 TO sr2.*
            ON DRAG_START(l_dnd) 
                LET l_drag_src = "sr2"
                LET l_drag_index = DIALOG.getCurrentRow("sr2")
            ON DRAG_FINISHED(l_dnd)
                CALL DIALOG.setSelectionRange("sr2",1,-1,0)
                INITIALIZE l_drag_src TO NULL
                INITIALIZE l_drag_index TO NULL
                INITIALIZE l_drop_index TO NULL
            ON DRAG_ENTER(l_dnd) 
                IF l_drag_src IS NULL OR l_drag_index IS NULL THEN 
                    CALL l_dnd.setOperation(NULL)
                END IF
            ON DROP (l_dnd)
                LET l_drag_dst = "sr2"
                LET l_drop_index = l_dnd.getLocationRow()
                CASE l_drag_src
                    WHEN "sr1"
                        FOR l_i = g_table1.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table2[l_drop_index].* = g_table1[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    #改變欄位順序
                    WHEN "sr2"
                        INITIALIZE l_tmp TO NULL
                        LET l_flag = FALSE 
                        FOR l_i = 1 TO g_table2.getLength()
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                LET l_tmp.* = g_table2[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                                LET l_flag = TRUE
                                EXIT FOR
                            END IF
                        END FOR
                        IF l_flag THEN
                            IF l_drop_index > l_drag_index THEN
                                LET l_insertpos = l_drop_index - 1
                            ELSE
                                LET l_insertpos = l_drop_index
                            END IF                        
                            CALL DIALOG.insertRow(l_drag_dst,l_insertpos)
                            CALL DIALOG.setSelectionRange(l_drag_dst,l_insertpos,l_insertpos,TRUE)
                            LET g_table2[l_insertpos].* = l_tmp.*
                        END IF
                    WHEN "sr3"
                        FOR l_i = g_table3.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table2[l_drop_index].* = g_table3[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr4"
                        FOR l_i = g_table4.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table2[l_drop_index].* = g_table4[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr5"
                        FOR l_i = g_table5.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table2[l_drop_index].* = g_table5[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr6"
                        FOR l_i = g_table6.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table2[l_drop_index].* = g_table6[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                END CASE
        END DISPLAY
        
        DISPLAY ARRAY g_table3 TO sr3.*
            ON DRAG_START(l_dnd) 
                LET l_drag_src = "sr3"
                LET l_drag_index = DIALOG.getCurrentRow("sr3")
            ON DRAG_FINISHED(l_dnd)
                CALL DIALOG.setSelectionRange("sr3",1,-1,0)
                INITIALIZE l_drag_src TO NULL
                INITIALIZE l_drag_index TO NULL
                INITIALIZE l_drop_index TO NULL
            ON DRAG_ENTER(l_dnd) 
                IF l_drag_src IS NULL OR l_drag_index IS NULL THEN
                    CALL l_dnd.setOperation(NULL)
                END IF
            ON DROP (l_dnd)
                LET l_drag_dst = "sr3"
                LET l_drop_index = l_dnd.getLocationRow()
                CASE l_drag_src
                    WHEN "sr1"
                        FOR l_i = g_table1.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table3[l_drop_index].* = g_table1[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr2"
                        FOR l_i = g_table2.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table3[l_drop_index].* = g_table2[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    #改變欄位順序
                    WHEN "sr3"
                        INITIALIZE l_tmp TO NULL
                        LET l_flag = FALSE 
                        FOR l_i = 1 TO g_table3.getLength()
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                LET l_tmp.* = g_table3[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                                LET l_flag = TRUE
                                EXIT FOR
                            END IF
                        END FOR
                        IF l_flag THEN
                            IF l_drop_index > l_drag_index THEN
                                LET l_insertpos = l_drop_index - 1
                            ELSE
                                LET l_insertpos = l_drop_index
                            END IF                        
                            CALL DIALOG.insertRow(l_drag_dst,l_insertpos)
                            CALL DIALOG.setSelectionRange(l_drag_dst,l_insertpos,l_insertpos,TRUE)
                            LET g_table3[l_insertpos].* = l_tmp.*
                        END IF
                    WHEN "sr4"
                        FOR l_i = g_table4.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table3[l_drop_index].* = g_table4[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr5"
                        FOR l_i = g_table5.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table3[l_drop_index].* = g_table5[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr6"
                        FOR l_i = g_table6.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table3[l_drop_index].* = g_table6[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                END CASE
        END DISPLAY
        
        DISPLAY ARRAY g_table4 TO sr4.*
            ON DRAG_START(l_dnd) 
                LET l_drag_src = "sr4"
                LET l_drag_index = DIALOG.getCurrentRow("sr4")
            ON DRAG_FINISHED(l_dnd)
                CALL DIALOG.setSelectionRange("sr4",1,-1,0)
                INITIALIZE l_drag_src TO NULL
                INITIALIZE l_drag_index TO NULL
                INITIALIZE l_drop_index TO NULL
            ON DRAG_ENTER(l_dnd) 
                IF l_drag_src IS NULL OR l_drag_index IS NULL THEN 
                    CALL l_dnd.setOperation(NULL)
                END IF
            ON DROP (l_dnd)
                LET l_drag_dst = "sr4"
                LET l_drop_index = l_dnd.getLocationRow()
                CASE l_drag_src
                    WHEN "sr1"
                        FOR l_i = g_table1.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table4[l_drop_index].* = g_table1[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr2"
                        FOR l_i = g_table2.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table4[l_drop_index].* = g_table2[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr3"
                        FOR l_i = g_table3.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table4[l_drop_index].* = g_table3[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    #改變欄位順序
                    WHEN "sr4"
                        INITIALIZE l_tmp TO NULL
                        LET l_flag = FALSE 
                        FOR l_i = 1 TO g_table4.getLength()
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                LET l_tmp.* = g_table4[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                                LET l_flag = TRUE
                                EXIT FOR
                            END IF
                        END FOR
                        IF l_flag THEN
                            IF l_drop_index > l_drag_index THEN
                                LET l_insertpos = l_drop_index - 1
                            ELSE
                                LET l_insertpos = l_drop_index
                            END IF                        
                            CALL DIALOG.insertRow(l_drag_dst,l_insertpos)
                            CALL DIALOG.setSelectionRange(l_drag_dst,l_insertpos,l_insertpos,TRUE)
                            LET g_table4[l_insertpos].* = l_tmp.*
                        END IF
                    WHEN "sr5"
                        FOR l_i = g_table5.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table4[l_drop_index].* = g_table5[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr6"
                        FOR l_i = g_table6.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table4[l_drop_index].* = g_table6[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                END CASE
        END DISPLAY
        
        DISPLAY ARRAY g_table5 TO sr5.*
            ON DRAG_START(l_dnd) 
                LET l_drag_src = "sr5"
                LET l_drag_index = DIALOG.getCurrentRow("sr5")
            ON DRAG_FINISHED(l_dnd)
                CALL DIALOG.setSelectionRange("sr5",1,-1,0)
                INITIALIZE l_drag_src TO NULL
                INITIALIZE l_drag_index TO NULL
                INITIALIZE l_drop_index TO NULL
            ON DRAG_ENTER(l_dnd) 
                IF l_drag_src IS NULL OR l_drag_index IS NULL THEN
                    CALL l_dnd.setOperation(NULL)
                END IF
            ON DROP (l_dnd)
                LET l_drag_dst = "sr5"
                LET l_drop_index = l_dnd.getLocationRow()
                CASE l_drag_src
                    WHEN "sr1"
                        FOR l_i = g_table1.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table5[l_drop_index].* = g_table1[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr2"
                        FOR l_i = g_table2.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table5[l_drop_index].* = g_table2[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr3"
                        FOR l_i = g_table3.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table5[l_drop_index].* = g_table3[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr4"
                        FOR l_i = g_table4.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table5[l_drop_index].* = g_table4[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    #改變欄位順序
                    WHEN "sr5"
                        INITIALIZE l_tmp TO NULL
                        LET l_flag = FALSE 
                        FOR l_i = 1 TO g_table5.getLength()
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                LET l_tmp.* = g_table5[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                                LET l_flag = TRUE
                                EXIT FOR
                            END IF
                        END FOR
                        IF l_flag THEN
                            IF l_drop_index > l_drag_index THEN
                                LET l_insertpos = l_drop_index - 1
                            ELSE
                                LET l_insertpos = l_drop_index
                            END IF                        
                            CALL DIALOG.insertRow(l_drag_dst,l_insertpos)
                            CALL DIALOG.setSelectionRange(l_drag_dst,l_insertpos,l_insertpos,TRUE)
                            LET g_table5[l_insertpos].* = l_tmp.*
                        END IF
                    WHEN "sr6"
                        FOR l_i = g_table6.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table5[l_drop_index].* = g_table6[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                END CASE
        END DISPLAY
        
        DISPLAY ARRAY g_table6 TO sr6.*
            ON DRAG_START(l_dnd) 
                LET l_drag_src = "sr6"
                LET l_drag_index = DIALOG.getCurrentRow("sr6")
            ON DRAG_FINISHED(l_dnd)
                CALL DIALOG.setSelectionRange("sr6",1,-1,0)
                INITIALIZE l_drag_src TO NULL
                INITIALIZE l_drag_index TO NULL
                INITIALIZE l_drop_index TO NULL
            ON DRAG_ENTER(l_dnd) 
                IF l_drag_src IS NULL OR l_drag_index IS NULL THEN
                    CALL l_dnd.setOperation(NULL)
                END IF
            ON DROP (l_dnd)
                LET l_drag_dst = "sr6"
                LET l_drop_index = l_dnd.getLocationRow()
                CASE l_drag_src
                    WHEN "sr1"
                        FOR l_i = g_table1.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table6[l_drop_index].* = g_table1[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr2"
                        FOR l_i = g_table2.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table6[l_drop_index].* = g_table2[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr3"
                        FOR l_i = g_table3.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table6[l_drop_index].* = g_table3[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr4"
                        FOR l_i = g_table4.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table6[l_drop_index].* = g_table4[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    WHEN "sr5"
                        FOR l_i = g_table5.getLength() TO 1 STEP -1
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                CALL DIALOG.insertRow(l_drag_dst,l_drop_index)
                                CALL DIALOG.setSelectionRange(l_drag_dst,l_drop_index,l_drop_index,TRUE)
                                LET g_table6[l_drop_index].* = g_table5[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                            END IF
                        END FOR
                    #改變欄位順序
                    WHEN "sr6"
                        INITIALIZE l_tmp TO NULL
                        LET l_flag = FALSE 
                        FOR l_i = 1 TO g_table6.getLength()
                            IF DIALOG.isRowSelected(l_drag_src,l_i) THEN
                                LET l_tmp.* = g_table6[l_i].*
                                CALL DIALOG.deleteRow(l_drag_src,l_i)
                                LET l_flag = TRUE
                                EXIT FOR
                            END IF
                        END FOR
                        IF l_flag THEN
                            IF l_drop_index > l_drag_index THEN
                                LET l_insertpos = l_drop_index - 1
                            ELSE
                                LET l_insertpos = l_drop_index
                            END IF                        
                            CALL DIALOG.insertRow(l_drag_dst,l_insertpos)
                            CALL DIALOG.setSelectionRange(l_drag_dst,l_insertpos,l_insertpos,TRUE)
                            LET g_table6[l_insertpos].* = l_tmp.*
                        END IF
                END CASE
        END DISPLAY

        BEFORE DIALOG
            --switch on multiple row selection
            CALL DIALOG.setSelectionMode("sr1",1) #多行，0:單行
            CALL DIALOG.setSelectionMode("sr2",1)
            CALL DIALOG.setSelectionMode("sr3",1)
            CALL DIALOG.setSelectionMode("sr4",1)
            CALL DIALOG.setSelectionMode("sr5",1)
            CALL DIALOG.setSelectionMode("sr6",1)

        ON ACTION maintain_b2
            LET g_action_choice = "set_orderby"  
            EXIT DIALOG 
        ON ACTION maintain_b3
            LET g_action_choice = "set_compute"  
            EXIT DIALOG 
      
        ON ACTION skip1
            CONTINUE DIALOG
            
        ON ACTION ACCEPT
            LET g_action_choice = "set_orderby"
            EXIT DIALOG
        ON ACTION CANCEL
            LET g_action_choice = "exit"
            EXIT DIALOG
    END DIALOG

    IF NOT has_rows() THEN
        LET g_action_choice = "exit"
    END IF
END FUNCTION

#設定欄位排序
PRIVATE FUNCTION gengr_b2()
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_ac         LIKE type_file.num10
    DEFINE l_ordcnt     LIKE type_file.num10
    DEFINE l_n          LIKE type_file.num10
    DEFINE l_comboBox   ui.ComboBox
    DEFINE l_flag       LIKE type_file.num5
    DEFINE l_tmpfid     STRING

    LET g_action_choice = ""
    #設定版面顯示欄位
    CALL FGL_DIALOG_SETFIELDORDER(FALSE) #設定欄位順序關掉 TRUE:是開啟S

    #建立欄位代號下拉選單
    LET l_comboBox = ui.ComboBox.forName("fid1")
    FOR l_i = 1 TO g_flddef.getLength()
        LET l_tmpfid = get_fid(g_flddef[l_i].recno,g_flddef[l_i].field_name)
        CALL l_comboBox.addItem(l_tmpfid,l_tmpfid)
    END FOR
    
    CALL FGL_DIALOG_SETFIELDORDER(FALSE)
    #init order screen record array
    LET l_ac = 0
    
    INPUT ARRAY g_ord WITHOUT DEFAULTS FROM sr_ord.*
        ATTRIBUTE(COUNT = l_ordcnt,MAXCOUNT = g_max_rec,UNBUFFERED,
        INSERT ROW = TRUE,DELETE ROW = TRUE,APPEND ROW = TRUE)

        BEFORE INPUT
            IF l_ordcnt != 0 THEN
                CALL DIALOG.setCurrentRow("sr_ord",l_ac)
            END IF
     
        BEFORE ROW
            LET l_ac = DIALOG.getCurrentRow("sr_ord")
            LET l_n  = DIALOG.getArrayLength("sr_ord")
            LET l_ordcnt = DIALOG.getArrayLength("sr_ord")
            DISPLAY l_ordcnt TO cnt
            
        BEFORE INSERT
            INITIALIZE g_ord[l_ac].* TO NULL
            LET g_ord[l_ac].no1 = l_ac
            LET g_ord[l_ac].grup1 = 'Y'
            LET g_ord[l_ac].nextpage1 = 'N'
            LET g_ord[l_ac].order1 = '1'
            NEXT FIELD fid1
            
        ON CHANGE fid1 #抓欄位別名
            LET g_ord[l_ac].fname1 = get_field_alias(g_ord[l_ac].fid1)

        AFTER FIELD fid1
            LET l_flag = FALSE
            FOR l_i = 1 TO l_ac
                IF g_ord[l_ac].fid1 = g_ord[l_i].fid1 AND l_i != l_ac THEN
                    LET l_flag = TRUE
                    EXIT FOR
                END IF
            END FOR
            IF l_flag THEN
                CALL cl_err('',-239,0)
                CALL g_ord.deleteElement(l_ac)
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CANCEL INSERT
            END IF
            LET l_ordcnt = l_ordcnt + 1
            DISPLAY l_ordcnt TO cnt

        BEFORE DELETE                            #是否取消單身
            LET l_ordcnt = l_ordcnt - 1
            DISPLAY l_ordcnt TO cnt

        AFTER ROW
            LET l_ac = DIALOG.getCurrentRow("sr_ord") #目前欄位
     
        ON ACTION CONTROLO                       #沿用所有欄位
            IF l_ac > 1 THEN
                LET g_ord[l_ac].* = g_ord[l_ac - 1].* 
                LET g_ord[l_ac].no1 = g_ord[l_ac - 1].no1 + 1 
                NEXT FIELD fid1
            END IF
        
        ON ACTION CONTROLG
            CALL cl_cmdask() #詢問使用者欲執行程式, 並執行之

        ON ACTION CONTROLR
            CALL cl_show_req_fields() #顯現畫面上需要輸入卻還未輸入的所有欄位.

        ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                RETURNING g_fld_name,g_frm_name #回傳目前interface根node的欄位name及from名稱
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913  #畫面欄位說明資料維護作業

        ON IDLE g_idle_seconds
            CALL cl_on_idle() #在 ON IDLE 時的處理.
            CONTINUE INPUT

        ON ACTION maintain_b1
            LET g_action_choice = "set_fields"  
            EXIT INPUT 
        ON ACTION maintain_b3
            LET g_action_choice = "set_compute"  
            EXIT INPUT 
        
        ON ACTION ACCEPT
            IF g_sr.reporttype = 1 AND (g_ord.getLength() < 1 
                OR (g_ord.getLength() >= 1 AND cl_null(g_ord[1].fid1)))
                AND g_sr.sets = "N" #報表是1:憑證，g_ord沒資料，不是套表
            THEN
                NEXT FIELD fid1
            ELSE
                LET g_action_choice = "set_compute"
                EXIT INPUT
            END IF
            
        ON ACTION CANCEL
            IF g_sr.reporttype = 1 AND (g_ord.getLength() < 1 OR (g_ord.getLength() >= 1 AND cl_null(g_ord[1].fid1))) THEN
                NEXT FIELD fid1
            ELSE
                LET g_action_choice = "exit"
                EXIT INPUT
            END IF
            
        ON ACTION skip1
            CONTINUE INPUT
    END INPUT

    LET INT_FLAG = 0
END FUNCTION

#設定計算式
PRIVATE FUNCTION gengr_b3()
    DEFINE l_ac2        LIKE type_file.num10
    DEFINE l_ordcnt2    LIKE type_file.num10
    DEFINE l_n2         LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_comboBox   ui.ComboBox
    DEFINE l_comboBox2  ui.ComboBox

    LET g_action_choice = ""
    #設定版面顯示欄位
    CALL FGL_DIALOG_SETFIELDORDER(FALSE)

    #設定群組欄位下拉選單
    LET l_comboBox = ui.ComboBox.forName("fid2")
    FOR l_i = 1 TO g_table2.getLength()
        #IF g_table2[l_i].fieldattr = m_picdirurl||"currency16.gif"
            #OR g_table2[l_i].fieldattr = m_picdirurl||"batch16.gif"
        #THEN
            CALL l_comboBox.addItem(g_table2[l_i].fldid,g_table2[l_i].fldid)
        #END IF
    END FOR
    FOR l_i = 1 TO g_table3.getLength()
        #IF g_table3[l_i].fieldattr = m_picdirurl||"currency16.gif"
            #OR g_table3[l_i].fieldattr = m_picdirurl||"batch16.gif"
        #THEN
            CALL l_comboBox.addItem(g_table3[l_i].fldid,g_table3[l_i].fldid)
        #END IF
    END FOR
    FOR l_i = 1 TO g_table4.getLength()
        #IF g_table4[l_i].fieldattr = m_picdirurl||"currency16.gif"
            #OR g_table4[l_i].fieldattr = m_picdirurl||"batch16.gif"
        #THEN
            CALL l_comboBox.addItem(g_table4[l_i].fldid,g_table4[l_i].fldid)
        #END IF
    END FOR
    FOR l_i = 1 TO g_table5.getLength()
        #IF g_table5[l_i].fieldattr = m_picdirurl||"currency16.gif"
            #OR g_table5[l_i].fieldattr = m_picdirurl||"batch16.gif"
        #THEN
            CALL l_comboBox.addItem(g_table5[l_i].fldid,g_table5[l_i].fldid)
        #END IF
    END FOR
    FOR l_i = 1 TO g_table6.getLength()
        #IF g_table6[l_i].fieldattr = m_picdirurl||"currency16.gif"
            #OR g_table6[l_i].fieldattr = m_picdirurl||"batch16.gif"
        #THEN
            CALL l_comboBox.addItem(g_table6[l_i].fldid,g_table6[l_i].fldid)
        #END IF
    END FOR

    LET l_comboBox2 = ui.ComboBox.forName("gfid2")
    CALL l_comboBox2.addItem(null,null)
    FOR l_i = 1 TO g_ord.getLength()
        CALL l_comboBox2.addItem(g_ord[l_i].fid1,g_ord[l_i].fid1)
    END FOR
    
    LET l_ac2 = 0
#設定計算頁
    INPUT ARRAY g_comp WITHOUT DEFAULTS FROM sr_comp.*
        ATTRIBUTE(COUNT = l_ordcnt2,MAXCOUNT = g_max_rec,UNBUFFERED,
        INSERT ROW = TRUE,DELETE ROW = TRUE,APPEND ROW = TRUE)
        
        BEFORE INPUT
            IF l_ordcnt2 != 0 THEN
                CALL DIALOG.setCurrentRow("sr_comp",l_ac2)
            END IF

        BEFORE ROW
            LET l_ac2 = DIALOG.getCurrentRow("sr_comp")
            LET l_n2  = DIALOG.getArrayLength("sr_comp")
            LET l_ordcnt2 = DIALOG.getArrayLength("sr_comp")
            DISPLAY l_ordcnt2 TO cnt1

        BEFORE INSERT
            LET l_n2 = ARR_COUNT()
            INITIALIZE g_comp[l_ac2].* TO NULL
            LET g_comp[l_ac2].no2 = l_ac2
            LET g_comp[l_ac2].aggr2 = 'A'
            LET g_comp[l_ac2].disp2 = '1'
            NEXT FIELD fid2

        ON CHANGE fid2
            LET g_comp[l_ac2].fname2 = get_field_alias(g_comp[l_ac2].fid2)

        #ON CHANGE gfid2
            #FOR l_i = 1 TO g_ord.getLength()
                #IF g_comp[l_ac2].gfid2 CLIPPED = g_ord[l_i].fid1 CLIPPED THEN
                    #LET g_comp[l_ac2].gfname2 = g_ord[l_i].fname1
                    #EXIT FOR
                #END IF
            #END FOR

        AFTER INSERT
            LET l_ordcnt2 = l_ordcnt2 + 1
            DISPLAY l_ordcnt2 TO cnt1

        BEFORE DELETE                            #是否取消單身
            LET l_ordcnt2 = l_ordcnt2 - 1
            DISPLAY l_ordcnt2 TO cnt1

        AFTER ROW
            LET l_ac2 = DIALOG.getArrayLength("s_comp")
            
        ON ACTION CONTROLO                       #沿用所有欄位 預設上筆資料
            IF l_ac2 > 1 THEN
                LET g_comp[l_ac2].* = g_comp[l_ac2 - 1].* 
                LET g_comp[l_ac2].no2 = g_comp[l_ac2 - 1].no2 + 1 
                NEXT FIELD fid2
            END IF
        ON ACTION CONTROLG #開窗查詢
            CALL cl_cmdask()

        ON ACTION CONTROLR
            CALL cl_show_req_fields() #回傳需要輸入的欄位

        ON ACTION CONTROLF #開啟欄位說明
            CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON ACTION maintain_b1
            LET g_action_choice = "set_fields"  
            EXIT INPUT 
        ON ACTION maintain_b2
            LET g_action_choice = "set_orderby"  
            EXIT INPUT           
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
            
        ON ACTION ACCEPT
            LET g_action_choice = "finish"
            EXIT INPUT
            
        ON ACTION CANCEL
            LET g_action_choice = "exit"
            EXIT INPUT
            
        ON ACTION skip1
            CONTINUE INPUT
    END INPUT
    LET INT_FLAG = 0
END FUNCTION

#將產生程式碼寫入檔案並執行編譯
PRIVATE FUNCTION gengr_update_code()
    DEFINE l_cmd    STRING
    DEFINE l_pwd    STRING
    DEFINE l_dir    STRING
    
    CALL add_grw_code()
    CALL add_mark(m_tmpcode)  
    CALL append_array(m_srccode,m_tmpcode,true)
    CALL save_file(m_srcpath)
    #清除陣列
    CALL m_tmpcode.clear()
    CALL m_srccode.clear()
    #產生4rp
    CALL p_read4rp_gr()

    #編譯產生的程式碼
    LET l_pwd = os.Path.pwd()
    LET l_dir = os.Path.join(FGL_GETENV(g_zz011),"4gl")
    IF os.Path.chdir(l_dir) THEN
        LET l_cmd = "r.c2 ",g_sr.prog
        DISPLAY "cmd: ",l_cmd
        RUN l_cmd
        LET l_cmd = "r.rdd ",g_sr.prog
        DISPLAY "cmd: ",l_cmd
        RUN l_cmd
        LET l_cmd = "r.l2 ",g_sr.prog
        DISPLAY "cmd: ",l_cmd
        RUN l_cmd
        IF os.Path.chdir(l_pwd) THEN END IF
    END IF
     #編譯畫面

    #LET l_dir = os.Path.join(FGL_GETENV(g_zz011),"4fd")
    #IF os.Path.chdir(l_dir) THEN
        #LET l_cmd = "r.f2 ",g_sr.prog
        #DISPLAY "cmd: ",l_cmd
        #RUN l_cmd
        #LET l_cmd = "r.gf ",g_sr.prog," 0 p"
        #DISPLAY "cmd: ",l_cmd
        #RUN l_cmd
        #IF os.Path.chdir(l_pwd) THEN END IF
    #END IF

    CALL cl_msgany(1,1,"Genero Report報表程式碼已自動產生.")
END FUNCTION

#分析原始程式並產生Genero Report程式段
PRIVATE FUNCTION parse_src_code()
    DEFINE l_tmpline    STRING  #目前所在行內容
    DEFINE l_utmpline   STRING  #目前所在行轉大寫後的內容
    DEFINE l_varname    STRING  #變數名稱字串
    DEFINE l_paramstr   STRING  #參數字串
    DEFINE l_tmpTabLn   LIKE type_file.num10 #cl_prt_temptable()所在行數
    DEFINE l_lastLn     LIKE type_file.num10 #原始程式最後比對的行數
    DEFINE l_cs3Ln      LIKE type_file.num10 #cl_prt_cs3()所在行數
    DEFINE l_ttsqlLnS   LIKE type_file.num10 #TempTable SQL開始行數
    DEFINE l_ttsqlLnE   LIKE type_file.num10 #TempTable SQL結束行數
    DEFINE l_cs3sqlLnS  LIKE type_file.num10 #cs3 SQL開始行數
    DEFINE l_cs3sqlLnE  LIKE type_file.num10 #cs3 SQL結束行數
    DEFINE l_cs3strLnS  LIKE type_file.num10 #cs3 Str開始行數
    DEFINE l_cs3strLnE  LIKE type_file.num10 #cs3 Str結束行數
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_gaq07      LIKE gaq_file.gaq07
    DEFINE l_udatatype  STRING
    DEFINE l_gr_find    STRING      #程式代號第4到最後 ex:g410
    DEFINE l_add_grdata LIKE type_file.num5 #找END FUNCTION
    DEFINE l_progLn     LIKE type_file.num10 #找出g410 行數

    
    CALL m_tmpcode.clear()
    #讀進原始碼檔
    CALL load_source(m_srcpath,m_srccode)

    IF chk_generated(m_srccode) THEN  #檢查是否有GREMARK
        CALL cl_msgany(1,1,"4GL程式碼已執行過本產生器,不可重複執行!!")
        EXIT PROGRAM 2
    END IF
    
    #找出cl_prt_temptable()的程式段
    LET m_mainLn = 0
    LET l_tmpTabLn = 0
    LET l_lastLn = 1
    LET m_trcnt = 0
    FOR l_i = 1 TO m_srccode.getLength()
        LET l_tmpline = rm_line_mark(m_srccode[l_i]) #取消掉MARK行
        
        IF l_tmpline IS NOT NULL THEN
            LET l_paramstr = get_substr(l_tmpline,"cl_prt_temptable(",")")
            #找到cl_prt_temptable()該行
            IF l_paramstr IS NOT NULL THEN
                #設定cl_prt_temptable()所在行數
                LET l_tmpTabLn = l_i
                LET l_varname = get_str_part(l_paramstr,",",-1)
                CALL find_lineno(l_varname,l_lastLn,l_tmpTabLn)
                    RETURNING l_ttsqlLnS,l_ttsqlLnE
                #產生TYPE RECORD定義程式段
                LET m_trcnt = m_trcnt + 1
                CALL add_typedef_code(m_tmpcode,l_ttsqlLnS,l_ttsqlLnE) #120629 janet 不用再DELFINE
                #將最後比對行數移到目前行
                LET l_lastLn = l_tmpTabLn
            END IF

            IF m_mainLn <= 0 THEN
                LET l_utmpline = l_tmpline.toUpperCase()
                IF l_utmpline.getIndexOf("MAIN",1) > 0 THEN
                    LET m_mainLn = l_i
                    #DISPLAY "m_mainLn=",m_mainLn
                END IF
            END IF
        END IF
    END FOR

    #找出cl_prt_cs3()程式段
    #LET l_cs3Ln = 0
    #FOR l_i = l_tmpTabLn + 1 TO m_srccode.getLength()
        #LET l_tmpline = rm_line_mark(m_srccode[l_i])
        #IF l_tmpline IS NOT NULL THEN
            #IF l_cs3Ln <= 0 THEN
                #LET l_paramstr = get_substr(l_tmpline,"cl_prt_cs3(",")")
                #找到cl_prt_cs3()該行
                #IF l_paramstr IS NOT NULL THEN
                    #LET l_cs3Ln = l_i
                    #找cs3 str參數程式段
                    #LET l_varname = get_str_part(l_paramstr,",",-1)
                    #CALL find_lineno(l_varname,l_tmpTabLn + 1,l_cs3Ln)
                        #RETURNING l_cs3strLnS,l_cs3strLnE
#
                    #找cs3 sql參數程式段
                    #LET l_varname = get_str_part(l_paramstr,",",-2)
                    #CALL find_lineno(l_varname,l_tmpTabLn + 1,l_cs3Ln)
                        #RETURNING l_cs3sqlLnS,l_cs3sqlLnE
#
                    #將CR程式段註解
                    #LET m_srccode[l_cs3Ln] = GRMARK,m_srccode[l_cs3Ln]
#
                    #IF l_cs3strLnS > 0 AND l_cs3strLnE > 0 THEN
                        #FOR l_i = l_cs3strLnS TO l_cs3strLnE
                            #LET m_srccode[l_i] = GRMARK,m_srccode[l_i]
                        #END FOR
                    #END IF
#
                    #IF l_cs3sqlLnS > 0 AND l_cs3sqlLnE > 0 THEN
                        #FOR l_i = l_cs3sqlLnS TO l_cs3sqlLnE
                            #LET m_srccode[l_i] = GRMARK,m_srccode[l_i]
                        #END FOR
                    #END IF
#
                    #加入呼叫Genero Report準備資料程式段
                    #CALL m_srccode.insertElement(l_cs3Ln + 1)
                    #LET m_srccode[l_cs3Ln + 1] = "    CALL ",m_grfuncname,"()    ",GRMARK
                #END IF
            #ELSE
                #LET l_paramstr = get_substr(l_tmpline,"cl_prt_cs3(",")")
                #找到cl_prt_cs3()該行
                #IF l_paramstr IS NOT NULL THEN
                    #將CR程式段註解
                    #LET l_cs3Ln = l_i
                    #LET m_srccode[l_cs3Ln] = GRMARK,m_srccode[l_cs3Ln]
                    #加入呼叫Genero Report準備資料程式段
                    #CALL m_srccode.insertElement(l_cs3Ln + 1)
                    #LET m_srccode[l_cs3Ln + 1] = "    CALL ",m_grfuncname,"()    ",GRMARK
                #END IF
            #END IF
        #END IF
    #END FOR


    #找出程式名稱()程式段 EX:axmg410()、g410()，在最後加上call xxxx_grdata()

    LET l_progLn = 0
    LET l_add_grdata=0 #判斷找到
    FOR l_i = l_tmpTabLn + 1 TO m_srccode.getLength()

            IF l_progLn <= 0 THEN
                
                    LET l_gr_find=g_sr.prog
                    LET l_gr_find=l_gr_find.subString(4,l_gr_find.getLength()),"("
                    IF m_srccode[l_i].getIndexOf("FUNCTION",1)>0  AND 
                      (m_srccode[l_i].getIndexOf(g_sr.prog,1)>0 OR m_srccode[l_i].getIndexOf(l_gr_find ,1)>0) THEN
                       LET l_progLn=l_i 
                       EXIT FOR 
                    END IF 
                
            END IF
    END FOR 
    
    LET l_cs3Ln = 0
    LET l_add_grdata=0 #判斷找到
    FOR l_i = l_progLn + 1 TO m_srccode.getLength()
        #LET l_tmpline = rm_line_mark(m_srccode[l_i])
        #IF l_tmpline IS NOT NULL THEN
            IF l_cs3Ln <= 0 THEN

                   IF m_srccode[l_i].getIndexOf("END FUNCTION",1) THEN 
                    #找到axmg800(),g800()該行
                        LET l_cs3Ln = l_i
                        #加入呼叫Genero Report準備資料程式段
                        IF m_srccode[l_cs3Ln-1] IS NULL THEN   #此行是NULL                        
                            LET m_srccode[l_cs3Ln - 1] = "    CALL ",m_grfuncname,"()    ",GRMARK                             
                        ELSE 
                            CALL m_srccode.insertElement(l_cs3Ln - 1)
                            LET m_srccode[l_cs3Ln - 1] = "    CALL ",m_grfuncname,"()    ",GRMARK
                        END IF 
                        EXIT FOR 
                   END IF  #IF m_srccode[l_i].getIndexOf("END FUNCTION",1) THEN 

            END IF  #IF l_cs3Ln <= 0 THEN
        #END IF
    END FOR

    
    #填入資料欄位定義陣列
    FOR l_i = 1 TO g_flddef.getLength()
        CALL cl_get_column_info('ds',g_flddef[l_i].table_name,g_flddef[l_i].column_name)
            RETURNING g_flddef[l_i].datatype,g_flddef[l_i].length
        #只有sr1的欄位才能選取
        IF g_flddef[l_i].recno = 1 THEN
            LET g_table1[l_i].fldid = get_fid(g_flddef[l_i].recno,g_flddef[l_i].field_name)
            IF g_table1[l_i].fldid[1,9] = "sr1.order" THEN
                LET g_table1[l_i].alias = g_table1[l_i].fldid
            ELSE
                SELECT gaq03,gaq07
                    INTO g_table1[l_i].alias,l_gaq07 
                    FROM gaq_file
                    WHERE gaq01 =  g_flddef[l_i].column_name AND gaq02 = g_lang
            END IF
            LET l_udatatype = UPSHIFT(g_flddef[l_i].datatype)
            CASE 
                WHEN l_udatatype = "TINYINT" OR l_udatatype = "SMALLINT"
                  OR l_udatatype = "INT" OR l_udatatype = "INTEGER"
                  OR l_udatatype = "BIGINT" OR l_udatatype = "NUMBER"
                  OR l_udatatype = "FLOAT" OR l_udatatype = "SMALLFLOAT"
                  OR l_udatatype = "DECIMAL" OR l_udatatype = "MONEY"
                    IF l_gaq07 = "203" OR l_gaq07 = "205" OR l_gaq07 = "023"
                        OR l_gaq07 = "019" OR l_gaq07 = "020" OR l_gaq07 = "021"  
                    THEN
                        LET g_table1[l_i].fieldattr = m_picdirurl,"currency16.gif"
                    ELSE
                        LET g_table1[l_i].fieldattr = m_picdirurl,"batch16.gif"
                    END IF
                WHEN l_udatatype = "DATE" OR l_udatatype = "DATETIME"
                    LET g_table1[l_i].fieldattr = m_picdirurl,"date16.gif"
                OTHERWISE
                    LET g_table1[l_i].fieldattr = m_picdirurl,"font16.gif"
            END CASE
        END IF
    END FOR

    #將產生的程式碼加入註記
    CALL add_mark(m_tmpcode) 
    #將產生的程式碼合併
    CALL insert_array(m_srccode,m_tmpcode,m_mainLn)    
END FUNCTION

##################################################
# Descriptions...:  檢查程式碼是否已執行過產生器
# Date & Author..:  2012/06/26 janet
# Input Parameter:  p_strarr    動態字串陣列
# Return code....:  l_flag      TRUE: 已執行,FALSE: 未執行
##################################################
PRIVATE FUNCTION chk_generated(p_strarr)
    DEFINE p_strarr DYNAMIC ARRAY OF STRING
    DEFINE l_i      LIKE type_file.num10
    DEFINE l_flag   SMALLINT

    LET l_flag = FALSE
    FOR l_i = 1 TO p_strarr.getLength()
        IF p_strarr[l_i].getIndexOf(GRMARK,1) > 0 THEN
            LET l_flag = TRUE
            EXIT FOR
        END IF
    END FOR
    RETURN l_flag
END FUNCTION


##################################################
# Descriptions...: 產生 TYPE RECORD 定義程式段
# Date & Author..: 2012/06/26 janet
# Input Parameter: p_strarr     動態字串陣列
#                  p_startline  起始行數
#                  p_endline    結束行數
# Return code....: none
##################################################
PRIVATE FUNCTION add_typedef_code(p_strarr,p_startline,p_endline)
    DEFINE p_strarr     DYNAMIC ARRAY OF STRING
    DEFINE p_startline  LIKE type_file.num10
    DEFINE p_endline    LIKE type_file.num10
    DEFINE l_curline    STRING      #目前所在行內容
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_charpos    DYNAMIC ARRAY OF LIKE type_file.num10
    DEFINE l_j          LIKE type_file.num10
    DEFINE l_charcnt    LIKE type_file.num10
    DEFINE l_charposCnt LIKE type_file.num10
    DEFINE l_str        STRING
    DEFINE l_nextstr    STRING
    DEFINE lc_strtok    base.StringTokenizer
    DEFINE lc_strbuf    base.StringBuffer
    DEFINE l_codeLines  LIKE type_file.num10
    DEFINE l_dbfcnt     LIKE type_file.num10     #欄位數
    DEFINE l_pos1       LIKE type_file.num10
    DEFINE l_pos2       LIKE type_file.num10

    WHENEVER ERROR CONTINUE
    IF p_startline <= p_endline AND p_startline > 0 THEN
        LET l_codeLines = p_strarr.getLength()
        IF l_codeLines > 0 THEN
            CALL p_strarr.appendElement()
        END IF
        
        CALL p_strarr.appendElement()
        LET l_codeLines = p_strarr.getLength()
      #  LET p_strarr[l_codeLines] = "TYPE sr"||m_trcnt||"_t RECORD"  #已有define 不用放到陣列
        LET p_strarr[l_codeLines] = "TYPE sr"||m_trcnt||"_t RECORD"  #EXT-D20130

        LET l_dbfcnt = g_flddef.getLength()
        FOR l_i = p_startline TO p_endline
            LET l_curline = rm_line_mark(m_srccode[l_i])
            IF l_curline IS NOT NULL THEN
                LET l_charcnt = 1
                FOR l_j = 1 TO l_curline.getLength()
                    IF l_curline.getCharAt(l_j) = "\"" THEN
                        LET l_charpos[l_charcnt] = l_j
                        LET l_charcnt = l_charcnt + 1
                    END IF
                END FOR

                LET l_charposCnt = l_charpos.getLength() 
                IF l_charposCnt > 1 THEN
                    FOR l_j = 1 TO l_charposCnt STEP 2
                        LET l_str = l_curline.subString(l_charpos[l_j] + 1,l_charpos[l_j + 1] - 1)
                        LET l_str = l_str.trim()
                        LET lc_strtok = base.StringTokenizer.create(l_str,",")
                        WHILE (lc_strtok.hasMoreTokens())
                            LET l_nextstr = lc_strtok.nextToken()
                            LET l_nextstr = l_nextstr.trim()
                            IF l_nextstr IS NOT NULL THEN 
                                LET lc_strbuf = base.StringBuffer.create()
                                CALL lc_strbuf.append(l_nextstr)
                                CALL lc_strbuf.replace("."," LIKE ",1)
                                CALL lc_strbuf.append(",")
                                CALL lc_strbuf.insertAt(1,"    ")
                               # LET l_codeLines = l_codeLines + 1
                                #LET p_strarr[l_codeLines] = lc_strbuf.toString() #已有define 不用放到陣列
                              #EXT-D20130 add (s)
                                LET l_codeLines = l_codeLines + 1
                                LET p_strarr[l_codeLines] = lc_strbuf.toString()
                              #EXT-D20130 add (e)

                                #將欄位放到資料欄位定義陣列
                                LET l_pos1 = l_nextstr.getIndexOf(".",1)
                                LET l_pos2 = l_nextstr.getIndexOf(".",l_pos1 +1)
                                LET l_dbfcnt = l_dbfcnt + 1
                                INITIALIZE g_flddef[l_dbfcnt] TO NULL
                                LET g_flddef[l_dbfcnt].recno = m_trcnt
                                LET g_flddef[l_dbfcnt].field_name = l_nextstr.subString(1,l_pos1 - 1)
                                LET g_flddef[l_dbfcnt].table_name = l_nextstr.subString(l_pos1 + 1,l_pos2 - 1)
                                LET g_flddef[l_dbfcnt].column_name = l_nextstr.subString(l_pos2 + 1,l_nextstr.getLength())
                            END IF
                        END WHILE
                    END FOR
                END IF
            END IF
        END FOR
          #已有define 不用放到陣列
       # LET p_strarr[l_codeLines] = p_strarr[l_codeLines].subString(1,p_strarr[l_codeLines].getLength() - 1)
       # LET l_codeLines = l_codeLines + 1
       # LET p_strarr[l_codeLines] = "END RECORD"
       #不已有define 不用放到陣列
       #EXT-D20130 add --(s)
        LET p_strarr[l_codeLines] = p_strarr[l_codeLines].subString(1,p_strarr[l_codeLines].getLength() - 1)
        LET l_codeLines = l_codeLines + 1
        LET p_strarr[l_codeLines] = "END RECORD"
       #EXT-D20130 add --(e)
    END IF
END FUNCTION

##################################################
# Descriptions...: 找出LET 變數的程式段
# Date & Author..: 2012/06/26 janet
# Input Parameter: p_str        目前行的字串
#                  p_startline  起始行數
#                  p_endline    結束行數
# Return code....: none
##################################################
PRIVATE FUNCTION find_lineno(p_str,p_startline,p_endline)
    DEFINE p_str        STRING
    DEFINE p_startline  LIKE type_file.num10
    DEFINE p_endline    LIKE type_file.num10
    DEFINE l_startline  LIKE type_file.num10
    DEFINE l_endline    LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_j          LIKE type_file.num10
    DEFINE l_tmpline    STRING      #去註解後的目前所在行內容
    DEFINE l_str        STRING
    DEFINE l_nextline   LIKE type_file.num10

    #DISPLAY "start: ",p_startline,",",p_endline
    LET l_startline = 0
    FOR l_i = p_endline - 1 TO p_startline STEP -1 
        LET l_tmpline = rm_line_mark(m_srccode[l_i])

        #找開始行
        IF l_tmpline.getIndexOf("LET",1) > 0 
            AND l_tmpline.getIndexOf(p_str,2) > 0
        THEN
            LET l_startline = l_i
            EXIT FOR
        END IF
    END FOR

    IF l_startline > 0 THEN
        FOR l_i = l_startline TO p_endline - 1 
            #找結束行
            LET l_tmpline = rm_line_mark(m_srccode[l_i])

            #找第一個結尾非逗號的行
            IF　l_tmpline IS NOT NULL
                AND l_tmpline.getCharAt(l_tmpline.getLength()) != ","
            THEN
                LET l_nextline = 0
                #找到該行後，確認非註解的下一行第一個非空白字元不可為逗號
                FOR l_j = l_i + 1 TO p_endline - 1
                    LET l_str = rm_line_mark(m_srccode[l_j])
                    LET l_str = l_str.trim()
                    #DISPLAY "cl_null(l_str)=",cl_null(l_str) USING "<<<<&"
                    IF NOT cl_null(l_str) THEN
                        LET l_nextline = l_j
                        EXIT FOR
                    END IF
                END FOR
                #DISPLAY "l_nextline: ",l_nextline USING "<<<<&"
                IF l_nextline > 0 THEN
                    IF l_str.getCharAt(1) != "," OR cl_null(l_str) THEN
                    LET l_endline = l_i
                    EXIT FOR
                    END IF
                ELSE
                    LET l_endline = l_i
                    EXIT FOR
                END IF
            END IF
        END FOR
    END IF
    #DISPLAY "result: ",l_startline,",",l_endline
    RETURN l_startline,l_endline
END FUNCTION

#移除該行中的註解
PRIVATE FUNCTION rm_line_mark(p_str)
    DEFINE p_str            STRING
    DEFINE l_str            STRING
    DEFINE l_mark_pos       LIKE type_file.num10
    DEFINE l_i              LIKE type_file.num10
    DEFINE l_char           STRING
    DEFINE l_char1          STRING
    DEFINE l_chkmark2       LIKE type_file.num10
    DEFINE l_last_chr_pos   LIKE type_file.num10    #最後一個非空白字元的位置

    LET l_mark_pos = 0
    LET l_chkmark2 = FALSE
    LET l_str = p_str.trim()
    FOR l_i = 1 TO p_str.getLength()
        LET l_char = l_str.getCharAt(l_i)
        IF l_char = "-" THEN
            LET l_char1 = l_str.getCharAt(l_i + 1)
            IF l_char1 = "-" THEN
                LET l_chkmark2 = TRUE
            END IF
        END IF
        IF l_char = "#" OR l_char = "{" OR l_chkmark2 THEN
            LET l_mark_pos = l_i
            EXIT FOR
        END IF
    END FOR
    IF l_mark_pos > 1 THEN
        LET l_str = l_str.subString(1,l_mark_pos - 1)
        LET l_str = l_str.trim()

        LET l_last_chr_pos = 0
        FOR l_i = l_str.getLength() TO 1 STEP -1
            IF l_str.getCharAt(l_i) = "\t" OR l_str.getCharAt(l_i) = "\f" THEN
                LET l_last_chr_pos = l_i
            ELSE
                EXIT FOR
            END IF
        END FOR
        IF l_last_chr_pos >= 1 THEN
            LET l_str = l_str.subString(1,l_last_chr_pos - 1)
        END IF
    ELSE
        IF l_mark_pos = 1 THEN
            LET l_str = NULL
        END IF
    END IF
    RETURN l_str
END FUNCTION

#找出多行註解段
PRIVATE FUNCTION find_marklines(p_arr)
    DEFINE p_arr    DYNAMIC ARRAY OF STRING
    DEFINE l_i      LIKE type_file.num10
    DEFINE l_j      LIKE type_file.num10
    DEFINE l_lnlen  LIKE type_file.num10
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_char   STRING

    LET l_cnt = 0
    FOR l_i = 1 TO p_arr.getLength()
        LET l_lnlen = p_arr[l_i].getLength()
        FOR l_j = 1 TO l_lnlen
            LET l_char = p_arr[l_i].getCharAt(l_j) 
            IF l_char = "{" THEN
                LET l_cnt = l_cnt + 1
                LET m_marklines[l_cnt].startLn = l_i
                LET m_marklines[l_cnt].startCol = l_j
                LET m_marklines[l_cnt].endLn = 0
                LET m_marklines[l_cnt].endCol = 0
            ELSE
                IF l_char = "}" THEN
                    IF m_marklines[l_cnt].endLn = 0
                        AND m_marklines[l_cnt].endCol = 0
                    THEN
                        LET m_marklines[l_cnt].endLn = l_i
                        LET m_marklines[l_cnt].endCol = l_j
                    END IF
                END IF
            END IF
        END FOR
        
    END FOR
END FUNCTION

#將檔案讀入原始碼字串陣列
PUBLIC FUNCTION load_source(p_filePath,p_arr)
    DEFINE p_filePath   STRING
    DEFINE p_arr        DYNAMIC ARRAY OF STRING 
    DEFINE l_cnt        LIKE type_file.num10
    DEFINE l_ch         base.Channel
    DEFINE l_result     STRING

    CALL p_arr.clear()
    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(p_filePath,"r")
    CALL l_ch.setDelimiter("")
    LET l_cnt = 1
    WHILE l_ch.read(l_result)
        LET p_arr[l_cnt] = l_result
        LET l_cnt = l_cnt + 1
    END WHILE
    CALL p_arr.deleteElement(l_cnt)
    CALL l_ch.close()
END FUNCTION

#加入Genero Report程式段
PRIVATE FUNCTION add_grw_code()
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_tplPath    STRING
    DEFINE l_strbuf     base.StringBuffer
    DEFINE l_orderby    STRING
    DEFINE l_defvar     DYNAMIC ARRAY OF STRING         #產生器REPORT段DEFINE變數
    DEFINE l_beforegrp  DYNAMIC ARRAY OF STRING         #產生器REPORT段BEFORE GROUP OF
    DEFINE l_aftergrp   DYNAMIC ARRAY OF STRING         #產生器REPORT段AFTER GROUP OF
    DEFINE l_lastrow    DYNAMIC ARRAY OF STRING         #產生器REPORT段LASTROW
    DEFINE l_everyrow   DYNAMIC ARRAY OF STRING         #產生器REPORT段ON EVERY ROW
    DEFINE l_ordasc     STRING
    DEFINE l_varname    STRING
    DEFINE l_varname1   STRING
    DEFINE l_insln      LIKE type_file.num10
    DEFINE l_pos        LIKE type_file.num10
    DEFINE l_tmpstr     STRING
    DEFINE l_typedef    STRING
    DEFINE l_find_tm    LIKE type_file.num10
    DEFINE l_find_str   STRING 
    DEFINE l_ii         INTEGER 
    
    CALL l_defvar.clear()
    CALL l_beforegrp.clear()
    CALL l_aftergrp.clear()
    CALL l_lastrow.clear()
    CALL l_everyrow.clear()
    #清除暫存程式碼陣列
    CALL m_tmpcode.clear()
    LET l_strbuf = base.StringBuffer.create()

    LET l_find_tm = 0
    FOR l_i = 1 TO m_srccode.getLength()
        IF m_srccode[l_i].getIndexOf("DEFINE",1) >= 1
            AND m_srccode[l_i].getIndexOf("tm",1) >= 1
        THEN
            LET l_find_tm = l_i
        END IF
    END FOR

    #組出ORDER BY程式段
    LET l_orderby = ""
    FOR l_i = 1 TO g_ord.getLength()
        IF g_ord[l_i].order1 = 2 THEN
            LET l_ordasc = " DESC"
        ELSE
            LET l_ordasc = ""
        END IF
        IF NOT cl_null(g_ord[l_i].fid1) THEN
            LET l_orderby = l_orderby,g_ord[l_i].fid1 CLIPPED,l_ordasc,","
            IF g_ord[l_i].grup1 = "Y" THEN
                LET l_beforegrp[l_i] = 8 SPACES,"BEFORE GROUP OF ",g_ord[l_i].fid1 CLIPPED
                LET l_aftergrp[l_i] = 8 SPACES,"AFTER GROUP OF ",g_ord[l_i].fid1 CLIPPED
            END IF
        END IF
    END FOR
    IF NOT cl_null(l_orderby) THEN
        LET l_orderby = l_orderby.subString(1,l_orderby.getLength() - 1)
        LET l_orderby = "ORDER EXTERNAL BY ",l_orderby
    END IF

    #憑證類報表在第一個before group後加入設定l_lineno=0
    #IF g_sr.reporttype = "1" AND g_sr.sets = "N" THEN
    IF g_sr.reporttype = "1" THEN
        IF l_beforegrp.getLength() >= 1 THEN
            CALL l_beforegrp.insertElement(2)
            LET l_beforegrp[2] = 12 SPACES,"LET l_lineno = 0"
        END IF
    END IF

    #組LAST ROW程式段
    LET l_lastrow[1] = 8 SPACES,"ON LAST ROW"

    #組define變數
    IF m_trcnt > 0 THEN                
        FOR l_i = 1 TO m_trcnt
            LET l_defvar[l_i] = "    DEFINE sr"||l_i||" sr"||l_i||"_t"
        END FOR

        #新增行號變數
        CALL l_defvar.appendElement()
        LET l_defvar[l_defvar.getLength()] = "    DEFINE l_lineno LIKE type_file.num5"
        CALL l_everyrow.appendElement()
        LET l_everyrow[l_everyrow.getLength()] = 12 SPACES,"LET l_lineno = l_lineno + 1"
        CALL l_everyrow.appendElement()
        LET l_everyrow[l_everyrow.getLength()] = 12 SPACES,"PRINTX l_lineno"
    END IF
    IF g_comp.getLength() > 0 THEN
        #清空聚合變數記錄陣列
        CALL g_aggr_vars.clear()
        FOR l_i = 1 TO g_comp.getLength()
            INITIALIZE g_aggr_vars[l_i].* TO NULL
            LET l_tmpstr = g_comp[l_i].fid2 CLIPPED
            LET l_pos = l_tmpstr.getIndexOf(".",1)
            LET l_varname = l_tmpstr.subString(l_pos + 1,l_tmpstr.getLength())
            LET l_typedef = get_typedef_string(g_comp[l_i].fid2)
            IF NOT cl_null(l_varname) AND NOT cl_null(l_typedef) THEN
                LET l_varname = "l_",l_varname.trim(),"_"||l_i
                #原版----START------
                #IF g_comp[l_i].aggr2 MATCHES "[AC]" THEN  #小計、小計及總計
                    #LET l_varname1 = l_varname,"_subtot"
                    #記錄自動產生的群組聚合變數名稱
                    #LET g_aggr_vars[l_i].g_var_name = l_varname1
                    #LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                    #LET l_insln = find_line(l_aftergrp,g_comp[l_i].gfid2)
                    #CALL l_aftergrp.insertElement(l_insln + 1)
                    #CALL l_aftergrp.insertElement(l_insln + 1)
                    #LET l_aftergrp[l_insln + 1] = 12 SPACES,"LET ",l_varname1," = GROUP SUM(",l_tmpstr,")"
                    #LET l_aftergrp[l_insln + 2] = 12 SPACES,"PRINTX ",l_varname1
                #END IF
                #IF g_comp[l_i].aggr2 MATCHES "[BC]" THEN  #總計、小計及總計
                    #LET l_varname1 = l_varname,"_tot"
                    #記錄自動產生的總計聚合變數名稱
                    #LET g_aggr_vars[l_i].t_var_name = l_varname1
                    #LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                    #LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"LET ",l_varname1," = SUM(",l_tmpstr,")"
                    #LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"PRINTX ",l_varname1
                #END IF 
                #IF g_comp[l_i].aggr2 MATCHES "[DF]" THEN  #平均(小計)、平均(小計)及總平均
                    #LET l_varname1 = l_varname,"_subavg" 
                    #記錄自動產生的群組聚合變數名稱
                    #LET g_aggr_vars[l_i].g_var_name = l_varname1
                    #LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                    #LET l_insln = find_line(l_aftergrp,g_comp[l_i].gfid2)
                    #CALL l_aftergrp.insertElement(l_insln + 1)
                    #CALL l_aftergrp.insertElement(l_insln + 1)
                    #LET l_aftergrp[l_insln + 1] = 12 SPACES,"LET ",l_varname1," = GROUP AVG(",l_tmpstr,")"
                    #LET l_aftergrp[l_insln + 2] = 12 SPACES,"PRINTX ",l_varname1
                #END IF
                #IF g_comp[l_i].aggr2 MATCHES "[EF]" THEN #總平均、平均(小計)及總平均
                    #LET l_varname1 = l_varname,"_avg"
                    #記錄自動產生的總計聚合變數名稱
                    #LET g_aggr_vars[l_i].t_var_name = l_varname1
                    #LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                    #LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"LET ",l_varname1," = AVG(",l_tmpstr,")"
                    #LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"PRINTX ",l_varname1
                #END IF
                #原版----END ------


                IF g_comp[l_i].aggr2 MATCHES "[AC]" THEN  #小計、小計及總計
                    LET l_varname1 = l_varname,"_subtot"
                    ##記錄自動產生的群組聚合變數名稱
                    LET l_find_str="AFTER GROUP"
                    #記錄自動產生的群組聚合變數名稱
                    LET g_aggr_vars[l_i].g_var_name = l_varname1
                    LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                    LET l_insln = 0
                    FOR l_ii = 1 TO l_aftergrp.getLength() #在每個群組尾全都加上
                        IF l_aftergrp[l_ii].getIndexOf(l_find_str,1) > 0 THEN
                           LET l_insln=l_ii 
                           CALL l_aftergrp.insertElement(l_insln + 1)
                           CALL l_aftergrp.insertElement(l_insln + 1)
                           LET l_aftergrp[l_insln + 1] = 12 SPACES,"LET ",l_varname1," = GROUP SUM(",l_tmpstr,")"
                           LET l_aftergrp[l_insln + 2] = 12 SPACES,"PRINTX ",l_varname1                                                    
                        END IF
                    END FOR
                END IF
                IF g_comp[l_i].aggr2 MATCHES "[BC]" THEN  #總計、小計及總計
                    LET l_varname1 = l_varname,"_tot"
                    ##記錄自動產生的總計聚合變數名稱
                    LET g_aggr_vars[l_i].t_var_name = l_varname1
                    LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                    LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"LET ",l_varname1," = SUM(",l_tmpstr,")"
                    LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"PRINTX ",l_varname1
                END IF 
                IF g_comp[l_i].aggr2 MATCHES "[DF]" THEN  #平均(小計)、平均(小計)及總平均
                    LET l_varname1 = l_varname,"_subavg" 
                    LET l_find_str="AFTER GROUP"
                    LET g_aggr_vars[l_i].g_var_name = l_varname1
                    LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                    LET l_insln = 0
                    FOR l_ii = 1 TO l_aftergrp.getLength() #在每個群組尾全都加上
                        IF l_aftergrp[l_ii].getIndexOf(l_find_str,1) > 0 THEN
                           LET l_insln=l_ii 
                           CALL l_aftergrp.insertElement(l_insln + 1)
                           CALL l_aftergrp.insertElement(l_insln + 1)
                           LET l_aftergrp[l_insln + 1] = 12 SPACES,"LET ",l_varname1," = GROUP AVG(",l_tmpstr,")"                    
                           LET l_aftergrp[l_insln + 2] = 12 SPACES,"PRINTX ",l_varname1                                                    
                        END IF
                    END FOR
                END IF
                IF g_comp[l_i].aggr2 MATCHES "[EF]" THEN #總平均、平均(小計)及總平均
                    LET l_varname1 = l_varname,"_avg"
                    ##記錄自動產生的總計聚合變數名稱
                    LET g_aggr_vars[l_i].t_var_name = l_varname1
                    LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                    LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"LET ",l_varname1," = AVG(",l_tmpstr,")"
                    LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"PRINTX ",l_varname1
                END IF

                
                #CASE g_comp[l_i].aggr2
                    #WHEN g_comp[l_i].aggr2 MATCHES "[AC]" OR g_comp[l_i].aggr2 MATCHES "[DF]"
                        #LET l_find_str="AFTER GROUP"
                        #IF g_comp[l_i].aggr2 MATCHES "[AC]" THEN LET l_varname1 = l_varname,"_subtot" END IF 
                        #IF g_comp[l_i].aggr2 MATCHES "[DF]" THEN LET l_varname1 = l_varname,"_subavg" END IF 
                        ##記錄自動產生的群組聚合變數名稱
                        #LET g_aggr_vars[l_i].g_var_name = l_varname1
                        #LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                        #LET l_insln = 0
                        #FOR l_ii = 1 TO l_aftergrp.getLength() #在每個群組尾全都加上
                            #IF l_aftergrp[l_ii].getIndexOf(l_find_str,1) > 0 THEN
                               #LET l_insln=l_ii 
                               #CALL l_aftergrp.insertElement(l_insln + 1)
                               #CALL l_aftergrp.insertElement(l_insln + 1)
                               #IF g_comp[l_i].aggr2 MATCHES "[AC]" THEN 
                                  #LET l_aftergrp[l_insln + 1] = 12 SPACES,"LET ",l_varname1," = GROUP SUM(",l_tmpstr,")"
                               #END IF
                               #IF g_comp[l_i].aggr2 MATCHES "[DF]" THEN 
                                  #LET l_aftergrp[l_insln + 1] = 12 SPACES,"LET ",l_varname1," = GROUP AVG(",l_tmpstr,")"
                               #END IF                        
                               #LET l_aftergrp[l_insln + 2] = 12 SPACES,"PRINTX ",l_varname1                                                    
                            #ELSE 
                                #EXIT FOR 
                            #END IF
                        #END FOR
                    #WHEN g_comp[l_i].aggr2 MATCHES "[BC]" OR g_comp[l_i].aggr2 MATCHES "[EF]"
                         #IF  g_comp[l_i].aggr2 MATCHES "[EF]" THEN LET l_varname1 = l_varname,"_avg" END IF 
                         #IF  g_comp[l_i].aggr2 MATCHES "[BC]" THEN LET l_varname1 = l_varname,"_tot" END IF 
                         ##記錄自動產生的總計聚合變數名稱
                         #LET g_aggr_vars[l_i].t_var_name = l_varname1
                         #LET l_defvar[l_defvar.getLength() + 1] = "    DEFINE ",l_varname1," ",l_typedef
                         #IF g_comp[l_i].aggr2 MATCHES "[EF]" THEN 
                            #LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"LET ",l_varname1," = AVG(",l_tmpstr,")"
                         #END IF 
                         #IF g_comp[l_i].aggr2 MATCHES "[BC]" THEN 
                            #LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"LET ",l_varname1," = SUM(",l_tmpstr,")"
                         #END IF                          
                         #LET l_lastrow[l_lastrow.getLength() + 1] = 12 SPACES,"PRINTX ",l_varname1             
                #END CASE               
            END IF
        END FOR
    END IF
    
    #讀取樣版檔
    LET l_tplpath = get_tplpath("gr01.tpl")
    CALL load_source(l_tplpath,m_tmpcode)
    
    #組原始碼字串
    FOR l_i = 1 TO m_tmpcode.getLength()
        CALL l_strbuf.clear()
        CALL l_strbuf.append(m_tmpcode[l_i])
        CALL l_strbuf.replace("${grfuncname}",m_grfuncname,0)
        CALL l_strbuf.replace("${prog}",g_sr.prog,0)
        CALL l_strbuf.replace("${orderby}",l_orderby,0)
        LET m_tmpcode[l_i] = l_strbuf.toString()
        CASE m_tmpcode[l_i].trim()
            WHEN "${defvar}"
                CALL m_tmpcode.deleteElement(l_i)
                CALL insert_array(m_tmpcode,l_defvar,l_i)
                LET l_i = l_i + l_defvar.getLength()
            WHEN "${beforegrp}"
                CALL m_tmpcode.deleteElement(l_i)
                CALL insert_array(m_tmpcode,l_beforegrp,l_i)
                LET l_i = l_i + l_beforegrp.getLength()
            WHEN "${aftergrp}"
                CALL m_tmpcode.deleteElement(l_i)
                CALL insert_array(m_tmpcode,l_aftergrp,l_i)
                LET l_i = l_i + l_aftergrp.getLength()
            WHEN "${lastrow}"
                CALL m_tmpcode.deleteElement(l_i)
                CALL insert_array(m_tmpcode,l_lastrow,l_i)
                LET l_i = l_i + l_lastrow.getLength()
            WHEN "ON EVERY ROW"
                CALL insert_array(m_tmpcode,l_everyrow,l_i + 1)
                LET l_i = l_i + l_everyrow.getLength()
            WHEN "PRINTX tm.*"
                IF l_find_tm = 0 THEN
                    CALL m_tmpcode.deleteElement(l_i)
                END IF
        END CASE
    END FOR
END FUNCTION

#取得樣板檔路徑
PUBLIC FUNCTION get_tplpath(p_tplname)
    DEFINE p_tplname    STRING
    DEFINE l_path       STRING

    LET l_path = os.Path.join(FGL_GETENV("TOP"),os.Path.join("config",os.Path.join("grtpl",p_tplname)))
    RETURN l_path
END FUNCTION

#存檔
PRIVATE FUNCTION save_file(p_filepath)
    DEFINE p_filepath   STRING
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_ch         base.Channel

    LET l_ch = base.Channel.create()
    CALL l_ch.openFile(p_filepath,"w")
    CALL l_ch.setDelimiter("")        
    FOR l_i = 1 TO m_srccode.getLength()
        CALL l_ch.writeLine(m_srccode[l_i])
    END FOR
    
    CALL l_ch.close()
END FUNCTION

#取出String token指定的部分
PRIVATE FUNCTION get_str_part(p_str,p_delim,p_index)
    DEFINE p_str        STRING
    DEFINE p_delim      STRING
    DEFINE p_index      LIKE type_file.num10
    DEFINE l_res        STRING
    DEFINE l_str        STRING
    DEFINE l_index      LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_strtok     base.StringTokenizer

    LET l_res = NULL
    LET l_strtok = base.StringTokenizer.create(p_str,p_delim)
    IF l_strtok IS NOT NULL THEN
        IF p_index > 0 THEN
            LET l_index = p_index
        ELSE
            LET l_index = l_strtok.countTokens() + 1 + p_index 
        END IF

        LET l_i = 1
        WHILE (l_strtok.hasMoreTokens())
            LET l_str = l_strtok.nextToken()
            IF l_i = l_index THEN
                LET l_res = l_str
                EXIT WHILE
            END IF
            LET l_i = l_i + 1
        END WHILE
    END IF
    IF l_res IS NOT NULL THEN
        LET l_res = l_res.trim()
    END IF
    RETURN l_res
END FUNCTION

#取出子字串
PRIVATE FUNCTION get_substr(p_str,p_startStr,p_endStr)
    DEFINE p_str            STRING
    DEFINE p_startStr       STRING
    DEFINE p_endStr         STRING
    DEFINE l_str            STRING
    DEFINE l_startPos       LIKE type_file.num10
    DEFINE l_endPos         LIKE type_file.num10
    DEFINE l_startStrLen    LIKE type_file.num10

    LET l_str = NULL
    IF p_str IS NOT NULL AND p_startStr IS NOT NULL AND p_endStr IS NOT NULL THEN
        LET l_startStrLen = p_startStr.getLength()
        LET l_startPos = p_str.getIndexOf(p_startStr,1)
        IF l_startPos > 0 THEN
            LET l_endPos = p_str.getIndexOf(p_endStr,l_startPos + 1)
        END IF
    END IF

    IF l_endPos >= l_startPos AND l_startPos > 0 THEN
        LET l_str = p_str.subString(l_startPos + l_startStrLen,l_endPos - 1)
    END IF

    RETURN l_str
END FUNCTION

#替產生的程式段加入註記
PRIVATE FUNCTION add_mark(p_arr)
    DEFINE p_arr    DYNAMIC ARRAY OF STRING

    CALL p_arr.insertElement(1)
    LET p_arr[1] = GRMARK,"START"
    CALL p_arr.appendElement()
    LET p_arr[p_arr.getLength()] = GRMARK,"END"
END FUNCTION

#將來源自字串陣列附加到目的字串陣列後
PRIVATE FUNCTION append_array(p_dstArr,p_srcArr,p_insertBlank)
    DEFINE p_dstArr         DYNAMIC ARRAY OF STRING
    DEFINE p_srcArr         DYNAMIC ARRAY OF STRING
    DEFINE p_insertBlank    TINYINT
    DEFINE l_i              LIKE type_file.num10
    DEFINE l_srclen         LIKE type_file.num10
    DEFINE l_dstlen         LIKE type_file.num10

    #目的陣列插入空行
    IF p_insertBlank THEN
        CALL p_dstArr.appendElement()
    END IF

    LET l_srclen = p_srcArr.getLength()
    LET l_dstlen = p_dstArr.getLength()
    FOR l_i = 1 TO l_srclen
        LET p_dstArr[l_dstlen + l_i] = p_srcArr[l_i]
    END FOR
END FUNCTION

#將來源字串陣列插入到目的字串陣列的某一行之後
PRIVATE FUNCTION insert_array(p_dstArr,p_srcArr,p_dstLineNo)
    DEFINE p_dstArr     DYNAMIC ARRAY OF STRING
    DEFINE p_srcArr     DYNAMIC ARRAY OF STRING
    DEFINE p_dstLineNo  LIKE type_file.num10
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_srclen     LIKE type_file.num10
    DEFINE l_dstlen     LIKE type_file.num10

    LET l_srclen = p_srcArr.getLength()
    LET l_dstlen = p_dstArr.getLength()
    IF p_dstLineNo > 0 THEN
        IF l_dstlen >= p_dstLineNo AND l_srclen > 0 THEN
            CALL p_dstArr.insertElement(p_dstLineNo)
            FOR l_i = l_srclen TO 1 STEP -1
                CALL p_dstArr.insertElement(p_dstLineNo)
                LET p_dstArr[p_dstLineNo] = p_srcArr[l_i]
            END FOR
        END IF
    END IF
END FUNCTION

#取得欄位別名
PRIVATE FUNCTION get_field_alias(p_field)
    DEFINE p_field  STRING
    DEFINE l_alias  STRING
    DEFINE l_i      LIKE type_file.num10
    DEFINE l_fld    STRING
    DEFINE l_tmp    STRING

    LET l_fld = p_field CLIPPED
    INITIALIZE l_alias TO NULL
    FOR l_i = 1 TO g_table1.getLength()
        LET l_tmp = g_table1[l_i].fldid CLIPPED
        IF l_fld = l_tmp THEN
            LET l_alias = g_table1[l_i].alias
            RETURN l_alias
        END IF
    END FOR
    FOR l_i = 1 TO g_table2.getLength()
        LET l_tmp = g_table2[l_i].fldid CLIPPED
        IF l_fld = l_tmp THEN
            LET l_alias = g_table2[l_i].alias
            RETURN l_alias
        END IF
    END FOR
    FOR l_i = 1 TO g_table3.getLength()
        LET l_tmp = g_table3[l_i].fldid CLIPPED
        IF l_fld = l_tmp THEN
            LET l_alias = g_table3[l_i].alias
            RETURN l_alias
        END IF
    END FOR
    FOR l_i = 1 TO g_table4.getLength()
        LET l_tmp = g_table4[l_i].fldid CLIPPED
        IF l_fld = l_tmp THEN
            LET l_alias = g_table4[l_i].alias
            RETURN l_alias
        END IF
    END FOR
    FOR l_i = 1 TO g_table5.getLength()
        LET l_tmp = g_table5[l_i].fldid CLIPPED
        IF l_fld = l_tmp THEN
            LET l_alias = g_table5[l_i].alias
            RETURN l_alias
        END IF
    END FOR
    FOR l_i = 1 TO g_table6.getLength()
        LET l_tmp = g_table6[l_i].fldid CLIPPED
        IF l_fld = l_tmp THEN
            LET l_alias = g_table6[l_i].alias
            RETURN l_alias
        END IF
    END FOR
    RETURN l_alias
END FUNCTION

#從欄位定義陣列中取的資料型態
PRIVATE FUNCTION get_typedef_string(p_fid)
    DEFINE p_fid    STRING
    DEFINE l_i      LIKE type_file.num10
    DEFINE l_type   STRING
    DEFINE l_cname  STRING
    DEFINE l_fid    STRING
    
    INITIALIZE l_type TO NULL
    LET l_fid = p_fid.trim()
    FOR l_i = 1 TO g_flddef.getLength()
        LET l_cname = "sr"||g_flddef[l_i].recno||"."||g_flddef[l_i].field_name
        LET l_cname = l_cname.trim()
        IF l_cname = l_fid THEN
            LET l_type = "LIKE ",g_flddef[l_i].table_name CLIPPED,".",g_flddef[l_i].column_name
            EXIT FOR
        END IF
    END FOR
    RETURN l_type
END FUNCTION

PRIVATE FUNCTION find_line(p_arr,p_str)
    DEFINE p_arr    DYNAMIC ARRAY OF STRING
    DEFINE p_str    STRING
    DEFINE l_i      LIKE type_file.num10
    DEFINE l_ln     LIKE type_file.num10

    LET l_ln = 0
    FOR l_i = 1 TO p_arr.getLength()
        IF p_arr[l_i].getIndexOf(p_str,1) > 0 THEN
            LET l_ln = l_i
            EXIT FOR
        END IF
    END FOR
    RETURN l_ln
END FUNCTION

PRIVATE FUNCTION dump_strarr(p_arr)
    DEFINE p_arr DYNAMIC ARRAY OF STRING
    DEFINE i INTEGER
    
    FOR i = 1 TO p_arr.getLength()
        DISPLAY "["||i||"]: ",p_arr[i]
    END FOR
END FUNCTION

PUBLIC FUNCTION get_fid(p_recno,p_fldname)
    DEFINE p_recno      LIKE type_file.num5
    DEFINE p_fldname    LIKE gac_file.gac06
    DEFINE l_fid        STRING

    INITIALIZE l_fid TO NULL
    IF p_recno > 0 AND p_fldname IS NOT NULL THEN
        LET l_fid = "sr"||p_recno||".",p_fldname CLIPPED
    END IF
    RETURN l_fid
END FUNCTION

PUBLIC FUNCTION get_fid_colname(p_fid)
    DEFINE p_fid        STRING
    DEFINE l_colname    STRING
    DEFINE l_pos        LIKE type_file.num10

    INITIALIZE l_colname TO NULL
    LET l_pos = p_fid.getIndexOf(".",1)
    IF l_pos >= 1 THEN 
        LET l_colname = p_fid.subString(l_pos + 1,p_fid.getLength())
    ELSE
        IF l_pos = 0 THEN
            LET l_colname = p_fid
        END IF
    END IF
    RETURN l_colname
END FUNCTION

PRIVATE FUNCTION copy_files()
    DEFINE l_dir    STRING
    DEFINE l_src    STRING
    DEFINE l_dst    STRING
    DEFINE lc_chin       base.Channel               
    DEFINE lc_chout      base.Channel               
    DEFINE l_cmd,l_read_str    STRING               
    DEFINE lr_prog       DYNAMIC ARRAY OF STRING    
    DEFINE l_i ,i        LIKE type_file.num5        
    
    # copy 4gl
    LET m_grfuncname = g_sr.prog CLIPPED,"_grdata"
    LET l_dir = os.Path.join(FGL_GETENV(g_zz011),"4gl")
    #LET l_src = os.Path.join(l_dir,g_sr.prog||".4gl")
    LET l_dst = os.Path.join(l_dir,g_sr.prog||".4gl")
    LET m_srcpath = l_dst
    #IF NOT os.Path.exists(l_dst) THEN  #原先就寫好gr的4gl程式
        #IF os.Path.copy(l_src,l_dst) THEN END IF
    #END IF


      #讀檔
      #LET l_cmd = l_dst     
      #DISPLAY l_cmd
      #LET lc_chin = base.Channel.create() #create new 物件
      #CALL lc_chin.openFile(l_cmd,"r") #開啟檔案
      #LET l_i=1

      #WHILE TRUE   
             #LET l_read_str =lc_chin.readLine() #整行讀入
             #LET l_read_str = cl_replace_str(l_read_str, g_sr.prog, g_sr.grprog)  #取代檔名
             #LET lr_prog[l_i] =l_read_str #讀取資料後存入tmp中
             #IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
             #LET l_i = l_i + 1
      #END WHILE
      #CALL lc_chin.close()  
#
      #寫檔	 
#
      #LET lc_chout = base.Channel.create()
      #CALL lc_chout.openFile(l_cmd,"w")
      #
      #FOR i = 1 TO lr_prog.getLength()
	    	 #CALL lc_chout.writeLine(lr_prog[i])
      #END FOR	 
      #CALL lc_chout.close()

    
    LET m_start = CURRENT HOUR TO FRACTION(5)
    CALL parse_src_code()  #分析原始程式並產生Genero Report程式段
    LET m_end = CURRENT HOUR TO FRACTION(5)
    LET m_interval = m_end - m_start
    DISPLAY "parsing time: ",m_interval
    
    # copy 4fd #已經做好 不需要COPY
    #LET l_dir = os.Path.join(FGL_GETENV(g_zz011),"4fd")
    #LET l_src = os.Path.join(l_dir,g_sr.prog||".4fd")
    #LET l_dst = os.Path.join(l_dir,g_sr.grprog||".4fd")
    #IF NOT os.Path.exists(l_dst) THEN
        #IF os.Path.copy(l_src,l_dst) THEN END IF
    #END IF
    
END FUNCTION
 
PRIVATE FUNCTION copy_zz()  #p_zz會自行建立，不需此function
    DEFINE l_zz08       LIKE zz_file.zz08 
    DEFINE l_transname  STRING 
 
    IF g_sr.prog IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    DROP TABLE x

    SELECT *
        FROM zz_file WHERE zz01=g_sr.prog INTO TEMP x
 
    IF cl_get_os_type() <> "WINDOWS" THEN    #for all kinds of UNIX 
        LET l_zz08="$FGLRUN $",UPSHIFT(g_zz011) CLIPPED,"i/",g_sr.grprog
    ELSE                                     #for all versions of WINDOWS
        LET l_zz08="%FGLRUN% %",UPSHIFT(g_zz011) CLIPPED,"i%/",g_sr.grprog
    END IF
 
    UPDATE x SET zz01 = g_sr.grprog,    #資料鍵值
                 zz08 = l_zz08,         #UNIX執行指令
                 zz09 = g_today,        #資料建立日期
                 zzuser = g_user,       #資料所有者
                 zzgrup = g_grup,       #資料所有者所屬群
                 zzmodu = g_user,       #資料修改日期
                 zzdate = g_today       #資料建立日期
 
    INSERT INTO zz_file SELECT *
        FROM x
        
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","zz_file",g_sr.grprog,"",SQLCA.sqlcode,"","",0)   
    ELSE
        DROP TABLE y
        SELECT * FROM gaz_file WHERE gaz01=g_sr.prog INTO TEMP y
        UPDATE y SET gaz01 = g_sr.grprog,   #資料鍵值
                     gazuser = g_user,      #資料所有者
                     gazgrup = g_grup,      #資料所有者所屬群
                     gazmodu = g_user,      #資料修改日期
                     gazdate = g_today      #資料建立日期
        INSERT INTO gaz_file SELECT * FROM y
 
        MESSAGE 'ROW(',g_sr.grprog,') O.K'
        
        CALL copy_zz_link()
        CALL copy_zz_per()
    END IF
END FUNCTION
 

PRIVATE FUNCTION copy_zz_link()
    DEFINE l_notfound    LIKE type_file.num5
    
    # Update gaz_file
    DELETE FROM gaz_file WHERE gaz01=g_sr.grprog
    DROP TABLE x
    SELECT * FROM gaz_file WHERE gaz01=g_sr.prog INTO TEMP x     
    IF SQLCA.sqlcode = NOTFOUND THEN
        LET l_notfound = TRUE
    END IF
    IF NOT l_notfound THEN
        UPDATE x SET gaz01  = g_sr.grprog,
                     gazuser= g_user,
                     gazgrup= g_grup,
                     gazmodu= NULL,
                     gazdate= g_today
                     
        INSERT INTO gaz_file SELECT * FROM x
 
        IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","gaz_file",g_sr.grprog,"",SQLCA.sqlcode,"","Reproduce gaz_file",1)   #No.FUN-660081
            RETURN
        END IF
    END IF
 
    # Update gak_file
    DELETE FROM gak_file WHERE gak01=g_sr.grprog
    DROP TABLE x
    SELECT * FROM gak_file WHERE gak01=g_sr.prog INTO TEMP x     
    IF SQLCA.sqlcode = NOTFOUND THEN
        LET l_notfound = TRUE
    END IF
    IF NOT l_notfound THEN    
        UPDATE x SET gak01  = g_sr.grprog,
                     gakuser= g_user,                             
                     gakgrup= g_grup,
                     gakmodu= NULL,
                     gakdate= g_today
        INSERT INTO gak_file SELECT * FROM x

        IF SQLCA.SQLCODE THEN    
            CALL cl_err3("ins","gak_file",g_sr.grprog,"",SQLCA.sqlcode,"","Reproduce gak_file",1)   #No.FUN-660081
            RETURN
        END IF
    END IF
 
    # Update gal_file
    DELETE FROM gal_file WHERE gal01=g_sr.grprog
    DROP TABLE x
    SELECT * FROM gal_file WHERE gal01=g_sr.prog INTO TEMP x     
    IF SQLCA.sqlcode = NOTFOUND THEN
        LET l_notfound = TRUE
    END IF
    IF NOT l_notfound THEN
        UPDATE x SET gal01  = g_sr.grprog
        INSERT INTO gal_file SELECT * FROM x

        IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","gal_file",g_sr.grprog,"",SQLCA.sqlcode,"","Reproduce gal_file",1)   #No.FUN-660081
            RETURN
        END IF
    END IF

END FUNCTION

PRIVATE FUNCTION copy_zz_per()
    DEFINE l_notfound   LIKE type_file.num5
    
    # Update gae_file
    DELETE FROM gae_file WHERE gae01=g_sr.grprog
    DROP TABLE x
    SELECT * FROM gae_file WHERE gae01=g_sr.prog INTO TEMP x     
    IF SQLCA.sqlcode = NOTFOUND THEN
        LET l_notfound = TRUE
    END IF
    IF NOT l_notfound THEN
        UPDATE x SET gae01  = g_sr.grprog
                     
        INSERT INTO gae_file SELECT * FROM x
 
        IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","gae_file",g_sr.grprog,"",SQLCA.sqlcode,"","Reproduce gae_file",1)   #No.FUN-660081
            RETURN
        END IF
    END IF
 
    # Update gav_file
    DELETE FROM gav_file WHERE gav01=g_sr.grprog
    DROP TABLE x
    SELECT * FROM gav_file WHERE gav01=g_sr.prog INTO TEMP x     
    IF SQLCA.sqlcode = NOTFOUND THEN
        LET l_notfound = TRUE
    END IF
    IF NOT l_notfound THEN
        UPDATE x SET gav01  = g_sr.grprog
        INSERT INTO gav_file SELECT * FROM x

        IF SQLCA.SQLCODE THEN    
            CALL cl_err3("ins","gav_file",g_sr.grprog,"",SQLCA.sqlcode,"","Reproduce gav_file",1)   #No.FUN-660081
            RETURN
        END IF
    END IF

END FUNCTION

PRIVATE FUNCTION has_rows()
    DEFINE l_flag   LIKE type_file.num5

    LET l_flag = (g_table2.getLength() > 0 OR g_table3.getLength() > 0
                 OR g_table4.getLength() > 0 OR g_table5.getLength() > 0
                 OR g_table6.getLength() > 0)
    RETURN l_flag
END FUNCTION

#新增gdw_file及gfs_file
PRIVATE  FUNCTION p_gengr_ins_grwdata()
    DEFINE l_gdw08   LIKE gdw_file.gdw08
    DEFINE l_gdw_cnt LIKE type_file.num10
    DEFINE l_cust    LIKE type_file.chr1  #EXT-D20130
    DEFINE l_chr     LIKE type_file.chr1  #EXT-D20130

   #EXT-D20130 --(s) 判斷是否為客製(第一碼為c)
    LET l_chr = g_sr.prog[1,1]
    IF l_chr MATCHES '[Cc]' THEN
       LET l_cust = 'Y'
    ELSE
       LET l_cust = 'N'
    END IF
   #EXT-D20130 --(e)

    SELECT count(*) INTO l_gdw_cnt FROM gdw_file 
           WHERE gdw01=g_sr.prog AND gdw02=g_sr.prog
           #AND   gdw03='N' AND gdw04='default'    #EXT-D20130 marked
           AND   gdw03=l_cust AND gdw04='default'  #EXT-D20130 add
           AND   gdw05='default' AND gdw06='std'

    IF l_gdw_cnt=0 THEN 

         SELECT MAX(gdw08) + 1 INTO l_gdw08 FROM gdw_file
         IF l_gdw08 IS NULL THEN
            LET l_gdw08 = 1
         END IF
         CALL p_gengr_ins_gfs(l_gdw08)
         INSERT INTO gdw_file (gdw01,gdw02,gdw03,gdw04,gdw05,
                               gdw06,gdw07,gdw08,gdw09,        
                               gdw11,gdw12,gdw13,gdwdate,gdwgrup,
                               gdwmodu,gdwuser,gdworig,gdworiu,gdw14, 
                               gdw15) 
             #VALUES (g_sr.prog,g_sr.prog,"N","default","default",   #EXT-D20130 marked
             VALUES (g_sr.prog,g_sr.prog,l_cust,"default","default", #EXT-D20130 modify gdw03
                     "std",1,l_gdw08,g_sr.prog,
                     "N","","",g_today,g_grup,
                     g_user,g_user,g_grup,g_user,"N", 
                     "1") 
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","gdw_file",g_sr.prog,"",SQLCA.sqlcode,"","",0)  
             
         END IF
    END IF        

END FUNCTION


FUNCTION p_gengr_ins_gfs(p_gdw08)
  DEFINE p_gdw08 LIKE gfs_file.gfs01
  DEFINE l_cnt,i,l_cnt1   LIKE type_file.num5
  DEFINE l_gfs  DYNAMIC ARRAY OF RECORD 
         gfs01   LIKE gfs_file.gfs01,
         gfs02   LIKE gfs_file.gfs02,
         gfs03   LIKE gfs_file.gfs03
         END RECORD 

  LET l_cnt=0  
  SELECT count(*) INTO l_cnt FROM gfs_file WHERE gfs01=p_gdw08  
  IF l_cnt>0 THEN RETURN END IF 
  IF l_cnt=0 THEN 
     
         DECLARE gfs01 SCROLL CURSOR FOR 
                 SELECT * FROM gfs_file WHERE gfs01='0'
         LET i=1 
         CALL l_gfs.clear()
         FOREACH gfs01 INTO l_gfs[i].*
           LET i=i+1
         END FOREACH 
         LET l_cnt1=i
         CALL l_gfs.deleteElement(l_cnt1)
         FOR i=1 TO  l_cnt1
         
           INSERT INTO gfs_file VALUES (p_gdw08,l_gfs[i].gfs02,l_gfs[i].gfs03)

           #INSERT INTO gfs_file(gfs01,gfs02,gfs03) VALUES (l_gfs[i].gfs01,l_gfs[i].gfs02,l_gfs[i].gfs03)
         END FOR 
         COMMIT WORK
      
  END IF 

  
END FUNCTION  

FUNCTION p_gengr_set_fontname()

   IF cl_null(g_sr.lang) THEN LET g_sr.lang = g_lang END IF

   CASE g_sr.lang
     WHEN "0" #繁體中文
        LET g_sr.fontname = cl_getmsg('azz1312',g_lang)
     WHEN "2" #簡體中文
        LET g_sr.fontname = 'SimHei'
     OTHERWISE
        LET g_sr.fontname = 'Arial Unicode MS'
   END CASE


END FUNCTION
