import { LightningElement } from 'lwc';
import chartjs from '@salesforce/resourceUrl/chartJs';
export default class CarouselDemo extends LightningElement {
    options = { autoScroll: true, autoScrollTime: 2 };
    items = [
            {
                type: 'line',
                data: {
                  labels: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
                  datasets: [{ 
                      data: [65, 69, 74, 78, 83, 86, 89, 92, 94, 96, 98, 100],
                      label: "Bench Press",
                      borderColor: "#3e95cd",
                      fill: false
                    }, { 
                      data: [67, 70, 73, 75, 78, 81, 83, 85, 88, 90, 93, 95],
                      label: "Back Squat",
                      borderColor: "#8e5ea2",
                      fill: false
                    }, { 
                      data: [62, 65, 68, 72, 75, 78, 82, 87, 90, 93, 97, 100],
                      label: "Deadlift",
                      borderColor: "#3cba9f",
                      fill: false
                    }, { 
                      data: [65, 68, 74, 77, 82, 87, 91, 95, 99, 102, 104, 105],
                      label: "Shoulder Press",
                      borderColor: "#e8c3b9",
                      fill: false
                    }
                  ]
                },
                options: {
                  title: {
                    display: true,
                    text: 'Lift Progress as a Ratio to Goal Weight'
                  }
                }
        }, {
            video: 'https://www.youtube.com/embed/SLaWOkc3bC8',
            header: 'Video 1',
            description: 'Demo video for carousel.',
        },
        {
            video: 'https://player.vimeo.com/video/241135386',
            header: 'Video 2',
            description: 'Demo image for carousel.',
        }, {
            image: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjExMDk0fQ&w=1000&q=80',
            header: 'Landscape 4',
            description: 'Demo image for carousel.',
        },
        {
            image: 'https://cdn.cnn.com/cnnnext/dam/assets/190517091026-07-unusual-landscapes-travel.jpg',
            header: 'Landscape 5',
            description: 'Demo image for carousel.',
        }, {
            image: 'https://solablogdotcom.files.wordpress.com/2015/11/lake-district-1009459_1920.png?w=1134',
            header: 'Landscape 6',
            description: 'Demo image for carousel.',
        },
        {
            image: 'https://i.unu.edu/media/ourworld.unu.edu-en/article/8564/Champions_of_Cumbria_Human_Landscapes1.jpg',
            header: 'Landscape 7',
            description: 'Demo image for carousel.',
        }, {
            image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSVGWCqosuufmXUpuQDGpktXc2e1PaIB2K-cOhJBVEFOuP4hjWR&usqp=CAU',
            header: 'Landscape 8',
            description: 'Demo image for carousel.',
        }
    ]
}