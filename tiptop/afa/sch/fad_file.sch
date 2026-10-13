/*
================================================================================
檔案代號:fad_file
檔案名稱:多部门折旧费用分摊单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fad_file
(
fad01       number(5) NOT NULL,      /*资料年度                               */
fad02       number(5) NOT NULL,      /*资料月份                               */
fad03       varchar2(24) NOT NULL,   /*资产会计科目                           */
fad04       varchar2(10) NOT NULL,   /*分摊类型                               */
fad05       varchar2(1),             /*分摊方式                               */
fad06       number(5),               /*生成顺序                               */
fadacti     varchar2(1),             /*资料有效码                             */
faduser     varchar2(10),            /*资料所有者                             */
fadgrup     varchar2(10),            /*资料所有群                             */
fadmodu     varchar2(10),            /*资料更改者                             */
faddate     date,                    /*最近更改日                             */
fad031      varchar2(24),            /*No Use                                 */
fadoriu     varchar2(10),            /*资料建立者                             */
fadorig     varchar2(10),            /*资料建立部门                           */
fad07       varchar2(1) DEFAULT '1' NOT NULL /*类型*/
);

alter table fad_file add  constraint fad_pk primary key  (fad07,fad01,fad02,fad03,fad04) enable validate;
grant select on fad_file to tiptopgp;
grant update on fad_file to tiptopgp;
grant delete on fad_file to tiptopgp;
grant insert on fad_file to tiptopgp;
grant index on fad_file to public;
grant select on fad_file to ods;
