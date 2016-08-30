//
//  ViewController.m
//  TestOC
//
//  Created by zhangxinwei on 16/6/6.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import "ViewController.h"
#import "YMRichText.h"
#import "YMBubbleText.h"
#import "YMMessage.h"


enum LINKTYPE
{
    LINKTYPE_url    = 1,
    LinkTYPE_dialog = 2,
    
};

@interface ViewController ()
{
    UITableView* messageTabelView;
    NSMutableArray* messageArray;
}


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 富文本
    NSString* ymString =
@"[/defs=22&defc=#FF000000]\
[还魂门:/c=#FFFF00FF&s=24]\n\
[/image=002.png]打开 地狱的大门,不请自来 贪欲念\n\
[/emoj=005][无常路上 买命钱,是生是畜 黄泉见/c=#FFFF0000]\n\
[/image=006.png][还魂门前 许个愿,不要相约 来世见/c=#FF00FF00]\n\
[/image=004.png]盗不到的 叫永远,解不开的 是心门\n\
[/emoj=005][最美的是 遗言,最丑的是 誓言/c=#FF0000FF]\n\
[/emoj=006]那些无法 的改变,就在放下 举起间\n\
[/image=007.png]最假的是 眼泪,最真的看 不见\n\
[/image=010.png][/emoj=010][/image=bd.png][百度一下，你就知道/link={\"type\":1,\"url\":\"http:www.baidu.com\"}]\n\
[/emoj=011][/image=011.png][点击一下，弹出对话框 悟空传/c=#FFFF0000&link={\"type\":2,\"text\":\"我要这天，再遮不住我眼。我要这地，再埋不了我心。要这众生，都明白我意。要那诸佛，全都烟消云散。\"}]";
    
    // TableView
    messageTabelView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    messageTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTabelView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chat_bg.jpg"]];
    messageTabelView.allowsSelection = NO;
    messageTabelView.delegate = self;
    messageTabelView.dataSource = self;
    messageTabelView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:messageTabelView];
    
    // 测试数据
    messageArray = [NSMutableArray array];
    for (int i = 0; i < 10; ++i) {
        YMMessage* message = [[YMMessage alloc]init];
        message.content = ymString;
        if (i % 2 == 0) {
            message.isLeft = YES;
        }
        else
        {
            message.isLeft = NO;
        }
        [message cacluteHeight];
        if (message.height < HEAD_WIDTH) {
            message.height = HEAD_WIDTH;
        }
        [messageArray addObject:message];
    }
    [messageTabelView reloadData];
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onClickLinkLabel:(NSString *)linkData
{
    // 解析处理
    NSLog(@"onClickLabel LinkData=%@", linkData);
    
    NSData* data = [linkData dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSNumber* type = [json objectForKey:@"type"];
    if (type) {
        switch ([type intValue]) {
            case LINKTYPE_url:
            {
                NSString* urlStr = [json objectForKey:@"url"];
                if (urlStr) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                }
            }
                break;
            case LinkTYPE_dialog:
            {
                NSString* text = [json objectForKey:@"text"];
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"内容" message:text preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messageArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ceil";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else
    {
        if ([cell.contentView viewWithTag:1]) {
            [[cell.contentView viewWithTag:1] removeFromSuperview];
        }
        if ([cell.contentView viewWithTag:2]) {
            [[cell.contentView viewWithTag:2] removeFromSuperview];
        }
    }
    
    
    YMMessage* message = [messageArray objectAtIndex:indexPath.row];
    float messageWidth = [UIScreen mainScreen].bounds.size.width - HEAD_WIDTH - HEAD_SPACE;
    
    // 头像
    UIImageView* headImageView = nil;
    if (message.isLeft) {
         headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head1.jpg"]];
         headImageView.frame = CGRectMake(0, 0, HEAD_WIDTH, HEAD_WIDTH);
    }
    else
    {
        headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head2.jpg"]];
        headImageView.frame = CGRectMake(messageWidth + HEAD_SPACE, 0, HEAD_WIDTH, HEAD_WIDTH);
    }
  
    headImageView.tag = 1;
    [cell.contentView addSubview:headImageView];
    
    // 消息
    YMBubbleText* bubbleText = [[YMBubbleText alloc]init];
    [bubbleText setText:message.content];
    if (message.isLeft) {
        UIImage* image = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        [bubbleText setOffset:CGRectMake(20, 10, 10, 10)];
        [bubbleText setStretchableImage:image LeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height * 0.7];
        [bubbleText setPosition:CGPointMake(HEAD_WIDTH, 0)];
    }
    else
    {
        UIImage* image = [UIImage imageNamed:@"chatto_bg_normal.png"];
        [bubbleText setOffset:CGRectMake(10, 10, 20, 10)];
        [bubbleText setStretchableImage:image LeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height * 0.7];
        [bubbleText setPosition:CGPointMake(0, 0)];
    }
    [bubbleText setMaxLineWidth:messageWidth];
    [bubbleText addTarget:self clickAction:@selector(onClickLinkLabel:)];
    bubbleText.tag = 2;
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:bubbleText];

    return cell;
}

#pragma mark - UITableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YMMessage* message = [messageArray objectAtIndex:indexPath.row];
    if (message) {
        return message.height;
    }
    else
    {
        return 0.0f;
    }
}

@end
