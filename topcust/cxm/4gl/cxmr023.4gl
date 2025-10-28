# Prog. Version..:
#
# Pattern name...: cxmr023.4gl
# Descriptions...: 客供料追踪
# Date & Author..: darcy:2025/09/19 
#HFBG-16030001
-- import libsummary
import os
import libparttrack

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD
      wc      string
   END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  

   INITIALIZE tm.* TO NULL         

   CALL cxmr023_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cxmr023_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cxmr023_w AT p_row,p_col WITH FORM "cxm/42f/cxmr023"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   CALL cl_opmsg('p')
   WHILE TRUE 
      construct by name tm.wc on tc_sma06 

         on action controlp
            case
                when infield(tc_sma06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "cq_tc_sma06" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tc_sma06
                    next field tc_sma06
            end case

         ON ACTION CONTROLG 
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE construct
   
         ON ACTION about
            CALL cl_about()
   
         ON ACTION help
            CALL cl_show_help()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT construct

      END construct

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW cxmr023_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF 

      CALL cl_wait()
      CALL cxmr023()
      ERROR ""
   END WHILE
   CLOSE WINDOW cxmr023_w
END FUNCTION


FUNCTION cxmr023()
   define l_sql,l_str,l_file       string
   define i,j,k,l                  integer
   define l_tc_sma06               like tc_sma_file.tc_sma06
   define l_uuid                   varchar(40)
   define l_path,l_shortid,l_tmp   string
   define l_children               dynamic array of string
   define h,res                    integer

   let l_uuid = cs_uuid()

   let l_sql = "insert into cxmr023_exp (uuid,cust_proj,fg_part_no,comp_part_no,cust_part_no,mat_spec,usage_qty)
                select '",l_uuid,"',tc_sma06,substr(bmb01,1,6) tc_sma02,bmb03,ima02,ima021,bmb06
                from (
                select bmb01,bmb03,bmb06/bmb07 bmb06
                from bmb_file
                where bmb04 <= trunc(sysdate)
                and (bmb05 is null or bmb05 > trunc(sysdate)) 
                start with bmb01 in (select ima01 from (
                select tc_sma06, tc_sma02, max(ima01) ima01
                            from (select tc_sma06, tc_sma02
                                  from tc_sma_file
                                  where tc_sma01 = 'csmi122' and ",tm.wc,"
                                  group by tc_sma06, tc_sma02)
                            left join ima_file
                            on ima01 like tc_sma02 || '%'
                            and ima01 not like '%-%'
                            and substr(ima01, 7, 1) in ('A', 'B', 'C')
                            and ima01 in (select bmb01 from bmb_file)
                         group by tc_sma06, tc_sma02
                )) connect by prior bmb03 = bmb01),ima_file,tc_sma_file
                where ima01 = bmb03 and tc_sma01='csmi122' and tc_sma02 = substr(bmb01,1,6)
                and bmb03 like 'K.%'"

   prepare cxmr023_ins_p from l_sql
   execute cxmr023_ins_p
   if sqlca.sqlcode then
      call cl_err("cxmr023_ins_p",sqlca.sqlcode,1)
      return
   end if

   -- 1) 杂收
   -- 来料明细（器件到料）   CR1
   -- 内部调拨（量产转量产） CR2
   -- 试产调拨（试产转量产） CR3

   -- 2）杂发
   -- 内部调拨（量产转量产） CR4
   -- 客户预留（客户下预留的挪仓、退料、转寄）CR5

   -- 1. 发料明细
   -- 2. 内部调拨出库明细
   -- 3. 内部调拨入库明细
   -- 4. 来料明细
   {
   1. 收料
   2. 内部调拨入
   3. 试产调拨入
   4. 内部调拨出
   5. 客户预留
   6. 发料
   }
   let l_sql = "insert into cxmr023_stock_movement
               (uuid ,cust_proj ,movement_type ,record_date ,fg_part_no ,comp_part_no ,CUST_PART_NO,mat_desc ,qty ,remark) 
               select uuid,cust_proj,
               case when tlf907 > 0 then 
                  case substr(tlf905,1,3) when 'CR1' then '1' when 'CR2' then '2' when 'CR3' then '3' else '1' end 
                  when tlf907 < 0 then
                  case substr(tlf905,1,3) when 'CR4' then '4' when 'CR5' then '5' else '6' end
               end  movement_type,
               tlf06,FG_PART_NO,tlf01,ima02,ima021, abs(tlf10*tlf12) tlf10,ina07
                from tlf_file,ina_file,( select uuid,cust_proj,FG_PART_NO,comp_part_no  from cxmr023_exp
                                          where uuid = ?),ima_file 
               where tlf905 = ina01  
               and tlf13 in ('aimt301','aimt302')  and tlf01= ima01 
               and tlf01 =comp_part_no"
   prepare cxmr023_stock_movement_p from l_sql
   execute cxmr023_stock_movement_p using l_uuid
   if sqlca.sqlcode then
      call cl_err("cxmr023_stock_movement_p",sqlca.sqlcode,1)
      return
   end if

   -- 1. 内部调拨 入 cxmr023_stock_movement 2
   -- 2. 试产调拨 入 cxmr023_stock_movement 3
   -- 器件到货量 cxmr023_stock_movement 1
   -- 内部调拨 出 cxmr023_stock_movement 4 
   -- 预留 退料 cxmr023_stock_movement 5
   -- 电子仓 实发套数 cxmr023_stock_movement 6
   let l_sql = "merge into cxmr023_exp a using (
               select uuid,CUST_PROJ, FG_PART_NO, COMP_PART_NO,sum(TRANS_IN_INT) TRANS_IN_INT,
                      sum(TRANS_IN_TRIAL) TRANS_IN_TRIAL,sum(ARRIVAL_QTY) ARRIVAL_QTY,
                      sum(TRANS_OUT_INT) TRANS_OUT_INT,sum(RESERVE_RET) RESERVE_RET,
                      sum(WH_ISSUE) WH_ISSUE from (
                     select uuid,CUST_PROJ, FG_PART_NO, COMP_PART_NO, 
                       case when movement_type = '2' then qty else 0 end TRANS_IN_INT,
                       case when movement_type = '3' then qty else 0 end TRANS_IN_TRIAL,
                       case when movement_type = '1' then qty else 0 end ARRIVAL_QTY,
                       case when movement_type = '4' then qty else 0 end TRANS_OUT_INT,
                       case when movement_type = '5' then qty else 0 end RESERVE_RET,
                       case when movement_type = '6' then qty else 0 end WH_ISSUE
                       from cxmr023_stock_movement
                      where uuid = ? )
                     group by  uuid,CUST_PROJ, FG_PART_NO, COMP_PART_NO) b
                     on (a.uuid = b.uuid and a.cust_proj=b.cust_proj 
                     and a.FG_PART_NO=b.FG_PART_NO and a.COMP_PART_NO = b.COMP_PART_NO)
               when matched then update set 
                  a.TRANS_IN_INT = b.TRANS_IN_INT,
                  a.TRANS_IN_TRIAL = b.TRANS_IN_TRIAL,
                  a.ARRIVAL_QTY = b.ARRIVAL_QTY,
                  a.TRANS_OUT_INT = b.TRANS_OUT_INT,
                  a.RESERVE_RET = b.RESERVE_RET,
                  a.WH_ISSUE = b.WH_ISSUE"
   prepare cxmr023_merge_move_p from l_sql
   execute cxmr023_merge_move_p using l_uuid
   if sqlca.sqlcode then
      call cl_err("cxmr023_merge_p",sqlca.sqlcode,1)
      return
   end if

   update cxmr023_exp set trans_in_int = 0 where uuid = l_uuid and trans_in_int is null
   update cxmr023_exp set trans_in_trial = 0 where uuid = l_uuid and trans_in_trial is null
   update cxmr023_exp set arrival_qty = 0 where uuid = l_uuid and arrival_qty is null
   update cxmr023_exp set trans_out_int = 0 where uuid = l_uuid and trans_out_int is null
   update cxmr023_exp set reserve_ret = 0 where uuid = l_uuid and reserve_ret is null
   update cxmr023_exp set wh_issue = 0 where uuid = l_uuid and wh_issue is null

   -- 电子仓 可配套数量 img
   let l_sql = "merge into cxmr023_exp 
                using (select img01 ,sum(img10)img10 from img_file group by img01)
                   on (comp_part_no = img01 and uuid = ?)
                 when matched then update set WH_AVAIL_KIT = img10"
   prepare cxmr023_merge_img_p from l_sql
   execute cxmr023_merge_img_p using l_uuid
   if sqlca.sqlcode then
      call cl_err("cxmr023_merge_img_p",sqlca.sqlcode,1)
      return
   end if
   update cxmr023_exp set WH_AVAIL_KIT = 0 where uuid = l_uuid and WH_AVAIL_KIT is null

   -- 成品报废 累计工单报废
   let l_sql = "merge into cxmr023_exp using (
                select substr(sfb05, 1, 6) sfb05, sum(sfb12) sfb12
                from sfb_file
                where sfb87 = 'Y' and sfb12 <> 0
                   and sfb05 not like '%-%'
                   and substr(sfb05, 7, 1) in ('A', 'B', 'C')
                group by substr(sfb05, 1, 6))
                on(fg_part_no = sfb05 and uuid = ?)
                when matched then update set scrap_qty = sfb12"
   prepare cxmr023_merge_sfb12_p from l_sql
   execute cxmr023_merge_sfb12_p using l_uuid
   if sqlca.sqlcode then
      call cl_err("cxmr023_merge_sfb12_p",sqlca.sqlcode,1)
      return
   end if
   update cxmr023_exp set scrap_qty = 0 where uuid = l_uuid and scrap_qty is null

   call exportTrack(l_uuid) returning l_shortid

   # 遍历目录
   let l_path = os.Path.Join("/u1/out",l_shortid)

   if not os.Path.exists(l_path) then
      display sfmt("%1 目录不存在，导出失败或无资料！",l_path)
      return
   end if

  if not os.Path.isdirectory(l_path) then
     display sfmt("%1 该目录不是一个文件夹",l_path)
     return
  end if

   call l_children.clear()
   call os.path.dirsort("name", 1)
   let h = os.path.diropen(l_path)
   let i = 1

   while h > 0
      let l_children[i] = os.path.dirnext(h)
      if l_children[i] is null then 
         exit while
      end if
      if l_children[i] == "." or l_children[i] == ".." then
         continue while
      end if
      let i = i + 1
   end while
   call l_children.deleteElement(i)

   if not cl_confirm2("cxm-062",sfmt("共%1个文件。",l_children.getLength())) then
      display "取消导出"
      return
   end if

   for i = 1 to l_children.getLength()
      let l_tmp = fgl_getenv("FGLASIP") clipped,"/tiptop/out/",l_shortid,"/",l_children[i] clipped
      call ui.Interface.frontCall("standard",
                                  "shellexec",
                                  ["EXPLORER \"" || l_tmp || "\""],
                                  [res])
      if status then
         call cl_err("Front End Call Failed.",status,1)
         return
      end if
   end for


   -- for i = 1 to l_children.getLength()
   --    let res = os.Path.delete(sfmt("%1/%2",l_path,l_children[i]))
   --    if not res then
   --       display sfmt("删除文件%1失败！",sfmt("%1/%2",l_path,l_children[i]))
   --    end if
   -- end for
   -- let res = os.Path.delete(l_path)

END FUNCTION


