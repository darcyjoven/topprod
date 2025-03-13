# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_delimg.4gl
# Descriptions...: 庫存明細庫存量為零時刪除作業
# Date & Author..: 92/06/04 By  Wu
# Usage..........: CALL s_delimg(p_rowid)
# Input Parameter: p_rowid   庫存明細檔中的rowid
# Return code....: NONE
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.CHI-710041 07/03/13 By jamie 取消sma882欄位及其判斷
# Modify.........: No.CHI-740011 07/04/13 By jamie 改CHI-710041判斷
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_delimg相關改以 料倉儲批為參數傳入 ,不使用 rowid 
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_delimg(p_img01,p_img02,p_img03,p_img04)   #FUN-8C0084
   #FUN-8C0084--BEGIN--
   DEFINE  p_img01    LIKE img_file.img01
   DEFINE  p_img02    LIKE img_file.img02
   DEFINE  p_img03    LIKE img_file.img03
   DEFINE  p_img04    LIKE img_file.img04
   #FUN-8C0084--END--
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_img01 ,g_plant) OR NOT s_internal_item( p_img01,g_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end------------------------------------- 
  WHENEVER ERROR CALL cl_err_msg_log
{ckp#1}  
#CHI-740011---mark---str---
#IF g_sma.sma882 MATCHES '[Yy]'  #CHI-7100041 mark
#  THEN                         
#     DELETE FROM img_file WHERE rowid = p_rowid AND img10 = 0 
#     IF SQLCA.sqlcode THEN 
#        #CALL cl_err('(s_delimg:ckp#1)',SQLCA.sqlcode,1)  #FUN-670091
#         CALL cl_err3("del","img_file","","",SQLCA.sqlcode,"","",1) #UFN-670091
#     ELSE 
#        IF SQLCA.SQLERRD[3] != 0 THEN 
#           #CALL cl_err(p_rowid,'mfg1023',0)  #FUN-670091
#            CALL cl_err3("del","img_file","","",SQLCA.sqlcode,"","mfg1023",1) #FUN-670091
#        END IF
#     END IF
#END IF   
#CHI-740011---mark---end---
END FUNCTION
