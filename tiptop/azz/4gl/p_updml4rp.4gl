# Prog. Version..: '5.30.06-13.04.19(00008)'     #
#
# Pattern name...: p_updml4rp.4gl
# Descriptions...: 比對兩個4rp檔案的差異
# Date & Author..: 12/02/21 By jacklai
# Usage .........: 
# Input Parameter: g_argv1    src 4rp檔案路徑 
#                  g_argv2    報表樣板ID
#                  g_argv3    語言別
# Return code....: none
# Memo...........: 調整完畢資料將回存到gdm_file，並更新語言別4rp
# Modify.........: No.FUN-C20112 12/02/23 By jacklai 上傳4rp改表格式比對
# Modify.........: No.FUN-C30008 12/03/07 By jacklai 增加欄位對齊屬性
# Modify.........: No:FUN-C40034 12/04/18 By janet 增加gdm26、gdm27兩個欄位, 全選/全不選ACTION
# Modify.........: No:FUN-C40064 12/04/17 By janet 增加r.f2、r.gf功能
# Modify.........: No:FUN-C50018 12/05/4  By janet 增加新舊值的勾選判斷
# Modify.........: No:TQC-C50065 12/05/08 By odyliao 修改新舊值判斷的問題
# Modify.........: No:FUN-C50143 12/05/30 By janet 新增ACTION[使用新值]、新舊值不同時，新值顯示紅色
# Modify.........: No:FUN-D30015 13/03/15 By odyliao 1.調整新舊值不同的判斷方式 2.使用舊值的欄位改為required
# Modify.........: No:EXT-D30029 13/03/28 by odyliao 調整畫面操作方式
# Modify.........: No:TQC-D40017 13/04/03 by odyliao 按下選取功能後，游標停留在原處，而不跳回第一行





#No.FUN-C20112 --start--
IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"
     
PRIVATE DEFINE g_sr_gdm DYNAMIC ARRAY OF RECORD
   chkall   LIKE type_file.chr1,
   gdm02n   LIKE gdm_file.gdm02,    #序號(新)
   gdm04n   LIKE gdm_file.gdm04,    #報表欄位代碼(新)
   gdm23n   LIKE gdm_file.gdm23,    #報表欄位說明(新)
   gdm05n   LIKE gdm_file.gdm05,    #類別(新)
   gdm07n   LIKE gdm_file.gdm07,    #定位點(新)
   gdm08n   LIKE gdm_file.gdm08,    #欄位寬度(新)
   gdm09n   LIKE gdm_file.gdm09,    #行序(新)
   gdm10n   LIKE gdm_file.gdm10,    #欄位順序(新)
   gdm11n   LIKE gdm_file.gdm11,    #字型(新)
   gdm12n   LIKE gdm_file.gdm12,    #字型大小(新)
   gdm13n   LIKE gdm_file.gdm13,    #粗體否(新)
   gdm14n   LIKE gdm_file.gdm14,    #顏色(新)
   gdm15n   LIKE gdm_file.gdm15,    #欄位說明寬度(新)
   gdm16n   LIKE gdm_file.gdm16,    #欄位說明字型(新)
   gdm17n   LIKE gdm_file.gdm17,    #欄位說明字型大小(新)
   gdm18n   LIKE gdm_file.gdm18,    #欄位說明粗體否(新)
   gdm19n   LIKE gdm_file.gdm19,    #欄位說明顏色(新)
   gdm20n   LIKE gdm_file.gdm20,    #折行否(新)
   gdm21n   LIKE gdm_file.gdm21,    #隱藏否(新)
   gdm22n   LIKE gdm_file.gdm22,    #欄位說明隱藏否(新)
   gdm24n   LIKE gdm_file.gdm24,    #欄位對齊(新) #FUN-C30008
   gdm25n   LIKE gdm_file.gdm25,    #欄位說明對齊(新)  #FUN-C30008
   gdm26n   LIKE gdm_file.gdm26,    #控制欄位隱藏公式(新)     #FUN-C40034
   gdm27n   LIKE gdm_file.gdm27,    #欄位說明隱藏公式(新)  #FUN-C40034
   gdm02    LIKE gdm_file.gdm02,    #序號
   gdm04    LIKE gdm_file.gdm04,    #報表欄位代碼
   gdm23    LIKE gdm_file.gdm23,    #報表欄位說明
   gdm05    LIKE gdm_file.gdm05,    #類別
   gdm07    LIKE gdm_file.gdm07,    #定位點
   gdm08    LIKE gdm_file.gdm08,    #欄位寬度
   gdm09    LIKE gdm_file.gdm09,    #行序
   gdm10    LIKE gdm_file.gdm10,    #欄位順序
   gdm11    LIKE gdm_file.gdm11,    #字型
   gdm12    LIKE gdm_file.gdm12,    #字型大小
   gdm13    LIKE gdm_file.gdm13,    #粗體否
   gdm14    LIKE gdm_file.gdm14,    #顏色
   gdm15    LIKE gdm_file.gdm15,    #欄位說明寬度
   gdm16    LIKE gdm_file.gdm16,    #欄位說明字型
   gdm17    LIKE gdm_file.gdm17,    #欄位說明字型大小
   gdm18    LIKE gdm_file.gdm18,    #欄位說明粗體否
   gdm19    LIKE gdm_file.gdm19,    #欄位說明顏色
   gdm20    LIKE gdm_file.gdm20,    #折行否
   gdm21    LIKE gdm_file.gdm21,    #隱藏否
   gdm22    LIKE gdm_file.gdm22,    #欄位說明隱藏否
   gdm24    LIKE gdm_file.gdm24,    #欄位對齊 #FUN-C30008
   gdm25    LIKE gdm_file.gdm25,    #欄位說明對齊  #FUN-C30008
   gdm26    LIKE gdm_file.gdm26,    #控制欄位隱藏公式     #FUN-C40034
   gdm27    LIKE gdm_file.gdm27,    #欄位說明隱藏公式  #FUN-C40034
   chkgdm02 LIKE type_file.chr1,
   chkgdm04 LIKE type_file.chr1,
   chkgdm23 LIKE type_file.chr1,
   chkgdm05 LIKE type_file.chr1,
   chkgdm07 LIKE type_file.chr1,
   chkgdm08 LIKE type_file.chr1,
   chkgdm09 LIKE type_file.chr1,
   chkgdm10 LIKE type_file.chr1,
   chkgdm11 LIKE type_file.chr1,
   chkgdm12 LIKE type_file.chr1,
   chkgdm13 LIKE type_file.chr1,
   chkgdm14 LIKE type_file.chr1,
   chkgdm15 LIKE type_file.chr1,
   chkgdm16 LIKE type_file.chr1,
   chkgdm17 LIKE type_file.chr1,
   chkgdm18 LIKE type_file.chr1,
   chkgdm19 LIKE type_file.chr1,
   chkgdm20 LIKE type_file.chr1,
   chkgdm21 LIKE type_file.chr1,
   chkgdm22 LIKE type_file.chr1,
   chkgdm24 LIKE type_file.chr1,    #FUN-C30008 add
   chkgdm25 LIKE type_file.chr1,    #FUN-C30008 add
   chkgdm26 LIKE type_file.chr1,    ##FUN-C40034 add
   chkgdm27 LIKE type_file.chr1,    #FUN-C40034 add   
   newval   STRING,
   oldval   STRING,
   useold   STRING
END RECORD

#FUN-C50143---add-start
PRIVATE DEFINE g_att_gdm DYNAMIC ARRAY OF RECORD
   chkall   LIKE type_file.chr1,
   gdm02n   LIKE gdm_file.gdm02,    #序號(新)
   gdm04n   LIKE gdm_file.gdm04,    #報表欄位代碼(新)
   gdm23n   STRING ,    #報表欄位說明(新)
   gdm05n   STRING,    #類別(新)
   gdm07n   STRING,    #定位點(新)
   gdm08n   STRING,    #欄位寬度(新)
   gdm09n   STRING,    #行序(新)
   gdm10n   STRING,    #欄位順序(新)
   gdm11n   STRING,    #字型(新)
   gdm12n   STRING,    #字型大小(新)
   gdm13n   STRING,    #粗體否(新)
   gdm14n   STRING,    #顏色(新)
   gdm15n   STRING,    #欄位說明寬度(新)
   gdm16n   STRING,    #欄位說明字型(新)
   gdm17n   STRING,    #欄位說明字型大小(新)
   gdm18n   STRING,    #欄位說明粗體否(新)
   gdm19n   STRING,    #欄位說明顏色(新)
   gdm20n   STRING,    #折行否(新)
   gdm21n   STRING,    #隱藏否(新)
   gdm22n   STRING,    #欄位說明隱藏否(新)
   gdm24n   STRING,    #欄位對齊(新) #FUN-C30008
   gdm25n   STRING,    #欄位說明對齊(新)  #FUN-C30008
   gdm26n   STRING,    #控制欄位隱藏公式(新)     #FUN-C40034
   gdm27n   STRING    #欄位說明隱藏公式(新)  #FUN-C40034
   #gdm02    LIKE gdm_file.gdm02,    #序號
   #gdm04    LIKE gdm_file.gdm04,    #報表欄位代碼
   #gdm23    LIKE gdm_file.gdm23,    #報表欄位說明
   #gdm05    LIKE gdm_file.gdm05,    #類別
   #gdm07    LIKE gdm_file.gdm07,    #定位點
   #gdm08    LIKE gdm_file.gdm08,    #欄位寬度
   #gdm09    LIKE gdm_file.gdm09,    #行序
   #gdm10    LIKE gdm_file.gdm10,    #欄位順序
   #gdm11    LIKE gdm_file.gdm11,    #字型
   #gdm12    LIKE gdm_file.gdm12,    #字型大小
   #gdm13    LIKE gdm_file.gdm13,    #粗體否
   #gdm14    LIKE gdm_file.gdm14,    #顏色
   #gdm15    LIKE gdm_file.gdm15,    #欄位說明寬度
   #gdm16    LIKE gdm_file.gdm16,    #欄位說明字型
   #gdm17    LIKE gdm_file.gdm17,    #欄位說明字型大小
   #gdm18    LIKE gdm_file.gdm18,    #欄位說明粗體否
   #gdm19    LIKE gdm_file.gdm19,    #欄位說明顏色
   #gdm20    LIKE gdm_file.gdm20,    #折行否
   #gdm21    LIKE gdm_file.gdm21,    #隱藏否
   #gdm22    LIKE gdm_file.gdm22,    #欄位說明隱藏否
   #gdm24    LIKE gdm_file.gdm24,    #欄位對齊 #FUN-C30008
   #gdm25    LIKE gdm_file.gdm25,    #欄位說明對齊  #FUN-C30008
   #gdm26    LIKE gdm_file.gdm26,    #控制欄位隱藏公式     #FUN-C40034
   #gdm27    LIKE gdm_file.gdm27,    #欄位說明隱藏公式  #FUN-C40034
   #chkgdm02 LIKE type_file.chr1,
   #chkgdm04 LIKE type_file.chr1,
   #chkgdm23 LIKE type_file.chr1,
   #chkgdm05 LIKE type_file.chr1,
   #chkgdm07 LIKE type_file.chr1,
   #chkgdm08 LIKE type_file.chr1,
   #chkgdm09 LIKE type_file.chr1,
   #chkgdm10 LIKE type_file.chr1,
   #chkgdm11 LIKE type_file.chr1,
   #chkgdm12 LIKE type_file.chr1,
   #chkgdm13 LIKE type_file.chr1,
   #chkgdm14 LIKE type_file.chr1,
   #chkgdm15 LIKE type_file.chr1,
   #chkgdm16 LIKE type_file.chr1,
   #chkgdm17 LIKE type_file.chr1,
   #chkgdm18 LIKE type_file.chr1,
   #chkgdm19 LIKE type_file.chr1,
   #chkgdm20 LIKE type_file.chr1,
   #chkgdm21 LIKE type_file.chr1,
   #chkgdm22 LIKE type_file.chr1,
   #chkgdm24 LIKE type_file.chr1,    #FUN-C30008 add
   #chkgdm25 LIKE type_file.chr1,    #FUN-C30008 add
   #chkgdm26 LIKE type_file.chr1,    ##FUN-C40034 add
   #chkgdm27 LIKE type_file.chr1,    #FUN-C40034 add   
   #newval   STRING,
   #oldval   STRING,
   #useold   STRING
END RECORD
#FUN-C50143---add-end 

#EXT-D30029----(S)
PRIVATE DEFINE g_diff DYNAMIC ARRAY OF RECORD
    check       LIKE type_file.chr1,     #使用舊值
    column_id   LIKE gdm_file.gdm04,     #欄位代號
    property    LIKE type_file.chr5,     #屬性
    new_value   LIKE type_file.chr1000,  #新值
    old_value   LIKE type_file.chr1000,  #舊值
    diff        LIKE type_file.chr1,     #是否有差異(Y/N)
    column_name LIKE gae_file.gae04,     #4rp記錄的欄位名稱
    feldname    LIKE gae_file.gae04,     #p_feldname 的名稱
    lineno      LIKE gdm_file.gdm02      #來源陣列的行數
END RECORD
DEFINE g_lang_now LIKE gdm_file.gdm03 
#EXT-D30029----(E)


PRIVATE DEFINE g_wc                 STRING
PRIVATE DEFINE g_sql                STRING
PRIVATE DEFINE g_rec_b              LIKE type_file.num5     # 單身筆數
PRIVATE DEFINE l_ac                 LIKE type_file.num5     # 目前處理的ARRAY CNT
PRIVATE DEFINE g_msg                LIKE type_file.chr1000
PRIVATE DEFINE g_curs_index         LIKE type_file.num10
PRIVATE DEFINE g_row_count          LIKE type_file.num10
PRIVATE DEFINE g_jump               LIKE type_file.num10
PRIVATE DEFINE g_no_ask             LIKE type_file.num5
PRIVATE DEFINE ga_gdm_new           DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
PRIVATE DEFINE ga_gdm_old           DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
PRIVATE DEFINE g_argv1              STRING
PRIVATE DEFINE g_argv2              STRING
PRIVATE DEFINE g_argv3              STRING
PRIVATE DEFINE g_gdm01              LIKE gdm_file.gdm01
PRIVATE DEFINE g_gdm03              LIKE gdm_file.gdm03
PRIVATE DEFINE g_4rppath            STRING

DEFINE g_chk_err_msg        STRING  #FUN-C10044 #檢查報表命名規則的錯誤訊息
DEFINE g_ac                 LIKE type_file.num5

MAIN 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-73001
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   WHENEVER ERROR CONTINUE

   IF NUM_ARGS() < 2 THEN
      EXIT PROGRAM -1
   END IF

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_4rppath = g_argv1
   LET g_gdm01 = g_argv2
   
   LET g_gdm03 = NULL
   IF NUM_ARGS() >= 3 THEN
      LET g_argv3 = ARG_VAL(3)
      LET g_gdm03 = g_argv3
   END IF

   IF (NOT cl_user()) THEN EXIT PROGRAM END IF

   IF (NOT cl_setup("AZZ")) THEN EXIT PROGRAM END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW p_mod_lang_4rp_w WITH FORM "azz/42f/p_updml4rp"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()

  #EXT-D30029 ---start
   CLOSE WINDOW p_mod_lang_4rp_w
   OPEN WINDOW p_updml4rp_diff_w WITH FORM "azz/42f/p_updml4rp_diff"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("p_updml4rp_diff")
  #EXT-D30029 ---end

  #FUN-D30015 ---(S)
   CALL cl_set_comp_required("chkgdm02,chkgdm04,chkgdm23,chkgdm05,chkgdm07,chkgdm08,chkgdm09",TRUE)
   CALL cl_set_comp_required("chkgdm10,chkgdm11,chkgdm12,chkgdm13,chkgdm14,chkgdm15,chkgdm16",TRUE)
   CALL cl_set_comp_required("chkgdm17,chkgdm18,chkgdm19,chkgdm20,chkgdm21,chkgdm22,chkgdm24",TRUE)
   CALL cl_set_comp_required("chkgdm25,chkgdm26,chkgdm27,chkall",TRUE)
  #FUN-D30015 ---(E)
 
   #設定語言別選項
   CALL cl_set_combo_lang("gdm03")

   IF NOT cl_null(g_argv1) THEN
      CALL p_updml4rp_q()
   END IF
 
   CALL p_updml4rp_menu()

  #EXT-D30029 ---start
   CLOSE WINDOW p_updml4rp_diff_w
  #EXT-D30029 ---end

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

PRIVATE FUNCTION p_updml4rp_read4rp()
   DEFINE l_doc      om.DomDocument
   DEFINE l_rootnode om.DomNode
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_j        LIKE type_file.num5
   DEFINE l_sql      STRING
   DEFINE l_found    LIKE type_file.num5
   DEFINE l_lastidx  LIKE type_file.num5
   DEFINE l_gdm23    LIKE gdm_file.gdm23

   IF NOT os.Path.exists(g_4rppath) THEN
      DISPLAY "File not found: ",g_4rppath
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM -2
   END IF
   LET l_doc = om.DomDocument.createFromXmlFile(g_4rppath)
   LET l_rootnode = l_doc.getDocumentElement()

   CALL g_sr_gdm.clear()
   CALL ga_gdm_new.clear()
   CALL ga_gdm_old.clear()

   LET g_chk_err_msg = NULL

   #讀4rp到陣列
#CHI-D30013 modify---(S)
  #CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"WORDBOX",g_gdm03,g_gdm01)
  #CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"WORDWRAPBOX",g_gdm03,g_gdm01)
  #CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"DECIMALFORMATBOX",g_gdm03,g_gdm01)
  #CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"PAGENOBOX",g_gdm03,g_gdm01)
  #CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"IMAGEBOX",g_gdm03,g_gdm01)
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"WORDBOX",g_gdm03,g_gdm01,'1')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"WORDBOX",g_gdm03,g_gdm01,'2')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"WORDWRAPBOX",g_gdm03,g_gdm01,'1')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"WORDWRAPBOX",g_gdm03,g_gdm01,'2')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"DECIMALFORMATBOX",g_gdm03,g_gdm01,'1')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"DECIMALFORMATBOX",g_gdm03,g_gdm01,'2')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"PAGENOBOX",g_gdm03,g_gdm01,'1')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"PAGENOBOX",g_gdm03,g_gdm01,'2')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"IMAGEBOX",g_gdm03,g_gdm01,'1')
   CALL p_replang_readnodes(ga_gdm_new,l_rootnode,"IMAGEBOX",g_gdm03,g_gdm01,'2')
#CHI-D30013 modify---(E)

   #顯示檢查命名規則的錯誤訊息
    IF g_chk_err_msg IS NOT NULL THEN
        CALL cl_err(g_chk_err_msg,"!",-1)
    END IF

   #將新資料新增到SCREEN RECORD
   FOR l_i = 1 TO ga_gdm_new.getLength()
      LET g_sr_gdm[l_i].newval = cl_gr_getmsg("gre-262",g_lang,"0") CLIPPED
      LET g_sr_gdm[l_i].oldval = cl_gr_getmsg("gre-262",g_lang,"1") CLIPPED
      LET g_sr_gdm[l_i].useold = cl_gr_getmsg("gre-262",g_lang,"2") CLIPPED
      LET g_sr_gdm[l_i].gdm02n = ga_gdm_new[l_i].gdm02 CLIPPED
      LET g_sr_gdm[l_i].gdm04n = ga_gdm_new[l_i].gdm04 CLIPPED
      #欄位說明需依語言別翻譯
     #EXT-D30029 ---(S)
      #LET g_sr_gdm[l_i].gdm23n = p_updml4rp_gdm23(g_gdm03,g_sr_gdm[l_i].gdm04n,ga_gdm_new[l_i].gdm05) #FUN-C30008
      LET g_sr_gdm[l_i].gdm23n = p_updml4rp_gdm23(g_gdm03,g_sr_gdm[l_i].gdm04n,ga_gdm_new[l_i].gdm05,ga_gdm_new[l_i].gdm23)
     #EXT-D30029 ---(E)
      LET g_sr_gdm[l_i].gdm05n = ga_gdm_new[l_i].gdm05 CLIPPED
      LET g_sr_gdm[l_i].gdm07n = ga_gdm_new[l_i].gdm07 CLIPPED
      LET g_sr_gdm[l_i].gdm08n = ga_gdm_new[l_i].gdm08 CLIPPED
      LET g_sr_gdm[l_i].gdm09n = ga_gdm_new[l_i].gdm09 CLIPPED
      LET g_sr_gdm[l_i].gdm10n = ga_gdm_new[l_i].gdm10 CLIPPED
      LET g_sr_gdm[l_i].gdm11n = ga_gdm_new[l_i].gdm11 CLIPPED
      LET g_sr_gdm[l_i].gdm12n = ga_gdm_new[l_i].gdm12 CLIPPED
      LET g_sr_gdm[l_i].gdm13n = ga_gdm_new[l_i].gdm13 CLIPPED
      LET g_sr_gdm[l_i].gdm14n = ga_gdm_new[l_i].gdm14 CLIPPED
      LET g_sr_gdm[l_i].gdm15n = ga_gdm_new[l_i].gdm15 CLIPPED
      LET g_sr_gdm[l_i].gdm16n = ga_gdm_new[l_i].gdm16 CLIPPED
      LET g_sr_gdm[l_i].gdm17n = ga_gdm_new[l_i].gdm17 CLIPPED
      LET g_sr_gdm[l_i].gdm18n = ga_gdm_new[l_i].gdm18 CLIPPED
      LET g_sr_gdm[l_i].gdm19n = ga_gdm_new[l_i].gdm19 CLIPPED
      LET g_sr_gdm[l_i].gdm20n = ga_gdm_new[l_i].gdm20 CLIPPED
      LET g_sr_gdm[l_i].gdm21n = ga_gdm_new[l_i].gdm21 CLIPPED
      LET g_sr_gdm[l_i].gdm22n = ga_gdm_new[l_i].gdm22 CLIPPED
      LET g_sr_gdm[l_i].gdm24n = ga_gdm_new[l_i].gdm24 CLIPPED #FUN-C30008
      LET g_sr_gdm[l_i].gdm25n = ga_gdm_new[l_i].gdm25 CLIPPED #FUN-C30008
      LET g_sr_gdm[l_i].gdm26n = ga_gdm_new[l_i].gdm26 CLIPPED #FUN-C40034
      LET g_sr_gdm[l_i].gdm27n = ga_gdm_new[l_i].gdm27 CLIPPED #FUN-C40034      
      LET g_sr_gdm[l_i].chkall = "Y"
     # CALL p_updml4rp_chkall(l_i,"Y")  #FUN-C40034 MARK
      CALL p_updml4rp_chkall2(l_i)  #FUN-C50018 ADD  判斷沒有舊值則CHK不勾
   END FOR

   CALL ga_gdm_new.clear() #Free Memory

   #自gdm_file讀取舊設定
   LET l_sql = "SELECT * FROM gdm_file",
               " WHERE gdm01 = ? AND gdm03 = ?",
               " ORDER BY gdm02"
   DECLARE p_updml4rp_read4rp_curs CURSOR FROM l_sql

   LET l_i = 1
   FOREACH p_updml4rp_read4rp_curs USING g_gdm01,g_gdm03 INTO ga_gdm_old[l_i].*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      ELSE
         LET l_i = l_i + 1
      END IF
   END FOREACH

   CALL ga_gdm_old.deleteElement(ga_gdm_old.getLength())

   #將舊資料新增到SCREEN RECORD
   FOR l_i = 1 TO ga_gdm_old.getLength()
      LET l_found = FALSE
      LET l_lastidx = 0
      FOR l_j = 1 TO g_sr_gdm.getLength()
         IF ga_gdm_old[l_i].gdm04 = g_sr_gdm[l_j].gdm04n THEN
            LET g_sr_gdm[l_j].newval = cl_gr_getmsg("gre-262",g_lang,"0") CLIPPED
            LET g_sr_gdm[l_j].oldval = cl_gr_getmsg("gre-262",g_lang,"1") CLIPPED
            LET g_sr_gdm[l_j].useold = cl_gr_getmsg("gre-262",g_lang,"2") CLIPPED
            LET g_sr_gdm[l_j].gdm02 = ga_gdm_old[l_i].gdm02 CLIPPED
            LET g_sr_gdm[l_j].gdm04 = ga_gdm_old[l_i].gdm04 CLIPPED
            LET g_sr_gdm[l_j].gdm23 = ga_gdm_old[l_i].gdm23 CLIPPED
            LET g_sr_gdm[l_j].gdm05 = ga_gdm_old[l_i].gdm05 CLIPPED
            LET g_sr_gdm[l_j].gdm07 = ga_gdm_old[l_i].gdm07 CLIPPED
            LET g_sr_gdm[l_j].gdm08 = ga_gdm_old[l_i].gdm08 CLIPPED
            LET g_sr_gdm[l_j].gdm09 = ga_gdm_old[l_i].gdm09 CLIPPED
            LET g_sr_gdm[l_j].gdm10 = ga_gdm_old[l_i].gdm10 CLIPPED
            LET g_sr_gdm[l_j].gdm11 = ga_gdm_old[l_i].gdm11 CLIPPED
            LET g_sr_gdm[l_j].gdm12 = ga_gdm_old[l_i].gdm12 CLIPPED
            LET g_sr_gdm[l_j].gdm13 = ga_gdm_old[l_i].gdm13 CLIPPED
            LET g_sr_gdm[l_j].gdm14 = ga_gdm_old[l_i].gdm14 CLIPPED
            LET g_sr_gdm[l_j].gdm15 = ga_gdm_old[l_i].gdm15 CLIPPED
            LET g_sr_gdm[l_j].gdm16 = ga_gdm_old[l_i].gdm16 CLIPPED
            LET g_sr_gdm[l_j].gdm17 = ga_gdm_old[l_i].gdm17 CLIPPED
            LET g_sr_gdm[l_j].gdm18 = ga_gdm_old[l_i].gdm18 CLIPPED
            LET g_sr_gdm[l_j].gdm19 = ga_gdm_old[l_i].gdm19 CLIPPED
            LET g_sr_gdm[l_j].gdm20 = ga_gdm_old[l_i].gdm20 CLIPPED
            LET g_sr_gdm[l_j].gdm21 = ga_gdm_old[l_i].gdm21 CLIPPED
            LET g_sr_gdm[l_j].gdm22 = ga_gdm_old[l_i].gdm22 CLIPPED
            LET g_sr_gdm[l_j].gdm24 = ga_gdm_old[l_i].gdm24 CLIPPED  #FUN-C30008
            LET g_sr_gdm[l_j].gdm25 = ga_gdm_old[l_i].gdm25 CLIPPED  #FUN-C30008
            LET g_sr_gdm[l_j].gdm26 = ga_gdm_old[l_i].gdm26 CLIPPED  #FUN-C40034
            LET g_sr_gdm[l_j].gdm27 = ga_gdm_old[l_i].gdm27 CLIPPED  #FUN-C40034            
            LET l_found = TRUE
            EXIT FOR
            
         END IF
         #TQC-C50065 MARK----(S)
         #CALL p_updml4rp_chkall2(l_j)  #FUN-C40034 ADD  判斷沒有舊值則CHK不勾
         #TQC-C50065 MARK----(E)
      END FOR
      CALL p_updml4rp_chkall2(l_j)  #TQC-C50065  判斷沒有舊值則CHK不勾
   END FOR

   CALL ga_gdm_old.clear() #Free Memory
END FUNCTION

PRIVATE FUNCTION p_updml4rp_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_sr_gdm.clear()

   #取所有語言別
   LET g_sql = "SELECT DISTINCT gay01 FROM gay_file",
               " WHERE gay01 IS NOT NULL AND gayacti='Y'" 
 
   IF NOT cl_null(g_gdm03) THEN
      LET g_wc = " AND gay01 = '",g_gdm03 CLIPPED,"'"
      LET g_sql = g_sql,g_wc
   END IF

   LET g_sql = g_sql," ORDER BY gay01"
 
   PREPARE p_updml4rp_pre FROM g_sql          # 預備一下
   DECLARE p_updml4rp_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FROM g_sql
END FUNCTION

FUNCTION p_updml4rp_count()
   DEFINE li_cnt     LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE l_gay01    LIKE gay_file.gay01
   
   DECLARE p_updml4rp_count_curs CURSOR FROM g_sql
   LET li_cnt = 1
   FOREACH p_updml4rp_count_curs INTO l_gay01
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    IF li_cnt >= 1 THEN
      LET li_cnt = li_cnt - 1
    END IF
    LET g_row_count = li_cnt
END FUNCTION
 
FUNCTION p_updml4rp_menu()
 
   WHILE TRUE
      CALL p_updml4rp_bp2()
      #CALL p_updml4rp_bp("G") #EXT-D30029 mark
 
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_updml4rp_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-C40034---ADD-START   
         WHEN "sel_all"
               CALL p_updml4rp_sel_all()
         WHEN "cancel_all"
               CALL p_updml4rp_cancel_all()
         #FUN-C40034---ADD-END
         #FUN-C50143---add-start
         WHEN "use_new"
              CALL  p_updml4rp_use_new()
         #FUN-C50143---add-end 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
        #EXT-D30029 add-----(S)
         WHEN "sel_all_diff"
               CALL p_updml4rp_sel_all_diff('Y')
         WHEN "cancel_all_diff"
               CALL p_updml4rp_sel_all_diff('N')
         WHEN "sel_diff"
               IF g_diff[l_ac].check = 'Y' THEN
                  LET g_diff[l_ac].check = 'N' 
               ELSE
                  LET g_diff[l_ac].check = 'Y' 
               END IF
         WHEN "save4rp"
              IF NOT cl_confirm("azz-938") THEN EXIT CASE END IF
              CALL p_updml4rp_diff_move_back() 
              CALL p_updml4rp_update()
              CALL p_updml4rp_save4rp()
         WHEN "translate_zhtw"
              CALL p_updml4rp_translate()
         WHEN "use_4rptext"
              CALL p_updml4rp_usecolumn('1')
         WHEN "use_feldname"
              CALL p_updml4rp_usecolumn('2')
        #EXT-D30029 add-----(E)
        #TQC-D40017--(S)
         WHEN "use_same_column"
              CALL p_updml4rp_usesamcolumn()
        #TQC-D40017--(E)
      END CASE
   END WHILE
END FUNCTION

#FUN-C50143 add-start---

FUNCTION p_updml4rp_use_new()
  DEFINE i     LIKE type_file.num5
    FOR i = 1 TO g_sr_gdm.getlength()
       CALL p_updml4rp_chkall_usenew(i)
    END FOR 
END FUNCTION 
#FUN-C50143 add-end-----

#FUN-C40034 ADD-START---
FUNCTION p_updml4rp_sel_all()
  DEFINE i     LIKE type_file.num5
    FOR i = 1 TO g_sr_gdm.getlength()
       CALL p_updml4rp_chkall(i,'Y')
    END FOR 
END FUNCTION 

FUNCTION p_updml4rp_cancel_all()
     DEFINE i     LIKE type_file.num5
    FOR i = 1 TO g_sr_gdm.getlength()
       CALL p_updml4rp_chkall(i,'N')
    END FOR 
END FUNCTION 

#FUN-C40034 ADD-END ---
 
FUNCTION p_updml4rp_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )

   CLEAR FORM              #清除畫面
   CALL g_sr_gdm.clear()   #清除單身
   
   DISPLAY '' TO FORMONLY.cnt
   CALL p_updml4rp_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_updml4rp_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gdm03 TO NULL
      LET g_gdm03 = ""
   ELSE
      CALL p_updml4rp_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_updml4rp_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_updml4rp_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1           #處理方式
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_updml4rp_b_curs INTO g_gdm03
      WHEN 'P' FETCH PREVIOUS p_updml4rp_b_curs INTO g_gdm03
      WHEN 'F' FETCH FIRST    p_updml4rp_b_curs INTO g_gdm03
      WHEN 'L' FETCH LAST     p_updml4rp_b_curs INTO g_gdm03
      WHEN '/' 
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_updml4rp_b_curs INTO g_gdm03
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gdm03,SQLCA.sqlcode,0)
      INITIALIZE g_gdm03 TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL p_updml4rp_show()
   END IF
END FUNCTION
 
#FUN-4A0088
FUNCTION p_updml4rp_show()                         # 將資料顯示在畫面上
   DISPLAY g_gdm03 TO gdm03
   LET g_lang_now = g_gdm03  #EXT-D30029
   CALL p_updml4rp_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

PRIVATE FUNCTION p_updml4rp_update()
   DEFINE la_gdm_u   DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_errmsg   STRING

   LET l_errmsg = NULL
   CALL la_gdm_u.clear()
   
   FOR l_i = 1 TO g_sr_gdm.getLength()
      LET la_gdm_u[l_i].gdm01 = g_gdm01
      LET la_gdm_u[l_i].gdm02 = g_sr_gdm[l_i].gdm02n
      LET la_gdm_u[l_i].gdm03 = g_gdm03
      LET la_gdm_u[l_i].gdm04 = g_sr_gdm[l_i].gdm04n
      LET la_gdm_u[l_i].gdm06 = "D"
      
      IF g_sr_gdm[l_i].chkgdm05 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm05) THEN
         LET la_gdm_u[l_i].gdm05 = g_sr_gdm[l_i].gdm05
      ELSE
         LET la_gdm_u[l_i].gdm05 = g_sr_gdm[l_i].gdm05n
      END IF

      IF g_sr_gdm[l_i].chkgdm07 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm07) THEN
         LET la_gdm_u[l_i].gdm07 = g_sr_gdm[l_i].gdm07
      ELSE
         LET la_gdm_u[l_i].gdm07 = g_sr_gdm[l_i].gdm07n
      END IF

      IF g_sr_gdm[l_i].chkgdm08 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm08) THEN
         LET la_gdm_u[l_i].gdm08 = g_sr_gdm[l_i].gdm08
      ELSE
         LET la_gdm_u[l_i].gdm08 = g_sr_gdm[l_i].gdm08n
      END IF

      IF g_sr_gdm[l_i].chkgdm09 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm09) THEN
         LET la_gdm_u[l_i].gdm09 = g_sr_gdm[l_i].gdm09
      ELSE
         LET la_gdm_u[l_i].gdm09 = g_sr_gdm[l_i].gdm09n
      END IF

      IF g_sr_gdm[l_i].chkgdm10 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm10) THEN
         LET la_gdm_u[l_i].gdm10 = g_sr_gdm[l_i].gdm10
      ELSE
         LET la_gdm_u[l_i].gdm10 = g_sr_gdm[l_i].gdm10n
      END IF

      IF g_sr_gdm[l_i].chkgdm11 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm11) THEN
         LET la_gdm_u[l_i].gdm11 = g_sr_gdm[l_i].gdm11
      ELSE
         LET la_gdm_u[l_i].gdm11 = g_sr_gdm[l_i].gdm11n
      END IF

      IF g_sr_gdm[l_i].chkgdm12 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm12) THEN
         LET la_gdm_u[l_i].gdm12 = g_sr_gdm[l_i].gdm12
      ELSE
         LET la_gdm_u[l_i].gdm12 = g_sr_gdm[l_i].gdm12n
      END IF

      IF g_sr_gdm[l_i].chkgdm13 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm13) THEN
         LET la_gdm_u[l_i].gdm13 = g_sr_gdm[l_i].gdm13
      ELSE
         LET la_gdm_u[l_i].gdm13 = g_sr_gdm[l_i].gdm13n
      END IF

      IF g_sr_gdm[l_i].chkgdm14 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm14) THEN
         LET la_gdm_u[l_i].gdm14 = g_sr_gdm[l_i].gdm14
      ELSE
         LET la_gdm_u[l_i].gdm14 = g_sr_gdm[l_i].gdm14n
      END IF

      IF g_sr_gdm[l_i].chkgdm15 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm15) THEN
         LET la_gdm_u[l_i].gdm15 = g_sr_gdm[l_i].gdm15
      ELSE
         LET la_gdm_u[l_i].gdm15 = g_sr_gdm[l_i].gdm15n
      END IF

      IF g_sr_gdm[l_i].chkgdm16 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm16) THEN
         LET la_gdm_u[l_i].gdm16 = g_sr_gdm[l_i].gdm16
      ELSE
         LET la_gdm_u[l_i].gdm16 = g_sr_gdm[l_i].gdm16n
      END IF

      IF g_sr_gdm[l_i].chkgdm17 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm17) THEN
         LET la_gdm_u[l_i].gdm17 = g_sr_gdm[l_i].gdm17
      ELSE
         LET la_gdm_u[l_i].gdm17 = g_sr_gdm[l_i].gdm17n
      END IF

      IF g_sr_gdm[l_i].chkgdm18 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm18) THEN
         LET la_gdm_u[l_i].gdm18 = g_sr_gdm[l_i].gdm18
      ELSE
         LET la_gdm_u[l_i].gdm18 = g_sr_gdm[l_i].gdm18n
      END IF

      IF g_sr_gdm[l_i].chkgdm19 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm19) THEN
         LET la_gdm_u[l_i].gdm19 = g_sr_gdm[l_i].gdm19
      ELSE
         LET la_gdm_u[l_i].gdm19 = g_sr_gdm[l_i].gdm19n
      END IF

      IF g_sr_gdm[l_i].chkgdm20 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm20) THEN
         LET la_gdm_u[l_i].gdm20 = g_sr_gdm[l_i].gdm20
      ELSE
         LET la_gdm_u[l_i].gdm20 = g_sr_gdm[l_i].gdm20n
      END IF

      IF g_sr_gdm[l_i].chkgdm21 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm21) THEN
         LET la_gdm_u[l_i].gdm21 = g_sr_gdm[l_i].gdm21
      ELSE
         LET la_gdm_u[l_i].gdm21 = g_sr_gdm[l_i].gdm21n
      END IF

      IF g_sr_gdm[l_i].chkgdm22 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm22) THEN
         LET la_gdm_u[l_i].gdm22 = g_sr_gdm[l_i].gdm22
      ELSE
         LET la_gdm_u[l_i].gdm22 = g_sr_gdm[l_i].gdm22n
      END IF

      IF g_sr_gdm[l_i].chkgdm23 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm23) THEN
         LET la_gdm_u[l_i].gdm23 = g_sr_gdm[l_i].gdm23
      ELSE
         LET la_gdm_u[l_i].gdm23 = g_sr_gdm[l_i].gdm23n
      END IF

      #FUN-C30008 --start--
      IF g_sr_gdm[l_i].chkgdm24 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm24) THEN
         LET la_gdm_u[l_i].gdm24 = g_sr_gdm[l_i].gdm24
      ELSE
         LET la_gdm_u[l_i].gdm24 = g_sr_gdm[l_i].gdm24n
      END IF

      IF g_sr_gdm[l_i].chkgdm25 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm25) THEN
         LET la_gdm_u[l_i].gdm25 = g_sr_gdm[l_i].gdm25
      ELSE
         LET la_gdm_u[l_i].gdm25 = g_sr_gdm[l_i].gdm25n
      END IF

      IF la_gdm_u[l_i].gdm24 IS NULL THEN
         LET la_gdm_u[l_i].gdm24 = " "
      END IF
      
      IF la_gdm_u[l_i].gdm25 IS NULL THEN
         LET la_gdm_u[l_i].gdm25 = " "
      END IF
      #FUN-C30008 --end--

      #FUN-C40034 --start--
      IF g_sr_gdm[l_i].chkgdm26 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm26) THEN
         LET la_gdm_u[l_i].gdm26 = g_sr_gdm[l_i].gdm26
      ELSE
         LET la_gdm_u[l_i].gdm26 = g_sr_gdm[l_i].gdm26n
      END IF

      IF g_sr_gdm[l_i].chkgdm27 = "Y" AND NOT cl_null(g_sr_gdm[l_i].gdm27) THEN
         LET la_gdm_u[l_i].gdm27 = g_sr_gdm[l_i].gdm27
      ELSE
         LET la_gdm_u[l_i].gdm27 = g_sr_gdm[l_i].gdm27n
      END IF

      IF la_gdm_u[l_i].gdm26 IS NULL THEN
         LET la_gdm_u[l_i].gdm26 = " "
      END IF
      
      IF la_gdm_u[l_i].gdm27 IS NULL THEN
         LET la_gdm_u[l_i].gdm27 = " "
      END IF
      #FUN-C40034 --end--

      
   END FOR

   #呼叫更新資料庫
   CALL p_replang_updgdm(la_gdm_u,g_gdm01,g_gdm03)
END FUNCTION

PRIVATE FUNCTION p_updml4rp_save4rp()
   DEFINE l_gdw01    LIKE gdw_file.gdw01
   DEFINE l_gdw09    LIKE gdw_file.gdw09
   DEFINE l_zz011    LIKE zz_file.zz011
   DEFINE l_cmd      STRING
   DEFINE l_4rpdir   STRING
   DEFINE l_4rppath  STRING
   DEFINE l_result   LIKE type_file.num5  #FUN-C30008

   LET l_result = FALSE #FUN-C30008
   SELECT gdw01,gdw09 INTO l_gdw01,l_gdw09 FROM gdw_file WHERE gdw08=g_gdm01

   SELECT zz011 INTO l_zz011 FROM zz_file WHERE zz01=l_gdw01

   LET l_zz011 = UPSHIFT(l_zz011)

   LET l_4rpdir = os.Path.join(FGL_GETENV(l_zz011 CLIPPED),"4rp")

   LET l_4rppath = os.Path.join(l_4rpdir,os.Path.join(g_gdm03 CLIPPED,l_gdw09 CLIPPED||".4rp"))

   #FUN-C30008 --start--
   #檢查來源與目的檔是否相同,不同才複製
   IF g_4rppath != l_4rppath THEN
      LET l_result = os.Path.copy(g_4rppath,l_4rppath)
   ELSE
      LET l_result = TRUE
   END IF
   #FUN-C30008 --end--
   
   #IF os.Path.copy(g_4rppath,l_4rppath) THEN   #FUN-C30008
   IF l_result THEN  #FUN-C30008
      LET l_cmd = "p_replang_regen '",g_gdm01 CLIPPED,"' '",g_gdm03 CLIPPED,"' '",l_4rpdir.trim(),"' '",l_gdw09 CLIPPED,"'"
      DISPLAY l_cmd
      #CALL cl_cmdrun(l_cmd)
      CALL cl_cmdrun_wait(l_cmd) #EXT-D20039
   END IF

   CALL cl_err('','lib-022',0) #EXT-D20039

END FUNCTION

#FUN-C40034 ADD-START----
PRIVATE FUNCTION p_updml4rp_chkall2(p_index)
   DEFINE p_index LIKE type_file.num5
   DEFINE l_gdm_all  LIKE type_file.chr1 
   

   
   IF p_index <= 0 THEN RETURN END IF
      LET l_gdm_all="Y"
      #IF cl_null(g_sr_gdm[p_index].gdm02) THEN
         #DISPLAY "g_sr_gdm[p_index].gdm02:",g_sr_gdm[p_index].gdm02
         #LET g_sr_gdm[p_index].chkgdm02="N"
         #LET l_gdm_all="N"
      #ELSE
         #LET g_sr_gdm[p_index].chkgdm02="Y"
      #END IF 
#
      #IF cl_null(g_sr_gdm[p_index].gdm04) THEN
         #LET g_sr_gdm[p_index].chkgdm04="N"
         #LET l_gdm_all="N"
      #ELSE
         #LET g_sr_gdm[p_index].chkgdm04="Y"
      #END IF 
      IF cl_null(g_sr_gdm[p_index].gdm23) THEN
         #DISPLAY "g_sr_gdm[p_index].gdm23n:",g_sr_gdm[p_index].gdm23n
         LET g_sr_gdm[p_index].chkgdm23="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm23="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm05) THEN
         LET g_sr_gdm[p_index].chkgdm05="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm05="Y"
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm07) THEN
         LET g_sr_gdm[p_index].chkgdm07="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm07="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm08) THEN
         LET g_sr_gdm[p_index].chkgdm08="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm08="Y"
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm09) THEN
         LET g_sr_gdm[p_index].chkgdm09="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm09="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm10) THEN
         LET g_sr_gdm[p_index].chkgdm10="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm10="Y"
      END IF  
      IF cl_null(g_sr_gdm[p_index].gdm11) THEN
         LET g_sr_gdm[p_index].chkgdm11="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm11="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm12) THEN
         LET g_sr_gdm[p_index].chkgdm12="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm12="Y"
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm13) THEN
         LET g_sr_gdm[p_index].chkgdm13="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm13="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm14) THEN
         LET g_sr_gdm[p_index].chkgdm14="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm14="Y"
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm15) THEN
         LET g_sr_gdm[p_index].chkgdm15="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm15="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm16) THEN
         LET g_sr_gdm[p_index].chkgdm16="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm16="Y"
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm17) THEN
         LET g_sr_gdm[p_index].chkgdm17="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm17="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm18) THEN
         LET g_sr_gdm[p_index].chkgdm18="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm18="Y"
      END IF        

      IF cl_null(g_sr_gdm[p_index].gdm19) THEN
         LET g_sr_gdm[p_index].chkgdm19="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm19="Y"
      END IF  
      IF cl_null(g_sr_gdm[p_index].gdm20) THEN
         LET g_sr_gdm[p_index].chkgdm20="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm20="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm21) THEN
         LET g_sr_gdm[p_index].chkgdm21="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm21="Y"
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm22) THEN
         LET g_sr_gdm[p_index].chkgdm22="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm22="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm24) THEN
         LET g_sr_gdm[p_index].chkgdm24="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm24="Y"
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm25) THEN
         LET g_sr_gdm[p_index].chkgdm25="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm25="Y"
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm26) THEN
         LET g_sr_gdm[p_index].chkgdm26="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm26="Y"
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm27) THEN
         LET g_sr_gdm[p_index].chkgdm27="N"
         LET l_gdm_all="N"
      ELSE
         LET g_sr_gdm[p_index].chkgdm27="Y"
      END IF 
        LET g_sr_gdm[p_index].chkall=l_gdm_all
END FUNCTION
#FUN-C40034 ADD-end ----



#FUN-C50143 ADD-START----
PRIVATE FUNCTION p_updml4rp_chkall_usenew(p_index)
   DEFINE p_index LIKE type_file.num5
   DEFINE l_gdm_all  LIKE type_file.chr1 
   
   
   IF p_index <= 0 THEN RETURN END IF
      LET l_gdm_all="Y"

      IF cl_null(g_sr_gdm[p_index].gdm23)  THEN
         LET g_sr_gdm[p_index].chkgdm23="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm23n) THEN
            LET g_sr_gdm[p_index].chkgdm23="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm23 <> g_sr_gdm[p_index].gdm23n THEN 
               LET g_sr_gdm[p_index].chkgdm23="N"
               LET l_gdm_all="N"
            ELSE        
               LET g_sr_gdm[p_index].chkgdm23="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm05) THEN
         LET g_sr_gdm[p_index].chkgdm05="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm05n) THEN
            LET g_sr_gdm[p_index].chkgdm05="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm05 <> g_sr_gdm[p_index].gdm05n THEN 
               LET g_sr_gdm[p_index].chkgdm05="N"
               LET l_gdm_all="N"
            ELSE       
             LET g_sr_gdm[p_index].chkgdm05="Y"
            END IF 
         END IF #FUN-D30015
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm07) THEN
         LET g_sr_gdm[p_index].chkgdm07="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm07n) THEN
            LET g_sr_gdm[p_index].chkgdm07="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm07 <> g_sr_gdm[p_index].gdm07n THEN 
               LET g_sr_gdm[p_index].chkgdm07="N"
               LET l_gdm_all="N"
            ELSE      
             LET g_sr_gdm[p_index].chkgdm07="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm08) THEN
         LET g_sr_gdm[p_index].chkgdm08="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm08n) THEN
            LET g_sr_gdm[p_index].chkgdm08="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm08 <> g_sr_gdm[p_index].gdm08n THEN 
               LET g_sr_gdm[p_index].chkgdm08="N"
               LET l_gdm_all="N"
            ELSE        
             LET g_sr_gdm[p_index].chkgdm08="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm09) THEN
         LET g_sr_gdm[p_index].chkgdm09="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm08n) THEN
            LET g_sr_gdm[p_index].chkgdm08="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm09 <> g_sr_gdm[p_index].gdm09n THEN 
               LET g_sr_gdm[p_index].chkgdm09="N"
               LET l_gdm_all="N"
            ELSE  
               LET g_sr_gdm[p_index].chkgdm09="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm10) THEN
         LET g_sr_gdm[p_index].chkgdm10="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm10n) THEN
            LET g_sr_gdm[p_index].chkgdm10="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm10 <> g_sr_gdm[p_index].gdm10n THEN 
               LET g_sr_gdm[p_index].chkgdm10="N"
               LET l_gdm_all="N"
            ELSE  
               LET g_sr_gdm[p_index].chkgdm10="Y"
            END IF 
         END IF #FUN-D30015
      END IF  

      IF cl_null(g_sr_gdm[p_index].gdm11) THEN
         LET g_sr_gdm[p_index].chkgdm11="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm11n) THEN
            LET g_sr_gdm[p_index].chkgdm11="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm11 <> g_sr_gdm[p_index].gdm11n THEN 
               LET g_sr_gdm[p_index].chkgdm11="N"
               LET l_gdm_all="N"
            ELSE      
               LET g_sr_gdm[p_index].chkgdm11="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm12) THEN
         LET g_sr_gdm[p_index].chkgdm12="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm12n) THEN
            LET g_sr_gdm[p_index].chkgdm12="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm12 <> g_sr_gdm[p_index].gdm12n THEN 
               LET g_sr_gdm[p_index].chkgdm12="N"
               LET l_gdm_all="N"
            ELSE   
               LET g_sr_gdm[p_index].chkgdm12="Y"
            END IF 
         END IF #FUN-D30015
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm13) THEN
         LET g_sr_gdm[p_index].chkgdm13="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm13n) THEN
            LET g_sr_gdm[p_index].chkgdm13="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm13 <> g_sr_gdm[p_index].gdm13n THEN 
               LET g_sr_gdm[p_index].chkgdm13="N"
               LET l_gdm_all="N"
            ELSE 
               LET g_sr_gdm[p_index].chkgdm13="Y"
            END IF 
         END IF ##FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm14) THEN
         LET g_sr_gdm[p_index].chkgdm14="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm14n) THEN
            LET g_sr_gdm[p_index].chkgdm14="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm14 <> g_sr_gdm[p_index].gdm14n THEN 
               LET g_sr_gdm[p_index].chkgdm14="N"
               LET l_gdm_all="N"
            ELSE  
               LET g_sr_gdm[p_index].chkgdm14="Y"
            END IF   
         END IF
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm15) THEN
         LET g_sr_gdm[p_index].chkgdm15="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm15n) THEN
            LET g_sr_gdm[p_index].chkgdm15="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm15 <> g_sr_gdm[p_index].gdm15n THEN 
               LET g_sr_gdm[p_index].chkgdm15="N"
               LET l_gdm_all="N"
            ELSE      
               LET g_sr_gdm[p_index].chkgdm15="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm16) THEN
         LET g_sr_gdm[p_index].chkgdm16="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm16n) THEN
            LET g_sr_gdm[p_index].chkgdm16="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm16 <> g_sr_gdm[p_index].gdm16n THEN 
               LET g_sr_gdm[p_index].chkgdm16="N"
               LET l_gdm_all="N"
            ELSE      
               LET g_sr_gdm[p_index].chkgdm16="Y"
            END IF 
         END IF #FUN-D30015
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm17) THEN
         LET g_sr_gdm[p_index].chkgdm17="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm17n) THEN
            LET g_sr_gdm[p_index].chkgdm17="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm17 <> g_sr_gdm[p_index].gdm17n THEN 
               LET g_sr_gdm[p_index].chkgdm17="N"
               LET l_gdm_all="N"
            ELSE     
               LET g_sr_gdm[p_index].chkgdm17="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm18) THEN
         LET g_sr_gdm[p_index].chkgdm18="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm18n) THEN
            LET g_sr_gdm[p_index].chkgdm18="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm18 <> g_sr_gdm[p_index].gdm18n THEN 
               LET g_sr_gdm[p_index].chkgdm18="N"
               LET l_gdm_all="N"
            ELSE           
               LET g_sr_gdm[p_index].chkgdm18="Y"
            END IF 
         END IF #FUN-D30015
      END IF        

      IF cl_null(g_sr_gdm[p_index].gdm19) THEN
         LET g_sr_gdm[p_index].chkgdm19="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm19n) THEN
            LET g_sr_gdm[p_index].chkgdm19="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm19 <> g_sr_gdm[p_index].gdm19n THEN 
               LET g_sr_gdm[p_index].chkgdm19="N"
               LET l_gdm_all="N"
            ELSE      
               LET g_sr_gdm[p_index].chkgdm19="Y"
            END IF 
         END IF #FUN-D30015
      END IF  

      IF cl_null(g_sr_gdm[p_index].gdm20) THEN
         LET g_sr_gdm[p_index].chkgdm20="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm20n) THEN
            LET g_sr_gdm[p_index].chkgdm20="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm20 <> g_sr_gdm[p_index].gdm20n THEN 
               LET g_sr_gdm[p_index].chkgdm20="N"
               LET l_gdm_all="N"
            ELSE     
               LET g_sr_gdm[p_index].chkgdm20="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm21) THEN
         LET g_sr_gdm[p_index].chkgdm21="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm21n) THEN
            LET g_sr_gdm[p_index].chkgdm21="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm21 <> g_sr_gdm[p_index].gdm21n THEN 
               LET g_sr_gdm[p_index].chkgdm21="N"
               LET l_gdm_all="N"
            ELSE            
               LET g_sr_gdm[p_index].chkgdm21="Y"
            END IF 
         END IF #FUN-D30015
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm22) THEN
         LET g_sr_gdm[p_index].chkgdm22="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm22n) THEN
            LET g_sr_gdm[p_index].chkgdm22="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm22 <> g_sr_gdm[p_index].gdm22n THEN 
               LET g_sr_gdm[p_index].chkgdm22="N"
               LET l_gdm_all="N"
            ELSE 
               LET g_sr_gdm[p_index].chkgdm22="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm24) THEN
         LET g_sr_gdm[p_index].chkgdm24="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm24n) THEN
            LET g_sr_gdm[p_index].chkgdm24="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm24 <> g_sr_gdm[p_index].gdm24n THEN 
               LET g_sr_gdm[p_index].chkgdm24="N"
               LET l_gdm_all="N"
            ELSE   
               LET g_sr_gdm[p_index].chkgdm24="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm25) THEN
         LET g_sr_gdm[p_index].chkgdm25="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm25n) THEN
            LET g_sr_gdm[p_index].chkgdm25="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm25 <> g_sr_gdm[p_index].gdm25n THEN 
               LET g_sr_gdm[p_index].chkgdm25="N"
               LET l_gdm_all="N"
            ELSE      
               LET g_sr_gdm[p_index].chkgdm25="Y"
            END IF 
         END IF #FUN-D30015
      END IF 

      IF cl_null(g_sr_gdm[p_index].gdm26) THEN
         LET g_sr_gdm[p_index].chkgdm26="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm26n) THEN
            LET g_sr_gdm[p_index].chkgdm26="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm26 <> g_sr_gdm[p_index].gdm26n THEN 
               LET g_sr_gdm[p_index].chkgdm26="N"
               LET l_gdm_all="N"
            ELSE      
               LET g_sr_gdm[p_index].chkgdm26="Y"
            END IF 
         END IF #FUN-D30015
      END IF 
      IF cl_null(g_sr_gdm[p_index].gdm27) THEN
         LET g_sr_gdm[p_index].chkgdm27="N"
         LET l_gdm_all="N"
      ELSE
       #FUN-D30015 add ----(S)
         IF cl_null(g_sr_gdm[p_index].gdm27n) THEN
            LET g_sr_gdm[p_index].chkgdm27="N"
         ELSE
       #FUN-D30015 add ----(E)
            IF g_sr_gdm[p_index].gdm27 <> g_sr_gdm[p_index].gdm27n THEN 
               LET g_sr_gdm[p_index].chkgdm27="N"
               LET l_gdm_all="N"
            ELSE      
               LET g_sr_gdm[p_index].chkgdm27="Y"
            END IF 
         END IF #FUN-D30015
      END IF 
        LET g_sr_gdm[p_index].chkall=l_gdm_all
END FUNCTION
#FUN-C50143 ADD-end ----

PRIVATE FUNCTION p_updml4rp_chkall(p_index, p_value)
   DEFINE p_index LIKE type_file.num5
   DEFINE p_value LIKE type_file.chr1
   
   IF p_index <= 0 THEN RETURN END IF
   
   LET g_sr_gdm[p_index].chkall = p_value
   LET g_sr_gdm[p_index].chkgdm02 = p_value
   LET g_sr_gdm[p_index].chkgdm04 = p_value
   LET g_sr_gdm[p_index].chkgdm23 = p_value
   LET g_sr_gdm[p_index].chkgdm05 = p_value
   LET g_sr_gdm[p_index].chkgdm07 = p_value
   LET g_sr_gdm[p_index].chkgdm08 = p_value
   LET g_sr_gdm[p_index].chkgdm09 = p_value
   LET g_sr_gdm[p_index].chkgdm10 = p_value
   LET g_sr_gdm[p_index].chkgdm11 = p_value
   LET g_sr_gdm[p_index].chkgdm12 = p_value
   LET g_sr_gdm[p_index].chkgdm13 = p_value
   LET g_sr_gdm[p_index].chkgdm14 = p_value
   LET g_sr_gdm[p_index].chkgdm15 = p_value
   LET g_sr_gdm[p_index].chkgdm16 = p_value
   LET g_sr_gdm[p_index].chkgdm17 = p_value
   LET g_sr_gdm[p_index].chkgdm18 = p_value
   LET g_sr_gdm[p_index].chkgdm19 = p_value
   LET g_sr_gdm[p_index].chkgdm20 = p_value
   LET g_sr_gdm[p_index].chkgdm21 = p_value
   LET g_sr_gdm[p_index].chkgdm22 = p_value
   LET g_sr_gdm[p_index].chkgdm24 = p_value  #FUN-C30008
   LET g_sr_gdm[p_index].chkgdm25 = p_value  #FUN-C30008
   LET g_sr_gdm[p_index].chkgdm26 = p_value  #FUN-C40034
   LET g_sr_gdm[p_index].chkgdm27 = p_value  #FUN-C40034   
END FUNCTION

FUNCTION p_updml4rp_b()                            # 單身
   DEFINE   l_chk_buf         LIKE type_file.chr1
   DEFINE   l_chk_t         LIKE type_file.chr1
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gdm03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')

    CALL cl_set_act_visible("accept",FALSE)

   INPUT ARRAY g_sr_gdm WITHOUT DEFAULTS FROM s_gdm.* 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE ROW
         LET l_ac = ARR_CURR()   #取得現在所在行
         #FUN-C50143--add---start--
         CALL p_updml4rp_set_att()
         CALL DIALOG.setCellAttributes(g_att_gdm)
         #FUN-C50153--add---end----
      BEFORE FIELD chkall
         LET l_chk_t = GET_FLDBUF(chkall)
      AFTER FIELD chkall
         LET l_chk_buf = GET_FLDBUF(chkall)
         IF l_chk_buf IS NOT NULL THEN 
            IF l_chk_t <> l_chk_buf THEN
               CALL p_updml4rp_chkall(l_ac,l_chk_buf)
            END IF
         END IF 
      ON CHANGE chkall
         LET l_chk_buf = GET_FLDBUF(chkall)
         IF l_chk_buf IS NOT NULL THEN 
            CALL p_updml4rp_chkall(l_ac,l_chk_buf)
         END IF
      ON ACTION save
         IF cl_confirm("azz1080") THEN
            DISPLAY "save 4rp"
            CALL p_updml4rp_update()
            CALL p_updml4rp_save4rp()
            EXIT INPUT
         END IF
   END INPUT
  #FUN-D30015 ---(S)
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
  #FUN-D30015 ---(E)
END FUNCTION


#FUN-C50143 add----start--

FUNCTION p_updml4rp_set_att()
   DEFINE l_i  LIKE type_file.num5

   FOR l_i = 1 TO g_sr_gdm.getlength()

      IF cl_null(g_sr_gdm[l_i].gdm23) OR (g_sr_gdm[l_i].gdm23 <> g_sr_gdm[l_i].gdm23n) THEN 
         LET g_att_gdm[l_i].gdm23n='red' 
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm05) OR (g_sr_gdm[l_i].gdm05 <> g_sr_gdm[l_i].gdm05n) THEN 
         LET g_att_gdm[l_i].gdm05n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm07) OR (g_sr_gdm[l_i].gdm07 <> g_sr_gdm[l_i].gdm07n) THEN 
         LET g_att_gdm[l_i].gdm07n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm08) OR (g_sr_gdm[l_i].gdm08 <> g_sr_gdm[l_i].gdm08n) THEN 
         LET g_att_gdm[l_i].gdm08n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm09) OR (g_sr_gdm[l_i].gdm09 <> g_sr_gdm[l_i].gdm09n) THEN 
         LET g_att_gdm[l_i].gdm09n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm10) OR (g_sr_gdm[l_i].gdm10 <> g_sr_gdm[l_i].gdm10n) THEN 
         LET g_att_gdm[l_i].gdm10n='red'
      END IF  

      IF cl_null(g_sr_gdm[l_i].gdm11) OR (g_sr_gdm[l_i].gdm11 <> g_sr_gdm[l_i].gdm11n) THEN 
         LET g_att_gdm[l_i].gdm11n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm12) OR (g_sr_gdm[l_i].gdm12 <> g_sr_gdm[l_i].gdm12n) THEN 
         LET g_att_gdm[l_i].gdm12n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm13) OR (g_sr_gdm[l_i].gdm13 <> g_sr_gdm[l_i].gdm13n) THEN 
         LET g_att_gdm[l_i].gdm13n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm14) OR (g_sr_gdm[l_i].gdm14 <> g_sr_gdm[l_i].gdm14n) THEN 
         LET g_att_gdm[l_i].gdm14n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm15) OR (g_sr_gdm[l_i].gdm15 <> g_sr_gdm[l_i].gdm15n) THEN 
         LET g_att_gdm[l_i].gdm15n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm16) OR (g_sr_gdm[l_i].gdm16 <> g_sr_gdm[l_i].gdm16n) THEN 
         LET g_att_gdm[l_i].gdm16n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm17) OR (g_sr_gdm[l_i].gdm17 <> g_sr_gdm[l_i].gdm17n) THEN 
         LET g_att_gdm[l_i].gdm17n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm18) OR (g_sr_gdm[l_i].gdm18 <> g_sr_gdm[l_i].gdm18n) THEN 
         LET g_att_gdm[l_i].gdm18n='red'
      END IF        

      IF cl_null(g_sr_gdm[l_i].gdm19) OR (g_sr_gdm[l_i].gdm19 <> g_sr_gdm[l_i].gdm19n) THEN 
         LET g_att_gdm[l_i].gdm19n='red'
      END IF  

      IF cl_null(g_sr_gdm[l_i].gdm20) OR (g_sr_gdm[l_i].gdm20 <> g_sr_gdm[l_i].gdm20n) THEN 
         LET g_att_gdm[l_i].gdm20n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm21) OR (g_sr_gdm[l_i].gdm21 <> g_sr_gdm[l_i].gdm21n) THEN 
         LET g_att_gdm[l_i].gdm21n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm22) OR (g_sr_gdm[l_i].gdm22 <> g_sr_gdm[l_i].gdm22n) THEN 
         LET g_att_gdm[l_i].gdm22n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm24) OR (g_sr_gdm[l_i].gdm24 <> g_sr_gdm[l_i].gdm24n) THEN 
         LET g_att_gdm[l_i].gdm24n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm25) OR (g_sr_gdm[l_i].gdm25 <> g_sr_gdm[l_i].gdm25n) THEN 
         LET g_att_gdm[l_i].gdm25n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm26) OR (g_sr_gdm[l_i].gdm26 <> g_sr_gdm[l_i].gdm26n) THEN 
         LET g_att_gdm[l_i].gdm26n='red'
      END IF 

      IF cl_null(g_sr_gdm[l_i].gdm27) OR (g_sr_gdm[l_i].gdm27 <> g_sr_gdm[l_i].gdm27n) THEN 
         LET g_att_gdm[l_i].gdm27n='red'
      END IF 
       
   END FOR
END FUNCTION
#FUN-C50143 add----end ----

FUNCTION p_updml4rp_b_fill(p_wc)               #BODY FILL UP
 
   DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(300)

   LET g_ac = 1  #TQC-D40017
   CALL p_updml4rp_read4rp()
   LET g_rec_b = g_sr_gdm.getLength()
   DISPLAY g_rec_b TO FORMONLY.cn2

   CALL p_updml4rp_diff_move_to()  #EXT-D30029

END FUNCTION
 
FUNCTION p_updml4rp_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_sr_gdm TO s_gdm.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         #FUN-C50143--add---start--
         CALL p_updml4rp_set_att()
         CALL DIALOG.setCellAttributes(g_att_gdm)
         #FUN-C50153--add---end---- 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG = FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_updml4rp_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
            ACCEPT DISPLAY
 
      ON ACTION previous                         # P.上筆
         CALL p_updml4rp_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump                             # 指定筆
         CALL p_updml4rp_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next                             # N.下筆
         CALL p_updml4rp_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last                             # 最終筆
         CALL p_updml4rp_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf 
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("gdm03")
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      #FUN-C40064 ADD----START
      ON ACTION sel_all
           LET g_action_choice = 'sel_all'
          EXIT DISPLAY
      ON ACTION cancel_all
           LET g_action_choice = 'cancel_all'
          EXIT DISPLAY
      #FUN-C40064 ADD----END
      #FUN-C50143 add----start
      ON ACTION use_new
           LET g_action_choice = 'use_new'
          EXIT DISPLAY      
      #FUN-C50143 add----end 
          
      ON ACTION about
         CALL cl_about()
       
      AFTER DISPLAY
         CONTINUE DISPLAY
         
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                          
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-C20112 --end--

#EXT-D30029 --start
#FUN-C30008 --start--
#FUNCTION p_updml4rp_gdm23(p_gdm03,p_gdm04,p_gdm05)
#  DEFINE p_gdm03 LIKE gdm_file.gdm03
#  DEFINE p_gdm04 LIKE gdm_file.gdm04
#  DEFINE p_gdm05 LIKE gdm_file.gdm05
#  DEFINE l_gdm23 LIKE gdm_file.gdm23
#  DEFINE l_desc  STRING
#  DEFINE l_name  STRING

#  LET l_gdm23 = NULL
#  IF NOT cl_null(p_gdm03) AND NOT cl_null(p_gdm04) AND NOT cl_null(p_gdm05) THEN
#     LET l_name = p_replang_getcolname(p_gdm04 CLIPPED)
#     LET l_gdm23 = cl_get_feldname(l_name,p_gdm03)
#     #單頭欄位說明尾端需加冒號(:)
#     IF l_gdm23 IS NOT NULL THEN
#        LET l_desc = l_gdm23 CLIPPED               
#        IF p_gdm05 = "1" AND l_desc.getCharAt(l_desc.getLength()) != ":" THEN
#           LET l_gdm23 = l_gdm23 CLIPPED,":"
#        END IF
#     END IF
#  END IF
#  RETURN l_gdm23
#END FUNCTION
#FUN-C30008 --end--
FUNCTION p_updml4rp_gdm23(p_gdm03,p_gdm04,p_gdm05,p_gdm23)
   DEFINE p_gdm03 LIKE gdm_file.gdm03
   DEFINE p_gdm04 LIKE gdm_file.gdm04
   DEFINE p_gdm05 LIKE gdm_file.gdm05
   DEFINE p_gdm23 LIKE gdm_file.gdm23
   DEFINE l_gdm23 LIKE gdm_file.gdm23
   DEFINE l_desc  STRING
   DEFINE l_name  STRING

   LET l_gdm23 = p_gdm23
   IF NOT cl_null(p_gdm03) AND NOT cl_null(p_gdm04) AND NOT cl_null(p_gdm05) THEN
      #單頭欄位說明尾端需加冒號(:)
      IF l_gdm23 IS NOT NULL THEN
         LET l_desc = l_gdm23 CLIPPED               
         IF p_gdm05 = "1" AND l_desc.getCharAt(l_desc.getLength()) != ":" THEN
            LET l_gdm23 = l_gdm23 CLIPPED,":"
         END IF
      END IF
   END IF
   RETURN l_gdm23
END FUNCTION

#取得 p_feldname 的值 (若取不到則保留取4rp欄位的名稱)
FUNCTION p_updml4rp_feldname(p_gdm03,p_gdm04,p_gdm05,p_gdm23)
   DEFINE p_gdm03 LIKE gdm_file.gdm03
   DEFINE p_gdm04 LIKE gdm_file.gdm04
   DEFINE p_gdm05 LIKE gdm_file.gdm05
   DEFINE p_gdm23 LIKE gdm_file.gdm23
   DEFINE l_gdm23 LIKE gdm_file.gdm23
   DEFINE l_desc  STRING
   DEFINE l_name  STRING

   LET l_gdm23 = NULL
   IF NOT cl_null(p_gdm03) AND NOT cl_null(p_gdm04) AND NOT cl_null(p_gdm05) THEN
      LET l_name = p_replang_getcolname(p_gdm04 CLIPPED)
      LET l_gdm23 = cl_get_feldname(l_name,p_gdm03)
      IF cl_null(l_gdm23) THEN LET l_gdm23 = p_gdm23 END IF
      #單頭欄位說明尾端需加冒號(:)
      IF l_gdm23 IS NOT NULL THEN
         LET l_desc = l_gdm23 CLIPPED               
         IF p_gdm05 = "1" AND l_desc.getCharAt(l_desc.getLength()) != ":" THEN
            LET l_gdm23 = l_gdm23 CLIPPED,":"
         END IF
      END IF
   END IF
   RETURN l_gdm23
END FUNCTION
#EXT-D30029 --end

#EXT-D30029  ----(S)
#將原陣列轉到新的比對陣列
FUNCTION p_updml4rp_diff_move_to() 
DEFINE l_i,l_j   LIKE type_file.num5
DEFINE l_line    LIKE type_file.num10

    CALL g_diff.clear()
    LET l_line = 1
    FOR l_i = 1 TO g_sr_gdm.getlength()
       #gdm05 類別
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '05'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm05n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm05
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF #只保留新舊值有差異的
       #gdm07 定位點
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '07'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm07n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm07
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN#只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm08 欄位寬度
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '08'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm08n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm08
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN#只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm09 行序
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '09'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm09n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm09
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm10 欄位順序
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '10'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm10n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm10
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm11 字型
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '11'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm11n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm11
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm12 字型大小
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '12'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm12n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm12
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm13 粗體
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '13'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm13n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm13
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm14 顏色
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '14'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm14n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm14
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm15 欄位說明寬度
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '15'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm15n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm15
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm16 欄位說明字型
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '16'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm16n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm16
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm17 欄位說明字型大小
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '17'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm17n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm17
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm18 欄位說明粗體
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '18'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm18n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm18
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm19 欄位說明顏色
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '19'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm19n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm19
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm20 折行
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '20'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm20n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm20
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm21 隱藏
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '21'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm21n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm21
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm22 欄位說明隱藏
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '22'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm22n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm22
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm23 欄位說明
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '23'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm23n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm23
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        LET g_diff[l_line].column_name = g_sr_gdm[l_i].gdm23n #記錄4rp中的欄位名稱
        LET g_diff[l_line].feldname = p_updml4rp_feldname(g_gdm03,g_sr_gdm[l_i].gdm04,g_sr_gdm[l_i].gdm05,g_diff[l_line].new_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm24 欄位對齊
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '24'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm24n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm24
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm25 欄位說明對齊
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '25'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm25n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm25
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm26 欄位顯示公式
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '26'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm26n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm26
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 
       #gdm27 欄位說明顯示公式
        LET g_diff[l_line].check = 'N'
        LET g_diff[l_line].column_id = g_sr_gdm[l_i].gdm04n
        LET g_diff[l_line].lineno = l_i
        LET g_diff[l_line].property = '27'
        LET g_diff[l_line].new_value = g_sr_gdm[l_i].gdm27n
        LET g_diff[l_line].old_value = g_sr_gdm[l_i].gdm27
        LET g_diff[l_line].diff = p_updml4rp_chkdiff(g_diff[l_line].new_value,g_diff[l_line].old_value)
        IF g_diff[l_line].diff = 'N' THEN #只保留新舊值有差異的
           CALL g_diff.deleteElement(l_line) 
        ELSE 
           LET l_line = l_line+1 
        END IF 

    END FOR
   
    CALL g_diff.deleteElement(l_line)
    LET l_line=l_line - 1
    DISPLAY l_line TO cn2

END FUNCTION

FUNCTION p_updml4rp_chkdiff(p_new_value,p_old_value)
DEFINE p_new_value  LIKE type_file.chr1000
DEFINE p_old_value  LIKE type_file.chr1000

   #兩者皆為空則回傳N
    IF cl_null(p_new_value) AND cl_null(p_old_value) THEN
       RETURN 'N'
    END IF

   #兩者其中一個為空則回傳Y
    IF cl_null(p_new_value) OR cl_null(p_old_value) THEN
       RETURN 'Y'
    END IF
    
   #兩者不同時回傳Y
    IF p_new_value <> p_old_value THEN
       RETURN 'Y'
    ELSE
       RETURN 'N'
    END IF

END FUNCTION

#將原陣列轉到新的比對陣列
FUNCTION p_updml4rp_diff_move_back() 
DEFINE l_i,l_j   LIKE type_file.num5
DEFINE l_line    LIKE type_file.num10

    FOR l_i = 1 TO g_diff.getlength()
        IF cl_null(g_diff[l_i].column_id) THEN CONTINUE FOR END IF
        LET l_line = g_diff[l_i].lineno
        CASE g_diff[l_i].property
         #gdm05 類別
          WHEN "05"
            LET g_sr_gdm[l_line].gdm05 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm05n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm05 = g_diff[l_i].check
         #gdm07 定位點
          WHEN "07"
            LET g_sr_gdm[l_line].gdm07 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm07n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm07 = g_diff[l_i].check
         #gdm08 欄位寬度
          WHEN "08"
            LET g_sr_gdm[l_line].gdm08 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm08n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm08 = g_diff[l_i].check
         #gdm09 行序
          WHEN "09"
            LET g_sr_gdm[l_line].gdm09 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm09n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm09 = g_diff[l_i].check
         #gdm10 欄位順序
          WHEN "10"
            LET g_sr_gdm[l_line].gdm10 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm10n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm10 = g_diff[l_i].check
         #gdm11 字型
          WHEN "11"
            LET g_sr_gdm[l_line].gdm11 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm11n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm11 = g_diff[l_i].check
         #gdm12 字型大小
          WHEN "12"
            LET g_sr_gdm[l_line].gdm12 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm12n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm12 = g_diff[l_i].check
         #gdm13 粗體
          WHEN "13"
            LET g_sr_gdm[l_line].gdm13 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm13n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm13 = g_diff[l_i].check
         #gdm14 顏色
          WHEN "14"
            LET g_sr_gdm[l_line].gdm14 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm14n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm14 = g_diff[l_i].check
         #gdm15 欄位說明寬度
          WHEN "15"
            LET g_sr_gdm[l_line].gdm15 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm15n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm15 = g_diff[l_i].check
         #gdm16 欄位說明字型
          WHEN "16"
            LET g_sr_gdm[l_line].gdm16 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm16n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm16 = g_diff[l_i].check
         #gdm17 欄位說明字型大小
          WHEN "17"
            LET g_sr_gdm[l_line].gdm17 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm17n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm17 = g_diff[l_i].check
         #gdm18 欄位說明粗體
          WHEN "18"
            LET g_sr_gdm[l_line].gdm18 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm18n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm18 = g_diff[l_i].check
         #gdm19 欄位說明顏色
          WHEN "19"
            LET g_sr_gdm[l_line].gdm19 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm19n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm19 = g_diff[l_i].check
         #gdm20 折行
          WHEN "20"
            LET g_sr_gdm[l_line].gdm20 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm20n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm20 = g_diff[l_i].check
         #gdm21 隱藏
          WHEN "21"
            LET g_sr_gdm[l_line].gdm21 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm21n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm21 = g_diff[l_i].check
         #gdm22 欄位說明隱藏
          WHEN "22"
            LET g_sr_gdm[l_line].gdm22 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm22n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm22 = g_diff[l_i].check
         #gdm23 欄位說明
          WHEN "23"
            LET g_sr_gdm[l_line].gdm23 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm23n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm23 = g_diff[l_i].check
         #gdm24 欄位對齊
          WHEN "24"
            LET g_sr_gdm[l_line].gdm24 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm24n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm24 = g_diff[l_i].check
         #gdm25 欄位說明對齊
          WHEN "25"
            LET g_sr_gdm[l_line].gdm25 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm25n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm25 = g_diff[l_i].check
         #gdm26 欄位顯示公式
          WHEN "26"
            LET g_sr_gdm[l_line].gdm26 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm26n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm26 = g_diff[l_i].check
         #gdm27 欄位說明顯示公式
          WHEN "27"
            LET g_sr_gdm[l_line].gdm27 = g_diff[l_i].old_value
            LET g_sr_gdm[l_line].gdm27n= g_diff[l_i].new_value
            LET g_sr_gdm[l_line].chkgdm27 = g_diff[l_i].check
        END CASE
    END FOR
   
END FUNCTION

FUNCTION p_updml4rp_bp2()
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF g_action_choice = "detail" THEN
      LET g_action_choice = " "
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_diff TO s_diff.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
        #TQC-D40017 (S)
         IF g_ac > 0 THEN 
            LET l_ac = g_ac
         ELSE
            LET l_ac = 1
         END IF
         CALL FGL_SET_ARR_CURR(l_ac)
        #TQC-D40017 (E)
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG = FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_updml4rp_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
            ACCEPT DISPLAY
 
      ON ACTION previous                         # P.上筆
         CALL p_updml4rp_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump                             # 指定筆
         CALL p_updml4rp_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next                             # N.下筆
         CALL p_updml4rp_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last                             # 最終筆
         CALL p_updml4rp_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf 
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("gdm03")
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION sel_diff
          LET g_action_choice = 'sel_diff'
          EXIT DISPLAY
      ON ACTION sel_all_diff
          LET g_action_choice = 'sel_all_diff'
          EXIT DISPLAY
      ON ACTION cancel_all_diff
          LET g_action_choice = 'cancel_all_diff'
          EXIT DISPLAY
      ON ACTION translate_zhtw
          LET g_action_choice = 'translate_zhtw'
          EXIT DISPLAY
      ON ACTION use_4rptext
          LET g_action_choice = 'use_4rptext'
          EXIT DISPLAY
      ON ACTION use_feldname
          LET g_action_choice = 'use_feldname'
          EXIT DISPLAY
     #TQC-D40017 ---(S)
      ON ACTION use_same_column
          LET g_action_choice = 'use_same_column'
          EXIT DISPLAY
     #TQC-D40017 ---(E)
      ON ACTION save4rp
          LET g_action_choice = 'save4rp'
          EXIT DISPLAY
          
      ON ACTION about
         CALL cl_about()
       
      AFTER DISPLAY
         CONTINUE DISPLAY
         
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                          
 
   END DISPLAY
   LET g_ac = l_ac #TQC-D40017
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p_updml4rp_sel_all_diff(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
  DEFINE i     LIKE type_file.num5
    FOR i = 1 TO g_diff.getlength()
        LET g_diff[i].check = p_cmd
    END FOR 
END FUNCTION 

FUNCTION p_updml4rp_translate()
DEFINE i LIKE type_file.num5
DEFINE l_gae04 LIKE gae_file.gae04
DEFINE l_check LIKE type_file.chr1
DEFINE l_choice LIKE type_file.chr1

      IF g_gdm03 NOT MATCHES '[02]' THEN RETURN END IF
      LET g_msg = cl_getmsg('azz1316',g_lang)
      PROMPT g_msg CLIPPED,': ' FOR l_choice
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
          ON ACTION controlp
             CALL cl_cmdask()
          ON ACTION help
             CALL cl_show_help()
          ON ACTION about
             CALL cl_about()
      END PROMPT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF

      CASE l_choice
        WHEN "1" LET g_lang_now = "0" LET l_check = "2"
        WHEN "2" LET g_lang_now = "2" LET l_check = "0"
        OTHERWISE RETURN 
      END CASE
         
      FOR i = 1 TO g_diff.getlength()
          IF g_diff[i].property <> '23' THEN CONTINUE FOR END IF
          IF cl_updml4rp_check02(l_check,g_diff[i].new_value) THEN
             LET l_gae04 = cl_trans_utf8_twzh(g_lang_now,g_diff[i].new_value)
             LET g_diff[i].new_value = l_gae04
          END IF
      END FOR

END FUNCTION

#選擇使用 4rp維護的Label名稱或系統欄位名稱(p_feldname)
FUNCTION p_updml4rp_usecolumn(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1
DEFINE i      LIKE type_file.num5 

    FOR i = 1 TO g_diff.getlength()
        IF g_diff[i].property = '23' THEN
           IF p_cmd = '1' THEN #使用4rp
              LET g_diff[i].new_value = g_diff[i].column_name
           ELSE
              LET g_diff[i].new_value = g_diff[i].feldname
           END IF
        END IF
    END FOR
END FUNCTION

FUNCTION cl_updml4rp_check02(lc_gay01,ls_str)

   DEFINE lc_gay01     LIKE gay_file.gay01
   DEFINE ls_str       STRING
   DEFINE ls_cmd       STRING
   DEFINE ls_result    STRING
   DEFINE ls_temp      STRING    #TEMPDIR路徑
   DEFINE ls_msg       STRING               #訊息        #FUN-B90139
   DEFINE l_gay03      LIKE gay_file.gay03  #語言別名稱   #FUN-B90139
   DEFINE l_sql        STRING               #FUN-B90139
   DEFINE l_str_ch     base.Channel #FUN-BB0104
   
   IF ls_str IS NULL THEN
      RETURN FALSE   #傳入值為空的時候,不查
   END IF
   LET ls_msg = NULL
   LET l_sql = 'SELECT gay03 FROM gay_file',
                ' WHERE gay01 = ? AND gayacti = "Y"'
   PREPARE cl_unicode_check02_pre FROM l_sql
   EXECUTE cl_unicode_check02_pre USING lc_gay01 INTO l_gay03

   LET ls_msg = ls_str CLIPPED,"|",l_gay03 CLIPPED
   LET ls_temp = os.Path.join(FGL_GETENV("TEMPDIR"),FGL_GETPID())

   LET ls_cmd = "\\rm -rf ",ls_temp.trim(),"qc.src ",ls_temp.trim(),"qc.tran ",ls_temp.trim(),"qc.u8 ",ls_temp.trim(),"qc.dif"
   RUN ls_cmd
   LET l_str_ch = base.Channel.create()
   CALL l_str_ch.openFile(ls_temp.trim()||"qc.src", "w")
   LET ls_str = cl_get_check_string(ls_str) #FUN-BB0152
   CALL l_str_ch.writeLine(ls_str.trim())
   CALL l_str_ch.close()

   CASE
      WHEN lc_gay01 = "0"
         LET ls_cmd = "iconv -f UTF-8 -t BIG5 "
      WHEN lc_gay01 = "2"
         LET ls_cmd = "iconv -f UTF-8 -t GB2312 "
      OTHERWISE
         RETURN TRUE   #傳入值不為簡體或繁體,不查
   END CASE
   LET ls_cmd = ls_cmd,ls_temp.trim(),"qc.src > ",ls_temp.trim(),"qc.tran "
   RUN ls_cmd
   IF os.Path.size(ls_temp.trim()||"qc.tran") = 0 THEN
      RETURN FALSE
   END IF
   CASE
      WHEN lc_gay01 = "0"
         LET ls_cmd = "iconv -f BIG5 -t UTF-8 "
      WHEN lc_gay01 = "2"
         LET ls_cmd = "iconv -f GB2312 -t UTF-8 "
   END CASE

   LET ls_cmd = ls_cmd,ls_temp.trim(),"qc.tran > ",ls_temp.trim(),"qc.u8 "
   RUN ls_cmd
   LET ls_cmd = "diff ",ls_temp.trim(),"qc.src ",ls_temp.trim(),"qc.u8 > ",ls_temp.trim(),"qc.dif"
   RUN ls_cmd
   IF os.Path.size(ls_temp.trim()||"qc.dif") > 0 THEN
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION
#EXT-D30029  ----(E)

FUNCTION p_updml4rp_usesamcolumn()
DEFINE l_column_now   LIKE gdm_file.gdm04
DEFINE l_flag         LIKE type_file.chr1
DEFINE i              LIKE type_file.num5

   IF l_ac <= 0 THEN RETURN END IF
   
   LET l_column_now = g_diff[l_ac].column_id
   CASE g_diff[l_ac].check
     WHEN "Y" LET l_flag = "N"
     WHEN "N" LET l_flag = "Y"
     OTHERWISE LET l_flag = "N"
   END CASE

   FOR i = 1 TO g_diff.getlength()
       IF l_column_now = g_diff[i].column_id THEN
          LET g_diff[i].check = l_flag
       END IF
   END FOR

END FUNCTION
