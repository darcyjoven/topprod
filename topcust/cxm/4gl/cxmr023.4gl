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

   call cxmr023_crt_tmp()

   let l_sql = " insert into cxmr023_sub ",
               "    select unique bmb03, bmd04 ",
               " from (select bmb01, bmb03, bmb06 / bmb07 bmb06 ",
               "          from bmb_file ",
               "          where bmb04 <= trunc(sysdate) ",
               "          and (bmb05 is null or bmb05 > trunc(sysdate)) ",
               "          start with bmb01 in ",
               "                   (select ima01 ",
               "                      from (select tc_sma06, tc_sma02, max(ima01) ima01 ",
               "                               from (select tc_sma06, tc_sma02 ",
               "                                        from tc_sma_file ",
               "                                     where tc_sma01 = 'csmi122' ",
               "                                     group by tc_sma06, tc_sma02) ",
               "                               left join ima_file ",
               "                                  on ima01 like tc_sma02 || '%' ",
               "                               and ima01 not like '%-%' ",
               "                               and substr(ima01, 7, 1) in ('A', 'B', 'C') ",
               "                               and ima01 like '%R' ",
               "                               and ima01 in (select bmb01 from bmb_file) ",
               "                               group by tc_sma06, tc_sma02)) ",
               "       connect by prior bmb03 = bmb01) ",
               " left join (select bmd08, bmd01, bmd04 ",
               "                from bmd_file ",
               "             where bmd05 <= trunc(sysdate) ",
               "                and (bmd06 is null or bmd06 > trunc(sysdate))) ",
               "    on bmd08 = bmb01 ",
               "    and bmd01 = bmb03 ",
               " where bmb03 like 'K.%' "
   prepare cxmr023_ins_sub1 from l_sql
   execute cxmr023_ins_sub1
   if sqlca.sqlcode then
      call cl_err("cxmr023_ins_sub1",sqlca.sqlcode,1)
      return
   end if
 

   let l_uuid = cs_uuid()

   -- 插入基础资料，展开的客供料
   let l_sql = "insert into cxmr023_exp (uuid,cust_proj,fg_part_no,comp_part_no,cust_part_no,mat_spec,usage_qty,sub_item)
                select '",l_uuid,"',tc_sma06,substr(bmb01,1,6) tc_sma02,bmb03,ima02,ima021,bmb06,bmb03
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
                            and ima01 like '%R'
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

   -- 将取替代资料插入
   insert into cxmr023_exp (uuid,cust_proj,fg_part_no,comp_part_no,cust_part_no,mat_spec,usage_qty,sub_item)
   select uuid,cust_proj,fg_part_no,comp_part_no,ima02,ima021,usage_qty,bmd04 
     from cxmr023_exp,cxmr023_sub,ima_file
    where uuid = l_uuid and bmb03 = comp_part_no and ima01 = bmd04 
   if sqlca.sqlcode then
      call cl_err("ins cxmr023_exp sub",sqlca.sqlcode,1)
      return
   end if

   -- 1) 杂收
   -- 来料明细（器件到料）  CRA
   -- 内部调拨（量产转量产） CR2
   -- 试产调拨（试产转量产） CR3

   -- 2）杂发
   -- 内部调拨（量产转量产） CRB
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
                  case when tlf905 in (select ina01 from cxmq024_cr2) then '2' when tlf905 in (select ina01 from cxmq024_cr3) then '3' when substr(tlf905,1,3)= 'CR2' then '2' when substr(tlf905,1,3) = 'CR3' then '3' else '1' end 
                  when tlf907 < 0 then
                  case when substr(tlf905,1,3) = 'CR5' then '5' when tlf06 <= to_date('251030','yymmdd') then '5' else '6' end
               end  movement_type,
               tlf06,FG_PART_NO,tlf01,ima02,ima021, abs(tlf10*tlf12) tlf10,ina07
                from tlf_file,ina_file,(select uuid,cust_proj,FG_PART_NO,sub_item from cxmr023_exp
                                         where uuid = ?),ima_file
               where tlf905 = ina01 and tlf13 in ('aimt301','aimt302')  and tlf01= ima01 
               and tlf01 = sub_item"
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
               select uuid,cust_proj, fg_part_no, comp_part_no,sum(trans_in_int) trans_in_int,
                      sum(trans_in_trial) trans_in_trial,sum(arrival_qty) arrival_qty,
                      sum(trans_out_int) trans_out_int,sum(reserve_ret) reserve_ret,
                      sum(wh_issue) wh_issue from (
                     select uuid,cust_proj, fg_part_no, comp_part_no, 
                       case when movement_type = '2' then qty else 0 end trans_in_int,
                       case when movement_type = '3' then qty else 0 end trans_in_trial,
                       case when movement_type = '1' then qty else 0 end arrival_qty,
                       case when movement_type = '4' then qty else 0 end trans_out_int,
                       case when movement_type = '5' then qty else 0 end reserve_ret,
                       case when movement_type = '6' then qty else 0 end wh_issue
                       from cxmr023_stock_movement
                      where uuid = ? )
                     group by  uuid,cust_proj, fg_part_no, comp_part_no) b
                     on (a.uuid = b.uuid and a.cust_proj=b.cust_proj 
                     and a.fg_part_no=b.fg_part_no and a.sub_item = b.comp_part_no)
               when matched then update set 
                  a.trans_in_int = b.trans_in_int,
                  a.trans_in_trial = b.trans_in_trial,
                  a.arrival_qty = b.arrival_qty,
                  a.trans_out_int = b.trans_out_int,
                  a.reserve_ret = b.reserve_ret,
                  a.wh_issue = b.wh_issue"
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
                   on (sub_item = img01 and uuid = ?)
                 when matched then update set wh_avail_kit = img10"
   prepare cxmr023_merge_img_p from l_sql
   execute cxmr023_merge_img_p using l_uuid
   if sqlca.sqlcode then
      call cl_err("cxmr023_merge_img_p",sqlca.sqlcode,1)
      return
   end if
   update cxmr023_exp set wh_avail_kit = 0 where uuid = l_uuid and wh_avail_kit is null

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

   -- -- 更新取替代料显示字段
   -- let l_sql =" merge into cxmr023_exp using ( ",
   --            " select bmb03,listagg(bmd04, ',') within group(order by bmd04) as bmd04 ",
   --            " from cxmr023_sub group by bmb03) ",
   --            " on (comp_part_no=bmb03 and uuid = ?) ",
   --            " when matched then update set sub_item = bmd04 "
   -- prepare cxmr023_merge_sub from l_sql
   -- execute cxmr023_merge_sub using l_uuid

   # darcy:2025/11/07 add s---
   # ship, batch, issue, yield
   insert into cxmr023_param (uuid,cust_proj) select unique uuid,cust_proj from cxmr023_exp

   -- 作废数量
   let l_sql = "merge into cxmr023_param a using ( ",
               " select uuid,cust_proj, nvl(sum(sfb081), 0) sfb081 ",
               "   from sfb_file, ",
               "         (select unique uuid, cust_proj, fg_part_no ",
               "            from cxmr023_exp   where uuid = ?) ",
               "   where sfb87 = 'Y' ",
               "      and sfb12 <> 0 and sfb05 not like '%-%' ",
               "      and substr(sfb05, 7, 1) in ('A', 'B', 'C') ",
               "      and substr(sfb05, 1, 6) = fg_part_no ",
               "   group by uuid,cust_proj) b ",
               " on (a.uuid = b.uuid and a.cust_proj = b.cust_proj)",
               " when matched then update set issue = sfb081"
   prepare cxmr023_merge_issue from l_sql
   execute cxmr023_merge_issue using l_uuid
   update cxmr023_param set issue = 0 where uuid = l_uuid and issue is null

   -- 批数
   let l_sql = "merge into cxmr023_param a using (  ",
               " select uuid,cust_proj, tc_oeb12",
               "  from (select uuid,cust_proj, tc_oeb12, tc_oeb16,",
               "                 dense_rank() OVER (partition by uuid, cust_proj order by tc_oeb16 desc) rn",
               "           from oea_file a,",
               "                 oeb_file b,",
               "                 tc_oeb_file c,",
               "                 (select unique uuid, cust_proj, fg_part_no",
               "                    from cxmr023_exp where uuid = ?)",
               "           where a.oea01 = b.oeb01 and b.oeb01 = c.tc_oeb01",
               "           and b.oeb03 = c.tc_oeb03 and a.oeaconf = 'Y'",
               "           and c.tc_oeb04 not like '%-%' and SUBSTR(c.tc_oeb04, 7, 1) in ('A', 'B', 'C')",
               "           and SUBSTR(c.tc_oeb04, 1, 6) = fg_part_no and a.oea00 = '0')",
               "  where rn = 2 )b ",
               " on (a.uuid = b.uuid and a.cust_proj = b.cust_proj)",
               " when matched then update set batch = tc_oeb12"
   prepare cxmr023_merge_batch from l_sql
   execute cxmr023_merge_batch using l_uuid
   update cxmr023_param set batch = 0 where uuid = l_uuid and batch is null

   -- 出货
   let l_sql  = "merge into cxmr023_param a using (",
                " select uuid, cust_proj, sum(ogb12) ogb12,sum(ohb12) ohb12",
                "   from (select unique uuid, cust_proj, fg_part_no from cxmr023_exp where uuid = ? )",
                "   left join (select substr(ogb04, 1, 6) ogb04, sum(ogb12) ogb12",
                "                  from oga_file, ogb_file where oga01 = ogb01",
                "                  and ogapost = 'Y' and oga09 = '2'",
                "                  and ogb04 not like '%-%' and SUBSTR(ogb04, 7, 1) in ('A', 'B', 'C')",
                "                  and ogb04 like '%R' ",
                "               group by substr(ogb04, 1, 6))",
                "      on ogb04 = fg_part_no",
                "   left join (select substr(ohb04, 1, 6) ohb04, sum(ohb12) ohb12",
                "                  from oha_file, ohb_file where oha01 = ohb01",
                "                  and ohapost = 'Y' and oha09 in ('1', '4')",
                "                  and oha04 not like '%-%' and SUBSTR(oha04, 7, 1) in ('A', 'B', 'C')",
                "                  and ohb04 like '%R' ",
                "               group by substr(ohb04, 1, 6))",
                "      on ohb04 = fg_part_no",
                " group by uuid, cust_proj) b",
                " on (a.uuid = b.uuid and a.cust_proj = b.cust_proj)",
                " when matched then update set ship = nvl(ogb12,0)-nvl(ohb12,0)"
   prepare cxmr023_merge_ship from l_sql
   execute cxmr023_merge_ship using l_uuid
   update cxmr023_param set ship = 0 where uuid = l_uuid and ship is null

   -- 良率
   let l_sql = "merge into cxmr023_param a using (",
               " select uuid,cust_proj,tc_bmj07 from (",
               " select uuid,cust_proj,tc_bmj07,tc_bmj09,",
               "        dense_rank() over(partition by uuid,cust_proj order by tc_bmj09 desc) r",
               "   from tc_bmi_file, tc_bmj_file,",
               "      ( select unique uuid,cust_proj,fg_part_no from cxmr023_exp where uuid = ?)",
               " where tc_bmi01 = tc_bmj01",
               "    and tc_bmiconf = 'Y' and substr(tc_bmj04, 1, 6) = fg_part_no",
               "    and substr(tc_bmj04, 7, 1) in ('A', 'B', 'C') and tc_bmj04 not like '%-%'",
               "    and tc_bmj11 = 1) where r = 1)b",
               " on (a.uuid=b.uuid and a.cust_proj=b.cust_proj)",
               " when matched then update set yield = tc_bmj07"
   prepare cxmr023_merge_yield from l_sql
   execute cxmr023_merge_yield using l_uuid 
   update cxmr023_param set yield = 98.5 where uuid = l_uuid and yield is null

   # darcy:2025/11/07 add e---

   # darcy:2025/11/10 add s---
   # 每个项目只保留一个料号
   let l_sql = "delete from cxmr023_exp",
               " where (uuid, cust_proj, fg_part_no) in",
               "       (select uuid, cust_proj, fg_part_no",
               "          from (select uuid, cust_proj, fg_part_no,",
               "                rank() over (partition by uuid, cust_proj order by fg_part_no desc) rn",
               "                from cxmr023_exp where uuid = ?)",
               "         where rn <> 1 group by uuid, cust_proj, fg_part_no )"
   prepare cxmr023_delete_exp from l_sql
   execute cxmr023_delete_exp using l_uuid

   # darcy:2025/11/10 add s---

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


function cxmr023_crt_tmp()
   drop table cxmr023_sub
   create temp table cxmr023_sub(
      bmb03 varchar(20),
      bmd04 varchar(20)
   ) 
end function
