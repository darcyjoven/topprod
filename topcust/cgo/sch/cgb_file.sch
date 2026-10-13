/*
================================================================================
檔案代號:cgb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cgb_file
(
cgb01       varchar2(100),           /*项目名称                               */
cgb02       date,                    /*建立日期                               */
cgb03       varchar2(1000),          /*说明                                   */
cgb04       date,                    /*修改日期                               */
cgb05       date,                    /*编译日期                               */
cgb06       varchar2(1),             /*编译状态                               */
cgb07       varchar2(20),
cgb08       varchar2(20),
cgb09       varchar2(20),
cgb10       date,
cgb11       date,
cgb12       date,
cgb13       number(5),
cgb14       number(5),
cgb15       number(5)
);

grant select on cgb_file to tiptopgp;
grant update on cgb_file to tiptopgp;
grant delete on cgb_file to tiptopgp;
grant insert on cgb_file to tiptopgp;
grant index on cgb_file to public;
grant select on cgb_file to ods;
