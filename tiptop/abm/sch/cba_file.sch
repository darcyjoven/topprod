/*
================================================================================
檔案代號:cba_file
檔案名稱:FAS 编码原则基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cba_file
(
cbacon      varchar2(40) NOT NULL,   /*规格主件                               */
                                     /*規格主件                               */
cbades      varchar2(80),            /*说明                                   */
                                     /*說明                                   */
cba01       number(5),               /*第一段位数                             */
                                     /*第一段位數                             */
cba02       number(5),               /*第二段位数                             */
                                     /*第二段位數                             */
cba03       number(5),               /*第三段位数                             */
                                     /*第三段位數                             */
cba04       number(5),               /*第四段位数                             */
                                     /*第四段位數                             */
cba05       number(5),               /*第五段位数                             */
                                     /*第五段位數                             */
cba06       number(5),               /*第六段位数                             */
                                     /*第六段位數                             */
cba07       number(5),               /*第七段位数                             */
                                     /*第七段位數                             */
cba08       number(5),               /*第八段位数                             */
                                     /*第八段位數                             */
cba09       number(5),               /*第九段位数                             */
                                     /*第九段位數                             */
cba10       number(5),               /*第十段位数                             */
                                     /*第十段位數                             */
cba11       number(5),               /*第十一段位数                           */
                                     /*第十一段位數                           */
cba12       number(5),               /*第十二段位数                           */
                                     /*第十二段位數                           */
cba13       number(5),               /*第十三段位数                           */
                                     /*第十三段位數                           */
cba14       number(5),               /*第十四段位数                           */
                                     /*第十四段位數                           */
cba15       number(5),               /*第十五段位数                           */
                                     /*第十五段位數                           */
cba16       number(5),               /*第十六段位数                           */
                                     /*第十六段位數                           */
cba17       number(5),               /*第十七段位数                           */
                                     /*第十七段位數                           */
cba18       number(5),               /*第十八段位数                           */
                                     /*第十八段位數                           */
cba19       number(5),               /*第十九段位数                           */
                                     /*第十九段位數                           */
cba20       number(5),               /*第二十段位数                           */
                                     /*第二十段位數                           */
cbaacti     varchar2(1),             /*资料有效码                             */
                                     /*系統維護                               */
cbauser     varchar2(10),            /*资料所有者                             */
                                     /*系統維護                               */
cbagrup     varchar2(10),            /*资料所有群                             */
                                     /*系統維護                               */
cbamodu     varchar2(10),            /*资料更改者                             */
                                     /*系統維護                               */
cbadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
cbaoriu     varchar2(10),            /*资料建立者                             */
cbaorig     varchar2(10)             /*资料建立部门                           */
);

alter table cba_file add  constraint cba_pk primary key  (cbacon) enable validate;
grant select on cba_file to tiptopgp;
grant update on cba_file to tiptopgp;
grant delete on cba_file to tiptopgp;
grant insert on cba_file to tiptopgp;
grant index on cba_file to public;
grant select on cba_file to ods;
