/*
================================================================================
檔案代號:tc_pmx_file
檔案名稱:询价单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_pmx_file
(
tc_pmx01    varchar2(20) NOT NULL,   /*核价单号                               */
tc_pmx02    number(5) NOT NULL,      /*项次                                   */
tc_pmx03    varchar2(40),            /*料件编号                               */
tc_pmx031   varchar2(120),           /*品名                                   */
tc_pmx032   varchar2(120),           /*规格                                   */
tc_pmx04    varchar2(40),            /*供应商编号                             */
tc_pmx05    varchar2(4),             /*供应商名称                             */
tc_pmx06    number(20,6),            /*核价税前单价                           */
tc_pmx07    number(20,6),            /*询价税前单价                           */
tc_pmx08    date,                    /*核价日期                               */
tc_pmx09    date,                    /*询价日期                               */
tc_pmx10    varchar2(6) NOT NULL,    /*作业编号                               */
tc_pmx06t   number(20,6),            /*核价含税单价                           */
tc_pmx07t   number(20,6),            /*询价含税单价                           */
tc_pmx11    varchar2(10),            /*工艺说明                               */
tc_pmx12    varchar2(1) NOT NULL,    /*价格类型                               */
tc_pmx13    varchar2(10) NOT NULL,   /*工艺单位编号，为空代表此笔             */
tc_pmxplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_pmxlegal varchar2(10) NOT NULL,   /*所属法人                               */
tc_pmx14    varchar2(15),            /*电子采购序号                           */
tc_pmxicd14 varchar2(1),             /*等级                                   */
tc_pmx15    varchar2(5),             /*询价单位                               */
tc_pmx16    number(15,3),            /*下限数量                               */
tc_pmx17    varchar2(10),            /*理由码                                 */
tc_pmx18    varchar2(20),            /*核价单号                               */
tc_pmx19    number(5),               /*核价项次                               */
tc_pmx20    varchar2(1),             /*最终核价                               */
tc_pmx21    varchar2(1),             /*是否涨价                               */
tc_pmx22    varchar2(1000)           /*备注                                   */
);

grant select on tc_pmx_file to tiptopgp;
grant update on tc_pmx_file to tiptopgp;
grant delete on tc_pmx_file to tiptopgp;
grant insert on tc_pmx_file to tiptopgp;
grant index on tc_pmx_file to public;
grant select on tc_pmx_file to ods;
