/*
================================================================================
檔案代號:vim_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vim_file
(
vim01       varchar2(10) NOT NULL,   /*VIP种类编号                            */
vim02       varchar2(80),            /*说明                                   */
vim03       number(15,6),            /*折扣率%                                */
vimacti     varchar2(1),             /*资料有效码                             */
vimdate     date,                    /*最近更改日                             */
vimgrup     varchar2(10),            /*资料所有部门                           */
vimmodu     varchar2(10),            /*资料更改者                             */
vimuser     varchar2(10),            /*资料所有者                             */
vimoriu     varchar2(10),            /*资料建立者                             */
vimorig     varchar2(10)             /*资料建立部门                           */
);

alter table vim_file add  constraint vim_pk primary key  (vim01) enable validate;
grant select on vim_file to tiptopgp;
grant update on vim_file to tiptopgp;
grant delete on vim_file to tiptopgp;
grant insert on vim_file to tiptopgp;
grant index on vim_file to public;
grant select on vim_file to ods;
