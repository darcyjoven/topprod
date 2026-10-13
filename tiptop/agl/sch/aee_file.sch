/*
================================================================================
檔案代號:aee_file
檔案名稱:科目核算项名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aee_file
(
aee00       varchar2(5) NOT NULL,    /*帐套                                   */
aee01       varchar2(24) NOT NULL,   /*科目编号                               */
aee02       varchar2(2) NOT NULL,    /*核算项顺序                             */
aee03       varchar2(30) NOT NULL,   /*核算项值                               */
aee04       varchar2(80),            /*说明                                   */
aee05       varchar2(20),            /*原始凭证编号                           */
aee06       date,                    /*原始凭证日期                           */
aeeacti     varchar2(1),             /*资料有效码                             */
aeeuser     varchar2(10),            /*资料所有者                             */
aeegrup     varchar2(10),            /*资料所有群                             */
aeemodu     varchar2(10),            /*资料更改者                             */
aeedate     date,                    /*最近更改日                             */
aee021      varchar2(10),            /*核算项类型编号                         */
                                     /*#FUN-5C0015                            */
aeeoriu     varchar2(10),            /*资料建立者                             */
aeeorig     varchar2(10)             /*资料建立部门                           */
);

alter table aee_file add  constraint aee_pk primary key  (aee00,aee01,aee02,aee03) enable validate;
grant select on aee_file to tiptopgp;
grant update on aee_file to tiptopgp;
grant delete on aee_file to tiptopgp;
grant insert on aee_file to tiptopgp;
grant index on aee_file to public;
grant select on aee_file to ods;
