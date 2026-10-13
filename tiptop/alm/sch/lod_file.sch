/*
================================================================================
檔案代號:lod_file
檔案名稱:合同变更其他费用标准信息档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lod_file
(
lod01       varchar2(20) NOT NULL,   /*合同编号                               */
lod02       varchar2(20) NOT NULL,   /*合同版本号                             */
lod03       varchar2(10) NOT NULL,   /*费用明细编号                           */
lod04       varchar2(24),            /*会计科目                               */
lod041      varchar2(24),            /*会计科目二                             */
lod05       varchar2(1),             /*金额类型                               */
lod06       number(20,2),            /*金额                                   */
lod07       varchar2(1),             /*收取方式                               */
lod08       date,                    /*生效日期                               */
lod09       date,                    /*失效日期                               */
lod10       varchar2(1) DEFAULT ' ' NOT NULL, /*费用归属*/
lodlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lodplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lod_file add  constraint lod_pk primary key  (lod01,lod02,lod03) enable validate;
grant select on lod_file to tiptopgp;
grant update on lod_file to tiptopgp;
grant delete on lod_file to tiptopgp;
grant insert on lod_file to tiptopgp;
grant index on lod_file to public;
grant select on lod_file to ods;
