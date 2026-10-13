/*
================================================================================
檔案代號:gen_file
檔案名稱:员工姓名资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gen_file
(
gen01       varchar2(10) NOT NULL,   /*员工编号                               */
                                     /*員工編號                               */
gen02       varchar2(40),            /*员工姓名                               */
                                     /*員工姓名                               */
gen03       varchar2(10),            /*所属部门编号                           */
gen04       varchar2(80),            /*职称                                   */
                                     /*職稱                                   */
gen05       varchar2(5),             /*分机                                   */
                                     /*分機                                   */
gen06       varchar2(80),            /*E-mail                                 */
                                     /*E-mail #03/02/11 add                   */
genacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
genuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
gengrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
genmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gendate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
genorig     varchar2(10),            /*资料建立部门                           */
genoriu     varchar2(10),            /*资料建立者                             */
genpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
gen07       varchar2(10),            /*归属营运中心                           */
gen08       varchar2(20)             /*行动电话                               */
);

alter table gen_file add  constraint gen_pk primary key  (gen01) enable validate;
grant select on gen_file to tiptopgp;
grant update on gen_file to tiptopgp;
grant delete on gen_file to tiptopgp;
grant insert on gen_file to tiptopgp;
grant index on gen_file to public;
grant select on gen_file to ods;
