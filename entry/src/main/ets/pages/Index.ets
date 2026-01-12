import { Books } from '../components/Books';
import { rcp } from '@kit.RemoteCommunicationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  content: string = ``;
  @State breeds: Books[] = [];
  link: string = `jsonplaceholder.typicode.com/todos`;
  private scroller: Scroller = new Scroller();

  async aboutToAppear() {
    await this.getTransferSynEx();
  }

  @Builder
  itemStart() {
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.post'))
        .width(20)
        .height(20)
    }
    .padding(8)
  }

  @Builder
  itemEnd() {
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.trash'))
        .width(20)
        .height(20)
    }
    .backgroundColor(Color.Orange)
    .padding(8)
  }

  build() {
    Column() {
      ArcList({ initialIndex: 0, scroller: this.scroller }) {
        ForEach(this.breeds, (breed: Books) => {
          ArcListItem() {
            Column() {
              Text(`User Id: ${breed.userId}`)
                .fontColor(Color.Black)
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
              Text(`Author Id: ${breed.id}`)
                .fontColor(Color.Black)
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
              Text(`Description: ${breed.title}`)
                .fontColor(Color.Black)
                .fontSize(12)
                .fontWeight(FontWeight.Bold)
            }
          }
          .backgroundColor('#fff8f1e3')
          .padding(4)
          .margin(4)
          .borderRadius(12)
          .borderWidth(1)
          .borderColor('#0A59F7')
          .width('100%')
          .swipeAction({
            start: {
              builder: () => {
                this.itemStart()
              }
            },
            end: {
              builder: () => {
                this.itemEnd()
              }
            }
          })
        }, (breed: Books) => breed.id)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .backgroundColor(Color.White)
  }

  private getTransferSynEx = async () => {
    const getURL = `https://` + this.link;
    const request = new rcp.Request(getURL, 'GET');
    const session = rcp.createSession();

    try {
      console.info('Fetching data from:', getURL);
      const response = await session.fetch(request);

      console.info('Response status:', response.statusCode);

      if (response.statusCode === 200) {
        const jsonData = response.toJSON();
        console.info('Data received:', JSON.stringify(jsonData).substring(0, 100));

        this.breeds = jsonData as Books[];
        console.info('Breeds length:', this.breeds.length);
      } else {
        console.error('Error status:', response.statusCode);
        this.content = `API error: ${response.statusCode}`;
      }

    } catch (err) {
      const error = err as BusinessError;
      console.error('Request failed:', JSON.stringify(error));
      this.content = `API request failed: ${error.message}`;
    }
  }
}
