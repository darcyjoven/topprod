/*
================================================================================
檔案代號:tc_pmm_file
檔案名稱:委外申请单
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_pmm_file
(
tc_pmm01    varchar2(20) NOT NULL,   /*委外单号                               */
tc_pmm02    date,                    /*录入日期                               */
tc_pmm03    varchar2(20),            /*Run Card号                             */
tc_pmm04    varchar2(20),            /*工单单号                               */
tc_pmm05    varchar2(40),            /*产品料号                               */
tc_pmm06    varchar2(10) NOT NULL,   /*作业编号                               */
tc_pmm07    varchar2(10),            /*委外供应商                             */
tc_pmm08    number(5),               /*工艺序号                               */
tc_pmm09    number(15,3),            /*委外数量                               */
tc_pmm10    varchar2(255),           /*备注                                   */
tc_pmm11    varchar2(1),             /*审核码                                 */
tc_pmmud01  varchar2(255),           /*详细LOT号                              */
tc_pmmud02  varchar2(1500),          /*生产说明                               */
tc_pmmud03  varchar2(1500),          /*使用工具                               */
tc_pmmud04  varchar2(40),            /*是否合并委外                           */
tc_pmmud05  varchar2(40),            /*合并委外作业编号                       */
tc_pmmud06  varchar2(40),            /*采购单号                               */
tc_pmmud07  number(15,3),            /*PNL                                    */
tc_pmmud08  number(15,3),            /*自订栏位-数值                          */
tc_pmmud09  number(15,3),            /*自订栏位-数值                          */
tc_pmmud10  number(10) NOT NULL,     /*项次                                   */
tc_pmmud11  number(10),              /*采购项次                               */
tc_pmmud12  number(10),              /*自订栏位-整数                          */
tc_pmmud13  varchar2(10),            /*补单否                                 */
tc_pmmud14  date,                    /*生成日期                               */
tc_pmmud15  date,                    /*删除日期                               */
tc_pmmacti  varchar2(1),             /*资料有效码                             */
tc_pmmdate  date,                    /*资料修改日期                           */
tc_pmmgrup  varchar2(10),            /*资料所属群组                           */
tc_pmmmodu  varchar2(10),            /*资料修改者                             */
tc_pmmuser  varchar2(10),            /*资料所有者                             */
tc_pmmplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_pmmlegal varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tc_pmm_file add  constraint tpc_pmm_pk primary key  (tc_pmm01,tc_pmmud10) enable validate;
grant select on tc_pmm_file to tiptopgp;
grant update on tc_pmm_file to tiptopgp;
grant delete on tc_pmm_file to tiptopgp;
grant insert on tc_pmm_file to tiptopgp;
grant index on tc_pmm_file to public;
grant select on tc_pmm_file to ods;
